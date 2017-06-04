#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi
source ./version.sh
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

function install_rpm() {
	#check stardlls
	if [ -d /opt/staros.xyz/stardlls ];then
		echo Stardlls check!
	else
		if [ -f ../package/centos/stardlls-$STARDLLS_VERSION-1.x86_64.rpm ];then
			rpm -ihv ../package/centos/stardlls-$STARDLLS_VERSION-1.x86_64.rpm
		else
			wget -P ../package/centos/ https://github.com/wfnex/stardlls/raw/master/stardlls-$STARDLLS_VERSION-1.x86_64.rpm
			rpm -ihv ../package/centos/stardlls-$STARDLLS_VERSION-1.x86_64.rpm
		fi
	fi
	if [ -d /opt/staros.xyz/protocol ];then
		echo protocol check!
	else
		if [ -f ../package/centos/protocol-$PROTOCOL_VERSION-1.x86_64.rpm ];then
			rpm -ihv ../package/centos/protocol-$PROTOCOL_VERSION-1.x86_64.rpm
		else
			wget -P ../package/centos/ https://github.com/wfnex/protocol/raw/master/protocol-$PROTOCOL_VERSION-1.x86_64.rpm
			rpm -ihv ../package/centos/protocol-$PROTOCOL_VERSION-1.x86_64.rpm
		fi
	fi
	if [ -d /opt/staros.xyz/starlang ];then
		echo starlang check!
	else
		if [ -f ../package/centos/starlang-$STARLANG_VERSION-1.x86_64.rpm ];then
			rpm -ihv ../package/centos/starlang-$STARLANG_VERSION-1.x86_64.rpm
		else
			wget -P ../package/centos/ https://github.com/wfnex/starlang/raw/master/starlang-$STARLANG_VERSION-1.x86_64.rpm
			rpm -ihv ../package/centos/starlang-$STARLANG_VERSION-1.x86_64.rpm
		fi
	fi
	#check dipc
	if [ -d /opt/staros.xyz/dipc ];then
		echo DIPC check!
	else
		if [ -f ../package/centos/dipc-$DIPC_VERSION-1.x86_64.rpm ];then
			rpm -ihv ../package/centos/dipc-$DIPC_VERSION-1.x86_64.rpm
		else
			wget -P ../package/centos/ https://github.com/wfnex/DIPC/raw/master/dipc-$DIPC_VERSION-1.x86_64.rpm
			rpm -ihv ../package/centos/dipc-$DIPC_VERSION-1.x86_64.rpm
		fi
	fi
	#check core
	if [ -d /opt/staros.xyz/starcore ];then
		echo StarCore check!
	else
		if [ -f ../package/centos/starcore-$STARCORE_VERSION-1.x86_64.rpm ];then
			rpm -ihv ../package/centos/starcore-$STARCORE_VERSION-1.x86_64.rpm
		else
			wget -P ../package/centos/ https://github.com/wfnex/starcore/raw/master/starcore-$STARCORE_VERSION-1.x86_64.rpm
			rpm -ihv ../package/centos/starcore-$STARCORE_VERSION-1.x86_64.rpm
		fi
	fi
}

function uninstall_rpm() {
	echo uninstall platform will cause application not avaliable, are you sure want uninstall platform?
	read -s -n1 -p "Press any key to continue ..."
	echo "\n"
	rpm -e starcore --nodeps
	rpm -e dipc --nodeps
	rpm -e starlang --nodeps
	rpm -e protocol --nodeps
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
