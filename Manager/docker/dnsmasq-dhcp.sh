#!/bin/sh
# https://github.com/shepner/Docker-DNSmasq

# WARNING: This is NOT a Docker Swarm service and runs with privledged rights


#NAME=DNSmasq-dhcp
#BASEPATH=/mnt/nas/docker/dnsmasq

#mkdir -p $BASEPATH/config
#mkdir -p $BASEPATH/webproc_dhcp

#wget -O $BASEPATH/webproc_dhcp/program.toml https://raw.githubusercontent.com/shepner/Docker-DNSmasq/master/program.toml
#wget -O $BASEPATH/config/dnsmasq_dhcp.conf https://raw.githubusercontent.com/shepner/Docker-DNSmasq/master/dnsmasq.conf
#wget -O $BASEPATH/config/dnsmasq.conf https://raw.githubusercontent.com/shepner/Docker-DNSmasq/master/dnsmasq.conf
#wget -O $BASEPATH/resolv.conf https://raw.githubusercontent.com/shepner/Docker-DNSmasq/master/resolv.conf

sudo docker create \
  --name=DNSmasq-dhcp \
  --restart unless-stopped \
  --privileged \
  --env WEBPROC_CONF=/mnt/webproc_dhcp/program.toml \
  --mount type=bind,src=/mnt/nas/docker/dnsmasq,dst=/mnt \
  --network host \
  shepner/dnsmasq:latest
