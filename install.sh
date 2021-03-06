#! /bin/bash
# File "install.sh"

apt-get update
apt-get upgrade
apt-get install -y build-essential libcurl4-gnutls-dev apache2-threaded-dev libtool dh-autoreconf libxml2 libxml2-dev libxml2-utils libaprutil1 libaprutil1-dev geoip-database libgeoip-dev
mkdir /home/distrib
mkdir /etc/nginx

wget -P /home/distrib/ http://nginx.org/download/nginx-1.7.4.tar.gz &&
cd /home/distrib/ && tar -xvpzf nginx-1.7.4.tar.gz &&
cd /home/distrib/nginx-1.7.4 && ./configure --sbin-path=/usr/local/sbin/nginx --conf-path=/etc/nginx/conf/nginx.conf --pid-path=/run/nginx.pid &&
make && make install &&
wget -P /etc/init.d/ https://raw.githubusercontent.com/Fleshgrinder/nginx-sysvinit-script/master/nginx
chmod 755 /etc/init.d/nginx

cd /home/distrib &&
git clone https://github.com/kyprizel/testcookie-nginx-module.git

cd /home/distrib/ &&
git clone https://github.com/SpiderLabs/ModSecurity.git mod_security &&
cd ./mod_security/ &&
./autogen.sh &&
./configure --enable-standalone-module --disable-apache2-module &&
make &&

cd /home/distrib &&
wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz &&
tar -zxvf GeoIP.tar.gz &&
cd /home/distrib/GeoIP-1.4.8 &&
./configure &&
make && make install

cd /home/distrib &&
wget -P /home/distrib http://luajit.org/download/LuaJIT-2.0.3.tar.gz &&
tar -xzvf LuaJIT-2.0.3.tar.gz &&
cd /home/distrib/LuaJIT-2.0.3 &&
make && make install &&
echo '/usr/local/lib' > /etc/ld.so.conf.d/geoip.conf

cd /home/distrib &&
git clone https://github.com/simpl/ngx_devel_kit.git

cd /home/distrib &&
git clone https://github.com/openresty/lua-nginx-module.git

ldconfig &&

export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.0

cd /home/distrib/nginx-1.7.4 && ./configure --sbin-path=/usr/local/sbin/nginx --conf-path=/etc/nginx/conf/nginx.conf --pid-path=/run/nginx.pid --with-http_geoip_module --add-module=../mod_security/nginx/modsecurity --add-module=../ngx_devel_kit --add-module=../lua-nginx-module  --add-module=../testcookie-nginx-module &&
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




###     TEST    ###
#if ! test -d /usr/local/include/luajit-2.0; then
#    echo "Installing LuaJIT-2.0.1."
#    wget "http://luajit.org/download/LuaJIT-2.0.1.tar.gz"
#    tar -xzvf LuaJIT-2.0.1.tar.gz
#    cd LuaJIT-2.0.1
#    make
#    sudo make install
#else
#    echo "Skipping LuaJIT-2.0.1, as it's already installed."
#fi