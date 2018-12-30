#!/bin/sh

########################################
#examples

#https://docs.docker.com/engine/admin/volumes/volumes/#start-a-container-with-a-volume
docker run -d \
  -it \
  --name devtest \
  --mount source=myvol2,target=/app \
  nginx:latest
docker inspect devtest
docker container stop devtest
docker container rm devtest
docker volume rm myvol2

#https://docs.docker.com/engine/admin/volumes/volumes/#use-a-volume-driver
docker plugin install --grant-all-permissions vieux/sshfs
docker volume create --driver vieux/sshfs \
  -o sshcmd=test@node2:/home/test \
  -o password=testpassword \
  sshvolume
docker run -d \
  --it \
  --name sshfs-container \
  --volume-driver vieux/sshfs \
  --mount src=sshvolume,target=/app,volume-opt=sshcmd=test@node2:/home/test,volume-opt=password=testpassword \
  nginx:latest

