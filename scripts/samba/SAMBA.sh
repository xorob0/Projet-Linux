#/bin/bash

source ../Common.sh


RootCheck
s=" ./SAMBA.sh DOSSIER UTILISATEUR NOM GROUPE
DOSSIER: Dossier de partage (Defaut: /Partage)
UTILISATEUR: Utilisateur possédant les droits (Defaut: Utilisateur courant)
NOM: Nom du partage (Defaut: DOSSIER)
GROUPE: Nom du groupe utilisé pour le partage (Defaut: GroupePartage)
"

Aide $1 $s

#On crée le dossier de partage
DossierPartage=`Argument $1 "/Partage"`
UserP=`Argument $2 $USER`
NameP=`Argument $3 $DossierPartage`
GroupePartage=`Argument $4 "GroupePartage"`

#Installation samba
Installe samba

#démarrage et activation du démon au démarrage
Service smb

#création du dossier partagé si celui-ci n'existe pas encore
mkdir -p $DossierPartage

#Ajout du groupe sharedFolder contenant user1 et user2
groupadd $GroupePartage
useradd -g sharedFolder $UserP

#On gère les permissions du dossier partagé
chmod 770 $DossierPartage
chown -R $UserP:$GroupePartage $DossierPartage

echo "Veuilez choisir un mot de passe pour l'utilisateur $UserP"
smbpasswd -a $UserP

# Copie des réglages de samba
echo"
[${NameP}]
path=${DossierPartage}
comment=Partage crée par un script
public=yes
force directory mode=777
force create mode=777
writeable=yes
browseable=yes" >> smb.conf
cp smb.conf /etc/samba/smb.conf

# Désavtivation de SELinux (car autrement impossible de se connecter depuis le client, il faudra configurer tout ça )
setenforce 0

#Redémarrage du service smb
sudo systemctl restart smb.service
