#!/bin/bash

# set -e  # if we encounter an error, abort

NUM_HOSTS=5

# Determine the host type
MACHINE_DRIVER=$(docker-machine inspect --format '{{.DriverName}}' node1)

echo
echo "Detected swarm on ${MACHINE_DRIVER}"
sleep 2
if [ "${MACHINE_DRIVER}" = "digitalocean" ]; then
  N1_ip=$(docker-machine ip node1)

  echo
  echo "Avertising swarm on external IP address for ${MACHINE_DRIVER}: ${N1_ip}"

  # advertise on external - which is the default without params on digital ocean
  docker-machine ssh node1 docker swarm init --advertise-addr ${N1_ip}
fi

if [ "${MACHINE_DRIVER}" = "amazonec2" ]; then
  echo
  echo "Make sure the internal network vpc has docker-machine SG allowing inbound tcp:2377"

  # N1_ip=$(docker-machine ssh node1 ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d \  -f 1)
  N1_ip=$(docker-machine inspect --format='{{.Driver.PrivateIPAddress}}' node1)

  echo
  echo "Avertising swarm on internal IP address for ${MACHINE_DRIVER}: ${N1_ip}"

  # advertise on eth0 (internal) - which is the default without params
  docker-machine ssh node1 docker swarm init 
  # to advertise as extern ip on aws
  # docker-machine ssh node1 docker swarm init --listen-addr eth0:2377 --advertise-addr ${N1_ip}
fi

echo 
echo "Connecting Managers to Swarm. Fetching manager token ..."
MGR_TOK=$(docker-machine ssh node1 docker swarm join-token manager -q)
for N in $(seq 2 3); do
  echo "Node ${N} joining as manager"
  WRKIP=$(docker-machine ip node${N})
  docker-machine ssh node${N} docker swarm join --token ${MGR_TOK} ${N1_ip}
done

echo
echo "Connecting Workers to Swarm. Fetching worker token ..."
WRK_TOK=$(docker-machine ssh node1 docker swarm join-token worker -q)
for N in $(seq 4 $NUM_HOSTS); do
  echo "Node ${N} joining as worker"
  WRKIP=$(docker-machine ip node${N})
  docker-machine ssh node${N} docker swarm join --token ${WRK_TOK} ${N1_ip}
done

echo
echo "To use your cluster remotely:"
echo 'eval $(docker-machine env node1)'
echo "docker node ls"