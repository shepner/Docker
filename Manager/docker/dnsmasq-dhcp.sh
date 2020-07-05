#!/bin/sh
# https://github.com/shepner/Docker-DNSmasq

# Combined DNS and DHCP server
# WARNING: This is NOT a Docker Swarm service and runs with privledged rights

NAME=dnsmasq
BASEPATH=/mnt/nas/docker/$NAME

#mkdir -p $BASEPATH/config
#wget -O $BASEPATH/config/dnsmasq_dhcp.conf https://raw.githubusercontent.com/shepner/Docker-DNSmasq/master/dnsmasq.conf
#wget -O $BASEPATH/config/dnsmasq.conf https://raw.githubusercontent.com/shepner/Docker-DNSmasq/master/dnsmasq.conf
#wget -O $BASEPATH/resolv.conf https://raw.githubusercontent.com/shepner/Docker-DNSmasq/master/resolv.conf

sudo docker create \
  --name=$NAME \
  --restart unless-stopped \
  --privileged \
  --env DNSMASQ_CONF=/mnt/config/dnsmasq_combined.conf \
  --mount type=bind,src=/mnt/nas/docker/dnsmasq,dst=/mnt \
  --network host \
  shepner/dnsmasq:latest

sudo docker start dnsmasq
