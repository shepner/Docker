#!/bin/sh

# https://www.linuxserver.io/our-images
# https://hub.docker.com/r/linuxserver/sonarr

UID=1003
GID=1100
TIMEZONE="America/Chicago"
NAME=sonarr
BASEPATH=/mnt/nas/downloads/$NAME

mkdir -p $BASEPATH/config
mkdir -p $BASEPATH/tv
mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$UID \
  --env PGID=$GID \
  --env TZ=$TIMEZONE \
  --publish published=8989,target=8989,protocol=tcp,mode=ingress \
  --mount type=bind,src=/etc/localtime,dst=/etc/localtime,readonly=1 \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=$BASEPATH/tv,dst=/tv \
  --mount type=bind,src=$BASEPATH/downloads,dst=/downloads \
  linuxserver/sonarr


