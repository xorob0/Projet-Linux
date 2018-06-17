source ../Common.sh

RootCheck

Installe httpd

Service httpd

DOMAIN=`Argument $1 "toto.linux.lan"`
PORT=`Argument $2 "2187"`

echo "ServerName $DOMAIN:$PORT" >> httpd.conf
echo "Listen $PORT" >> httpd.conf

cp httpd.conf /etc/httpd/conf/httpd.conf

echo "coucou" > /var/www/html/index.html

iptables -A INPUT -p tcp --dport $PORT -j ACCEPT
iptables -A OUTPUT -p tcp --sport $PORT  -j ACCEPT


