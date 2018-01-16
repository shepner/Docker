# Docker-DockerMachineHost

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

3. Install [docker-machine](https://docs.docker.com/machine/install-machine/#installing-machine-directly) and OpenVPN
```Shell
./Docker-DockerMachineHost/setup.sh
```


http://www.getfareye.com/in/blog/establishing-ipsec-tunnel-using-openswan-tool-on-amazon-ec2

https://wiki.ubuntu.com/VPN


