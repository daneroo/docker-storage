#!/bin/bash

# set -e  # if we encounter an error, abort

export MACHINE_DRIVER=amazonec2
# AWS_DEFAULT_REGION=...
# AWS_INSTANCE_TYPE=t2.micro
# export AWS_ACCESS_KEY_ID=AKI...
# export AWS_SECRET_ACCESS_KEY=...

NUM_HOSTS=5
echo "Removing $NUM_HOSTS hosts (in parallell)"
for N in $(seq 1 $NUM_HOSTS); do
  docker-machine rm -f node$N
done
echo
echo "Done removing hosts"
echo

echo "List to see if any are left ..."
docker-machine ls