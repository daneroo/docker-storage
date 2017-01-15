#!/bin/bash

# set -e  # if we encounter an error, abort
NUM_HOSTS=1

export MACHINE_DRIVER=amazonec2

function main(){
  loadAndcheckEnv
  makeRexrayConfig

  # docker-machine ssh aws01 "echo whoami | sudo sh" # root
  docker-machine ssh aws01 "curl -sSL https://dl.bintray.com/emccode/rexray/install | sh -s -- stable"

  echo "${REXRAY_CONFIG}" | docker-machine ssh aws01 "sudo tee /etc/rexray/config.yml" >/dev/null

  docker-machine ssh aws01 "sudo service rexray start"

    
  exit 
}

function badEnv(){
  cat <<-EOD
  'till we use something more AWS'y..."
  Need to set credentials for ENV vars like so
#-- AWS_CREDS.env -
export AWS_ACCESS_KEY_ID=KEYXXX
export AWS_SECRET_ACCESS_KEY=SECRETYYY
export AWS_DEFAULT_REGION=us-east-1
EOD
  exit 1
}

function loadAndcheckEnv(){
  if [ -f "AWS_CREDS.env" ]; then
    source "AWS_CREDS.env"
  fi
  if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
    badEnv
  fi  
  if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
    badEnv
  fi  
  if [ -z "${AWS_DEFAULT_REGION}" ]; then
    badEnv
  fi  
}

function makeRexrayConfig(){
# Mind the indentation
# REXRAY_CONFIG: Interpolate config with env vars
read -r -d '' REXRAY_CONFIG <<-END_HEREDOC
libstorage:
  service: ebs
  integration:
    volume:
      operations:
        mount:
          preempt: true
          rootPath: /data
ebs:
  accessKey: ${AWS_ACCESS_KEY_ID}
  secretKey: ${AWS_SECRET_ACCESS_KEY}
  region: ${AWS_DEFAULT_REGION}
END_HEREDOC
}

# Call main, after all functions are defined
main

exit 1


# AWS
echo
if [ "${MACHINE_DRIVER}" = "amazonec2" ]; then
  echo "Configuring for ${MACHINE_DRIVER}"
  # export MACHINE_DRIVER=amazonec2
  
  # Credentials
  # are read from ~/.aws/c.. by default
  # AWS_DEFAULT_REGION=...
  # AWS_INSTANCE_TYPE=t2.micro

  # export AWS_AMI=ami-5f709f34  #default hvm-ssd
  export AWS_AMI=ami-45709f2e  #hvm, default still borks (this is for us-east-1)
fi

echo
echo "Creating ${NUM_HOSTS} hosts on provider: ${MACHINE_DRIVER}"
echo "..."
echo
sleep 2

echo "Creating $NUM_HOSTS hosts (in parallell)"
echo
for N in $(seq 1 $NUM_HOSTS); do
  docker-machine create node$N &
done
wait
echo
echo "Done creating hosts"

if [ "${MACHINE_DRIVER}" = "amazonec2" ]; then
  sleep 5

  echo "Adding ubuntu user to docker group (in parallell)"
  for N in $(seq 1 $NUM_HOSTS); do
    docker-machine ssh node$N sudo usermod -aG docker ubuntu &
  done
  wait
  echo
  echo "Done adding ubuntu user to docker group"
fi

