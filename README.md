# Docker

Setup a (simple?) redundant Docker swarm in a hybrid cloud config

## steps

1. [Install docker manager](https://github.com/shepner/Docker/tree/master/Manager)

   You will need 3 of these.  One in AWS (dm01) and the other 2 on the local hosts (dm02 and dm03)
2. [Install docker engine](https://github.com/shepner/Docker/tree/master/Engine/Ubuntu)

   You will need 6 of these (de01-6) spread across the 2 local hosts

3. [setup the nodes](https://github.com/shepner/Docker/blob/master/Manager/HOME/bin/dc_install_nodes.sh)
4. On dm01, [setup the swarm](https://github.com/shepner/Docker/blob/master/Manager/HOME/bin/dm_swarm_create.sh)
5. [install portainer](https://github.com/shepner/Docker/blob/master/Manager/docker/portainer/install_portainer.sh)


--------

other stuff
1.  create a github repo for your Docker image.  The Dockerfile goes gere along with instructions on how to actually use the Docker image
2.  create a [Docker hub](https://hub.docker.com/) account and link it to github
3.  link the github repo to Docker hub.  This will let you automagically recreate your image file whenever there is an update (yay?)
4.  go [install RancherOS on VMware](https://github.com/shepner/Docker-RancherOS)
5.  [build/configure the system that will run Docker Engine](https://github.com/shepner/Docker-DockerMachineHost)

[automated docker image build instructions](https://docs.docker.com/docker-hub/builds/)

https://hub.docker.com/_/ubuntu/

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/#format)

[Create a Docker Parent Image from scratch](https://docs.docker.com/engine/userguide/eng-image/baseimages/#creating-a-simple-parent-image-using-scratch)

[Dockerfile best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#general-guidelines-and-recommendations)


---

[Minio](https://www.minio.io/) is an open source object storage server with Amazon S3 compatible API
