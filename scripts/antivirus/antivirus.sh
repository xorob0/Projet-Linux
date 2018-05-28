#Check installation du support EPEL
sudo yum install epel-release

#Installation de tous les composants de ClamAV

sudo yum install clamav-server clamav-data clamav-update clamav-filesystem
clamav clamav-scanner-systemd clamav-devel clamav-lib 
clamav-server-systemd

#Configuration du daemon Clam

#Copie du template dans le cas où l'on a pas de fichier de configuration
sudo cp /usr/share/clamav/template/clamd.conf /etc/clamd.d/clamd.conf

#Activation de Freshclam pour garder la DB à jour
sudo cp /etc/freshclam.conf /etc/freshclam.conf.bak

#Création du service freshclam et configuration
sudo nano /usr/lib/systemd/system/clam-freshclam.service

#Démarrage et activation du service au démarrage
sudo systemctl enable clam-freshclam.service
sudo systemctl start clam-freshclam.service

#Changement des fichiers service autrement  clamd@.service ne démarre pas
#On renomme le fichier
sudo mv /usr/lib/systemd/system/clamd@.service /usr/lib/systemd/system/clamd.service

#On modifie le fichier clamd@scan.service et on change la référence vers
# /lib/systemd/system/clamd.service

sudo nano /usr/lib/systemd/system/clamd@scan.service 

#On modifie le fichier /usr/lib/systemd/system/clamd.service et on configure

sudo  nano /usr/lib/systemd/system/clamd.service

#Démarrage et automatistion des services 
sudo systemctl enable clamd.service
sudo systemctl enable clamd@scan.service
sudo systemctl start clamd.service
systemctl start clamd@scan.service

#On peut tester l'antivirus
clamscan -i -r /home





