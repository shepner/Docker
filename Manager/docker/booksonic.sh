#!/bin/sh
# https://docs.linuxserver.io/images/docker-booksonic

CUID=1003
CGID=1000
TIMEZONE="America/Chicago"
NAME=booksonic
BASEPATH=/mnt/nas/docker/$NAME

mkdir -p $BASEPATH/config
#mkdir -p $BASEPATH/tv
#mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --publish published=4040,target=4040,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=/mnt/nas/media/Audiobook,dst=/audiobooks \
  linuxserver/booksonic
  

#  -e CONTEXT_PATH=url-base \
#  -v </path/to/podcasts>:/podcasts \
#  -v </path/to/othermedia>:/othermedia \
  
