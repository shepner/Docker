# Install Notes

1. have a physical server suitable to run [Docker](https://www.docker.com/) containers, VMs (via [KVM](https://www.linux-kvm.org/)), while using ZFS

    * ZFS data pool should be 4TB mirrored and is dedicated to docker/VMs
    * separate boot/swap drive(s)

2. Download/install [Ubuntu Server 20.04.01 LTS](https://ubuntu.com/download/server/thank-you?version=20.04.1&architecture=amd64)
3. Configuration steps:

## Patch the system

``` shell
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade && sudo apt -y autoremove
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






