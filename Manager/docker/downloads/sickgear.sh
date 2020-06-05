#!/bin/sh
# https://docs.linuxserver.io/images/docker-sickgear

NAME=sickgear
UID=1003
GID=1100
TIMEZONE="America/Chicago"
BASEPATH=/mnt/nas/downloads/$NAME

mkdir -p $BASEPATH/config
mkdir -p $BASEPATH/tv
#mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name=$NAME \
  --constraint 'node.role != manager' \
  --env PUID=$UID \
  --env PGID=$GID \
  --env TZ=$TIMEZONE \
  --publish published=8089,target=8081,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=$BASEPATH/tv,dst=/tv \
  --mount type=bind,src=/mnt/nas/downloads/transmission/downloads,dst=/downloads \
  linuxserver/sickgear
