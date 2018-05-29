#!/bin/bash

source ../Common.sh

RootCheck

#Installation de NTP
Installe ntp ntpdate ntp-doc

#On stop le service ntpd
systemctl stop ntpd

#On met le serveur à la bonne heure au préalable
ntpdate be.pool.ntp.org

#Configuration du serveur ntp
cp ntp.conf /etc/ntp.conf   

#Démarrage et activation du service
systemctl start ntpd 
systemctl enable ntpd 

echo "Le sercie ntp est maintenant installé et activé"
