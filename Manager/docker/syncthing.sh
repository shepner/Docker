#!/bin/sh
# https://github.com/linuxserver/docker-syncthing

CONFIG_PATH=/mnt/nas/docker/syncthing
DATA_PATH=/mnt/nas/media/syncthing/

sudo docker create \
  --name syncthing \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ="America/Chicago" \
  --publish published=8384,target=8384,protocol=tcp,mode=ingress \
  --publish published=22000,target=22000,protocol=tcp,mode=ingress \
  --publish published=21027,target=21027,protocol=udp,mode=ingress \
  --mount type=bind,src=$CONFIG_PATH/config,dst=/config \
  --mount type=bind,src=$DATA_PATH/data1,dst=/data1 \
  --mount type=bind,src=$DATA_PATH/data2,dst=/data2 \
  --restart unless-stopped \
  linuxserver/syncthing
