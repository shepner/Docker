#!/bin/sh

#FIX DNS FIRST OR USE IP ADDRESSES INSTEAD!

#create the docker engines
#docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=rancher --generic-ip-address=de01a de01a
#docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=rancher --generic-ip-address=de01b de01b

#show what is available
sudo docker-machine ls

#make this machine a swarm manager
sudo docker swarm init
#run `docker swarm join-token manager` to add another manager
#see also:  https://docs.docker.com/engine/swarm/swarm_manager_locking/

#add workers
#NOTE:  Change the IP as appropriate as it is dynamically assigned
docker-machine ssh de01a "docker swarm join --token SWMTKN-1-3r0pylmc19wj6yq0qpl7hkpikt5kskdodh3dysv8cma0hh11t3-67pdlz6dt9dzg1cjjq32m1vv6 10.1.3.18:2377"
docker-machine ssh de01b "docker swarm join --token SWMTKN-1-3r0pylmc19wj6yq0qpl7hkpikt5kskdodh3dysv8cma0hh11t3-67pdlz6dt9dzg1cjjq32m1vv6 10.1.3.18:2377"

#show the cluster
sudo docker node ls

#make sure ~/docker-compose.yml exists

#deploy the cluster
sudo docker stack deploy -c docker-compose.yml getstartedlab

#delete the cluster
sudo docker stack rm getstartedlab
