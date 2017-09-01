#!/bin/sh

GITHUBARCHIVE="master.zip"

#fetch the latest files from gethub
wget https://github.com/shepner/Docker/archive/$GITHUBARCHIVE

#refresh and load the github functions
unzip -jo $GITHUBARCHIVE Docker-master/Manager/home_etc/functions_github -d ~/etc
chmod 600 ~/etc/functions_github
. ~/etc/functions_github

#refresh stuff
install_update_script $GITHUBARCHIVE



#install_mosh
#configure_dnsexit
#install_openvpn
#install_docker_engine
#install_docker_machine
#install_docker_compose
#configure_docker_swarm
