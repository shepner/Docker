#!/bin/bash
#for some reason I had to use /bin/bash for /bin/sh stuff

nodes[0]="de01a"
nodes[1]="de02a"
nodes[2]="de03a"

PATCHCMD="sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade && sudo apt -y autoremove"
REBOOTCMD="sudo reboot"

#patch the docker engines
for DE in ${nodes[@]}; do
  docker-machine ssh $DE $PATCHCMD
done

#patch the local server
$PATCHCMD

#reboot the docker engines
for DE in ${nodes[@]}; do
  docker-machine ssh $DE $REBOOTCMD
done

#reboot the local server
$REBOOTCMD
