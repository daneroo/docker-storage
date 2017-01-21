# Docker for AWS

- [Docker for AWS](https://docs.docker.com/docker-for-aws/)
- [Launch Docker for AWS](https://docs.docker.com/docker-for-aws/release-notes/)
- [Direct Stack](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=Docker&templateURL=https://editions-us-east-1.s3.amazonaws.com/aws/stable/Docker.tmpl)

## Create
```
aws cloudformation create-stack --stack-name d4aws \
  --template-url <templateurl> \
  --parameters \
  ParameterKey=KeyName,ParameterValue=<keyname> \
  ParameterKey=InstanceType,ParameterValue=t2.micro \
  ParameterKey=ManagerInstanceType,ParameterValue=t2.micro \
  ParameterKey=ClusterSize,ParameterValue=1 \
  --capabilities CAPABILITY_IAM
```

## Access to manager
ssh into one of the managers:
```
ssh -i ~/.ssh/cdb-dan.pem docker@54.144.4.109
curl -O https://raw.githubusercontent.com/daneroo/docker-storage/master/app/docker-compose.yml

# -- use ELB
open http://docker-elb-510328559.us-east-1.elb.amazonaws.com:9999/
```
