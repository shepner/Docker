#!/bin/bash
#https://docs.traefik.io/

DE1="de01a"

#set the node we are going to use
docker-machine env $DE1
eval $(docker-machine env $DE1)

################################################################################

cd ~/docker/swarm-test2

docker --compose-file docker-compose.yml VOTE

echo "Goto this page to view test: http://$DE1:8000"
read -p "press [enter]"



################################################################################

#unselect the active node
eval $(docker-machine env -u)
