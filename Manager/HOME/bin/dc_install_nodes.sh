#!/bin/sh
#####################################
# DONT GO BLINDLY RUNNING THIS!
#####################################

nodes[0]="de01a"
nodes[1]="de01b"
nodes[2]="de02a"
nodes[3]="de02b"
nodes[4]="de03a"
nodes[5]="de03b"

#show what is available
docker-machine ls

#setup the ssh keys
for DE in ${nodes[@]} ; do
  ssh-copy-id -i ~/.ssh/dockerengine_rsa dockerengine@$DE
done

#create the docker engines
for DE in ${nodes[@]} ; do
  docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=dockerengine --generic-ip-address=$DE $DE
done

#show what is available
docker-machine ls

