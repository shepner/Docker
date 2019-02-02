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

TIMEZONE="America/Chicago"
BASEPATH=/mnt/nas/media

mkdir -p $BASEPATH/eBooks2

sudo docker service create \
  --name Calibre \
  --publish published=6080,target=6080,protocol=tcp,mode=ingress \
  --replicas=1 \
  --constraint 'node.role != manager' \
  shepner/calibre

--mount type=bind,src=$BASEPATH/eBooks2,dst=/Library \


