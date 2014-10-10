#! /bin/bash
# File "install.sh"

apt-get update
apt-get upgrade
apt-get install -y build-essential libcurl4-gnutls-dev apache2-threaded-dev libtool dh-autoreconf libxml2 libxml2-dev libxml2-utils libaprutil1 libaprutil1-dev
mkdir /home/distrib
mkdir /etc/nginx

wget -P /home/distrib/ http://nginx.org/download/nginx-1.7.4.tar.gz &&
cd /home/distrib/ && tar -xvpzf nginx-1.7.4.tar.gz &&
cd /home/distrib/nginx-1.7.4 && ./configure --sbin-path=/usr/local/sbin/nginx --conf-path=/etc/nginx/conf/nginx.conf --pid-path=/run/nginx.pid &&
make && make install &&
wget -P /etc/init.d/ https://raw.githubusercontent.com/Fleshgrinder/nginx-sysvinit-script/master/nginx
chmod 755 /etc/init.d/nginx

cd /home/distrib/ &&
git clone https://github.com/SpiderLabs/ModSecurity.git mod_security &&
cd ./mod_security/ &&
./autogen.sh &&
./configure --enable-standalone-module --disable-apache2-module &&
make &&

cd /home/distrib/nginx-1.7.4 && ./configure --sbin-path=/usr/local/sbin/nginx --conf-path=/etc/nginx/conf/nginx.conf --pid-path=/run/nginx.pid --add-module=../mod_security/nginx/modsecurity &&
make && make install &&
rm -rf /etc/nginx/conf/nginx.conf
cp /home/install/nginx.conf /etc/nginx/conf/
cp /home/distrib/mod_security/modsecurity.conf-recommended /etc/nginx/conf/
mv /etc/nginx/conf/modsecurity.conf-recommended /etc/nginx/conf/modsecurity.conf
cp /home/distrib/mod_security/unicode.mapping /etc/nginx/conf/
/usr/local/sbin/nginx
service nginx restart

cd /home/distrib/ &&
git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git
echo -e "\n\n########## Mod-Security CRS 10 conf ##########" >> /etc/nginx/conf/modsecurity.conf
cat /home/distrib/owasp-modsecurity-crs/modsecurity_crs_10_setup.conf.example >> /etc/nginx/conf/modsecurity.conf
echo -e "\n\n########## Base Mod-Security OWASP CRS ##########" >> /etc/nginx/conf/modsecurity.conf
cat /home/distrib/owasp-modsecurity-crs/base_rules/*.conf >> /etc/nginx/conf/modsecurity.conf
cp /home/distrib/owasp-modsecurity-crs/base_rules/*.data /etc/nginx/conf/
service nginx restart