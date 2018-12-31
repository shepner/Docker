#!/bin/sh

#https://docs.docker.com/swarm/reference/manage/

docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise de02:4000 consul://de02:8500

