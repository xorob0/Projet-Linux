#!/bin/bash
#mon commentaire²
echo "# Allow all connections \nvsftpd: ALL\n# IP adress range\nvsftpd: 10.0.0.0/255.255.255.0" > /etc/hosts.allow

