#!/bin/sh

# https://traefik.io
# https://docs.traefik.io/user-guide/swarm-mode/

docker run -d -p 8080:8080 -p 80:80 -v $PWD/traefik.toml:/etc/traefik/traefik.toml traefik


sudo docker network create --driver overlay --attachable traefik-net

sudo docker service create \
  --name traefik \
  --constraint 'node.role == manager' \
  --publish published=80,target=80,protocol=tcp,mode=ingress \
  --publish published=8080,target=8080,protocol=tcp,mode=ingress \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  --network traefik-net \
  traefik \
  --docker \
  --docker.swarmMode \
  --docker.domain=traefik \
  --docker.watch \
  --api

