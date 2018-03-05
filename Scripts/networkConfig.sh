#!/bin/bash

source Common.sh

IP = Argument $1 "192.168.1.2"
MASK = Argument $2 "255.255.255.0"
GATEWAY = Argument $3 "192.168.1.1"
DNS = Arguemnt $4 "8.8.8.8"
CARD = Argument $5 `ip link show | grep "2: " | cut -d " " -f2 | sed "s/://"`


echo "TYPE=Ethernet
BOOTPROTO=static
IPADDR=${IP}
NETMASK=${MASK}
GATEWAY=${GATEWAY}
DNS1=${DNS}
NAME=${CARD}
ONBOOT=yes" > /etc/sysconfig/network-scripts/ifcfg-${CARD}

systemctl restart network.service

echo 'Configuration réseau appliquée'
