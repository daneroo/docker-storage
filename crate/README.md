## Crate.io
- [Dockercon Demo](https://crate.io/a/orchestrating-a-sql-database-cluster-with-docker/)
- [docker swarm info](https://crate.io/docs/scale/docker_swarm/)
- [k8s info](https://crate.io/docs/scale/kubernetes/)

Try using anonymous volume (no source=name)
```
docker service create \
  --name crate \
  --replicas 3 \
  --publish 4200:4200/tcp \
  --mount type=volume,target=/data,volume-driver=local \
  --update-delay 20s \
  --update-parallelism 1 \
  crate:1.0 \
  crate \
    -Des.cluster.name=dksto \
    -Des.discovery.zen.minimum_master_nodes=2 \
    -Des.gateway.recover_after_nodes=2 \
    -Des.gateway.recover_after_time=5m \
    -Des.gateway.expected_nodes=3
```

But swap mode=global for replicas 3, and anonymous mount for bin to /tmp
```
#    --mode global \
#    --mount type=bind,source=/tmp,target=/data \
#
# Can't publish 4200:
#  --publish 4200:4200/tcp \
# Error response from daemon: rpc error: code = 3 desc = EndpointSpec: port published with ingress mode can't be used with dnsrr mode

docker network create -d overlay crate-network
docker service create \
  --name crate \
  --network crate-network \
  --replicas 3 \
  --endpoint-mode dnsrr \
  --update-parallelism 1 \
  --update-delay 60s \
  --mount type=volume,target=/data,volume-driver=local \
  crate:1.0 \
    crate \
    -Des.discovery.zen.ping.multicast.enabled=false \
    -Des.discovery.zen.ping.unicast.hosts=crate \
    -Des.gateway.expected_nodes=3 \
    -Des.discovery.zen.minimum_master_nodes=2 \
    -Des.gateway.recover_after_nodes=2 \
    -Des.network.bind=_eth0:ipv4_

```