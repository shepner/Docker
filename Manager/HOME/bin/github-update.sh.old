#!/bin/sh

GITHUBARCHIVE="master.zip"

#fetch the latest files from gethub
curl -L https://github.com/shepner/Docker/archive/master.zip > $GITHUBARCHIVE

#####################################################
#refresh and load the github functions
unzip -jo $GITHUBARCHIVE Docker-master/Manager/home_etc/functions_github -d ~/etc
chmod 644 ~/etc/functions_github
. ~/etc/functions_github

#update the update script
install_update_script $GITHUBARCHIVE

#####################################################
#refresh and load the other functions
unzip -jo $GITHUBARCHIVE Docker-master/Manager/home_etc/functions_misc_software -d ~/etc
chmod 644 ~/etc/functions_github
. ~/etc/functions_misc_software

setup_dnsexit $GITHUBARCHIVE
#install_openvpn
#install_mosh

#####################################################
#refresh and load all the docker stuff
unzip -jo $GITHUBARCHIVE Docker-master/Manager/home_etc/functions_docker -d ~/etc
chmod 644 ~/etc/functions_docker
. ~/etc/functions_docker

unzip -jo $GITHUBARCHIVE Docker-master/Manager/home_bin/dm-* -d ~/bin
unzip -jo $GITHUBARCHIVE Docker-master/Manager/home_bin/dc-* -d ~/bin
chmod 644 ~/bin/dm-*.sh
chmod 644 ~/bin/dc-*.sh

rm -Rf ~/docker
unzip -jo $GITHUBARCHIVE Docker-master/Manager/docker/* -d ~/docker

install_docker_machine
#install_docker_engine
#install_docker_compose
#configure_docker_swarm

