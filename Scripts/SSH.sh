#!/bin/bash

#Installation du paquet open-ssh (vérification) permettant de partager un service ssh, par défaut il est normalement déjà installé
Installe openssh-server

# Utilsation du fichier de config
cp ../Files/sshd_config /etc/ssh/ssh_config
cp ../Files/sshbanner /etc/ssh/banner

#démarrage service sshd
sudo service sshd start
