#!/bin/sh

# https://www.linuxserver.io/our-images
# https://hub.docker.com/r/linuxserver/transmission

UID=1003
GID=1100
TIMEZONE="America/Chicago"
BASEPATH=/mnt/nas/docker/transmission

mkdir -p $BASEPATH/config
mkdir -p $BASEPATH/watch
mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name transmission \
  --env PUID=$UID \
  --env PGID=$GID \
  --env TZ=$TIMEZONE \
  --publish published=9091,target=9091,protocol=tcp,mode=ingress \
  --publish published=51413,target=51413,protocol=tcp,mode=ingress \
  --publish published=51413,target=51413,protocol=udp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=$BASEPATH/watch,dst=/watch \
  --mount type=bind,src=$BASEPATH/downloads,dst=/downloads \
  linuxserver/transmission
