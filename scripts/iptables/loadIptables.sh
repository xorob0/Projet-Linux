#!/bin/bash
source ../Common.sh

RootCheck

iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#Autorise loopback

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#ssh

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

iptables -A INPUT -p tcp --dport 50683 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 50683  -j ACCEPT

iptables -A INPUT -p tcp --sport 50683  -j ACCEPT
iptables -A OUTPUT -p tcp --dport 50683  -j ACCEPT

#Autoriser le trafic entrant d'une connexion déjà établie

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#Autorise ping et icmp

iptables -A OUTPUT -p icmp -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT

#Autorise dns

iptables -A OUTPUT -p tcp --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT

#http et https

iptables -A INPUT -p tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# NTP

iptables -A OUTPUT -p udp --sport 123 -j ACCEPT
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -i lo -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p udp --sport 123:123 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o lo -p udp --sport 123 -j ACCEPT
iptables -A OUTPUT -p udp --dport 123:123 -m state --state NEW,ESTABLISHED -j ACCEPT

# NFS

iptables -A OUTPUT -p tcp -m multiport --sport 111,892,2049,32803 -j ACCEPT
iptables -A OUTPUT -p udp -m multiport --sport 111,892,2049,32803 -j ACCEPT
iptables -A INPUT -p udp -m multiport --dport 111,892,2049,32803 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dport 111,892,2049,32803 -j ACCEPT

# samba

iptables -A INPUT -p udp --dport 137 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --sport 137 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp --dport 138 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --sport 138 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 139 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 139 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 445 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --sport 445 -m state --state NEW,ESTABLISHED -j ACCEPT

iptables -A INPUT -p tcp --dport 135 -j ACCEPT
iptables -A INPUT -p udp --dport 135 -j ACCEPT
iptables -A INPUT -p tcp --dport 137 -j ACCEPT
iptables -A INPUT -p tcp --dport 138 -j ACCEPT
iptables -A INPUT -p udp --dport 139 -j ACCEPT
iptables -A INPUT -p udp --dport 445 -j ACCEPT

iptables -A OUTPUT -p tcp -m state --state RELATED,ESTABLISHED --sport 135 -j ACCEPT
iptables -A OUTPUT -p udp -m state --state RELATED,ESTABLISHED --sport 135 -j ACCEPT
iptables -A OUTPUT -p tcp -m state --state RELATED,ESTABLISHED --sport 137 -j ACCEPT
iptables -A OUTPUT -p udp -m state --state RELATED,ESTABLISHED --sport 137 -j ACCEPT
iptables -A OUTPUT -p tcp -m state --state RELATED,ESTABLISHED --sport 138 -j ACCEPT
iptables -A OUTPUT -p udp -m state --state RELATED,ESTABLISHED --sport 138 -j ACCEPT
iptables -A OUTPUT -p tcp -m state --state RELATED,ESTABLISHED --sport 139 -j ACCEPT
iptables -A OUTPUT -p udp -m state --state RELATED,ESTABLISHED --sport 139 -j ACCEPT
iptables -A OUTPUT -p tcp -m state --state RELATED,ESTABLISHED --sport 445 -j ACCEPT
iptables -A OUTPUT -p udp -m state --state RELATED,ESTABLISHED --sport 445 -j ACCEPT

#Ftp

iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 40000:40100 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 40000:40100 -j ACCEPT
iptables -A INPUT -p tcp --dport 50683 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 50683 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
