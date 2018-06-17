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
Service ntpd

echo "Le service NTP est maintenant installé et activé."
