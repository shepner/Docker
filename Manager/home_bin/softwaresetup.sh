#!/bin/sh

#Run this file to install the software needed to get this working

##################################################
#make future updates easier
#usage:  install_update_script master.zip
install_update_script() {
  unzip -jo $1 Docker-master/Manager/update_from_github.sh -d ~
  chmod 700 ~/update_from_github.sh
}

##################################################
#Mosh
#https://mosh.org
install_mosh() {
  echo "Open 60000-61000 UDP inbound for mosh to work"
  sudo apt install mosh
}

##################################################
#DNSexit
configure_dnsexit() {
  chmod 750 /home/ubuntu/Docker-DockerMachineHost/dnsexit.sh

  if [ ! -f /home/ubuntu/.dnsexit ] ; then
    cp /home/ubuntu/Docker-DockerMachineHost/.dnsexit /home/ubuntu/.dnsexit
    echo "Be sure to edit /home/ubuntu/.dnsexit"
  fi
  chmod 600 /home/ubuntu/.dnsexit

  if [ `grep -c dnsexit /etc/crontab` -eq 0 ] ; then
    echo '*/2 * * * * ubuntu /home/ubuntu/Docker-DockerMachineHost/dnsexit.sh' | sudo tee -a /etc/crontab
  fi
}

##################################################
#unzip
install_unzip () {
  sudo apt install unzip
}

##################################################
#OpenVPN
install_openvpn () {
  sudo apt-get install network-manager-openvpn
  
  sudo ln -s /home/ubuntu/Docker-DockerMachineHost/client.conf /etc/openvpn/client.conf
  
  install_unzip
  
  cd
  unzip vpn-udp-1195-vpn.asyla.org-config.zip
  sudo cp /home/ubuntu/vpn-udp-1195-vpn.asyla.org/* /etc/openvpn/
  sudo ln -a /etc/openvpn/vpn-udp-1195-vpn.asyla.org.ovpn /etc/openvpn/vpn-udp-1195-vpn.asyla.org.conf
  
  echo 'AUTOSTART="all"' | sudo tee -a /etc/default/openvpn
}

##################################################
#Docker CE
#https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
install_docker_engine () {
  #Update the apt package inde
  sudo apt-get update
  
  #Install packages to allow apt to use a repository over HTTPS
  sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
    
  #Add Docker’s official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  
  #Use the following command to set up the stable repository
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    
  #Update the apt package index
  sudo apt-get update
  
  #Install the latest version of Docker CE
  sudo apt-get install docker-ce
  
  #Configure Docker to start on boot
  sudo systemctl enable docker
}

##################################################
#Docker Machine
install_docker_machine () {
  VERSION="v0.12.2"
  curl -L https://github.com/docker/machine/releases/download/$VERSION/docker-machine-`uname -s`-`uname -m` > /tmp/docker-machine
  chmod +x /tmp/docker-machine
  sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
}

##################################################
#Docker Compose
#make sure this is still the current version
#https://github.com/docker/compose/releases
install_docker_compose () {
  VERSION="1.15.0"
  curl -L https://github.com/docker/compose/releases/download/$VERSION/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
  chmod +x /tmp/docker-compose
  sudo cp /tmp/docker-compose /usr/local/bin/docker-compose
}

##################################################
#Docker Compose
configure_docker_swarm () {
  cp /home/ubuntu/Docker-DockerMachineHost/docker-compose.yml /home/ubuntu/
}
