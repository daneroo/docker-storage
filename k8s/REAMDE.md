# Kubernetes

## cockroachdb petset example
```
./minikube.sh
# -- or
kubectl create -f cockroachdb-statefulset.yaml

# -- in another shell
kubectl port-forward cockroachdb-0 8080

open http://0.0.0.0:8080
./demo.sh

# -- get a sql client
kubectl run -it --rm cockroach-client --image=cockroachdb/cockroach --restart=Never --command -- ./cockroach sql --host cockroachdb-public

# -- scale up and down
kubectl scale statefulset cockroachdb --replicas=4
kubectl scale statefulset cockroachdb --replicas=3

# -- clean up
kubectl delete statefulsets,pods,persistentvolumes,persistentvolumeclaims,services -l app=cockroachdb
# -- check
kubectl get pods,persistentvolumes,persistentvolumeclaims,services
```

## kops
- [kops](https://github.com/kubernetes/kops)
- [kops tutorial](https://github.com/kubernetes/kops/blob/master/docs/aws.md)
- See also `/Code/Irdeto/OPD/cdb-infra/k8s/kops-aws`

### Create
```bash
# perhaps should enable versioning? name region: --region us-east-1
aws s3 mb s3://kops_clusters.imetrical.net
export KOPS_STATE_STORE=s3://kops_clusters.imetrical.net
export NAME=dksto.imetrical.net
export EDITOR=emacs

# check zones: aws ec2 describe-availability-zones --region us-east-1

# -- create
#   other options
# --cloud aws : implicit with name of zone
# --ssh-public-key (default is ~/.ssh/id_rsa.pub)
# --master-zones : must be odd, where to run master nodes
# --zones : where to run cluster
# --master-size=m3.medium # is the default
# --node-size=t2.medium # is the default
# --node-count 2  # is the default
# --kubernetes-version=1.2.2
kops create cluster \
  --zones=us-east-1c \
  --master-size=t2.small \
  --node-size=t2.small \
  --node-count 5 \
  --kubernetes-version=1.5.2 \
  ${NAME}
```

### Review / Update
```
kops get cluster # list clusters
kops edit cluster --name ${NAME}
kops get instancegroups --name ${NAME} # list instance groups
kops edit ig --name ${NAME} nodes
kops edit ig --name ${NAME} master-us-east-1c
```

### Now bring up the cluster:
```
kops update cluster ${NAME} --yes
```

### Smoke test:
```
kubectl get nodes --show-labels

# -o "UserKnownHostsFile /dev/null"
ssh admin@api.${NAME}
```

### Dashboard
With watch:
```
watch kubectl get pods,persistentvolumes,persistentvolumeclaims,services
```

Dashboard addon:
```bash
kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.5.0.yaml
kubectl proxy
open http://127.0.0.1:8001/api
open 'http://127.0.0.1:8001/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard/#/admin?namespace=default'
```


### Tear it down:
```
kops delete cluster ${NAME} --yes
```

```
# -- review
kops get cluster # list clusters
kops edit cluster ${NAME}

```


## minikube refresher
```
minikube start

kubectl get pods --all-namespaces
kubectl get nodes

kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
kubectl get pods
kubectl get deployments

kubectl expose deployment hello-minikube --type=NodePort
kubectl get services

curl $(minikube service hello-minikube --url)
kubectl delete service,deployment hello-minikube

# -- check
kubectl get pods
kubectl get deployments
kubectl get services
```
