#!/bin/bash

source ../Common.sh

RootCheck

ARG=`Argument $1 "22"`

#Installation du paquet open-ssh (vérification) permettant de partager un service ssh, par défaut il est normalement déjà installé
Installe openssh-server

echo "Port $PORT" >> sshd_config

# Utilsation du fichier de config
cp sshd_config /etc/ssh/sshd_config
cp sshbanner /etc/ssh/banner

#démarrage service sshd
Service sshd

iptables -A INPUT -p tcp --dport $PORT -j ACCEPT
iptables -A OUTPUT -p tcp --sport $PORT  -j ACCEPT
