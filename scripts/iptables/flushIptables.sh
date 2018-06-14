#!/bin/bash
source ../Common.sh

RootCheck

iptables -F
iptables -X

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

echo IPtables vidé
