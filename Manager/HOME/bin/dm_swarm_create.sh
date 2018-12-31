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

MANAGERIP="10.1.3.18"

#show what is available
docker-machine ls

#make this machine a swarm manager
sudo docker swarm init --advertise-addr $MANAGERIP

# to add another manager
# https://docs.docker.com/engine/swarm/admin_guide/#add-manager-nodes-for-fault-tolerance
# https://docs.docker.com/engine/swarm/swarm_manager_locking/
#sudo docker swarm join-token manager

# fetch the swarm worker token
TOKEN=`sudo docker swarm join-token -q worker`

for DE in ${nodes[@]} ; do
  # add workers
  docker-machine ssh de01a "docker swarm join --token $TOKEN $MANAGERIP:2377"done
done

#show the cluster
sudo docker node ls

########

# do this to fix a broken node
#NODE=de03a
#TOKEN=`sudo docker swarm join-token -q worker`
#docker-machine ssh $NODE "docker swarm leave"
#docker-machine ssh $NODE "docker swarm join --token $TOKEN 10.1.3.18:2377"


