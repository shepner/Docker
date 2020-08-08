# Install Notes

## Initial install

1. have a physical server suitable to run [Docker](https://www.docker.com/) containers, VMs (via [KVM](https://www.linux-kvm.org/)), while using ZFS

    * ZFS data pool should be 4TB mirrored and is dedicated to docker/VMs
    * separate boot/swap drive(s)

2. Download/install [Ubuntu Server 20.04.01 LTS](https://ubuntu.com/download/server/thank-you?version=20.04.1&architecture=amd64)

3. Patch the system

``` shell
cat > ~/update.sh << EOF
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade && sudo apt -y autoremove
EOF
chmod 754 ~/update.sh
~/update.sh
```

4. Fix groups

``` shell
sudo groupmod `id -un` -n asyla
```

5. Remove what little bits of pesky security we have

``` shell
echo "`id -un` ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
```

6. [Disable the local dns listener](https://mmoapi.com/post/how-to-disable-dnsmasq-port-53-listening-on-ubuntu-18-04) (might require a reboot)

``` shell
#sudo netstat -tulnp | grep 53
echo 'DNSStubListener=no' | sudo tee --append /etc/systemd/resolved.conf
sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved.service
#sudo netstat -tulnp | grep 53

sudo rm /etc/resolv.conf
sudo sh -c 'cat > /etc/resolv.conf << EOF
search asyla.org
nameserver 10.0.0.71
nameserver 208.67.222.222
nameserver 208.67.220.220
EOF'
```

7. Disk monitoring

``` shell
sudo apt install -y smartmontools

systemctl status smartd
```

8. Forward email

``` shell
echo "`id -un`@asyla.org" > ~/.forward
echo "`id -un`@asyla.org" | sudo tee -a /root/.forward
```




?. setup ssh keys

``` shell
nodes[0]="n01"
nodes[1]="n02"
nodes[2]="n03"
for DHOST in ${nodes[@]} ; do
  ssh-copy-id -i ~/.ssh/<key> docker@$DHOST
  ssh docker@$DHOST "mkdir -p .ssh"
  scp ~/.ssh/docker_rsa docker@$DHOST:.ssh/docker_rsa
  scp ~/.ssh/docker_rsa.pub docker@$DHOST:.ssh/docker_rsa.pub
  ssh docker@$DHOST "chmod -R 700 ~/.ssh"
done
```

   This might also be a good point to update `~/.ssh/config` so specifying the user ID and identity file is not needed

## [OpenZFS](https://openzfs.github.io/openzfs-docs/Getting%20Started/Ubuntu/index.html#installation)

Install utilities:

``` shell
sudo apt update
sudo apt -y install zfsutils-linux
```

Show what disks are on the system:

``` shell
sudo lsblk
```

Create a ZFS mirror using the 2 spare drives:

``` shell
sudo zpool create data1 mirror /dev/sdb /dev/sdc
```

Create the datasets

``` shell
sudo zfs create data1/docker
sudo zfs create data1/kvm
```

## setup NFS
``` shell
sudo apt-get install -y nfs-common

sudo mkdir -p /mnt/nas/data1/docker
echo "nas:/data1/docker /mnt/nas/data1/docker nfs rw 0 0" | sudo tee --append /etc/fstab
sudo mkdir -p /mnt/nas/data2/docker
echo "nas:/data2/docker /mnt/nas/data2/docker nfs rw 0 0" | sudo tee --append /etc/fstab

sudo mkdir -p /mnt/nas/data1/kvm
echo "nas:/data1/kvm /mnt/nas/data1/kvm nfs rw 0 0" | sudo tee --append /etc/fstab
sudo mkdir -p /mnt/nas/data2/kvm
echo "nas:/data1/kvm /mnt/nas/data2/kvm nfs rw 0 0" | sudo tee --append /etc/fstab

sudo mount -a
```

## [KVM](https://help.ubuntu.com/community/KVM/Installation)

Install Necessary Packages

``` shell
sudo apt-get -y install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
```

This requires a GUI:

``` shell
sudo apt-get install virt-manager
```

Add Users to Groups:

``` shell
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm
```

Be sure to logout/login again


Verify Installation:

``` shell
virsh list --all
```

Instructions for what to do with this: https://help.ubuntu.com/community/KVM


## [Docker](https://www.docker.com/)

[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/):

``` shell
# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Use the following command to set up the stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# INSTALL DOCKER ENGINE
# Update the apt package index, and install the latest version of Docker Engine and containerd, or go to the next step to install a specific version:
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```

Install [Docker Compose](https://docs.docker.com/compose/install/)
``` shell
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```


