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

docker service create --replicas 1 --name helloworld alpine ping docker.com
docker service inspect --pretty helloworld
docker service ps helloworld

docker service scale helloworld=5
docker service ps helloworld

docker service rm helloworld
```

## requiremets
Should make a script which checks...

- aws cli: `brew install awscli`
- docker-machine
- doctl: `brew install doctl`
