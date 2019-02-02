#!/bin/sh

CONFIG_PATH=/mnt/nas/docker/calibre
LIBRARY_PATH=/mnt/nas/media/eBooks2

sudo mkdir -p $CONFIG_PATH
sudo chown docker:docker $CONFIG_PATH

sudo docker service create \
  --name Calibre \
  --publish published=6080,target=6080,protocol=tcp,mode=ingress \
  --mount type=bind,src=$CONFIG_PATH,dst=/config \
  --mount type=bind,src=$LIBRARY_PATH,dst=/Library \
  --replicas=1 \
  --constraint 'node.role != manager' \
  shepner/calibre



