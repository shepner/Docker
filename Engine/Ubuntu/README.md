# Install Ubuntu Server as Docker Engine


## Install Ubuntu Server
1. download Ubuntu Server 16.04.3
2. VMware guest settings:
CPU: 8
RAM: 64
Disk: 128
3. assign static IP addrs in DHCP server and update DNS
4. setup ssh keys `ssh-copy-id -i ~/.ssh/<key> <user>@<host>`
5. setup generic docker account
``` shell
sudo adduser --home /home/dockerengine --shell /bin/bash --ingroup sudo dockerengine
```
6. update the system
``` shell
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo reboot
```

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
1. Instll the latest
``` shell
sudo apt-get install docker-ce
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
test to make sure it all works
``` shell
sudo mount -t nfs4 1.1.1.1:/mountpoint /mnt
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
5. Start the service (from [here](https://www.howtogeek.com/216454/how-to-manage-systemd-services-on-a-linux-system/))
``` shell
#sudo service docker-volume-netshare start
sudo systemctl enable docker-volume-netshare.service
sudo systemctl start docker-volume-netshare.service
```

### use Netshare
1. Launch a container
``` shell
docker run -i -t --volume-driver=nfs -v nfshost/path:/mount ubuntu /bin/bash
```

### or better, just use NFS at the host
``` shell
sudo apt-get install -y nfs-common
sudo echo "hostname:/some/path/here /mnt nfs rw 0 0" >> /etc/fstab
sudo mount -a
```


---

---

## Install LXD (need to play with this more)
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


