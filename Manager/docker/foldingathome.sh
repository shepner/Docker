#!/bin/sh
# https://docs.linuxserver.io/images/docker-foldingathome

UID=1003
GID=1100
TIMEZONE="America/Chicago"
NAME=foldingathome
BASEPATH=/mnt/nas/docker/$NAME

mkdir -p $BASEPATH/config

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$UID \
  --env PGID=$GID \
  --env TZ=$TIMEZONE \
  --publish published=7396,target=7396,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  linuxserver/foldingathome
