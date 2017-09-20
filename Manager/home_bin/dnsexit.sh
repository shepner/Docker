#!/bin/sh

#pull the params from the config file
. ~/etc/dnsexit.conf

#echo DNSIP = $DNSIP
#echo IP = $IP

echo "\n\nverify the URL\n"
curl s 'http://www.dnsexit.com/ipupdate/dyndata.txt'

echo "\n\nvalidate the credentials\n"
curl -s 'http://update.dnsexit.com/ipupdate/account_validate.jsp?login=$USERID&password=$PASSWORD'

echo "\n\nverify the domain(s)\n"
curl -s 'http://update.dnsexit.com/ipupdate/domains.jsp?login=$USERID'

echo "\n\nupdate the IP\n"
if [ "$DNSIP" != "$IP" ]; then
  echo "updating $HOST from $DNSIP to $IP"
  curl -s 'http://update.dnsexit.com/RemoteUpdate.sv?login=$USERID&password=$PASSWORD&host=$HOST&myip=$IP'
fi
