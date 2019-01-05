#!/bin/sh

# https://forums.plex.tv/t/official-plex-media-server-docker-images-getting-started/172291
# https://github.com/plexinc/pms-docker

# The claim token can be found here:
# https://www.plex.tv/claim/
CLAIMTOKEN=""
UID=1003
GID=1100
NETWORKS="10.0.0.0/8"

sudo docker service create \
  --name plex \
  --hostname plex \
  --network host \
  --env TZ="America/Chicago" \
  --env PLEX_CLAIM="$CLAIMTOKEN" \
  --env PLEX_UID=$UID \
  --env PLEX_GID=$GID \
  --env ALLOWED_NETWORKS=$NETWORKS \
  --mount type=bind,src=/mnt/nas/docker/plex/config,dst=/config \
  --mount type=bind,src=/mnt/nas/docker/plex/transcode,dst=/transcode \
  --mount type=bind,src=/mnt/nas/media,dst=/data \
  --constraint node.role!=manager \
  --replicas=1 \
  plexinc/pms-docker  


