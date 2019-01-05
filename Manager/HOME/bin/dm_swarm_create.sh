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

#show what is available
docker-machine ls

####################################
# RUN THESE COMMANDS ON EACH MANAGER
####################################
# https://docs.docker.com/engine/swarm/admin_guide/
# https://docs.docker.com/engine/swarm/swarm_manager_locking/

# dm01
MANAGERIP=10.1.3.18
#sudo docker swarm init --advertise-addr $MANAGERIP
#docker node update --availability drain dm01

# add the other managers
#TOKEN=`sudo docker swarm join-token -q manager`

# dm02
#ssh -i ~/.ssh/docker_rsa dm02 "sudo docker swarm join --token $TOKEN $MANAGERIP:2377"
#docker node update --availability drain dm02

# dm03
#ssh -i ~/.ssh/docker_rsa dm03 "sudo docker swarm join --token $TOKEN $MANAGERIP:2377"
#docker node update --availability drain dm03

####################################

# fetch the swarm worker token
TOKEN=`sudo docker swarm join-token -q worker`

# add workers
for DE in ${nodes[@]} ; do
  docker-machine ssh $DE "docker swarm join --token $TOKEN $MANAGERIP:2377"
done

#show the swarm nodes
sudo docker node ls

########
exit  # dont run anything after this point

# do this to fix a broken node
TOKEN=`sudo docker swarm join-token -q worker`
for DE in ${nodes[@]} ; do
  docker-machine ssh $DE "docker swarm leave"
  docker-machine ssh $DE "docker swarm join --token $TOKEN $MANAGERIP:2377"
done

