#!/bin/bash

#Configuration de l'interface réseau  ens33
#ATTENTION, se mettre en NAT et executer en admin

echo "TYPE=Ethernet
BOOTPROTO=static
IPADDR=192.168.65.128
NETMASK=255.255.255.0
GATEWAY=192.168.65.2
DNS1=192.168.65.2
NAME=ens33
ONBOOT=yes" > /etc/sysconfig/network-scripts/ifcfg-ens33

systemctl restart network.service

echo 'Configuration réseau appliquée'
