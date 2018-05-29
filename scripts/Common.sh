#!/bin/bash

# Vérification des erreurs
set -e

# Vérifie qu'un package est installé
function EstInstalle {
  if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

function Installe {
	if EstInstalle "$@"
	then
		echo "$@ est/sont déjà installé"
	else
		yum -y install "$@" &> /dev/null # Tentative d'installation du paquet

		if EstInstalle "$@" # Vérification que le paquet à été correctement installé
		then
			if [ -z "$2" ]
			then
				echo "$@ est maintenant installé"
			else
				echo "$@ sont maintenant installés"
			fi

		else
			echo "Impossible d'installer le(s) package(s) \"$@\""
			echo "Vérifiez votre connexion internet et réessayez !"
			exit
		fi
	fi
}

function Argument {
	# Si le premier argument est vide on retourne le deuxième
	if [ -z "$1" ]
	then
		return "$2"
	else
		return "$1"
	fi
}

function RootCheck {
	if [ "$EUID" -ne 0 ]
	then 
			echo "Vous devez lancer ce script en tant que root"
			echo "Ré-essayez avec \"sudo ./$0\""
			exit
	fi
}

function Service {
	if ! systemctl restart $1
	then
		echo "Erreur lors du lancement du service"
		exit 1
	else
		systemctl enable $1 &> /dev/null
		echo "Le service à bien été lancé"
	fi
}

function Aide {
	if [ "$1" == "-h" ]
	then
		printf $2
		exit
	fi
}
