#!/bin/bash
source ../Common.sh
RootCheck

Installe vsftp

DossierPartage = Argument $1 "/Partage"

systemctl start vsftp.service
systemctl enable vsftp.service

mkdir -p $DossierPartage


echo "# Allow all connections \nvsftpd: ALL\n# IP adress range\nvsftpd: 10.0.0.0/255.255.255.0" > /etc/hosts.allow

