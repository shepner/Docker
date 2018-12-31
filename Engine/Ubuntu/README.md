# Install Ubuntu Server as Docker Engine


## Install Ubuntu Server
1. download Ubuntu Server 18.04.1
2. VMware guest settings:

   CPU: 8
   
   RAM: 64
   
   Disk: 128
   
3. assign static IP addrs in DHCP
4. add the name/ip to DNS (docker-machine wont work without this!)
5. setup ssh keys: `ssh-copy-id -i ~/.ssh/<key> <user>@<host>`

## setup Docker
1. login to server: `ssh <user>@<host>`
2. setup generic docker account
``` shell
sudo groupadd docker
sudo adduser --home /home/dockerengine --shell /bin/bash --ingroup sudo --ingroup docker dockerengine
sudo gpasswd -a dockerengine docker
sudo gpasswd -a dockerengine sudo
```
3. Remove what little bits of pesky security we have for the sevice ID
``` shell
echo 'dockerengine ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
```
TODO:  tie this down to specific commands to pretend its more secure

4. update the system
``` shell
bash <(curl -s https://raw.githubusercontent.com/shepner/Docker/master/Engine/Ubuntu/update_ubuntu.sh)
```

## Install Docker CE
``` shell
bash <(curl -s https://raw.githubusercontent.com/shepner/Docker/master/Engine/Ubuntu/install_docker.sh)
sudo reboot
```

---

Not sure if I want to use this


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
echo "nasname:/dockermountpoint /mnt/nasname/docker nfs rw 0 0" | sudo tee --append /etc/fstab
sudo mkdir -p /mnt/nasname/docker
sudo mount -a
sudo chown dockerengine:docker /mnt/nasname/docker
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


