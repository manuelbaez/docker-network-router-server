#! /bin/sh

#Add external gateway as default for internet access
route del default gw {{internalDockerGateway}} | true;
route add default gw {{externalGateway}};

#Run named service
/usr/sbin/named -g -c /etc/bind/named.conf -u root -p 53 