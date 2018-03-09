#!/bin/bash

#Installation du paquet open-ssh (vérification) permettant de partager un service ssh, par défaut il est normalement déjà installé
yum install openssh-server

#démarrage service sshd
sudo service sshd start

#Configuration client linux  (voir fichier de config)
#Configuation client windows (voir fichier de config) 

#Mise en place de sécurité dans le fichier de configuration /etc/ssh/sshd_config
#Il faut au minimum empêcher la connexion par mot de passe sur root et utiliser une authentification par clé asynchrone (rsa)

#Pour une sécurité optimal, il faut empêcher l'accès en root par SSH avec le fichier de config sshd_config et gérer le fichier sudosers pour placer des droits sur les utilisateurs 






