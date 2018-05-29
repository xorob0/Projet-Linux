#/bin/bash

souce ../Common.sh

RootCheck
s=" ./SAMBA.sh DOSSIER UTILISATEUR NOM GROUPE
DOSSIER: Dossier de partage (Defaut: /Partage)
UTILISATEUR: Utilisateur possédant les droits (Defaut: Utilisateur courant)
NOM: Nom du partage (Defaut: DOSSIER)
GROUPE: Nom du groupe utilisé pour le partage (Defaut: GroupePartage)
"

Aide $1 $s

#On crée le dossier de partage
DossierPartage=Argument $1 "/Partage"
UserP=Argument $2 $USER
NameP=Argument $3 $DossierPartage
GroupePartage=$4 "GroupePartage"

#Installation samba
Installe samba

#démarrage et activation du démon au démarrage
systemctl start smb.service
systemctl enable smb.service

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


# Configuration de iptable pour accepter le trafic samba
iptables -A INPUT -p udp -m udp --dport 137 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 138 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 139 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 445 -j ACCEPT
service iptables save


# Désavtivation de SELinux (car autrement impossible de se connecter depuis le client, il faudra configurer tout ça )
setenforce 0

#Redémarrage du service smb
sudo systemctl restart smb.service
