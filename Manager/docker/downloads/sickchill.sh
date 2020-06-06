#!/bin/sh
# https://docs.linuxserver.io/images/docker-sickchill

UID=1003
GID=1000
TIMEZONE="America/Chicago"
NAME=sickchill
BASEPATH=/mnt/nas/downloads/$NAME

mkdir -p $BASEPATH/config
#mkdir -p $BASEPATH/tv
#mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$UID \
  --env PGID=$GID \
  --env TZ=$TIMEZONE \
  --publish published=8181,target=8081,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=/mnt/nas/media/Videos,dst=/tv \
  --mount type=bind,src=/mnt/nas/downloads/transmission/downloads/complete,dst=/downloads \
  linuxserver/sickchill
