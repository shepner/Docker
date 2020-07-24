
* name: a01
* Compatability: 6.7
* OS Family: Linux
* OS Version: Other 4.x or later Linux (64-bit)

---

* CPU: 8
* Memory: 64GB
* Disk1: 256GB

---

* Boot Options > Firmware: BIOS


login: root

``` shell
setup-alpine
```

* keyboard: us
* keyboard varient: us
* hostname a01
* interface: eth0
* IP address: 10.0.0.81
* netmask: 255.255.255.0
* gateway: 10.0.0.1
* domain: asyla.org
* nameservers: 10.0.0.71 10.0.0.74
* timezone: CST6CDT
* ntp client: chrony (default)
* mirror to use: f
* ssh server: openssh (default)
* disk to use: sda
* how to use: sys

``` shell
reboot
```

Create the docker account:

``` shell
addgroup -g 1000 asyla
adduser -s /bin/bash -G asyla -u 1003 docker
```




[Install Alpine on VMWare](https://wiki.alpinelinux.org/wiki/Install_Alpine_on_VMWare):

``` shell
apk add --update open-vm-tools
/etc/init.d/open-vm-tools start
rc-update add open-vm-tools
```



