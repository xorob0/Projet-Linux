#!/bin/bash

source ../Common.sh

CheckRoot

Chemin=`Arguemnt $1 "/Backup"` # Le chemin peut aussi être sous la forme user@hostname:/path/to/repo
PWD=`Argument $2 "Test123*"`
DATE=`date '+%Y%m%d%H%M%S'`
tmpfile="/tmp/borgcron"

# Installation de python et de pip
Installe python

cd /tmp/
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py

# Installation de borg
pip install borgbackup

# Inistialisation du repo borg
borg init --encryption=$PWD $Chemin
borg create $Chemin::$DATE /

# Ajout de borg au crontab toute les heures
crontab -l > $tmpfile
echo "0 * * * * export BORG_PASSPHRASE='$PWD';borg create $Chemin::`date '+%Y%m%d%H%M%S'` /" >> $tmpfile
crontab $tmpfile
rm $tmpfile
