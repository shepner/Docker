#!/bin/bash
#for some reason I had to use /bin/bash for /bin/sh stuff

nodes[0]="de01"
nodes[1]="de02"
nodes[2]="de03"
nodes[3]="de04"
nodes[4]="de05"
nodes[5]="de06"

PATCHCMD="sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade && sudo apt -y autoremove"
REBOOTCMD="sudo reboot"

#patch the docker engines
for DE in ${nodes[@]} ; do
  docker-machine ssh $DE $PATCHCMD
done

#reboot the docker engines
for DE in ${nodes[@]} ; do
  docker-machine ssh $DE $REBOOTCMD
  sleep 60
done
