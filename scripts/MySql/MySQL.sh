#!/bin/bash

source ../Common.sh

RootCheck

UserDB=`Argument $1 "user"`
PWD=`Argument $2 "Test123*"`
DB=`Argument $3 "database"`

#Ajout de la repo
rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rp://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm &> /dev/null

Installe mysql-community-server
#Démarrage et lancement du service au démarrage
systemctl start mysqld
systemctl enable mysqld

# Lancer mysql avec le bon runlevel
/sbin/chkconfig --levels 235 mysqld on

# Règles firewall
firewall-cmd --permanent --zone=trusted --add-source=192.0.2.10/32
firewall-cmd --permanent --zone=trusted --add-port=3306/tcp
firewall-cmd  --reload

TMPPWD=`cat /var/log/mysqld.log | grep temporary | grep  -oE '[^ ]+$'`
echo " Your temporary password is $TMPPWD"

#Configuration du serveur 
mysql_secure_installation

#Option
#ENTER, Y, Y, Y, Y, Y

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
# mysql -u root -p
