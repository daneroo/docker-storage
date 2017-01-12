# Docker Storage

Notes for Docker Ottawa meetup 2017-01-25

- The problem
- The objective
- Thw how

## requiremets
Should make a script which checks...

- aws cli
- docker-machine
- 

## docker-machine (ec2)
Based on Orchestration workshop/prepare-machine/

### setup
```
./setup-machine.sh 
```
### Cleanup
```bash
for N in $(seq 1 5); do
  docker-machine rm -f node$N
done
```

