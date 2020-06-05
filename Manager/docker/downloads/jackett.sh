#!/bin/sh
# https://docs.linuxserver.io/images/docker-jackett

UID=1003
GID=1000
TIMEZONE="America/Chicago"
NAME=jackett
BASEPATH=/mnt/nas/downloads/$NAME

mkdir -p $BASEPATH/config
mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$UID \
  --env PGID=$GID \
  --env TZ=$TIMEZONE \
  --env AUTO_UPDATE=true \
  --publish published=9117,target=9117,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=$BASEPATH/downloads,dst=/downloads \
  linuxserver/jackett
  
