#!/bin/bash
#for some reason I had to use /bin/bash for /bin/sh stuff

nodes[0]="de01a"
nodes[1]="de01b"
nodes[2]="de02a"
nodes[3]="de02b"
nodes[4]="de03a"
nodes[5]="de03b"

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
