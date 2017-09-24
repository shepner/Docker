# RancherOS

Instructions for manually installing [RancherOS](rancher.com/rancher-os/) came from [here](https://sdbrett.com/BrettsITBlog/2017/01/rancheros-installing-to-hard-disk/)

Here are the full details for [configuring RancherOS](http://rancher.com/docs/os/configuration/)

make sure that the system will have internet access.  you wont be able to install to disk without it

1.  boot up under VMware in the usual way
2.  run the following command and change the password:  ```sudo passwd rancher```
3.  obtain the ip address of the system:  ```ifconfig eth0```
4.  on your local machine, generate the ssh keypair you intend to use:  ```ssh-keygen -t rsa```
5.  ssh to the system:  ```ssh rancher@<ip address>```
6.  create the config file using the appropriate template (cloud-config-\<hostname\>.yml):  ```vi cloud-config.yml``` Note: dont forget to fill in the blanks!
7.  install RancherOS to disk and reboot:  ```sudo ros install -c cloud-config.yml -d /dev/sda```
8.  the local machine should now be able to ssh using the key

To [enable vmware tools](http://rancher.com/docs/os/system-services/adding-system-services/):
1.  ssh to RancherOS
2.  enable the service:  ```sudo ros service enable open-vm-tools```
3.  start the service:  ```sudo ros service up open-vm-tools```
4.  validate that it is running:  ```sudo ros service list ```

VMware settings
1.  Ubuntu Linux (64-bit)
2.  CPU: 8
3.  Memory:  16GB
4.  Disk:  30GB
5.  Network: 10.1.1.0/24
6.  
