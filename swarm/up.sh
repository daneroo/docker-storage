#!/bin/bash

# set -e  # if we encounter an error, abort
NUM_HOSTS=5

export MACHINE_DRIVER=amazonec2
# export MACHINE_DRIVER=digitalocean
export MACHINE_DRIVER=${MACHINE_DRIVER:-digitalocean}

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

# Digital Ocean
if [ "${MACHINE_DRIVER}" = "digitalocean" ]; then
  echo "Configuring for ${MACHINE_DRIVER}"
  # export MACHINE_DRIVER=digitalocean

  # Credentials
  # get the digital ocean token from the doctl config file
  export DIGITALOCEAN_ACCESS_TOKEN=$(grep access-token ~/.config/doctl/config.yaml|cut -f 2 -d:| tr -d '[:space:]')
  # export DIGITALOCEAN_IMAGE=ubuntu-16.04.x64
  # export DIGITALOCEAN_REGION=nyc3 #default
  export DIGITALOCEAN_REGION=nyc1
  # export DIGITALOCEAN_SIZE=512mb
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

  # optional check
  for N in $(seq 1 $NUM_HOSTS); do
    echo Checking host: $node$N
    docker-machine ssh node$N grep docker /etc/group
  done

fi

