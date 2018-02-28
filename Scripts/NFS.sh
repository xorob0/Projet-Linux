#!/bin/bash

#Installation du serveur nfs
sudo yum install nfs-utils

#Activation et démarrage  des services nfs au boot
sudo chkconfig nfs on
sudo systemctl enable rpcbind.service
sudo systemctl start nfs.service
sudo systemctl start rpcbind.service

#création du dossier partagé
sudo mkdir /home/start

#Modification des permissions d'accès
sudo chmod 755 /home

#Configuration du fichier /etc/exports

#Redémarrage du service nfs
sudo systemctl restart nfs.service

#On exporte le partage
sudo exportfs -a
showmount -e
