#!/bin/sh
# https://docs.linuxserver.io/images/docker-heimdall
# https://heimdall.site/

CUID=1003
CGID=1000
TIMEZONE="America/Chicago"
NAME=heimdall
BASEPATH=/mnt/nas/docker/$NAME

mkdir -p $BASEPATH/config

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --publish published=9080,target=80,protocol=tcp,mode=ingress \
  --publish published=9443,target=443,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  linuxserver/heimdall
