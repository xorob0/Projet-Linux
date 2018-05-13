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
	echo "Dans quel slot est configuré votre Challenge ?(1/2)"
	read S
	if [ "$S" = "1" ] || [ "$C" = "2" ]
	then
		SERIAL=`ykinfo -s`
		mkdir /home/$LOGIN/.yubico
		ykpamcfg -$S
		mv /root/.yubico/challenge-* /var/yubico/$LOGIN-"${SERIAL: -7}"
	else
		echo "Dans quel slot voulez-vous configurer votre Cahllenge ? (1/2)"
		read S

	 	echo "y" | ykpersonalize -$S -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible
		SERIAL=`ykinfo -s`
		mkdir /home/$LOGIN/.yubico
		ykpamcfg -$S
		mv /root/.yubico/challenge-* /var/yubico/$LOGIN-"${SERIAL: -7}"
	fi
fi

echo "Permettre la connexion en ssh sur cet utilisateur ? (N/y)"
read C
if [ "$C" = "y" ] || [ "$C" = "Y" ]
then
	usermod -g sshallow $LOGIN
fi


