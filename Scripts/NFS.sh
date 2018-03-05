#!/bin/bash
source Common.sh

# Vérification de l'utilisateur
if [ "$EUID" -ne 0 ]
then 
		echo "Vous devez lancer ce script en tant que root"
		echo "Ré-essayez avec \"sudo ./NFS.sh\""
		exit
fi

# Défault du dossier de partage
DossierPartage = Argument $1 "/Partage"

#création du dossier partagé si celui-ci n'existe pas encore
if [ ! -d $DossierPartage ]
then
	mkdir $DossierPartage
fi

#Modification des permissions d'accès
chmod 755 $DossierPartage

echo "Le dossier $DossierPartage est maintenant crée"

# Installation du serveur nfs
Installe nfs-utils

#Activation et démarrage des services nfs au boot
chkconfig nfs on
systemctl enable rpcbind.service
systemctl enable nfs.service
systemctl start rpcbind.service
systemctl start nfs.service


#Configuration du fichier /etc/exports

#On exporte le partage
exportfs -a
showmount -e
