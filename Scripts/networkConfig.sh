#!/bin/bash

#Configuration de l'interface réseau  ens33
#ATTENTION, se mettre en NAT et executer en admin
#ATTENTION, le nom de l'interface peut changer en fontion de la vm

read -p "Entrez l'adresse IP" IP
read -p "Entrez le masque de sous réseau" MASK
read -p "Entrez votre gateway" GATEWAY
read -p "Entrez votre DNS (Entrer pour 8.8.8.8)" DNS

echo "Voici la liste de vos cartes réseau :"
read -p "Entrez votre carte réseau" CARD

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
