# RancherOS

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
    - ```wget https://raw.githubusercontent.com/shepner/Docker/master/Engine/RancherOS/cloud-config.yml```
3.  edit the file:  ```vi cloud-config.yml```
4.  install RancherOS to disk and reboot:
    - ```sudo ros install -c cloud-config.yml -d /dev/sda```

## manager specific

### install ssh keys:

```
scp .ssh/rancher_rsa manager:.ssh/id_rsa
scp .ssh/rancher_rsa.pub manager:.ssh/id_rsa.pub
```

### setup kubernetes cluster

Only run this on one of the 3 managers:

```
mkdir -P ~/.kube/config
wget -P ~/.kube/config https://raw.githubusercontent.com/shepner/Docker/master/Engine/RancherOS/cluster.yml
rke up --config ~/.kube/config/cluster.yml
```
