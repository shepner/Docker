#!/bin/sh
######################################
# DONT JUST RUN THIS!
######################################

DE1="de01a" # de01a
DE2="de02a" # de02a
DE3="de03a" # de03a

#make sure we have nodes in the swarm
sudo docker node ls

#set the first machine as active
#https://docs.docker.com/machine/reference/env/
docker-machine env $DE1
eval $(docker-machine env $DE1)

#make sure it is now the active node
docker-mahine active

#run a test on the active node
#NOTE that this didnt need sudo.  This is because it went through 
# docker-machine and not the local instance
docker run hello-world

#verify it actually ran there
docker-machine ssh $DE1 "docker container ls -a"

#now remove the active node (revert back to the local machine)
#and show that it did not run there
eval $(docker-machine env -u)
sudo docker container ls -a

#####################################################
#https://docs.docker.com/engine/swarm/services/

#Create a service
#docker service create nginx
docker service create --name my_web nginx

#now give it a port
docker service update --publish-add 80 my_web

#remove the service
docker service remove my_web

