#!/bin/bash

source ../Common.sh

RootCheck

DOMAIN=`Argument $1 "linux"`
SUBDOMAIN=`Argument $2 "toto"`

IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
NETID=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/' | cut -f1-3 -d'.'`
HN=`hostname`

# Installation des paquet
Installe "bind" "bind-utils"

systemctl enable named.service
systemctl start  named.service
#Ajout de l'adresse IP du seveur DNS si pas déjà fais dans le fichier de config réseau et dans /etc/resolv.conf "nameserver 192.168.65.128"
systemctl restart network.service
#Modification fichier /etc/named.conf
#Création du fichier de zone "linux_forward.zone" et "linux_reverse.zone" dans var/named/ et configuration des  fichiers

# Création du fichier named

echo "
options {
	listen-on port 53 { 127.0.0.1;$IP; }; /*ajout de l'ip du serveur*/
	listen-on-v6 port 53 { ::1; };
	directory 	\"/var/named\";
	dump-file 	\"/var/named/data/cache_dump.db\";
	statistics-file \"/var/named/data/named_stats.txt\";
	memstatistics-file \"/var/named/data/named_mem_stats.txt\";
        allow-query    { $NETID; localhost; }; /*ajout du reseau autorisé à query*/
	recursion yes;   /*mis sur no */

	dnssec-enable yes;
	dnssec-validation yes;

	/* Path to ISC DLV key*/
	bindkeys-file \"/etc/named.iscdlv.key\";

	managed-keys-directory \"/var/named/dynamic\";

	pid-file \"/run/named/named.pid\";
	session-keyfile \"/run/named/session.key\";
};

logging {
        channel default_debug {
                file \"data/named.run\";
                severity dynamic;
        };
};



/*Si domaine inconnu, aller voir dans named.ca*/

zone \".\" IN {
	type hint;
	file \"named.ca\";
};

/*AJOUT DES ZONES*/

zone \"$DOMAIN.lan\" IN {
type master;
file \"forward.$DOMAIN\";
allow-update { none; };
};

zone \"2.0.10.in-addr.arpa\" IN {
type master;
file \"reverse.$DOMAIN\";
allow-update { none; };
};


include \"/etc/named.rfc1912.zones\";
include \"/etc/named.root.key\";
" > /etc/named.conf

echo "
\$TTL 86400
@   IN  SOA     $HN.$DOMAIN.lan. root.$DOMAIN.lan. (
        2011071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
@       IN  NS  $HN.$DOMAIN.lan.
projet  IN  A   $IP
$SUBDOMAIN   IN CNAME    $HN
" > /var/named/forward.$DOMAIN

echo "
\$TTL 86400
@   IN  SOA     $HN.$DOMAIN.lan. root.$DOMAIN.lan. (
        2011071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
@        IN  NS      $HN.$DOMAIN.lan.
@        IN  PTR     $DOMAIN.lan.
projet   IN  A       $IP
15       IN  PTR     $HN.$DOMAIN.lan.
" > /var/named/reverse.$DOMAIN

chown -v root:named /etc/named.conf
systemctl restart named.service

named-checkconf -v /etc/named.conf
named-checkzone $DOMAIN.lan /var/named/forward.$DOMAIN
named-checkzone $DOMAIN.lan /var/named/reverse.$DOMAIN
