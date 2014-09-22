#!/bin/sh
# Fichier "vote-nir"

echo | apt-get update
echo | apt-get upgrade
echo | apt-get install build-essential libcurl3 apache2-threaded-dev libtool dh-autoreconf libxml2 libxml2-dev libxml2-utils libaprutil1 libaprutil1-dev
echo | mkdir /home/distrib &&
echo | wget -P /home/distrib/ http://nginx.org/download/nginx-1.7.4.tar.gz
echo | tar -xvpzf /home/distrib/nginx-1.4.2.tar.gz &&
echo | /home/distrib/nginx-1.4.2.tar.gz/configure &&
echo | /home/distrib/nginx-1.4.2.tar.gz/make &&
echo | /home/distrib/nginx-1.4.2.tar.gz/make install &&
echo | ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
echo | git clone https://github.com/ggarrigu/VM-install.git /home/distrib/ &&
echo | cp /home/distrib/VM-install/nginx /etc/init.d/ &&
echo | chmod 755 /etc/init.d/nginx
echo | chown root:root /etc/init.d/nginx
echo | /usr/local/sbin/nginx &&
echo | service nginx restart
