#!/bin/sh

# do everything needed to run Plex in a Docker container, permit direct access from the local network,
# make it possible so it can be accessed from the internet, *and* install a plugin.
#
# This combo of requirements prevents running Plex as a service within a swarm.  Rather, it
# must run outside the swarm on a single node.  The only thing done to simplify this mess was
# to use the official image and to manage the plugin separately.  This may benefit from
# remaining a regular VM until things improve


# With this script, the directories:
# '/var/lib/plexmediaserver' (Ubuntu) and '/mnt/nas/docker/plex/config' (Docker container)
# are the same thing.  In the event you are migrating from a Linux (Ubuntu) server to a Docker
# container, it is possible to move the original Library folder to a new (shared) location
# and point the container at it.  You will also want to do the same with your media folder.
# For each, setup symbolic links as appropriate:
#   `ln -s /mnt/nas/docker/plex/config /var/lib/plexmediaserver`
#   `ln -s <old mountpoint> /data` 
# and then update the Plex library folders to be `'/data/<remaining orig path>'.  This gives
# a very transparant method to migrate from the old server to the new container and back
# be sure the file permissions are correct on all folders

# The claim token is only needed with a new setup
# https://www.plex.tv/claim/
CLAIMTOKEN=

NETWORKS="10.0.0.0/8"
UID=1003
GID=1100
TIMEZONE="America/Chicago"

NODE=de01
NETNME=bridge_plex
SUBNET=10.1.1.0/30
IPADDR=10.1.1.2
GWADDR=10.1.1.1


# Create the bridge network
# We need a fixed IP so we can set the NAT address on the firewall
ssh $NODE " \
  sudo docker network create --attachable --driver bridge --subnet=$SUBNET --gateway=$GWADDR $NETNME \
"


# Enable enable routing and permit the external network to see the subnet
# https://docs.docker.com/network/bridge/
ssh $NODE "sudo sysctl net.ipv4.conf.all.forwarding=1"
ssh $NODE "sudo iptables -P FORWARD ACCEPT"


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
ssh $NODE " \
  sudo docker run \
  --detach \
  --name plex \
  --network=$NETNME \
  --ip $IPADDR \
  --env TZ=$TIMEZONE \
  --env PLEX_CLAIM="$CLAIMTOKEN" \
  --env PLEX_UID=$UID \
  --env PLEX_GID=$GID \
  --env ALLOWED_NETWORKS=$NETWORKS \
  --volume type=bind,src=/mnt/nas/docker/plex/config,dst=/config \
  --volume type=bind,src=/mnt/nas/docker/plex/transcode,dst=/transcode \
  --volume type=bind,src=/mnt/nas/media,dst=/data \
  plexinc/pms-docker \
"

