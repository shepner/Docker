#!/bin/sh
# https://hub.docker.com/r/cpoppema/docker-flexget

UID=1003
GID=1100
TIMEZONE="America/Chicago"
BASEPATH=/mnt/nas/docker/flexget
PASSWD=

mkdir -p $BASEPATH/config
mkdir -p $BASEPATH/downloads

docker create \
    --name=flexget \
    -e PUID=$UID \
    -e PGID=$GID \
    -e TZ=$TIMEZONE \
    -e WEB_PASSWD=$PASSWD \
    -e TORRENT_PLUGIN=transmission \
    -e FLEXGET_LOG_LEVEL=debug \
    -p 5050:5050 \
    -v $BASEPATH/config:/config \
    -v $BASEPATH/downloads:/downloads \
    cpoppema/docker-flexget
    
    
