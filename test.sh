#! /bin/bash
# File "test.sh"

dep=('libcurl4-gnutls-dev' 'apache2-threaded-dev' 'libtool' 'dh-autoreconf' 'libxml2' 'libxml2-dev' 'libxml2-utils' 'libaprutil1' 'libaprutil1-dev' 'fesse')


for i in "${dep[@]}"
	do
		dpkg -l | grep -q "$i"
		if [ $? -eq 0 ] ; then
			echo "Package $i already installed."
		else
			echo "Package $i is not installed yet."
		fi
	done
