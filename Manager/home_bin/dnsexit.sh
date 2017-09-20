#!/bin/sh

#pull the params from the config file
. ~/etc/dnsexit.conf

echo USERID = $USERID
echo DNSIP = $DNSIP
echo IP = $IP

echo verify the URL
curl s "http://www.dnsexit.com/ipupdate/dyndata.txt"

echo validate the credentials
curl -s "http://update.dnsexit.com/ipupdate/account_validate.jsp?login=$USERID&password=$PASSWORD"

echo verify the domain
curl -s "http://update.dnsexit.com/ipupdate/domains.jsp?login=$USERID"

echo update the IP
if [ "$DNSIP" != "$IP" ]; then
  echo "updating $HOST from $DNSIP to $IP"
  curl -s "http://update.dnsexit.com/RemoteUpdate.sv?login=$USERID&password=$PASSWORD&host=$HOST&myip=$IP"
fi

echo \n
