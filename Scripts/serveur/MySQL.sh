#!/bin/bash
#Check de l'installation de mysql
sudo yum install mariadb mariadb-server

#Démarrage et lancement du service au démarrage
sudo service mariadb start
sudo systemctl enable mariadb

#Configuration du serveur 
mysql_secure_installation

#Option
ENTER, Y, Y, N, Y, Y

#Setting the root password ensures that nobody can log into the MariaDB
#root user without the proper authorisation.

#By default, a MariaDB installation has an anonymous user, allowing anyone
#to log into MariaDB without having to have a user account created for
#them.  This is intended only for testing, and to make the installation
#go a bit smoother.  You should remove them before moving into a
#production environment.

#Normally, root should only be allowed to connect from 'localhost'.  This
#ensures that someone cannot guess at the root password from the network.

#By default, MariaDB comes with a database named 'test' that anyone can
#access.  This is also intended only for testing, and should be removed
#before moving into a production environment.

#Reloading the privilege tables will ensure that all changes made so far
#will take effect immediately.



#Connexion à la db
mysql -u root -p
