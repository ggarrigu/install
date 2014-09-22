#!/bin/bash
# Fichier "install.sh"

apt-get update
apt-get upgrade
apt-get install build-essential libcurl4-gnutls-dev apache2-threaded-dev libtool dh-autoreconf libxml2 libxml2-dev libxml2-utils libaprutil1 libaprutil1-dev
mkdir /home/distrib
wget -P /home/distrib/ http://nginx.org/download/nginx-1.7.4.tar.gz &&
cd /home/distrib/ && tar -xvpzf nginx-1.7.4.tar.gz
cd /home/distrib/nginx-1.7.4 && ./configure &&
make && make install &&
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
cp /home/install/nginx /etc/init.d/ &&
chmod 755 /etc/init.d/nginx
/usr/local/sbin/nginx &&
service nginx restart & wait
cd /home/distrib/
git clone https://github.com/SpiderLabs/ModSecurity.git mod_security &&
cd ./mod_security/ &&
./autogen.sh &&
./configure --enable-standalone-module --disable-apache2-module &&
make &&
cp modsecurity.conf-recommended /usr/local/nginx/conf/
cp unicode.mapping /usr/local/nginx/conf/
mv /usr/local/nginx/conf/modsecurity.conf-recommended /usr/local/nginx/conf/modsecurity.conf
cd /home/distrib/nginx-1.7.4 &&
./configure --add-module=../mod_security/nginx/modsecurity &&
make && make install &&
service nginx restart
