#!/bin/bash
IS_APACHE_INSTALLED=$(dpkg -l apache2 | grep ii |wc -l)
if [ $IS_APACHE_INSTALLED = 0 ]
then
apt update
apt install apache2 -y -q
fi

#------------------------------------

source vm2.config
export $(cut -d= -f1 vm2.config)
envsubst < default1.conf '$APACHE_VLAN_IP' > /etc/apache2/sites-enabled/default1.conf

#------------------------------------

modprobe 8021q
vconfig add $INTERNAL_IF $VLAN
ip addr add $APACHE_VLAN_IP dev $INTERNAL_IF:$VLAN
ip link set up $INTERNAL_IF:$VLAN
ip route add default via $GW_IP




