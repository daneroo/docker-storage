# Scenario

## RexRay - Swarm

```bash
eval $(docker-machine env node1)
# -- Swarm Vizualizer
docker service create \
  --name=viz \
  --publish=9999:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  manomarks/visualizer

open "http://$(docker-machine ip node1):9999"

# -- scaling compute
docker service create --replicas 1 --name helloworld alpine ping google.com
docker service scale helloworld=5
docker service ps helloworld

docker service rm helloworld

# -- docker volume (manual)
docker volume ls
docker volume create -d rexray --name myvolume --opt=size=10
docker volume ls

# -- run and attach from host 1
eval $(docker-machine env node1)
docker run --rm -it --name ubu -v myvolume:/mypath ubuntu

for i in $(seq 1 10); do echo $(date -Iseconds) host:$(hostname) Message $i| tee -a /mypath/mylog.txt; sleep 1; done
cat /mypath/mylog.txt

# -- run and attach from host 1
eval $(docker-machine env node2)
docker run --rm -it --name ubu -v myvolume:/mypath ubuntu


docker service create --name ubu \
 --mount type=volume,source=myvolume,target=/mypath \
 ubuntu bash -c 'for i in $(seq 1 10); do echo $(date -Iseconds) host:$(hostname) Message $i| tee -a /mypath/mylog.txt; sleep 1; done'

docker service update --constraint-add 'node.hostname == node1' ubu
docker service update --constraint-rm 'node.hostname == node1' ubu


watch docker service ps ubu
```

## K8s Persitent Volume claims
```
watch kubectl get pods,persistentvolumes,persistentvolumeclaims,services

kubectl create -f cockroachdb-statefulset.yaml

kubectl exec cockroachdb-0 -- /cockroach/cockroach sql --host cockroachdb-0.cockroachdb -e 'create database if not exists dksto'
kubectl exec cockroachdb-0 -- /cockroach/cockroach user set --host cockroachdb-0.cockroachdb dkstouser
kubectl exec cockroachdb-0 -- /cockroach/cockroach sql --host cockroachdb-0.cockroachdb -e 'grant all on database dksto to dkstouser'

# -- shel on node (if needed)
kubectl exec -it cockroachdb-0 bash
# -- UI
kubectl port-forward cockroachdb-0 8080
open http://0.0.0.0:8080

# -- run the generator
kubectl run -it --rm generator --env DB_CONNECT="host=cockroachdb-0.cockroachdb port=26257 dbname=dksto sslmode=disable user=dkstouser password=dkstoseKret" --image=daneroo/dksto_generator --restart=Never

# -- scale up 
kubectl scale statefulset cockroachdb --replicas=3

# -- kill a node
kubectl delete pod cockroachdb-1

# -- scale up and down
kubectl scale statefulset cockroachdb --replicas=2
kubectl scale statefulset cockroachdb --replicas=3
kubectl scale statefulset cockroachdb --replicas=4
kubectl scale statefulset cockroachdb --replicas=3

# -- clean up
kubectl delete statefulsets,pods,persistentvolumes,persistentvolumeclaims,services -l app=cockroachdb

```

## Create Swarm + RexRay
```
cd ../swarm
./up.sh
./swarmify.sh
cd ../RexRay
./rexify.sh

docker node ls
```