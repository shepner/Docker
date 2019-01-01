#!/bin/sh
# Network load balancer
# https://traefik.io
# https://docs.traefik.io/user-guide/swarm-mode/

# management interface listens on port 8080/tcp

sudo docker network create --driver overlay --attachable traefik-net

sudo docker service create \
  --name traefik \
  --constraint 'node.role == manager' \
  --publish published=8080,target=8080,protocol=tcp,mode=ingress \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  --network traefik-net \
  --replicas=1 \
  traefik \
  --docker \
  --docker.swarmMode \
  --docker.domain=traefik \
  --docker.watch \
  --api

