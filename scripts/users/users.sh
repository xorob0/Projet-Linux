#!/bin/bash
source ../Common.sh

RootCheck

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

echo "Voulez-vous mettre un quota sur la partition home de cet utilisateur ? (N/y)"
read Q
echo "Avez-vous rajouté l'option defaults,usrquota,grpquota à la place de defaults sur la partition voulu dans le fichier /etc/fstab ? (N/y) "
read F

if ([ "$Q" = "y" ] || [ "$Q" = "Y" ])  && ([ "$F" = "y" ] || [ "$F" = "Y" ])
	then
	Installe quota

	mount -o remount /home
	quotacheck -cugv /home
	quotaon /home/
	edquota -u $LOGIN
	#On affiche les quotas
	repquota -as
	#Configuration periode de grace
	echo "Voulez-vous modifier la période de grâce ? (N/y)"
	read P
	if [ "$P" = "y" ] || [ "$P" = "Y" ]
	then
	edquota -t
	fi
fi

echo "L'utilisateur  $LOGIN a bien été créé"


