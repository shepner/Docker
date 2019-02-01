#!/bin/sh
# aptalca/docker-rdp-calibre
# https://hub.docker.com/r/aptalca/docker-rdp-calibre
#docker run \
#  -d \
#  --name="RDP-Calibre" \
#  -e EDGE="0" \
#  -e WIDTH="1280" \
#  -e HEIGHT="720" \
#  -v /path/to/config:/config:rw \
#  -e TZ=America/New_York \
#  -p XXXX:8080 \
#  -p YYYY:8081 \
#  aptalca/docker-rdp-calibre

BASEPATH=/mnt/nas/media
TIMEZONE="America/Chicago"

mkdir -p $BASEPATH/eBooks2

sudo docker service create \
  --name Calibre \
  --env EDGE="0" \
  --env WIDTH="1280" \
  --env HEIGHT="720" \
  --env TZ=$TIMEZONE \
  --publish published=8080,target=8080,protocol=tcp,mode=ingress \
  --publish published=8081,target=8081,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/eBooks2,dst=/config \
  --replicas=1 \
  --constraint 'node.role != manager' \
  aptalca/docker-rdp-calibre


