# ZoneMinder

https://hub.docker.com/r/quantumobject/docker-zoneminder

``` shell
docker swarm init
docker stack deploy -c docker-compose.yml zm
echo "wait for a few seconds to MySQL start for the first time"
docker service scale zm_web=1
echo "go to ZoneMinder console Options-Servers and declare node.0-&gt;stream0.localhost and node.1 ... node.3, finally start"
docker service scale zm_stream=3
docker service ls
```

