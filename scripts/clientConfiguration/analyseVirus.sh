#!/bin/bash

date=$(date +%d_%m_%Y_%H_%M)

echo Arret du service freshclam et mise à jour

service clam-freshclam stop

freshclam

service clam-freshclam start

echo Service  redémarré et mise à jour effectuée
echo Entrez le nom du repertoire ou fichier à analyser: 
read nom

if [ -e "$nom" ];then
  echo Analyse en cours ....

  echo "--------------------------------------------------------------------  ---\n" >> $HOME/analyseVirus.log
  echo " " >> $HOME/analyseVirus.log
  echo "Analyse du $date\n" >> $HOME/analyseVirus.log
  echo " "  >> $HOME/analyseVirus.log

  clamscan -l $HOME/analyseVirus.log -r $nom
else
  echo Vous avez entré un nom de repertoire ou fichier inexistant
fi

