#!/bin/bash
source Common.sh

USER = Argument $1 "root"
IP = Argument $2 "192.168.1.2"

# Installation ssh
Installe openssh

#On génère une clé RSA et on stocke la clé privé dans /root/.ssh/id_rsa, ensuite on défini le mdp (passphrase = Test123*).
#Cette procédure va permettre d'établir une connexion SSH par clé asymétrique. La clef publique est stockée dans un fichier qui porte le même nom plus une extension .pub
 
if [ ! -f ~/.ssh/id_rsa.pub ]; then
	ssh-keygen -t rsa
fi

#On copie la clé public du client du dossier /root/.ssh/id_rsa.pub dans celle de l'utilisateur du serveur pour pouvoir s'y connecter sans mdp mais avec clé rsa

ssh-copy-id -i /root/.ssh/id_rsa.pub $USER@$IP

#On se connecte 
ssh $USER@$IP
