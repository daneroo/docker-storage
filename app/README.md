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
# --- prometheus
open http://0.0.0.0:9090/
# -- cockroach 8080
open http://0.0.0.0:8080/

```
## References
- [Glide](https://github.com/Masterminds/glide)
- [Docker example](https://github.com/tvtamas/docker-golang-glide)
