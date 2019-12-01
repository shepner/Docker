#!/bin/sh
# Jenkins
# https://hub.docker.com/r/jenkins/jenkins
# https://github.com/jenkinsci/docker/blob/master/README.md

CONFIG_PATH=/mnt/nas/docker/jenkins

sudo mkdir -p $CONFIG_PATH/data
sudo chmod -R 775 $CONFIG_PATH
sudo chown -R root:docker $CONFIG_PATH

sudo docker service create \
  --name jenkins \
  --user root \
  --publish published=8081,target=8080,protocol=tcp,mode=ingress \
  --publish published=50000,target=50000,protocol=tcp,mode=ingress \
  --mount type=bind,src=$CONFIG_PATH/data,dst=/var/jenkins_home \
  --replicas=1 \
  --constraint 'node.role != manager' \
  jenkins/jenkins:lts

# [Setup instructions](https://jenkins.io/doc/book/installing/#setup-wizard)
#
# For the password:  `sudo cat $CONFIG_PATH/data/secrets/initialAdminPassword`
# Determine which node it is running on: `docker service ps jenkins`
# Now goto `http://<node IP address>:8081` and login

# if you need to bounce the service
#sudo docker service scale jenkins=0
#sudo docker service scale jenkins=1
