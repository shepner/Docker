#!/bin/sh
# https://github.com/linuxserver/docker-syncthing

CONFIG_PATH=/mnt/nas/docker/syncthing
DATA_PATH=/mnt/nas/media/syncthing

docker create \
  --name=syncthing \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ="America/Chicago" \
  -e UMASK_SET=<022> \
  --publish published=8384,target=8384,protocol=tcp,mode=ingress \
  --publish published=22000,target=22000,protocol=tcp,mode=ingress \
  --publish published=21027,target=21027,protocol=udp,mode=ingress \
  --mount type=bind,src=$CONFIG_PATH,dst=/config \
  --mount type=bind,src=$DATA_PATH,dst=/syncthing \
  --restart unless-stopped \
  linuxserver/syncthing

##########
# VNC Console:  6080
# Calibre web interface:  8080

CONFIG_PATH=/mnt/nas/docker/syncthing
LIBRARY_PATH=/mnt/nas/media/eBooks

sudo mkdir -p $CONFIG_PATH
sudo chmod -R 775 $CONFIG_PATH
sudo chown docker:docker $CONFIG_PATH

#sudo mkdir -P $LIBRARY_PATH
#sudo chmod -R 775 $LIBRARY_PATH
#sudo chown docker:docker $LIBRARY_PATH

sudo mkdir -P $LIBRARY_PATH-incoming
sudo chmod -R 777 $LIBRARY_PATH-incoming
sudo chown docker:docker $LIBRARY_PATH-incoming

sudo docker service create \
  --name Calibre \
  --publish published=6080,target=6080,protocol=tcp,mode=ingress \
  --publish published=8080,target=8080,protocol=tcp,mode=ingress \
  --mount type=bind,src=$CONFIG_PATH,dst=/config \
  --mount type=bind,src=$LIBRARY_PATH,dst=/Library \
  --mount type=bind,src=$LIBRARY_PATH-incoming,dst=/incoming \
  --replicas=1 \
  --constraint 'node.role != manager' \
  shepner/calibre

