# Docker

to get this whole mess working:
1.  create a github repo for your Docker image.  The Dockerfile goes gere along with instructions on how to actually use the Docker image
2.  create a [Docker hub](https://hub.docker.com/) account and link it to github
3.  link the github repo to Docker hub.  This will let you automagically recreate your image file whenever there is an update (yay?)
4.  go [install RancherOS on VMware](https://github.com/shepner/Docker-RancherOS)
5.  [build/configure the system that will run Docker Engine](https://github.com/shepner/Docker-DockerMachineHost)
6.  



[automated docker image build instructions](https://docs.docker.com/docker-hub/builds/)

https://hub.docker.com/_/ubuntu/

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/#format)

[Create a Docker Parent Image from scratch](https://docs.docker.com/engine/userguide/eng-image/baseimages/#creating-a-simple-parent-image-using-scratch)

[Dockerfile best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#general-guidelines-and-recommendations)


---

[Minio](https://www.minio.io/) is an open source object storage server with Amazon S3 compatible API
