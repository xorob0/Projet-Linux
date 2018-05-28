#!/bin/bash
#Installation de ntpdate 
sudo yum install ntpdate

#activation du service 
sudo systemctl enable ntpd

#On stop le service sinon erreur de socket
sudo systemctl stop ntpd
#Synchronisation avec le serveur

echo "Synchronisation de l'horloge depuis le serveur linux.lan"
sudo ntpdate 192.168.0.29
echo "Synchronisation effectuée"


