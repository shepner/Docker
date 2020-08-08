# Install Notes

## Install server

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

4. [Disable the local dns listener](https://mmoapi.com/post/how-to-disable-dnsmasq-port-53-listening-on-ubuntu-18-04) (might require a reboot)

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

5. Disk monitoring

``` shell
sudo apt install -y smartmontools

systemctl status smartd
```

## User account stuff

### Setup ssh keys

Do this from the local workstation:

``` shell
DHOST=n03
ssh-copy-id -i ~/.ssh/shepner_rsa.pub $DHOST
scp ~/.ssh/shepner_rsa $DHOST:.ssh/shepner_rsa
scp ~/.ssh/shepner_rsa.pub $DHOST:.ssh/shepner_rsa.pub
scp ~/.ssh/config $DHOST:.ssh/config
ssh $DHOST "chmod -R 700 ~/.ssh"
```

### Fix groups

``` shell
sudo groupmod `id -un` -n asyla
```

### Remove what little bits of pesky security we have

``` shell
echo "`id -un` ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
```

### Forward email

``` shell
echo "`id -un`@asyla.org" > ~/.forward
echo "`id -un`@asyla.org" | sudo tee -a /root/.forward
```

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
sudo zfs create data1/vm
```

### Data replication

[Creating and Destroying ZFS Snapshots](https://docs.oracle.com/cd/E19253-01/819-5461/gbcya/index.html)

create an initial set of snapshots to work with

``` shell
sudo zfs snapshot data1/docker@auto-`date +"%Y-%m-%d_%H-%M"`
sudo zfs snapshot data1/vm@auto-`date +"%Y-%m-%d_%H-%M"`
zfs list -t snapshot
#sudo zfs destroy data1/vm@n03_20200808_165344
```

Schedule the creation of snapshots

``` shell
crontab -e
```

Add the following to the end of the file.  Be sure to set the hostname as appropriate:

``` crontab
0 */6 * * * zfs snapshot data1/vm@auto-`date +"%Y-%m-%d_%H-%M"`
0 */6 * * * zfs snapshot data1/docker@auto-`date +"%Y-%m-%d_%H-%M"`
```

([zrep](http://www.bolthole.com/solaris/zrep/) might be another option too)

Enable ssh login for root

``` shell
echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd
```

Do this part on FreeNAS:

1. Storage > Pools > <pool> > Add Dataset
   Create a new dataset named `<hostname>-<poolname>`
   Create another dataset within called `<poolname>` for each
2. System > Generate Keypairs
   Create/generate key for the host
   Add the public key to the new host

``` shell
sudo vi /root/.ssh/authorized_keys
```
    
3. System > SSH Connections
   Add a new connection for the host using the key
   Discover remote host key, then save
4. Tasks > Replication Tasks
   Create a replication job per dataset
   Keep the data for 2 days
   Replicate every */6 hours
   Save then go back in and check "Replicate from scratch if incremental is not possible"

## setup NFS

<not sure is this is really needed or not>

``` shell
sudo apt-get install -y nfs-common

sudo mkdir -p /mnt/nas/data1/docker
echo "nas:/data1/docker /mnt/nas/data1/docker nfs rw 0 0" | sudo tee --append /etc/fstab
sudo mkdir -p /mnt/nas/data2/docker
echo "nas:/data2/docker /mnt/nas/data2/docker nfs rw 0 0" | sudo tee --append /etc/fstab

sudo mkdir -p /mnt/nas/data1/vm
echo "nas:/data1/vm /mnt/nas/data1/vm nfs rw 0 0" | sudo tee --append /etc/fstab
sudo mkdir -p /mnt/nas/data2/vm
echo "nas:/data1/vm /mnt/nas/data2/vm nfs rw 0 0" | sudo tee --append /etc/fstab

sudo mkdir -p /mnt/nas/data1/media
echo "nas:/data1/media /mnt/nas/data1/media nfs rw 0 0" | sudo tee --append /etc/fstab

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


