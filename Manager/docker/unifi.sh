#!/bin/sh

# https://hub.docker.com/r/jacobalberty/unifi
# https://github.com/jacobalberty/unifi-docker

BASEDIR=/mnt/nas/docker
PUID=1003
PGUID=1100

mkdir -p $BASEDIR/unifi/data
mkdir -p $BASEDIR/unifi/log

sudo docker service create \
  --name unifi \
  --publish published=8080,target=8080,protocol=tcp,mode=ingress \
  --publish published=8443,target=8443,protocol=tcp,mode=ingress \
  --publish published=3478,target=3478,protocol=udp,mode=ingress \
  --publish published=10001,target=10001,protocol=udp,mode=ingress \
  --env TZ="America/Chicago" \
  --env RUNAS_UID0=false \
  --env UNIFI_UID=$PUID \
  --env UNIFI_GID=$PGUID \
  --mount type=bind,src=$BASEDIR/unifi,dst=/unifi \
  --constraint node.role!=manager \
  --replicas=1 \
  jacobalberty/unifi:stable


