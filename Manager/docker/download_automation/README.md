# Docker-download_automation

``` shell
BASEDIR=/mnt/nas/docker/download_automation

# All
mkdir -p $BASEDIR/downloads

# transmission
mkdir -p $BASEDIR/transmission/config
mkdir -p $BASEDIR/transmission/watch

# sonarr
mkdir -p $BASEDIR/transmission/config
mkdir -p $BASEDIR/transmission/tv

sudo docker stack deploy --compose-file docker-compose.yml stacktest
```
