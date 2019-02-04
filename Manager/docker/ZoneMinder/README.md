# ZoneMinder

``` shell
CONFIG_PATH=/mnt/nas/docker/zoneminder

sudo mkdir -p $CONFIG_PATH/events
sudo mkdir -p $CONFIG_PATH/images
sudo mkdir -p $CONFIG_PATH/mysql
sudo mkdir -p $CONFIG_PATH/log
sudo chown -R docker:docker $CONFIG_PATH
sudo chmod -R 775 $CONFIG_PATH


sudo docker service create \
  --name zoneminder \
  --env TZ="America/Chicago" \
  --publish published=1080,target=80,protocol=tcp,mode=ingress \
  --mount type=bind,src=$CONFIG_PATH/events,dst=/var/lib/zoneminder/events \
  --mount type=bind,src=$CONFIG_PATH/images,dst=/var/lib/zoneminder/images \
  --mount type=bind,src=$CONFIG_PATH/mysql,dst=/var/lib/mysql \
  --mount type=bind,src=$CONFIG_PATH/log,dst=/var/log/zm \
  --replicas=1 \
  --constraint 'node.role != manager' \
  shepner/zoneminder
```






https://hub.docker.com/r/quantumobject/docker-zoneminder

``` shell
zm_install.sh

docker stack deploy -c docker-compose.yml zm

echo "wait for a few seconds to MySQL start for the first time"
docker service scale zm_web=1

echo "go to ZoneMinder console Options-Servers and declare node.0-&gt;stream0.localhost and node.1 ... node.3, finally start"
docker service scale zm_stream=3

docker service ls
```

