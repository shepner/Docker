#!/bin/sh
# https://docs.linuxserver.io/images/docker-sonarr

CUID=1003
CGID=1000
#CUID=0
#CGID=0
TIMEZONE="America/Chicago"
NAME=sonarr
BASEPATH=/mnt/nas/docker1/$NAME

mkdir -p $BASEPATH/config
#mkdir -p $BASEPATH/tv
#mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --publish published=8989,target=8989,protocol=tcp,mode=ingress \
  --mount type=bind,src=/etc/localtime,dst=/etc/localtime,readonly=1 \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=/mnt/nas/media/Videos,dst=/tv \
  --mount type=bind,src=/mnt/nas/docker1/transmission/downloads/complete,dst=/downloads \
  linuxserver/sonarr
