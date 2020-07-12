#!/bin/sh
# https://docs.linuxserver.io/images/docker-organizr
# https://organizr.app/

#broken initial page so not using


CUID=1003
CGID=1000
TIMEZONE="America/Chicago"
NAME=organizr
BASEPATH=/mnt/nas/docker/$NAME

mkdir -p $BASEPATH/config

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --publish published=9983,target=80,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  linuxserver/organizr
