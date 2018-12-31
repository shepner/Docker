#!/bin/sh

# FIX DNS SO IP IS NOT NEEDED
#create the docker engines
docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=dockerengine --generic-ip-address=10.0.0.71 de01a
docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=dockerengine --generic-ip-address=10.0.0.72 de02a
docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=dockerengine --generic-ip-address=10.0.0.73 de03a
docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=dockerengine --generic-ip-address=10.0.0.74 de01b

# show what is available
sudo docker-machine ls

# make this machine a swarm manager
sudo docker swarm init --advertise-addr 10.1.3.18

# to add another manager
#sudo docker swarm join-token manager

# to re-obtain the swarm join token
TOKEN-`sudo docker swarm join-token -q worker`

# add workers
# NOTE:  the `docker swarm init` string is what you will be using but make sure the IP address is one the workers can talk to
docker-machine ssh de01a "docker swarm join --token $TOKEN 10.1.3.18:2377"
docker-machine ssh de02a "docker swarm join --token $TOKEN 10.1.3.18:2377"
docker-machine ssh de03a "docker swarm join --token $TOKEN 10.1.3.18:2377"

#show the cluster
sudo docker node ls

# do this to fix a broken node
NODE=de03a
TOKEN=`sudo docker swarm join-token -q worker`
docker-machine ssh $NODE "docker swarm leave"
docker-machine ssh $NODE "docker swarm join --token $TOKEN 10.1.3.18:2377"


# make sure ~/docker-compose.yml exists

# deploy the cluster
#sudo docker stack deploy -c docker-compose.yml getstartedlab

# delete the cluster
#sudo docker stack rm getstartedlab
