#!/bin/sh
# https://docs.linuxserver.io/images/docker-calibre

# 6080(8080) Calibre desktop gui. ctrl-alt-shift to access the clipboard
# 8080(8081) Calibre webserver gui.

# Dont use the webserver.  Rather, use [cops](https://github.com/shepner/Docker/blob/master/Manager/docker/ebooks/cops.sh) instead

CUID=1003
CGID=1000
TIMEZONE="America/Chicago"
NAME=calibre
BASEPATH=/mnt/nas/docker/$NAME

mkdir -p $BASEPATH/config

sudo docker service create \
  --name $NAME \
  --hostname $NAME \
  --constraint 'node.role != manager' \
  --env PUID=$CUID \
  --env PGID=$CGID \
  --env TZ=$TIMEZONE \
  --publish published=6080,target=8080,protocol=tcp,mode=ingress \
  --mount type=bind,src=$BASEPATH/config,dst=/config \
  --mount type=bind,src=/mnt/nas/media,dst=/media \
  linuxserver/calibre


#  -e GUAC_USER=abc `#optional` \
#  -e GUAC_PASS=900150983cd24fb0d6963f7d28e17f72 `#optional` \
#  -e UMASK_SET=022 `#optional` \
#  -e CLI_ARGS= `#optional` \
#  --publish published=8081,target=8081,protocol=tcp,mode=ingress \


##########################################################
# VNC Console:  6080
# Calibre web interface:  8080

#CONFIG_PATH=/mnt/nas/docker/calibre
#LIBRARY_PATH=/mnt/nas/media/eBooks

#sudo mkdir -p $CONFIG_PATH
#sudo chmod -R 775 $CONFIG_PATH
#sudo chown docker:docker $CONFIG_PATH

#sudo mkdir -P $LIBRARY_PATH
#sudo chmod -R 775 $LIBRARY_PATH
#sudo chown docker:docker $LIBRARY_PATH

#sudo mkdir -P $LIBRARY_PATH-incoming
#sudo chmod -R 777 $LIBRARY_PATH-incoming
#sudo chown docker:docker $LIBRARY_PATH-incoming

#sudo docker service create \
#  --name calibre \
#  --publish published=6080,target=6080,protocol=tcp,mode=ingress \
#  --publish published=8080,target=8080,protocol=tcp,mode=ingress \
#  --mount type=bind,src=$CONFIG_PATH,dst=/config \
#  --mount type=bind,src=$LIBRARY_PATH,dst=/Library \
#  --mount type=bind,src=$LIBRARY_PATH-incoming,dst=/incoming \
#  --replicas=1 \
#  --constraint 'node.role != manager' \
#  shepner/calibre


