
export INTERNAL_NET_INTERFACE=$(ip route list {{clientSubnet}} | awk '{print $3}');
export EXTERNAL_NET_INTERFACE=$(ip route list {{externalSubnet}} | awk '{print $3}');

#Add external gateway as default
route del default gw {{internalDockerGateway}} | true;
route add default gw {{externalGateway}};
 

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -i $INTERNAL_NET_INTERFACE -o $EXTERNAL_NET_INTERFACE -j ACCEPT
iptables -A FORWARD -i $EXTERNAL_NET_INTERFACE -o $INTERNAL_NET_INTERFACE -m state --state ESTABLISHED,RELATED \
         -j ACCEPT
iptables -t nat -A POSTROUTING -o $EXTERNAL_NET_INTERFACE -j MASQUERADE

klogd -c 1
touch /var/log/kern.log
tail -f /var/log/kern.log