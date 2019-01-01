# DNSmasq

this might be a good alternative?  https://hub.docker.com/r/jpillora/dnsmasq

Set this to run on the managers rather then the nodes
``` shell
sudo docker service create \
  --name DNSmasq \
  --publish published=53,target=53,protocol=udp,mode=ingress \
  --publish published=53,target=53,protocol=tcp,mode=ingress \
  --publish published=8080,target=8080,protocol=tcp,mode=ingress \
  --constraint node.role==manager \
  --replicas=2 \
  shepner/dnsmasq:latest
```

[Docker Service Create](https://docs.docker.com/engine/reference/commandline/service_create/) documentation


