# [Docker-DNSmasq](https://hub.docker.com/r/shepner/docker-dnsmasq/)

Uses [Alpine Linux](https://hub.docker.com/_/alpine/), [DNSmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html), and has [webproc](https://github.com/jpillora/webproc/) to previde a web interface.  New builds (should) occur whenever Alpine or this github repo is updated.


http://www.thekelleys.org.uk/dnsmasq/doc.html
http://oss.segetech.com/intra/srv/dnsmasq.conf


https://docs.docker.com/engine/reference/commandline/service_create/

``` shell
sudo docker service create \
  --name DNSmasq \
  --publish published=53,target=53,protocol=udp,mode=ingress \
  --publish published=8080,target=8080,protocol=tcp,mode=ingress \
  --replicas=1 \
  shepner/dnsmasq:latest
```



