# RexRay integration

- [Manual installation - Install via curl](http://rexray.readthedocs.io/en/stable/user-guide/installation/#install-via-curl)
- [Docs on ebs config](http://libstorage.readthedocs.io/en/stable/user-guide/storage-providers/#aws-ebs)
- [Docs on efs config](http://libstorage.readthedocs.io/en/stable/user-guide/storage-providers/#aws-efs)
- [RexRay Config generator](http://rexrayconfig.codedellemc.com/)

## Vagrant
Run the demo from [this article](http://rexray.readthedocs.io/en/stable/user-guide/demo/)

## On EC2
Make a machine
```bash
export MACHINE_DRIVER=amazonec2
# export AWS_AMI=ami-5f709f34  #default hvm-ssd
export AWS_AMI=ami-45709f2e  #hvm, default still borks (this is for us-east-1)

docker-machine create aws01

docker-machine ssh aws01
```
Install rexray, config start service
```bash
sudo su -
curl -sSL https://dl.bintray.com/emccode/rexray/install | sh -s -- stable
rexray version
service rexray status
#  REX-Ray is stopped


vi /etc/rexray/config.yml
rexray start
# or
service rexray start
```
Make a vloume
```bash
docker volume create -d rexray --name pg_data --opt=size=10
docker volume create -d rexray --name pg_data --opt=size=10 --opt=type=gp2
docker volume create -d rexray --name pg_data --opt=size=10 --opt=type=io1 --opt=iops=150
# or
sudo rexray volume create --volumename pg_data --size=10

docker volume ls
docker volume inspect pg_data

docker run -dit --name pg -e POSTGRES_PASSWORD=mysecretpassword --volume-driver=rexray -v pg_data:/var/lib/postgresql/data postgres
```


## References
- [Getting started](http://rexray.readthedocs.io/en/stable/#quick-start)
- [Vagrant (local) demo](http://rexray.readthedocs.io/en/stable/user-guide/demo/)
- [RexRay Config generator](http://rexrayconfig.codedellemc.com/)
- [Postgres demo](https://github.com/codedellemc/labs/tree/master/demo-persistence-with-postgres-docker)
