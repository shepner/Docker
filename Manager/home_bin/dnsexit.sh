#!/bin/sh

#pull the params from the config file
. ~/etc/dnsexit.conf

#echo DNSIP = $DNSIP
#echo IP = $IP

if [ "$DNSIP" != "$IP" ]; then
  echo "updating $HOST from $DNSIP to $IP"
  curl -s 'http://update.dnsexit.com/RemoteUpdate.sv?login=$USERID&password=$PASSWORD&host=$HOST&myip=$IP'
fi
