#!/bin/bash
source ../Common.sh

RootCheck
#Check installation du support EPEL
Installe epel-release

#Installation de tous les composants de ClamAV

Installe clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd

#Configuration du daemon Clam
#Copie du template dans le cas où l'on a pas de fichier de configuration
cp /usr/share/clamav/template/clamd.conf /etc/clamd.d/clamd.conf

#Activation de Freshclam pour garder la DB à jour

#Création du service freshclam et configuration
echo "# Run the freshclam as daemon
[Unit]
Description = freshclam scanner
After = network.target

[Service]
Type = forking
ExecStart = /usr/bin/freshclam -d -c 4
Restart = on-failure
PrivateTmp = true

[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/clam-freshclam.service

#Démarrage et activation du service au démarrage
Service clam-freshclam.service

#Changement des fichiers service autrement  clamd@.service ne démarre pas
#On renomme le fichier si on l'a pas déjà fais
if [ ! -e "/usr/lib/systemd/system/clamd.service" ];then
    mv /usr/lib/systemd/system/clamd@.service /usr/lib/systemd/system/clamd.service
fi

#On modifie le fichier clamd@scan.service et on change la référence vers
# /lib/systemd/system/clamd.service
echo ".include /lib/systemd/system/clamd.service

[Unit]
Description = Generic clamav scanner daemon

[Install]
WantedBy = multi-user.target" > /usr/lib/systemd/system/clamd@scan.service

#On modifie le fichier /usr/lib/systemd/system/clamd.service et on configure
echo "[Unit]
Description = clamd scanner daemon
After = syslog.target nss-lookup.target network.target

[Service]
Type = simple
ExecStart = /usr/sbin/clamd -c /etc/clamd.d/clamd.conf --foreground=yes
Restart = on-failure
PrivateTmp = true

[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/clamd.service

#Démarrage et automatistion des services 
Service clamd.service
Service clamd@scan.service





