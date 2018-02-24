#!bin/bash

#On vérifie d'abord si le package bind-utils est installé

nomPaquet="bind.x86_64"

if [ $(rpm -q $nomPaquet | grep "le paquet" ) ]
then
   yum install bind bind-utils
fi
systemctl enable named.service
systemctl start  named.service
#Ajout de l'adresse IP du seveur DNS si pas déjà fais dans le fichier de config réseau et dans /etc/resolv.conf "nameserver 192.168.65.128"
systemctl restart network.service
#Modification fichier /etc/named.conf
#Création du fichier de zone "linux_forward.zone" et "linux_reverse.zone" dans var/named/ et configuration des  fichiers

#On test
chgrp named -R /var/named
chown -v root:named /etc/named.conf
systemctl restart named.service

named-checkconf -v /etc/named.conf
named-checkzone linux.lan /var/named/linux_forward.zone
nslookup serveur.linux.lan
dig serveur.linux.lan


#test de la reverse
named-checkzone linux.lan /var/named/linux_reverse.zone
nslookup 192.168.65.128
