#!/bin/sh
# https://docs.linuxserver.io/images/docker-booksonic

# having trouble indexing the audio books


UID=1003
GID=1000
TIMEZONE="America/Chicago"
NAME=booksonic
BASEPATH=/mnt/nas/docker/$NAME

mkdir -p $BASEPATH/config
#mkdir -p $BASEPATH/tv
#mkdir -p $BASEPATH/downloads

sudo docker service create \
  --name $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$UID \
  --env PGID=$GID \
  --env TZ=$TIMEZONE \
  --publish published=4040,target=4040,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=/mnt/nas/media/Audio\ Books,dst=/audiobooks \
  linuxserver/booksonic
  

#  -e CONTEXT_PATH=url-base \
#  -v </path/to/podcasts>:/podcasts \
#  -v </path/to/othermedia>:/othermedia \
  
