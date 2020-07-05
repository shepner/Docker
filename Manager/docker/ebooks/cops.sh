#!/bin/sh
# https://docs.linuxserver.io/images/docker-cops
# http://blog.slucas.fr/en/oss/calibre-opds-php-server

NAME=cops
CUID=1003
CGID=1000
TIMEZONE="America/Chicago"
BASEPATH=/mnt/nas/docker/$NAME

mkdir -p $BASEPATH/config
#mkdir -p $BASEPATH/books

sudo docker service create \
  --name=$NAME \
  --constraint 'node.role != manager' \
  --env PUID=$UID \
  --env PGID=$GID \
  --env TZ=$TIMEZONE \
  --publish published=8000,target=80,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=/mnt/nas/media/eBooks,dst=/books \
  linuxserver/cops
