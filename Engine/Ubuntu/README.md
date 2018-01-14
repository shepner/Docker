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








