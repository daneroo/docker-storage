# Docker Storage

Notes for Docker Ottawa meetup 2017-01-25

- The problem
- The objective
- The how

## TODO 
- [RexRay](https://github.com/codedellemc/labs/tree/master/demo-persistence-with-postgres-docker)
- app in GO
- [Infinit and Docker](https://media-glass.es/playing-with-infinit-docker-651236e68cf#.viifcrula)
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

## Docker for AWS
- [Docker for AWS](https://docs.docker.com/docker-for-aws/)
- [Launch Docker for AWS](https://docs.docker.com/docker-for-aws/release-notes/)

ssh into one of the managers:
```
ssh -i ~/.ssh/cdb-dan.pem docker@54.144.4.109
```

## K8s (kops/minikube)