source ../Common.sh

RootCheck

Installe httpd

Service httpd

DOMAIN=`Argument $1 "toto.linux.lan"`
PORT=`Argument $2 "2187"`

# Ajout des configurations au fichier de config
echo "ServerName $DOMAIN:$PORT" >> httpd.conf
echo "Listen $PORT" >> httpd.conf

# Déplacement du fichier de config
cp httpd.conf /etc/httpd/conf/httpd.conf

# Création d'une page web stupide permettant de tester la bonne configuration
echo "coucou" > /var/www/html/index.html

# Ajout du port aux iptables
iptables -A INPUT -p tcp --dport $PORT -j ACCEPT
iptables -A OUTPUT -p tcp --sport $PORT  -j ACCEPT


