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
UID=1003
GID=1100
NETWORKS="10.0.0.0/8"


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

