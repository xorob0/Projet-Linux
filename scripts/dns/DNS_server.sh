#!/bin/bash

source ../Common.sh

RootCheck

DOMAIN=`Argument $1 "linux.lan"`

IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`

# Installation des paquet
Installe "bind" "bind-utils"

systemctl enable named.service
systemctl start  named.service
#Ajout de l'adresse IP du seveur DNS si pas déjà fais dans le fichier de config réseau et dans /etc/resolv.conf "nameserver 192.168.65.128"
systemctl restart network.service
#Modification fichier /etc/named.conf
#Création du fichier de zone "linux_forward.zone" et "linux_reverse.zone" dans var/named/ et configuration des  fichiers

# Création du fichier named

echo "options {
	listen-on port 53 { 127.0.0.1;$IP; }; /*ajout de l'ip du serveur*/
	listen-on-v6 port 53 { ::1; };
	directory 	\"/var/named\";
	dump-file 	\"/var/named/data/cache_dump.db\";
	statistics-file \"/var/named/data/named_stats.txt\";
	memstatistics-file \"/var/named/data/named_mem_stats.txt\";
        allow-query    { 0.0.0.0; }; /*ajout du reseau autorisé à query*/

    /* Securité à mettre en place pour s authentifier et etre sur que ça soit le bon*/

	recursion yes;   

	dnssec-enable yes;
	dnssec-validation yes;

	/* Path to ISC DLV key*/
	bindkeys-file \"/etc/named.iscdlv.key\";

	managed-keys-directory \"/var/named/dynamic\";

	pid-file \"/run/named/named.pid\";
	session-keyfile \"/run/named/session.key\";
};" > /etc/named.conf

echo "$TTL 86400
@   IN  SOA     server.$DOMAIN.lan root.$DOMAIN.lan. (
        2011071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
@       IN  NS  $DOMAIN.lan.
@       IN  A   $IP
server  IN  A   192.168.188.34" > /etc/named/forward.$DOMAIN

echo "$TTL 86400
@   IN  SOA     server.$DOMAIN.lan .root.$DOMAIN.lan. (
        2011071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
@        IN  NS      server.$DOMAIN.lan.
@        IN  PTR     $DOMAIN.lan.
server   IN  A       $IP
${IP}    IN  PTR     server.$DOMAIN.lan." > /etc/named/reverse.$DOMAIN

chown -v root:named /etc/named.conf
systemctl restart named.service

named-checkconf -v /etc/named.conf
named-checkzone $DOMAIN.lan /var/named/forward.$DOMAIN
named-checkzone $DOMAIN.lan /var/named/reverse.$DOMAIN
