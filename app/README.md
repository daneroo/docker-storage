# Worker app

- Glide Based
- Simple worker writes message (to a database)
- instrumented with prometheus

## Build
```
./buildAndPush.sh
```

## Run
```
docker stack deploy -c docker-compose.yml  app

# -- viz
open "http://$(docker-machine ip node1):9999"

# -- grafana
open http://0.0.0.0:3000/
open "http://$(docker-machine ip node1):3000"
# --- prometheus
open http://0.0.0.0:9090/
open "http://$(docker-machine ip node2):9090"
# -- cockroach 8080
open http://0.0.0.0:8080/
open "http://$(docker-machine ip node2):8080"
```

## stadalond databases
```
docker run --rm -e POSTGRES_DB=dksto -e POSTGRES_USER=dkstouser -e POSTGRES_PASSWORD=dkstoseKret -p 5432:5432 postgres
docker run --rm -p 26257:5432 cockroachdb/cockroach:beta-20170112 start --logtostderr --insecure --http-host 0.0.0.0

/cockroach/cockroach sql -e 'create database if not exists dksto'
/cockroach/cockroach user set dkstouser
/cockroach/cockroach sql -e 'grant all on database dksto to dkstouser'

```
## References
- [Glide](https://github.com/Masterminds/glide)
- [Docker example](https://github.com/tvtamas/docker-golang-glide)
