#!/bin/bash

source ../Common.sh
# Activation de l'EPEL
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Installation du module PAM
Installe pam_yubico

cp ../Files/yubikey-auth /etc/pam.d/yubikey-auth
cp ../Files/sshd /etc/pam.d/sshd
