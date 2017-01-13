#!/bin/bash

# set -e  # if we encounter an error, abort

NUM_HOSTS=5

M1=$(docker-machine ip node1)
docker-machine ssh node1 docker swarm init --advertise-addr ${M1}

# mode managers
MGR_TOK=$(docker-machine ssh node1 docker swarm join-token manager -q)
for N in $(seq 2 3); do
  echo "Node ${N} joining as managerr"
  WRKIP=$(docker-machine ip node${N})
  docker-machine ssh node${N} docker swarm join --token ${MGR_TOK} ${M1}
done

WRK_TOK=$(docker-machine ssh node1 docker swarm join-token worker -q)
for N in $(seq 4 $NUM_HOSTS); do
  echo "Node ${N} joining as worker"
  WRKIP=$(docker-machine ip node${N})
  docker-machine ssh node${N} docker swarm join --token ${WRK_TOK} ${M1}
done
