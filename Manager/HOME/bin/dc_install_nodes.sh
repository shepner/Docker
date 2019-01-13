#!/bin/sh
#####################################
# DONT GO BLINDLY RUNNING THIS!
#####################################

nodes[0]="de01"
nodes[1]="de02"
nodes[2]="de03"
nodes[3]="de04"
nodes[4]="de05"
nodes[5]="de06"

# show what is available
docker-machine ls

# setup the ssh keys
for DE in ${nodes[@]} ; do
  ssh-copy-id -i ~/.ssh/docker_rsa docker@$DE
done

# create the docker engines
for DE in ${nodes[@]} ; do
  #docker-machine stop $DE
  #docker-machine rm $DE
  docker-machine create --driver generic --generic-ssh-key ~/.ssh/docker_rsa --generic-ssh-user=docker --generic-ip-address=$DE $DE
done

# show what is available
docker-machine ls

