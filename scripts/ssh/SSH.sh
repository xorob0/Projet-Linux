#!/bin/bash

source Common.sh

#Installation du paquet open-ssh (vérification) permettant de partager un service ssh, par défaut il est normalement déjà installé
Installe openssh-server

# Utilsation du fichier de config
cp sshd_config /etc/ssh/sshd_config
cp sshbanner /etc/ssh/banner

#démarrage service sshd
Service sshd
