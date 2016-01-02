#!/bin/bash
# Rubin Azad
# Email: rubinsaifi@live.com
# Download samples from avialable repositories

# Try to improve this and add other places from where we can get samples for free
# this is just a start

if [ -e $1]; then
	echo "usage: bash getsample.sh XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
fi
logger='getfiles.log'
vxvault='http://vxvault.siri-urz.net/files/'
malshare_url='http://api.malshare.com/sampleshare.php'
malshare_apikey='Add-your-API-here'

if [ $1 ]
	then
	hash=$1
	if [  ${#hash} -eq 32 ]
		then
		hash=$( echo "$hash" | tr -s  '[:lower:]'  '[:upper:]' )
		hashfile=$hash.zip
		wget -O $hashfile --user-agent="Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)" --http-user=infected --http-passwd=O3aNDL5z $vxvault$hashfile --quiet
		if [ $? -ne 0 ]
			then
			if [ -f $hashfile ]
				then
				rm -f $hashfile
			fi
			echo "[`date +%D`][`date +%T`][$hash][Failed][VXVAULT]" >> $logger
	        	user_agent='wget_malshare daily 1.0'
        		payload="action=getfile&api_key=$malshare_apikey&hash=$hash"
			wget -O $hash.bin --user-agent="$user_agent" --post-data="$payload" $malshare_url --quiet
			cat $hash.bin | grep "ERROR!" > /dev/null
			if [ $? -eq 0 ]
				then
				rm -f $hash.bin
				echo "[`date +%D`][`date +%T`][$hash][Failed][MALSHARE]" >> $logger
			else
				echo "$hash.bin downloaded"
				echo "[`date +%D`][`date +%T`][$hash][Success][MALSHARE]" >> $logger
			fi
		else
			echo "$hashfile downloaded"
			echo "[`date +%D`][`date +%T`][$hash][Success][VXVAULT]" >> $logger
			echo 'Done'
		fi
	else
		echo "[`date +%D`][`date +%T`][$hash][Failed][Not Valid MD5]" >> $logger
	fi
else
	echo 'ERROR: No Input given'
	echo 'Existing.....'
	exit
fi
