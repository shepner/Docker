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

###################################################################################################
# Portainer
# https://www.portainer.io


# Install Portainer Agent to the swarm as a global service in the cluster
# https://portainer.readthedocs.io/en/stable/agent.html

# setup the agent network
sudo docker network create --driver overlay --attachable portainer_agent_network

# create the agent service
sudo docker service create \
  --name portainer_agent \
  --network portainer_agent_network \
  -e AGENT_CLUSTER_ADDR=tasks.portainer_agent \
  --mode global \
  --constraint 'node.platform.os == linux' \
  --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
  --mount type=bind,src=//var/lib/docker/volumes,dst=/var/lib/docker/volumes \
  portainer/agent


# Install Portainer Server
# https://portainer.readthedocs.io/en/stable/deployment.html
# Deploy Portainer Server on a standalone LINUX Docker host/single node swarm cluster
#sudo docker volume create portainer_data
#sudo docker run -d -p 9000:9000 \
#  --name portainer \
#  --restart always \
#  -v /var/run/docker.sock:/var/run/docker.sock \
#  -v /home/ubuntu/portainer:/data portainer/portainer

# Portainer Server as a Docker Swarm service
# There needs to be a way to sync the data directories across all nodes

#setup the data dir
#sudo mkdir -p /docker/portainer
#docker-machine ssh de01a "sudo mkdir -p /docker/portainer"
#docker-machine ssh de02a "sudo mkdir -p /docker/portainer"
#docker-machine ssh de03a "sudo mkdir -p /docker/portainer"

#deploy the service
sudo docker service create \
    --name portainer \
    --network portainer_agent_network \
    --publish 9000:9000 \
    --replicas=1 \
    --constraint 'node.role == manager' \
    portainer/portainer -H "tcp://tasks.portainer_agent:9001" --tlsskipverify
#  --mount type=bind,src=/docker/portainer,dst=/data \

#now goto "http://<node IP address>:9000" and login


