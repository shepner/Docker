#!/bin/sh

# FIX DNS FIRST OR USE IP ADDRESSES INSTEAD!

# UPDATE THIS SECTION!  NOT USING RANGER
#create the docker engines
#docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=rancher --generic-ip-address=de01a de01a
#docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=rancher --generic-ip-address=de01b de02a
#docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=rancher --generic-ip-address=de01b de03a

# show what is available
sudo docker-machine ls

# make this machine a swarm manager
sudo docker swarm init

# to add another manager
#sudo docker swarm join-token manager

# to re-obtain the swarm join token
#sudo docker swarm join-token worker

# add workers
# NOTE:  the `docker swarm init` string is what you will be using but make sure the IP address is one the workers can talk to
docker-machine ssh de01a "docker swarm join --token SWMTKN-1-4[...]1h83 10.1.3.18:2377"
docker-machine ssh de02a "docker swarm join --token SWMTKN-1-4[...]1h83 10.1.3.18:2377"
docker-machine ssh de03a "docker swarm join --token SWMTKN-1-4[...]1h83 10.1.3.18:2377"

# do this to fix a broken node
#docker-machine ssh de03a "docker swarm leave"
#docker-machine ssh de03a "docker swarm join --token SWMTKN-1-4[...]1h83 10.1.3.18:2377"


#show the cluster
sudo docker node ls

# make sure ~/docker-compose.yml exists

# deploy the cluster
#sudo docker stack deploy -c docker-compose.yml getstartedlab

# delete the cluster
#sudo docker stack rm getstartedlab
