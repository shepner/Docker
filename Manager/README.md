# Docker Manager

Follow the instructions below as appropriate. Everything is using Ubuntu

## AWS instructions

<placeholder>

## Local Ubuntu instructions

### Install Ubuntu Server
1. download Ubuntu Server 18.04.1
2. VMware guest settings:
   * CPU: 2
   * RAM: 64
   * Disk: 128
3. Docker settings:
   * assign static IP address.  Note we arent going to use DNS/DHCP because those services may be hosted in docker.
   * DNS servers:  208.67.222.222, 208.67.220.220
   * create a personal account
4. ssh to the host `ssh docker@host>` and [disable the local dns listener](https://mmoapi.com/post/how-to-disable-dnsmasq-port-53-listening-on-ubuntu-18-04) (might require a reboot)
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

## Instructions for all managers

At this point all managers should be at the same point regardless of where they reside

### setup the Docker service account
1. login to server: `ssh docker@<host>`
2. setup generic docker account
``` shell
sudo groupadd docker --gid 1100
sudo adduser --home /home/docker --uid 1003 --gid 1100 --shell /bin/bash docker

sudo gpasswd -a docker sudo
```
3. Remove what little bits of pesky security we have for the sevice ID
``` shell
echo 'docker ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
```
4. update the hostfile
``` shell
bash <(curl -s https://raw.githubusercontent.com/shepner/Docker/master/Manager/HOME/bin/update_etc_hosts.sh)
```
5. copy the ssh keys to docker managers
``` shell
nodes[0]="dm01"
nodes[1]="dm02"
nodes[2]="dm03"
nodes[3]="dm04"
for DHOST in ${nodes[@]} ; do
  ssh-copy-id -i ~/.ssh/<key> docker@$DHOST
  ssh docker@$DHOST "mkdir -p .ssh"
  scp ~/.ssh/docker_rsa docker@$DHOST:.ssh/docker_rsa
  scp ~/.ssh/docker_rsa.pub docker@$DHOST:.ssh/docker_rsa.pub
  ssh docker@$DHOST "chmod -R 700 ~/.ssh"
done
```
   This might also be a good point to update `~/.ssh/config` so specifying the user ID and identity file is not needed


### patch the system
``` shell
bash <(curl -s https://raw.githubusercontent.com/shepner/Docker/master/Manager/HOME/bin/update_ubuntu.sh)
```

### setup NFS
``` shell
sudo apt-get install -y nfs-common

#sudo mkdir -p /mnt/nas/docker
#echo "nas:/data1/docker /mnt/nas/docker nfs rw 0 0" | sudo tee --append /etc/fstab

#sudo mkdir -p /mnt/nas/downloads
#echo "nas:/mnt/data1/downloads /mnt/nas/downloads nfs rw 0 0" | sudo tee --append /etc/fstab

#sudo mount -a

#sudo chown -R docker:docker /mnt/nas/docker
```

### CIFS support ([article](https://wiki.ubuntu.com/MountWindowsSharesPermanently))
```
sudo apt install cifs-utils

sh -c 'cat > /home/docker/.smbcredentials << EOF
username=docker
password=mspassword
domain=
EOF'
chmod 600 /home/docker/.smbcredentials

sudo mkdir -p /mnt/nas/docker1
echo "//nas/docker1 /mnt/nas/docker1 cifs rw,credentials=/home/docker/.smbcredentials 0 0" | sudo tee --append /etc/fstab

sudo mkdir -p /mnt/nas/docker
echo "//nas/docker   /mnt/nas/docker cifs rw,credentials=/home/docker/.smbcredentials 0 0" | sudo tee --append /etc/fstab

sudo mount -a
```

### Install Docker software

[Docker CE for Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
``` shell
bash <(curl -s https://raw.githubusercontent.com/shepner/Docker/master/Engine/Ubuntu/install_docker.sh)
```

[docker machine](https://docs.docker.com/machine/install-machine/#install-machine-directly)
``` shell
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
```

[docker compose](https://docs.docker.com/compose/install/)
``` shell
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

### Finish
``` Shell
sudo reboot
```


---
---
CLEANUP THIS STUFF
---
---



## AWS

Notes for building a host on [Amazon AWS EC2](https://console.aws.amazon.com/ec2/v2) to run [Docker Machine](https://docs.docker.com/machine/).  It will need to act as an [OpenVPN](https://openvpn.net) client in order connect to the Docker Engines that sit behind NAT.

Steps:
1.  install latest ubuntu LTS free tier server
2.  fetch the inital script to bootstrap
```Shell
wget https://raw.githubusercontent.com/shepner/Docker/master/Manager/github-update.sh
```
3.  Download the OpenVPN client config/keys locally and scp them to the client
```Shell
scp ./vpn-udp-1195-config.zip ubuntu@<host>
```
4.  [test VPN connectivity](https://openvpn.net/index.php/open-source/documentation/howto.html#start)
5.  copy the ssh key and set permissions
```Shell
scp -i .ssh/aws.pem .ssh/dockerengine_rsa ubuntu@<host>:.ssh/
scp -i .ssh/aws.pem .ssh/dockerengine_rsa.pub ubuntu@<host>:.ssh/
ssh -i .ssh/aws.pem ubuntu@<host> chmod 600 .ssh/dockerengine_rsa*
```

---
---
---

3. Install [docker-machine](https://docs.docker.com/machine/install-machine/#installing-machine-directly) and OpenVPN
```Shell
./Docker-DockerMachineHost/setup.sh
```


http://www.getfareye.com/in/blog/establishing-ipsec-tunnel-using-openswan-tool-on-amazon-ec2

https://wiki.ubuntu.com/VPN

---
---
more even older stuff
---
---

# Docker-DockerMachineHost

Notes for building a host on [Amazon AWS EC2](https://console.aws.amazon.com/ec2/v2) to run [Docker Machine](https://docs.docker.com/machine/).  It will need to act as an [OpenVPN](https://openvpn.net) client in order connect to the Docker Engines that sit behind NAT.

Steps:
1.  install latest ubuntu LTS free tier server
2.  clone this repo
``` shell
cd ~
git clone https://github.com/shepner/Docker-Manager.git
git pull
```
+ whatever else to hook it up to the repo
3.  Download the OpenVPN client config/keys locally and scp them to the client
```Shell
scp ./vpn-udp-1195-config.zip ubuntu@<host>
```
4.  [test VPN connectivity](https://openvpn.net/index.php/open-source/documentation/howto.html#start)
5.  copy the ssh key and set permissions
```Shell
scp -i .ssh/aws.pem .ssh/dockerengine_rsa ubuntu@<host>:.ssh/
scp -i .ssh/aws.pem .ssh/dockerengine_rsa.pub ubuntu@<host>:.ssh/
ssh -i .ssh/aws.pem ubuntu@<host> chmod 600 .ssh/dockerengine_rsa*
```



---
---

3. Install [docker-machine](https://docs.docker.com/machine/install-machine/#installing-machine-directly) and OpenVPN
```Shell
./Docker-DockerMachineHost/setup.sh
```


http://www.getfareye.com/in/blog/establishing-ipsec-tunnel-using-openswan-tool-on-amazon-ec2

https://wiki.ubuntu.com/VPN





