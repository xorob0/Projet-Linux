#!/bin/bash
source Common.sh

RootCheck

# Défault du dossier de partage
DossierPartage = Argument $1 "/Partage"
ARG = Argument $2 "rw,sync,no_root_squash,no_subtree_check)"
IP = Argument $3 `ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`

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
echo "$DossierPartage	$IP$ARG" >> /etc/exports

#On exporte le partage
exportfs -a
showmount -e
