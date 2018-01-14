# Install Ubuntu Server as Docker Engine


## Install Ubuntu Server
1. download Ubuntu Server 16.04.3
2. 


## [Prepare to install Docker CE](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository)
1. Update the apt package index
``` shell
sudo apt-get update
```
2. Install packages to allow apt to use a repository over HTTPS:
``` shell
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common
```
3. Add Docker’s official GPG key:
``` shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
4. set up the stable repository
``` shell
sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
```


## [Install Docker CE](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce-1)
1. List the available versions
``` shell
sudo apt-cache madison docker-ce
```
2. Instll the latest
``` shell
sudo apt-get install docker-ce=<VERSION>
```
3. Test
``` shell
sudo docker run hello-world
```

## Netshare
### Install Netshare
[Netshare](http://netshare.containx.io/docs/getting-started) is a Docker plugin which, among other things, provides NFS support
https://github.com/ContainX/docker-volume-netshare
1. Install NFS support on Ubuntu
``` shell
sudo apt-get install -y nfs-common
```
2. Look for the latest release:  https://github.com/ContainX/docker-volume-netshare/releases/
3. Install
``` shell
wget https://github.com/ContainX/docker-volume-netshare/releases/download/v0.34/docker-volume-netshare_0.34_amd64.deb
sudo dpkg -i docker-volume-netshare_0.34_amd64.deb
```
4. Modify the startup options
``` shell
sudo vi /etc/default/docker-volume-netshare
```
5. Start the service
``` shell
sudo service docker-volume-netshare start
```

### use Netshare
1. start the service
``` shell
sudo docker-volume-netshare nfs
```
2. Launch a container
``` shell
docker run -i -t --volume-driver=nfs -v nfshost/path:/mount ubuntu /bin/bash
```




## Install LXD
[LXD](https://www.ubuntu.com/containers/lxd) is a linux hypervisor to run full OSs like containers.  More info can be found [here](https://linuxcontainers.org/lxd/getting-started-cli/)
1. Activate LXD
``` shell
sudo lxd init
```
2. Create your first container
``` shell
lxc launch ubuntu: first-machine
```
3. See your machine running
``` shell
lxc list
```
4. Jump into that container
``` shell
lxc exec first-machine bash
```
5. clean up
``` shell
lxc stop first-machine
lxc delete first-machine
```


