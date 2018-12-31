# [Docker-DNSmasq](https://hub.docker.com/r/shepner/docker-dnsmasq/)

Uses [Alpine Linux](https://hub.docker.com/_/alpine/), [DNSmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html), and has [webproc](https://github.com/jpillora/webproc/) to previde a web interface.  New builds (should) occur whenever Alpine or this github repo is updated.


http://www.thekelleys.org.uk/dnsmasq/doc.html
http://oss.segetech.com/intra/srv/dnsmasq.conf


https://docs.docker.com/engine/reference/commandline/service_create/
https://docs.docker.com/config/containers/container-networking/

example of how to setup as a service listening on a single ip address named 'ns01'

``` shell
sudo docker service create \
  --name DNSmasq \
  --host ns01:10.0.0.12 \
  --publish 53:53/udp \
  --replicas=1 \
  shepner/dnsmasq:latest
```



