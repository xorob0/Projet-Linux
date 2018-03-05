#!/bin/bash
source Common.sh

# Vérification de l'utilisateur
if [ "$EUID" -ne 0 ]
then 
		echo "Vous devez lancer ce script en tant que root"
		echo "Ré-essayez avec \"sudo ./NFS.sh\""
		exit
fi

# Installation du serveur nfs
# L'option "-y" dit à yum de ne rien demander à l'utilisateur
yum -y install nfs-utils &>/dev/null

if EstInstalle nfs-utils
then
	echo "Impossible d'installer le package \"nfs-utils\""
	echo "Vérifiez votre connexion internet et réessayez !"
	exit
else
	echo "NFS est maintenant installé"
fi

#Activation et démarrage  des services nfs au boot
chkconfig nfs on
systemctl enable rpcbind.service
systemctl enable nfs.service
systemctl start rpcbind.service
systemctl start nfs.service

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
