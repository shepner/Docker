# RancherOS

This is for deploying a redundent Kubernetes cluster via RKE to run Rancher.

## VMware settings

1.  Ubuntu Linux (64-bit)
2.  CPU: 8 (worker) 2 (manager)
3.  Memory:   64GB (worker) 16GB (manager)
4.  Disk:  60GB
5.  Network: 10.0.0.0/24

## Install RancherOS

Instructions for manually installing [RancherOS](https://rancher.com/rancher-os/) came from [here](https://sdbrett.com/BrettsITBlog/2017/01/rancheros-installing-to-hard-disk/)

Here are the full details for [configuring RancherOS](https://rancher.com/docs/os/configuration/)

make sure that the system will have internet access.  you wont be able to install to disk without it

do this on the VM itself:

1.  make sure to create ssh keys in advance
2.  boot up under VMware in the usual way
3.  run the following command and change the password:
    `sudo passwd rancher`
4.  obtain the ip address of the system:
    `ifconfig eth0`
5.  on your local machine, generate the ssh keypair you intend to use:
    `ssh-keygen -t rsa`

and now you can do this from a workstation:

1.  ssh to the system:
    `ssh rancher@<ip address>`
2.  download the config file:
    `wget https://raw.githubusercontent.com/shepner/Docker/master/Rancher/cloud-config.yml`
3.  edit the file:
    `vi cloud-config.yml`
4.  install RancherOS to disk and reboot:
    `sudo ros install -c cloud-config.yml -d /dev/sda`

install ssh keys:
* All nodes:
  `scp .ssh/rancher_rsa manager:.ssh/id_rsa`
* Managers only:
  `scp .ssh/rancher_rsa.pub manager:.ssh/id_rsa.pub`

## Install NGINX

[instructions](https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/create-nodes-lb/)

On the NGINX Load Balancer machine:

```
wget -P /home/rancher https://raw.githubusercontent.com/shepner/Docker/master/Rancher/nginx.conf
```

edit the file as appropriate:
`vi /home/rancher/nginx.conf`

```
docker run \
  -d \
  --restart=unless-stopped \
  -p 80:80 \
  -p 443:443 \
  -v /home/rancher/nginx.conf:/etc/nginx/nginx.conf \
  nginx:1.15
```

## Rancher

### Setup the Rancher cluster

[Rancher cluster instructions](https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/kubernetes-rke/)

[RKE install instructions](https://rancher.com/docs/rke/latest/en/installation/)

[kubernetes install](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

```
mkdir ~/.kube
wget -P ~/.kube https://raw.githubusercontent.com/shepner/Docker/master/Rancher/rancher-cluster.yml
```

Only run this on one of the 3 managers:

```
rke up --config ~/.kube/rancher-cluster.yml
ln -s ~/.kube/kube_config_rancher-cluster.yml ~/.kube/config
```

if you remove the cluster, reboot the nodes to clear out the docker instances.

### Install the cert manager

```
# Install the CustomResourceDefinition resources separately
#kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/v0.13.1/deploy/manifests/00-crds.yaml

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
#helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.12.0
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.13.1
```

verify is is running:
`kubectl get pods --namespace cert-manager`

### Install Rancher ([instructions](https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/helm-rancher/))

```
# Update your local Helm chart repository cache
helm repo update

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

kubectl create namespace cattle-system
```

Do this if using Rancher with self signed certs:

```
#helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.my.org
helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.asyla.org --set ingress.tls.source=rancher 
```

or do this for Rancher with Lets Encrypt certs:

```
#helm install rancher rancher-stable/rancher \
#  --namespace cattle-system \
#  --set hostname=rancher.my.org \
#  --set ingress.tls.source=letsEncrypt \
#  --set letsEncrypt.email=me@example.org
```

To watch status updates:
`kubectl -n cattle-system rollout status deploy/rancher`
