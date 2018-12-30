#!/bin/bash
#https://docs.traefik.io/

DE1="de01a"

#set the node we are going to use
docker-machine env $DE1
eval $(docker-machine env $DE1)

cd ~/docker/traefik-test1/traefik
docker-compose up -d

#WARNING: The Docker Engine you're using is running in swarm mode.
#Compose does not use swarm mode to deploy services to multiple nodes in a swarm. All containers will be scheduled on the current node.
#To deploy your application across the swarm, use `docker stack deploy`.

echo "goto http://de01a:8080 and see the dashboard"
read -p "Press [Enter]"

#start 2 target nodes
cd ~/docker/traefik-test1/test
docker-compose up -d --scale whoami=2

#show all the running nodes
docker-compose ps

echo "run 'curl -H Host:whoami.docker.localhost http://de01a' twice and note the change of IP address"
echo "also note the change in the dashboard"
read -p "Press [Enter]"

#add another target
cd ~/docker/traefik-test1/test
docker-compose up -d --scale whoami=3
docker-compose ps

echo "shutting it all down"
read -p "Press [Enter]"

#targets
cd ~/docker/traefik-test1/test
docker-compose down
docker-compose ps

#traefik
cd ~/docker/traefik-test1/traefik
docker-compose down
docker-compose ps


#unselect the active node
eval $(docker-machine env -u)
