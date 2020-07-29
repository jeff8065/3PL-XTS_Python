#!/bin/bash 

 
addrip=$(ifconfig  | grep   "inet addr:" | sed 's/\ Bcast:.*//' | sed 's/\inet addr://' | sed 's/\ //g' | sed -n '1p')
echo "Local IP:"$addrip
PC_name=$(whoami)
echo "PC_name:"$PC_name
function apache2()
{
	sudo apt-get install -y apache2 

	cd /var/www/html 
	sudo ln -s /CTS_tool CTS_tool

	sudo bash -c  'echo "<Directory /CTS_tool>
	Options Indexes FollowSymLinks
	AllowOverride None
	Require all granted
	Order allow,deny
	allow from all
</Directory>
	" >> /etc/apache2/apache2.conf '
	sudo  service apache2 restart
}

function CtsMediaTestCasesDownload()
{
	sudo wget  -c --no-parent -nH --reject "index.html*" https://dl.google.com/dl/android/cts/android-cts-media-1.5.zip -P /CTS_tool/Media
	sudo chown -R $PC_name /CTS_tool/Media/android-cts-media-1.5.zip
	sudo unzip -n /CTS_tool/Media/android-cts-media-1.5.zip -d /CTS_tool/Media
	sudo chown -R $PC_name /CTS_tool/Media/android-cts-media-1.5
}

function GtsExoPlayerTestCases()
{
	sudo wget  -c --no-parent -nH --reject "index.html*" https://storage.googleapis.com/exoplayer-test-media-1/gen-4/exoplayer-gts-media.zip -P /CTS_tool/Media
	sudo chown -R $PC_name /CTS_tool/Media/exoplayer-gts-media.zip
	sudo unzip -n /CTS_tool/Media/exoplayer-gts-media.zip -d /CTS_tool/Media
	sudo chown -R $PC_name /CTS_tool/Media/gts
}

function GtsMediaTestCasesDownload()
{
	sudo wget -c --no-parent -nH --reject "index.html*" https://storage.googleapis.com/gts_media/wvmedia-gts-media.zip -P /CTS_tool/Media
	sudo chown -R $PC_name /CTS_tool/Media/wvmedia-gts-media.zip
	sudo unzip -n /CTS_tool/Media/wvmedia-gts-media.zip -d /CTS_tool/Media
	sudo chown -R $PC_name /CTS_tool/Media/wvmedia
}

function GtsYouTubeTestCasesDownload()
{
	sudo wget  -c --no-parent -nH --reject "index.html*" https://storage.googleapis.com/youtube-test-media/gts/GtsYouTubeTestCases-media-1.0.zip -P /CTS_tool/Media
	sudo chown -R $PC_name /CTS_tool/Media/GtsYouTubeTestCases-media-1.0.zip
	sudo unzip -n /CTS_tool/Media/GtsYouTubeTestCases-media-1.0.zip -d /CTS_tool/Media
	sudo chown -R $PC_name /CTS_tool/Media/test
}

function dynamicconfig()
{


echo '{
  "dynamicConfigEntries": {
    "media_files_url": {
      "configValues": [
        "http://'$addrip'/CTS_tool/Media/GtsYouTubeTestCases-media-1.0.zip"
      ]
    }
  }
} '> /CTS_tool/Media/YouTube-dynamic-config-1.0.json


echo '{
  "dynamicConfigEntries": {
    "base_url": {
      "configValues": [
        "http://'$addrip'/CTS_tool/Media/gts/exoplayer/"
      ]
    }
  }
} ' > /CTS_tool/Media/dynamic-config-1.0.json

echo '=http://'$addrip'/CTS_tool/Media/wvmedia' > /CTS_tool/Media/GtsMedia-dynamic-config-1.0.txt

}

function comments()
{
echo "#################################    GTS   ##########################"
echo -m "GtsExoPlayerTestCases  --module-arg GtsExoPlayerTestCases:config-url:http://192.168.0.125(Apache2 IP)/CTS_tool/Media/dynamic-config-1.0.json"
echo -m "GtsYouTubeTestCases --module-arg GtsYouTubeTestCases:config-url:http://192.168.0.125(Apache2 IP)/CTS_tool/Media/YouTube-dynamic-config-1.0.json"
echo -m "GtsMediaTestCases --module-arg GtsMediaTestCases:instrumentation-arg:media-path:=http://192.168.0.125(Apache2 IP)/CTS_tool/Media/wvmedia"
echo "#################################    CTS   ##########################"
echo -m "CtsMediaTestCases --module-arg CtsMediaTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5"
echo -m "CtsMediaStressTestCases --module-arg CtsMediaStressTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5"
echo -m "CtsMediaBitstreamsTestCases --module-arg CtsMediaBitstreamsTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5"


}
function list()
{
	echo
	echo "-------------------------------------------------"
	
	echo "1.install apache2"
	echo "2.Download all Media""(27.35 GB)"
	echo "3.Build dynamic-config.json"
	echo "4.Show run comment"
	echo "------------------------"
	read -p "please key in number:" optional	
	if [ "$optional" == "1" ];then
		apache2
		
	elif [ "$optional" == "2" ];then
		CtsMediaTestCasesDownload
		GtsExoPlayerTestCases
		GtsYouTubeTestCasesDownload
		GtsMediaTestCasesDownload
	elif [ "$optional" == "3" ];then
		dynamicconfig
	elif [ "$optional" == "4" ];then
		comments
	else 
		echo "incorrect number"
		echo "please try again!"
		list
	fi
}

list


