#!/bin/bash

source ../Common.sh

RootCheck

Chemin=`Argument $1 "/Backup"` # Le chemin peut aussi être sous la forme user@hostname:/path/to/repo
PWD=`Argument $2 "Test123*"`
DATE=`date '+%Y%m%d%H%M%S'`
tmpfile="/tmp/borgcron"

# Installation de python et de pip
Installe openssl openssl-devel
Installe gcc
Installe yum-utils
Installe python36u

cd /tmp/
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python3.6 get-pip.py

pip3.6 install --upgrade setuptools

# Installation de borg
pip3.6 install borgbackup

# Inistialisation du repo borg
borg init --encryption=$PWD $Chemin
borg create $Chemin::$DATE /

# Ajout de borg au crontab toute les heures
crontab -l > $tmpfile
echo "0 * * * * export BORG_PASSPHRASE='$PWD';borg create $Chemin::`date '+%Y%m%d%H%M%S'` /" >> $tmpfile
crontab $tmpfile
rm $tmpfile
