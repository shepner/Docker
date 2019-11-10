#!/bin/sh
# Jenkins
# https://jenkins.io/doc/book/installing/#downloading-and-running-jenkins-in-docker
#docker run \
#  -u root \
#  --rm \
#  -d \
#  -p 8080:8080 \
#  -p 50000:50000 \
#  -v jenkins-data:/var/jenkins_home \
#  -v /var/run/docker.sock:/var/run/docker.sock \
#  jenkinsci/blueocean

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
  jenkinsci/blueocean 

# [Setup instructions](https://jenkins.io/doc/book/installing/#setup-wizard)
#
# For the password:  `sudo cat $CONFIG_PATH/data/secrets/initialAdminPassword`
# Determine which node it is running on: `docker service ps jenkins`
# Now goto `http://<node IP address>:8081` and login



# if you need to bounce the service
#sudo docker service scale jenkins=0
#sudo docker service scale jenkins=1
