#!/bin/sh
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

