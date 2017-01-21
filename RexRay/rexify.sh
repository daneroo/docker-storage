#!/bin/bash

# set -e  # if we encounter an error, abort
NUM_HOSTS=5

export MACHINE_DRIVER=amazonec2

# This is called at end of script
function main(){
  loadAndcheckEnv
  makeRexrayConfig

  rexify
  # docker-machine ssh aws01 "echo whoami | sudo sh" # root
  # docker-machine ssh aws01 "curl -sSL https://dl.bintray.com/emccode/rexray/install | sh -s -- stable"

  # echo "${REXRAY_CONFIG}" | docker-machine ssh aws01 "sudo tee /etc/rexray/config.yml" >/dev/null

  # docker-machine ssh aws01 "sudo service rexray start"
    
}

function rexify(){
  if [ "${MACHINE_DRIVER}" = "amazonec2" ]; then
    echo
    echo "Installing RexRay plugin (${MACHINE_DRIVER})"
    for N in $(seq 1 $NUM_HOSTS); do
      HOST=node$N
      echo "Installing on ${HOST} ..."

      # docker-machine ssh ${HOST} "echo whoami | sudo sh" # root

      docker-machine ssh ${HOST} "curl -sSL https://dl.bintray.com/emccode/rexray/install | sh -s -- stable"
      echo "  plugin installed on ${HOST}"
      echo "${REXRAY_CONFIG}" | docker-machine ssh ${HOST} "sudo tee /etc/rexray/config.yml" >/dev/null
      echo "  plugin configured on ${HOST}"
      docker-machine ssh ${HOST} "sudo service rexray start"
      echo "  service started on ${HOST}"

    done
    echo
    echo "Done Installing RexRay plugin"
  else
    echo
    echo "Cannot install RexRay plugin on ${MACHINE_DRIVER}"
  fi
}

function badEnv(){
  # Just the error message
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
