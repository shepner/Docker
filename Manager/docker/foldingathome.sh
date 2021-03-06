#!/bin/sh
# https://docs.linuxserver.io/images/docker-foldingathome

CUID=1003
CGID=1000
TIMEZONE="America/Chicago"
NAME=foldingathome
BASEPATH=/mnt/nas/docker/$NAME

mkdir -p $BASEPATH/config

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --publish published=7396,target=7396,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  linuxserver/foldingathome
