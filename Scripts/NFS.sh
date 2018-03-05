#!/bin/bash
# Vérification de l'utilisateur
if [ "$EUID" -ne 0 ]
  then 
		echo "Vous devez lancer ce script en tant que root"
		echo "Ré-essayez avec \"sudo ./NFS.sh\""
		exit
fi

#Installation du serveur nfs
yum install nfs-utils

#Activation et démarrage  des services nfs au boot
chkconfig nfs on
systemctl enable rpcbind.service
systemctl start nfs.service
systemctl start rpcbind.service

#création du dossier partagé
mkdir /home/start

#Modification des permissions d'accès
chmod 755 /home

#Configuration du fichier /etc/exports

#Redémarrage du service nfs
systemctl restart nfs.service

#On exporte le partage
exportfs -a
showmount -e
