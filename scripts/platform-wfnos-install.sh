#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

help()
{
echo ===============================================================================
echo platform installer usage:
echo ===============================================================================
echo "./platfor-installer.sh [type]"
echo "[type]:"
echo "          install    		: Install Platform of StarOS" 
echo "          uninstall       : Uninstall Platform of StarOS"
echo ===============================================================================
}

if [ "$1" == "help" ] || [ "$1" == "" ]
then
	help
	exit 1
fi

function check_os() {
	# Figure out what system we are running on
	if [ -f /etc/lsb-release ];then
		. /etc/lsb-release
	elif [ -f /etc/redhat-release ];then
		sudo yum install -y redhat-lsb
		sudo yum install -y telnet
		sudo yum install -y wget
		DISTRIB_ID=`lsb_release -si`
		DISTRIB_RELEASE=`lsb_release -sr`
		DISTRIB_CODENAME=`lsb_release -sc`
		DISTRIB_DESCRIPTION=`lsb_release -sd`
	fi
	echo DISTRIB_ID: $DISTRIB_ID
	echo DISTRIB_RELEASE: $DISTRIB_RELEASE
	echo DISTRIB_CODENAME: $DISTRIB_CODENAME
	echo DISTRIB_DESCRIPTION: $DISTRIB_DESCRIPTION
}

function install_rpm() {
	check_os
	if [ $DISTRIB_ID == "CentOS" ]; then
		#check stardlls
		if [ -d /opt/stardlls ];then
			echo Stardlls check!
		else
			if [ -f ../package/centos/stardlls-1.0.0-1.x86_64.rpm ];then
				rpm -ihv ../package/centos/stardlls-1.0.0-1.x86_64.rpm
			else
				wget -P ../package/centos https://github.com/wfnex/stardlls/raw/master/stardlls-1.0.0-1.x86_64.rpm
				rpm -ihv ../package/centos/stardlls-1.0.0-1.x86_64.rpm
			fi
		fi
		#check dipc
		if [ -d /opt/dipc ];then
			echo DIPC check!
		else
			if [ -f ../package/centos/dipc-1.2.0-1.x86_64.rpm ];then
				rpm -ihv ../package/centos/dipc-1.2.0-1.x86_64.rpm
			else
				wget -P ../package/centos/ https://github.com/wfnex/DIPC/raw/master/dipc-1.2.0-1.x86_64.rpm
				rpm -ihv ../package/centos/dipc-1.2.0-1.x86_64.rpm
			fi
		fi
		#check core
		if [ -d /opt/starcore ];then
			echo StarCore check!
		else
			if [ -f ../package/centos/starcore-1.1.0-1.x86_64.rpm ];then
				rpm -ihv ../package/centos/starcore-1.1.0-1.x86_64.rpm
			else
				wget -P ../package/centos/ https://github.com/wfnex/starcore/raw/master/starcore-1.1.0-1.x86_64.rpm
				rpm -ihv ../package/centos/starcore-1.1.0-1.x86_64.rpm
			fi
		fi
		#check wfnos
		if [ -d /opt/wfnos ];then
			echo WFNOS check!
		else
			if [ -f ../package/centos/wfnos-2.1.0-1.x86_64.rpm ];then
				rpm -ihv ../package/centos/wfnos-2.1.0-1.x86_64.rpm
			else
				wget -P ../package/centos/ https://github.com/wfnex/wfnos/raw/master/wfnos-2.1.0-1.x86_64.rpm
				rpm -ihv ../package/centos/wfnos-2.1.0-1.x86_64.rpm
			fi
		fi
	else
		echo StarOS only run at centos!
	fi
}

function uninstall_rpm() {
	echo uninstall platform will cause application not avaliable, are you sure want uninstall platform?
	read -s -n1 -p "Press any key to continue ..."
	echo "\n"
	rpm -e wfnos --nodeps
	rpm -e core --nodeps
	rpm -e dipc --nodeps
	rpm -e stardlls --nodeps
}


if [ "$1" == "install" ]
then
	install_rpm
elif [ "$1" == "uninstall" ]
then
	uninstall_rpm
else
	help
	exit 1
fi
