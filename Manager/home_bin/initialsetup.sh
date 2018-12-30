#!/bin/sh

#Run this file to install the software needed to get this working
#THIS NEEDS TESTED!  The individual commands work but it has not been tested within this script!

#pull in the installation functions
. /home/ubuntu/Docker-DockerMachineHost/softwaresetup

#bootstrap the server
install_update_script
install_mosh
configure_dnsexit
install_openvpn
install_docker_engine
install_docker_machine
install_docker_compose
