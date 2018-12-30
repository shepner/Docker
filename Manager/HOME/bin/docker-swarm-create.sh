#!/bin/sh
#####################################
# DONT GO BLINDLY RUNNING THIS!
#####################################

#this page has some good stuff for rewriting this into something better:
#https://codefresh.io/blog/deploy-docker-compose-v3-swarm-mode-cluster/


#FIX DNS FIRST OR USE IP ADDRESSES INSTEAD!

DE1="de01a" #de01a
DE2="de01a" #de02a
DE3="de01a" #de03a

#setup the ssh keys
#ssh-copy-id -i ~/.ssh/dockerengine_rsa dockerengine@$DE1
#ssh-copy-id -i ~/.ssh/dockerengine_rsa dockerengine@$DE2
#ssh-copy-id -i ~/.ssh/dockerengine_rsa dockerengine@$DE3

#create the docker engines
#docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=dockerengine --generic-ip-address=$DE1 de01a
#docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=dockerengine --generic-ip-address=$DE2 de02a
#docker-machine create --driver generic --generic-ssh-key ~/.ssh/dockerengine_rsa --generic-ssh-user=dockerengine --generic-ip-address=$DE3 de03a

#show what is available
docker-machine ls

#make this machine a swarm manager
#sudo docker swarm init

#run `docker swarm join-token manager` to add another manager
#see also:  https://docs.docker.com/engine/swarm/swarm_manager_locking/

#add workers
#NOTE:  Change the IP as appropriate as it is dynamically assigned
#docker-machine ssh $DE1 "docker swarm join --token SWMTKN-1-2vs23xm21icmw8ckmbbtu9q0ta6p2fa9qzjdmr7q68y2pbxqfa-466oq8ty4qtps3e9aqfr9bakm 10.1.3.18:2377"
#docker-machine ssh $DE2 "docker swarm join --token SWMTKN-1-2vs23xm21icmw8ckmbbtu9q0ta6p2fa9qzjdmr7q68y2pbxqfa-466oq8ty4qtps3e9aqfr9bakm 10.1.3.18:2377"
#docker-machine ssh $DE3 "docker swarm join --token SWMTKN-1-2vs23xm21icmw8ckmbbtu9q0ta6p2fa9qzjdmr7q68y2pbxqfa-466oq8ty4qtps3e9aqfr9bakm 10.1.3.18:2377"

#show the cluster
#sudo docker node ls
