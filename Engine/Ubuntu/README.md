# Install Docker Engine on Ubuntu Server


## Install Ubuntu Server
1. download Ubuntu Server 18.04.1
2. VMware guest settings:
   * CPU: 8
   * RAM: 64
   * Disk: 128
3. NIC settings:
   * assign static IP address. Note we arent going to use DNS/DHCP because those services may be hosted in docker.
   * DNS servers: 208.67.222.222, 208.67.220.220
4. be sure to setup a normal user account that wont be used for Docker
5. ssh to the host `ssh <user>@<host>` and create generic docker account
``` shell
sudo groupadd asyla --gid 1000
sudo adduser --home /home/docker --uid 1003 --gid 1000 --shell /bin/bash docker

sudo gpasswd -a docker sudo
```
you may need to fix the group name
6. setup ssh keys:
``` shell
DHOST=<host IP>
ssh-copy-id -i ~/.ssh/docker_rsa docker@$DHOST

scp ~/.ssh/docker_rsa.pub docker@$DHOST:.ssh/
scp ~/.ssh/docker_rsa docker@$DHOST:.ssh/
ssh docker@$DHOST "chmod 600 .ssh/docker_rsa
scp ~/.ssh/config docker@$DHOST:.ssh/
```
   This might also be a good point to update `~/.ssh/config` so specifying the user ID and identity file is not needed
7. ssh to the host `ssh docker@host>` and [disable the local dns listener](https://mmoapi.com/post/how-to-disable-dnsmasq-port-53-listening-on-ubuntu-18-04) (might require a reboot)
``` shell
#sudo netstat -tulnp | grep 53
echo 'DNSStubListener=no' | sudo tee --append /etc/systemd/resolved.conf
sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved.service
#sudo netstat -tulnp | grep 53

sudo rm /etc/resolv.conf
sudo sh -c 'cat > /etc/resolv.conf << EOF
nameserver 208.67.222.222
nameserver 208.67.220.220
EOF'
```
   dont worry too much about the "sudo: unable to resolve host <hostname>: Resource temporarily unavailable" error.  This is fixed by placing the hostname in `/etc/hosts` which we will do later.


## setup Docker
1. login to server: `ssh docker@<host>`
2. Remove what little bits of pesky security we have for the sevice ID (dont forget to actually run that or you will get `sudo: no tty present and no askpass program specified`)
``` shell
echo 'docker ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
```
3. update the hostfile
``` shell
bash <(curl -s https://raw.githubusercontent.com/shepner/Docker/master/Manager/HOME/bin/update_etc_hosts.sh)
```
4. update the system
``` shell
bash <(curl -s https://raw.githubusercontent.com/shepner/Docker/master/Engine/Ubuntu/update_ubuntu.sh)
```

## Install Docker CE
``` shell
bash <(curl -s https://raw.githubusercontent.com/shepner/Docker/master/Engine/Ubuntu/install_docker.sh)
```

## setup NFS
first, update the hosts file for the NFS host
 ``` shell
 echo  >> /etc/hosts
 echo "<IP> <name>" | sudo tee --append /etc/hosts
 ```

``` shell
sudo apt-get update
sudo apt-get install -y nfs-common

sudo mkdir -p /mnt/nas/docker
echo "nas:/mnt/data2/docker /mnt/nas/docker nfs rw 0 0" | sudo tee --append /etc/fstab

sudo mkdir -p /mnt/nas/media
echo "nas:/mnt/data1/media /mnt/nas/media nfs rw 0 0" | sudo tee --append /etc/fstab

sudo mkdir -p /mnt/nas/downloads
echo "nas:/mnt/data1/downloads /mnt/nas/downloads nfs rw 0 0" | sudo tee --append /etc/fstab

sudo mount -a

#sudo chown -R dockerengine:docker /mnt/nas/docker
```

``` Shell
sudo reboot
```

### CIFS support
```
sudo apt install cifs-utils
```


---

## Review this stuff below

---

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


