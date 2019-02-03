#!/bin/sh
# VNC Console:  6080
# Calibre web interface:  8080

CONFIG_PATH=/mnt/nas/docker/calibre
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


