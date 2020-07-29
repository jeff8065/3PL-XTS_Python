#!/bin/bash
pc=$(whoami)
SFTP_SERVER="3pl-test.pegatroncorp.com"
SFTP_USER="jinny"
SFTP_PWD="Pega#3p1O207"
home=$(whoami)
ubuntuVersion=$(lsb_release -r -s)

cp -r /CTS_tool/for_pythonUI/CTSUI.sh /home/$home 
chmod 755 /home/$home/CTSUI.sh
cp -r /CTS_tool/for_pythonUI/CTSUI.sh /home/$home/Desktop
chmod 755 /home/$home/Desktop/CTSUI.sh


function Ubuntu16()
{
	if [ $ubuntuVersion == '16.04' ];then
	sudo add-apt-repository ppa:ubuntu-mate-dev/precise-mate
	sudo apt-get update
	sudo apt-get install -y mate-terminal 
	fi
}

function Sync_CTSUI()
{
	echo "1"| sudo -S sudo apt-get install -y python-tk
	lftp sftp://$SFTP_USER:$SFTP_PWD@$SFTP_SERVER -e 'mirror -n  /disk3/3pl/CTS_tool/for_pythonUI /CTS_tool/for_pythonUI ; bye'
	echo "1"| sudo apt-get install python3-bs4
	#echo "1" | sudo pip install requests #ubuntu18.04
	sudo chmod 755 /CTS_tool/for_pythonUI/*
	yes | '/home/'$home'/android-sdk-linux/tools/bin/sdkmanager' --update
	echo "=============================================================================="
	echo ""
	echo ""
	python '/CTS_tool/for_pythonUI/CTS1.py'
}

function MediaLocal()
{
	cd /CTS_tool/Media
	search_GtsMediatxt=$(ls | grep -m1 GtsMedia-dynamic-config-1.0.txt )
	GtsMedia=GtsMedia-dynamic-config-1.0.txt

	if [ "$search_GtsMediatxt" == "$GtsMedia" ] ;then
	echo "GtsMedia.txt existing"
	else

	cd /CTS_tool/Media
	echo " " > GtsMedia-dynamic-config-1.0.txt
	echo "Cerate GtsMedia.txt"
	fi

	search_CtsMediatxt=$(ls | grep -m1 CtsMedia.txt )
	CtsMedia=CtsMedia.txt
	if [ "$search_CtsMediatxt" == "$CtsMedia" ] ;then
	echo "CtsMedia.txt existing"
	else

	cd /CTS_tool/Media
	echo "/CTS_tool/Media/android-cts-media-1.5" > CtsMedia.txt
	echo "Cerate CtsMedia.txt"
	fi




	cd ~
	CheckBashrcGts=$(grep -q  "export GtsMedia" .bashrc && echo "0" || echo "1")
	if [ $CheckBashrcGts == "1" ];then
	echo 'GtsMedia=$(head /CTS_tool/Media/GtsMedia-dynamic-config-1.0.txt)' >>~/.bashrc
	echo "export GtsMedia" >> ~/.bashrc
		else
		echo "bashrc existing"

	fi
	
	CheckBashrcCts=$(grep -q  "export CtsMedia" .bashrc && echo "0" || echo "1")
	if [ $CheckBashrcCts == "1" ];then
	echo 'CtsMedia=$(head /CTS_tool/Media/CtsMedia.txt)' >>~/.bashrc
	echo "export CtsMedia" >> ~/.bashrc
		else
		echo "bashrc existing"

	fi


}

#MediaLocal
#echo "############################################"
#if [ $ubuntuVersion == '16.04' ];then
#Ubuntu16
#fi

Sync_CTSUI
