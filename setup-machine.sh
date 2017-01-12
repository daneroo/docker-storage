#!/bin/bash

# set -e  # if we encounter an error, abort

export MACHINE_DRIVER=amazonec2
# AWS_DEFAULT_REGION=...
# AWS_INSTANCE_TYPE=t2.micro
# export AWS_ACCESS_KEY_ID=AKI...
# export AWS_SECRET_ACCESS_KEY=...

NUM_HOSTS=5
echo "Creating $NUM_HOSTS hosts (in parallell)"
for N in $(seq 1 $NUM_HOSTS); do
  docker-machine create node$N &
done
wait
echo
echo "Done creating hosts"

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
