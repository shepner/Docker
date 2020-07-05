#!/bin/sh
# https://docs.linuxserver.io/images/docker-transmission

CUID=1003
CGID=1000
#CUID=0
#CGID=0
TIMEZONE="America/Chicago"
NAME=transmission
BASEPATH=/mnt/nas/docker2/$NAME

mkdir -p $BASEPATH/config
mkdir -p $BASEPATH/watch
mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --publish published=9091,target=9091,protocol=tcp,mode=ingress \
  --publish published=51413,target=51413,protocol=tcp,mode=ingress \
  --publish published=51413,target=51413,protocol=udp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=$BASEPATH/watch,dst=/watch \
  --mount type=bind,src=$BASEPATH/downloads,dst=/downloads \
  linuxserver/transmission
