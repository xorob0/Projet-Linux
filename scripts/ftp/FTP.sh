#!/bin/bash
source ../Common.sh
RootCheck

s='./FTP.sh [DOSSIER]
DOSSIER: Dossier de partage (Defaut: /home/Partage)
'

Aide $1 $s

Installe vsftpd

DossierPartage=`Argument $1 "/home/Partage"`

systemctl start vsftp.service
systemctl enable vsftp.service

mkdir -p $DossierPartage


echo "veuillez rajouter l'option defaults,usrquota,grpquota à la place de defaults sur la partition voulu dans le fichier /etc/fstab"

#La modification de /etc/fstab doit préalablement être déjà effectué
Installe quota

mount -o remount /home
quotacheck -cugv /home
quotaon /home/
edquota -u vsftp
#On affiche les quotas
repquota -as
#Configuration periode de grace
echo "Voulez-vous modifier la période de grâce ? (N/y)"
read P
if [ "$P" = "y" ] || [ "$P" = "Y" ]
    then
    edquota -t
fi

echo "# Allow all connections \nvsftpd: ALL\n# IP adress range\nvsftpd: 10.0.0.0/255.255.255.0" > /etc/hosts.allow
