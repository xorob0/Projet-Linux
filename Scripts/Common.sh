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
		yum -y install "$@" &>/dev/null # Tentative d'installation du paquet

		if EstInstalle "$@" # Vérification que le paquet à été correctement installé
		then
			echo "$@ est/sont maintenant installé(s)"
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
		echo "$2"
	else
		echo "$1"
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
