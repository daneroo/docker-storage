# Docker Storage

Notes for Docker Ottawa meetup 2017-01-25

- The problem
- The objective
- The how

## TODO 
- [Swarm viz](https://github.com/ManoMarks/docker-swarm-visualizer)
- Refactor swarm/up|down innto single with param for MACHINE_TYPE / number (MGR/WRK)
- [RexRay](https://github.com/codedellemc/labs/tree/master/demo-persistence-with-postgres-docker)
- [Infinit](https://infinit.sh/get-started/linux)

## Swarm (AWS / Digital Ocean)
Check the `swarm/` directory
```bash
./up.sh 
./swarmify.sh

./down.sh
```

## Swarm Viz
Show the [Swarm viz](https://github.com/ManoMarks/docker-swarm-visualizer).
```bash
docker service create \
  --name=viz \
  --publish=80:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  manomarks/visualizer

open "http://$(docker-machine ip node1)"
```

## K8s (kops/minikube)