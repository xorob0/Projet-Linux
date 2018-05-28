#/bin/bash

#Installation samba
sudo yum install samba

#démarrage et activation du démon au démarrage
sudo systemctl start smb.service
sudo chkconfig smb on

#On crée le dossier de partage
mkdir sharedFolder /home/sharedFolder

#linuxCLient aura accès uniquement a son repertoire et windowsClient uniquement au sien
#On va également créee 2 utilisateurs en local qui auront accès à un dossier partagé

mkdir /home/sharedFolder

#Ajout du groupe sharedFolder contenant user1 et user2
groupadd sharedFolder
useradd -g sharedFolder user1
useradd -g sharedFolder user2

#On gère les permissions du dossier partagé
chmod 770 /home/sharedFolder/
chown -R root:sharedFolder /home/sharedFolder/


#On autorise les utilisateurs à accéder en samba et on leur met un mot de passe
smbpasswd -a linuxClient
smbpasswd -a windowsClient
smbpasswd -a user1
smbpasswd -a user2

#Désactivation Firewall + SELinux (car autrement impossible de se connecter depuis le client, il faudra configurer tout ça )
iptables -F
setenforce 0

#Modification du fichier de configuration /etc/samba/smb.conf


#Redémarrage du service smb
sudo systemctl restart smb.service


