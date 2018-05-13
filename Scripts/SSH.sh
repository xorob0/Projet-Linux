#!/bin/bash

#Installation du paquet open-ssh (vérification) permettant de partager un service ssh, par défaut il est normalement déjà installé
yum install -y openssh-server

# Utilsation du fichier de config
cp ../Files/sshd_config /etc/ssh/ssh_config

#démarrage service sshd
sudo service sshd start
