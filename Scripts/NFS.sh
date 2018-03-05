#!/bin/bash
source Common.sh

# Vérification de l'utilisateur
if [ "$EUID" -ne 0 ]
then 
		echo "Vous devez lancer ce script en tant que root"
		echo "Ré-essayez avec \"sudo ./NFS.sh\""
		exit
fi

# Le premier argument est le dossier de partage desiré
DossierPartage = "$1"

# Si il n'y a pas d'argument, on partage /Partage
if [ -z "$DossierPartage" ]
then
	$DossierPartage = "/Partage"
fi

#création du dossier partagé si celui-ci n'existe pas encore
if [ ! -d $DossierPartage ]
then
	mkdir $DossierPartage
fi

#Modification des permissions d'accès
chmod 755 $DossierPartage

echo "Le dossier $DossierPartage est maintenant crée"

# Installation du serveur nfs
yum -y install nfs-utils &>/dev/null # L'option "-y" dit à yum de ne rien demander à l'utilisateur

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


#Configuration du fichier /etc/exports

#Redémarrage du service nfs
systemctl restart nfs.service

#On exporte le partage
exportfs -a
showmount -e
