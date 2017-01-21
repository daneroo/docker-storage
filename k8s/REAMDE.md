# Kubernetes

## cockroachdb petset example
```
./minikube.sh

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
