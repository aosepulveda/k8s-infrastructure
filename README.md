# Kubernetes Infrastructure PoC

This repository contains scripts for a basic infrastructure based on Kubernetes.

## Basic commands

```bash
kubectl get pod # check pods
minikube dashboard # view minikube dashboard
```

## Local Environment

Using minikube as a local cluster.

```bash
brew install kubernetes-cli # install kubectl
kubectl version --short
brew install minikube
minikube start
minikube status
```
<https://kubernetes.io/docs/tasks/tools/install-minikube/>



## GitOps Configuration

### Flux

```bash
helm repo add fluxcd https://charts.fluxcd.io
kubectl create ns fluxcd
curl -sL https://fluxcd.io/install | sh
```

```bash
helm upgrade -i flux fluxcd/flux --wait \
--namespace fluxcd \
--set registry.pollInterval=1m \
--set git.pollInterval=1m \
--set git.url=git@github.com:aosepulveda/k8s-infrastructure
```

Output:

```bash
Release "flux" does not exist. Installing it now.
NAME: flux
LAST DEPLOYED: Sat Aug  8 18:29:03 2020
NAMESPACE: fluxcd
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Get the Git deploy key by either (a) running

  kubectl -n fluxcd logs deployment/flux | grep identity.pub | cut -d '"' -f2

or by (b) installing fluxctl through
https://docs.fluxcd.io/en/latest/references/fluxctl#installing-fluxctl
and running:

  fluxctl identity --k8s-fwd-ns fluxcd
```

## Service Mesh

<https://linkerd.io/2/getting-started/>

### Installation

#### Local Environment

```bash
brew install linkerd
linkerd check --pre # validate k8s cluster
linkerd install | kubectl apply -f - # install
linkerd check
linkerd dashboard & # check dashboard
```

## Helm

<https://helm.sh/>

### Installation

```bash
brew install helm
```

## Helm Operator

```bash
helm upgrade -i helm-operator fluxcd/helm-operator --wait \
--namespace fluxcd \
--set git.ssh.secretName=flux-git-deploy \
--set git.pollInterval=1m \
--set chartsSyncInterval=1m \
--set helm.versions=v3
```

## Flagger

```bash
helm repo add flagger https://flagger.app
kubectl apply -f https://raw.githubusercontent.com/weaveworks/flagger/master/artifacts/flagger/crd.yaml
helm upgrade -i flagger flagger/flagger --wait \
--namespace linkerd \
--set crd.create=false \
--set metricsServer=http://linkerd-prometheus:9090 \
--set meshProvider=linkerd
```

## Extras

### Kong API Gateway

```bash
helm repo add kong https://charts.konghq.com
helm repo update
helm install kong/kong --generate-name --set ingressController.installCRDs=false
```

The installation return this:

```
NAME: kong-1596641728
LAST DEPLOYED: Wed Aug  5 11:35:35 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
To connect to Kong, please execute the following commands:

HOST=$(kubectl get svc --namespace default kong-1596641728-kong-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PORT=$(kubectl get svc --namespace default kong-1596641728-kong-proxy -o jsonpath='{.spec.ports[0].port}')
export PROXY_IP=${HOST}:${PORT}
curl $PROXY_IP

Once installed, please follow along the getting started guide to start using
Kong: https://bit.ly/k4k8s-get-started
```

for get PROXY_IP run

```bash
export PROXY_IP=$(minikube service kong-1596641728-kong-proxy --url | head -1)
```

### Terraform

#### Installation

```bash
brew install terraform
```

#### Output

```base
    ~/Doc/D/kubernetes/k8s-infrastructure/terraform  terraform apply "output.tfplan"                                                                  ✔  8s   22:14:41 
google_container_cluster.primary: Creating...
google_container_cluster.primary: Still creating... [10s elapsed]
google_container_cluster.primary: Still creating... [20s elapsed]
google_container_cluster.primary: Still creating... [30s elapsed]
google_container_cluster.primary: Still creating... [40s elapsed]
google_container_cluster.primary: Still creating... [50s elapsed]
google_container_cluster.primary: Still creating... [1m0s elapsed]
google_container_cluster.primary: Still creating... [1m10s elapsed]
google_container_cluster.primary: Still creating... [1m20s elapsed]
google_container_cluster.primary: Still creating... [1m30s elapsed]
google_container_cluster.primary: Still creating... [1m40s elapsed]
google_container_cluster.primary: Still creating... [1m50s elapsed]
google_container_cluster.primary: Still creating... [2m0s elapsed]
google_container_cluster.primary: Still creating... [2m10s elapsed]
google_container_cluster.primary: Still creating... [2m20s elapsed]
google_container_cluster.primary: Still creating... [2m30s elapsed]
google_container_cluster.primary: Creation complete after 2m36s [id=projects/tyndorael-projects/locations/us-east1-d/clusters/mobile-apps]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

cluster = mobile-apps
cluster_ca_certificate = <sensitive>
host = <sensitive>
password = <sensitive>
username = <sensitive>
```