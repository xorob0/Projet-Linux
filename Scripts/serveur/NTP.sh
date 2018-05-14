#!/bin/bash

#Installation de NTP
sudo yum install ntp ntpdate

#On stop le service du serveur de temps chronyd et on le désactive ou sup$
sudo systemctl stop chronyd
sudo systemctl disable chronyd

#On stop le service ntpd
sudo systemctl stop ntpd

#On met le serveur à la bonne heure au préalable
sudo ntpdate be.pool.ntp.org

#Configuration du serveur ntp
sudo nano /etc/ntp.conf   

#Démarrage et activation du service
sudo systemctl start ntpd 
sudo systemctl enable ntpd 

#On  test si le serveur est bien configuré (il doit s'afficher)
ntpq –p 

