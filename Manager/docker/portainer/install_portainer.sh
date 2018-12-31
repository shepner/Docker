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
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  --mount type=bind,src=/var/lib/docker/volumes,dst=/var/lib/docker/volumes \
  portainer/agent

# Portainer Server as a Docker Swarm service
# NOTE:  There needs to be a way to sync the data directories across all nodes

# setup the data dir
sudo mkdir -p /mnt/nas/docker/portainer

# deploy the service
# https://docs.docker.com/engine/reference/commandline/service_create/
sudo docker service create \
    --name portainer \
    --network portainer_agent_network \
    --publish 9000:9000 \
    --replicas=1 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=/mnt/nas/docker/portainer,dst=/data \
    portainer/portainer -H "tcp://tasks.portainer_agent:9001" --tlsskipverify

# now goto "http://<node IP address>:9000" and login

# if you need to bounce the service
#sudo docker service scale portainer=0
#sudo docker service scale portainer=1

