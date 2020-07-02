#!/bin/sh
# https://docs.linuxserver.io/images/docker-jackett

#CUID=1003
#CGID=1000
CUID=0
CGID=0
TIMEZONE="America/Chicago"
NAME=jackett
BASEPATH=/mnt/nas/downloads/$NAME

mkdir -p $BASEPATH/config
mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name $NAME \
  --hostname $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --env AUTO_UPDATE=true \
  --publish published=9117,target=9117,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=$BASEPATH/downloads,dst=/downloads \
  linuxserver/jackett
  
