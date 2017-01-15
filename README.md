# Docker Storage

Notes for Docker Ottawa meetup 2017-01-25

- The problem
- The objective
- The how

## TODO 
- [RexRay](https://github.com/codedellemc/labs/tree/master/demo-persistence-with-postgres-docker)
- [Flocker](https://flocker-docs.clusterhq.com/en/latest/docker-integration/manual-install.html)
- [Tectonic on CoreOS](https://tectonic.com/enterprise/docs/latest/install/aws/index.html)
- [Helm](https://github.com/kubernetes/helm)
- [Helm CI/CD article](https://hackernoon.com/the-missing-ci-cd-kubernetes-component-helm-package-manager-1fe002aac680#.mq4ol654o)
- Refactor swarm/up|down innto single with param for MACHINE_TYPE / number (MGR/WRK)
- Rewrite in GO!
- New Relic + reset key (iMetrical/Main)
- [Infinit](https://infinit.sh/get-started/linux)

## Swarm (AWS / Digital Ocean)
Check the `swarm/` directory
```bash
./up.sh 
./swarmify.sh

./down.sh
```

## RexRay
See `RexRay/`

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

## New Relic instrumentation
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
## K8s (kops/minikube)