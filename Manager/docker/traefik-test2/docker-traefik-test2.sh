#!/bin/bash
#https://docs.traefik.io/

DE1="de01a"

#set the node we are going to use
docker-machine env $DE1
eval $(docker-machine env $DE1)

################################################################################

echo "show all the running nodes"
docker-compose ps

################################################################################
echo "start traefik"
cd ~/docker/traefik-test2/traefik

echo "create a new network called web on the target node"
docker network create web

echo "make the empty acme.json file and copy the traefik.toml file to where the containers can find them you will want to adjust the below path to something appropriate"

docker-machine ssh $DE1 "mkdir -p /mnt/nas/docker/traefik-test2/traefik/"
docker-machine ssh $DE1 "touch /mnt/nas/docker/traefik-test2/traefik/acme.json && chmod 600 /mnt/nas/docker/traefik-test2/traefik/acme.json"
docker-machine scp traefik.toml $DE1:/mnt/nas/docker/traefik-test2/traefik/

echo "launch traefik"
docker-compose up -d

echo "goto https://$DE1"

################################################################################
echo "start test services"
read -p "Press [Enter]"

cd ~/docker/traefik-test2/testservice

echo "start the services"
docker-compose up -d


################################################################################
echo "goto https://$DE1"

echo "show all the running nodes"
docker-compose ps

echo "about to shut it all down"
read -p "Press [Enter]"

docker-compose down
docker-compose ps

################################################################################

#unselect the active node
eval $(docker-machine env -u)
