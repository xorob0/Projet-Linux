#!/bin/bash

echo "Login:"
read LOGIN
echo "Mot de passe:"
read -s PASS
useradd $LOGIN -p $PASS

echo "Voulez-vous configurer une Yubikey pour cet utilisateur ? (N/y)"
read C
if [ "$C" = "y" ] || [ "$C" = "Y" ]
then
	echo "Veuillez connecter votre Yubikey"
	read
	echo "Dans quel slot est configuré votre Challenge ?"
	read S
	if [ "$S" = "1" ] || [ "$C" = "2" ]
	then

		mkdir /home/$LOGIN/.yubico
		ykpamcfg -$S -p /home/$LOGIN/.yubico
	else
		echo "y" | ykpersonalize -a -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible
	fi
fi


