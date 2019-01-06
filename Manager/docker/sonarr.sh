#!/bin/sh

# https://www.linuxserver.io/our-images
# https://hub.docker.com/r/linuxserver/sonarr

UID=1003
GID=1100
TIMEZONE="America/Chicago"

sudo docker service create \
  --name sonarr \
  --publish published=8989,target=8989,protocol=tcp,mode=ingress \
  --env PUID=<UID> \
  --env PGID=<GID> \
  --env TZ=$TIMEZONE \ 
  --mount type=bind,src=/etc/localtime,dst=/etc/localtime,readonly=1 \
  --mount type=bind,src=,dst=/config \
  --mount type=bind,src=,dst=/tv \
  --mount type=bind,src=,dst=/downloads \
  linuxserver/sonarr


