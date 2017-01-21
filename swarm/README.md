# Docker Swarm scripts

Use docker-machine (AWS ec2 / digital ocean) to provision swarm

_Based on Orchestration workshop/prepare-machine/_

## Setup Host Machines
on AWS takes 200s
on DigitalOcean : 250s
```bash
./up.sh 
```
### Create the swarm
- node 1-3 managers
- node 4-5 workers
```bash
./swarmify.sh
```

### Cleanup Host Machines
```bash
./down.sh
```


## Usage
swarm service example
```
eval $(docker-machine env node1)
docker node ls

docker service create --replicas 1 --name helloworld alpine ping google.com
docker service inspect --pretty helloworld
docker service ps helloworld

docker service scale helloworld=5
docker service ps helloworld

docker service rm helloworld
```

## Monitoring/Visualizing

See [this article for grafana/prometheus in swarm mode services](https://grafana.net/dashboards/609)

### Show the [Swarm viz](https://github.com/ManoMarks/docker-swarm-visualizer).
```bash
eval $(docker-machine env node1)
docker service create \
  --name=viz \
  --publish=9999:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  manomarks/visualizer

open "http://$(docker-machine ip node1):9999"
```

### CAdvisor
```
docker service create \
  --mode global \
  --mount type=bind,source=/,destination=/rootfs,ro=1 \
  --mount type=bind,source=/var/run,destination=/var/run \
  --mount type=bind,source=/sys,destination=/sys,ro=1 \
  --mount type=bind,source=/var/lib/docker/,destination=/var/lib/docker,ro=1 \
  --publish mode=host,target=8080,published=8080 \
  --name=cadvisor \
  google/cadvisor:latest
```
### New Relic instrumentation
- See also `ir-runner, instapool`
- Turn this into a service running on all hosts

```bash
NEWRELIC_KEY="......"
docker run -d \
--privileged=true --name nrsysmond \
--pid=host \
--net=host \
-v /sys:/sys \
-v /dev:/dev \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /var/log:/var/log:rw \
-e NRSYSMOND_license_key=${NEWRELIC_KEY} \
-e NRSYSMOND_logfile=/var/log/nrsysmond.log \
newrelic/nrsysmond:latest
```

## requiremets
Should make a script which checks...

- aws cli: `brew install awscli`
- docker-machine
- doctl: `brew install doctl`
