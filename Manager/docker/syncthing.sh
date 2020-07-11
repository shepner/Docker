#!/bin/sh
# https://docs.linuxserver.io/images/docker-syncthing

NAME=syncthing
CUID=1003
CGID=1000
TIMEZONE="America/Chicago"
BASEPATH=/mnt/nas/docker1/syncthing

sudo mkdir -p $BASEPATH/config
sudo mkdir -p $BASEPATH/data1
sudo mkdir -p $BASEPATH/data2

sudo docker service create \
  --name $NAME \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --constraint 'node.role != manager' \
  --publish published=8384,target=8384,protocol=tcp,mode=ingress \
  --publish published=22000,target=22000,protocol=tcp,mode=ingress \
  --publish published=21027,target=21027,protocol=udp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=$BASEPATH/data1,dst=/data1 \
  --mount type=bind,src=$BASEPATH/data2,dst=/data2 \
  linuxserver/syncthing
