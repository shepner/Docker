# RancherOS

This is for deploying a redundent Kubernetes cluster via RKE to run Rancher.

## VMware settings

1.  Ubuntu Linux (64-bit)
2.  CPU: 8 (worker) 2 (manager)
3.  Memory:   64GB (worker) 8GB (manager)
4.  Disk:  16GB
5.  Network: 10.0.0.0/24

## Install RancherOS

Instructions for manually installing [RancherOS](https://rancher.com/rancher-os/) came from [here](https://sdbrett.com/BrettsITBlog/2017/01/rancheros-installing-to-hard-disk/)

Here are the full details for [configuring RancherOS](https://rancher.com/docs/os/configuration/)

make sure that the system will have internet access.  you wont be able to install to disk without it

### on the VM

1.  boot up under VMware in the usual way
2.  run the following command and change the password:  ```sudo passwd rancher```
3.  obtain the ip address of the system:  ```ifconfig eth0```
4.  on your local machine, generate the ssh keypair you intend to use:  ```ssh-keygen -t rsa```

### initial config from a workstation

make sure to create ssh keys in advance

1.  ssh to the system:
    - ```ssh rancher@<ip address>```
2.  download the config file:
    - ```wget https://raw.githubusercontent.com/shepner/Docker/master/Rancher/cloud-config.yml```
3.  edit the file:  ```vi cloud-config.yml```
4.  install RancherOS to disk and reboot:
    - ```sudo ros install -c cloud-config.yml -d /dev/sda```

## manager specific

### setup nodes and a load balancer

[instructions](https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/create-nodes-lb/)

On the NGINX Load Balancer:

```
wget -P /home/rancher https://raw.githubusercontent.com/shepner/Docker/master/Rancher/nginx.conf
```

edit the file as appropriate: `vi /home/rancher/nginx.conf`

```
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /home/rancher/nginx.conf:/etc/nginx/nginx.conf \
  nginx:1.15
```

### install ssh keys:

```
scp .ssh/rancher_rsa manager:.ssh/id_rsa
scp .ssh/rancher_rsa.pub manager:.ssh/id_rsa.pub
```

### install rancher

#### setup kubernetes cluster

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

#### install rancher 

[instructions](https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/helm-rancher/)

```
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

kubectl create namespace cattle-system
```

Install the cert manager

```
# Install the CustomResourceDefinition resources separately
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.12.0
```

verify is is running:

```
kubectl get pods --namespace cert-manager
```

Do this if using Rancher with self signed certs:

```
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.my.org
```

or do this for Rancher with Lets Encrypt certs:

```
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.my.org \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=me@example.org
```

To watch status updates:

```
kubectl -n cattle-system rollout status deploy/rancher
```
