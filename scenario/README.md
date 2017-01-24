# Scenario

# RexRay - Swarm

```bash
docker volume ls

docker volume create -d rexray --name myvolume --opt=size=10
docker volume ls

eval $(docker-machine env node1)
docker run --rm -it --name ubu -v myvolume:/mypath ubuntu

for i in $(seq 1 10); do echo $(date -Iseconds) host:$(hostname) Message $i| tee -a /mypath/mylog.txt; sleep 1; done
cat /mypath/mylog.txt

eval $(docker-machine env node2)
docker run --rm -it --name ubu -v myvolume:/mypath ubuntu


docker service create --name ubu \
 --mount type=volume,source=myvolume,target=/mypath \
 ubuntu bash -c 'for i in $(seq 1 10); do echo $(date -Iseconds) host:$(hostname) Message $i| tee -a /mypath/mylog.txt; sleep 1; done'

docker service update --constraint-add 'node.hostname == node1' ubu
docker service update --constraint-rm 'node.hostname == node1' ubu


watch docker service ps ubu


```

# Create Swarm + RexRay
```
./up.sh
./swarmify.sh
cd ../RexRay
./rexify.sh
```