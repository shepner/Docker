#!/bin/sh

# With this script, the directories:
# '/var/lib/plexmediaserver' (Ubuntu) and '/mnt/nas/docker/plex/config' (container)
# are the same.  In the event you are migrating from a Linux (Ubuntu) server to a Docker
# container, it is possible to move the original Library folder to a new (shared) location
# and point the container at it.  You will also want to do the same with your media folder.
# For each, setup symbolic links as appropriate:
#   `ln -s /mnt/nas/docker/plex/config /var/lib/plexmediaserver`
#   `ln -s <old mountpoint> /data` 
# and then update the Plex library folders to be `'/data/<remaining orig path>'.  This gives
# a very transparant method to migrate from the old server to the new container and back


# The claim token can be found here: https://www.plex.tv/claim/
CLAIMTOKEN=   # only needed with a new setup
NETWORKS="10.0.0.0/8"

UID=1003
GID=1100
TIMEZONE="America/Chicago"



# install/update the Absolute Series Scanner plugin
# https://github.com/ZeroQI/Absolute-Series-Scanner
PLEXDIR="/mnt/nas/docker/plex/config/Library/Application Support/Plex Media Server/Scanners"
sudo mkdir -p "$PLEXDIR/Series"
sudo wget -O "$PLEXDIR/Series/Absolute Series Scanner.py" https://raw.githubusercontent.com/ZeroQI/Absolute-Series-Scanner/master/Scanners/Series/Absolute%20Series%20Scanner.py
sudo chown -R $UID:$GID "$PLEXDIR"
sudo chmod 775 -R "$PLEXDIR"


# start the Plex service (slow to start!)
# https://github.com/plexinc/pms-docker
# https://forums.plex.tv/t/official-plex-media-server-docker-images-getting-started/172291
sudo docker service create \
  --name plex \
  --hostname plex \
  --network host \
  --env TZ=$TIMEZONE \
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

################################################
# dont run anything beyond this point
exit

# trying to find a way to define a static address for the container.  Currently using a bridge for this.

#docker network create --driver bridge --subnet=10.1.1.0/24 --gateway=10.1.1.1 docker_bridge
#  --network=docker_bridge \
#  --ip 10.1.1.100 \

sudo docker run \
  --detach \
  --name plex \
  --network=host \
  --ip 10.0.0.80 \
  --env TZ=$TIMEZONE \
  --env PLEX_CLAIM="$CLAIMTOKEN" \
  --env PLEX_UID=$UID \
  --env PLEX_GID=$GID \
  --env ALLOWED_NETWORKS=$NETWORKS \
  --volume type=bind,src=/mnt/nas/docker/plex/config,dst=/config \
  --volume type=bind,src=/mnt/nas/docker/plex/transcode,dst=/transcode \
  --volume type=bind,src=/mnt/nas/media,dst=/data \
  plexinc/pms-docker  

