#!/bin/bash

name=$1
apps=$2
appdata=$3
documents=$4
downloads=$5
music=$6
pictures=$7
videos=$8
calls=$9
messages=${10}
tmp=mydatatransfer

echo "RESTORING MYDATATRANSFER BACKUP..."

if [[ ! -n $(tar -tf $name | grep mdt01) ]]; then
    /usr/share/harbour-mydatatransfer/scripts/restore_legacy.sh
fi

cd ~

if [ "$apps" = 1 ]; then
	echo "APP DATA RESTORING..."
	# restore config and local folders
        tar -xf $name $tmp/.config && tar --strip-components=1 -xvf $name $tmp/.local
fi

if [ "$documents" = 1 ]; then
	echo "DOCUMENTS RESTORING..."
	# restore documents
        tar -xf $name $tmp/Documents
fi

if [ "$downloads" = 1 ]; then
	echo "DOWLOADS RESTORING..."
	# restore downloads
        tar -xf $name $tmp/Downloads
fi

if [ "$music" = 1 ]; then
	echo "MUSIC RESTORING..."
	# restore music
        tar -xf $name $tmp/Music
fi

if [ "$pictures" = 1 ]; then
	echo "PICTURES RESTORING..."
	# restore pictures
        tar -xf $name $tmp/Pictures
fi

if [ "$videos" = 1 ]; then
	echo "VIDEOS RESTORING..."
	# restore videos
        tar -xf $name $tmp/Videos
fi

if [ "$calls" = 1 ]; then
        echo "CALL HISTORY RESTORING..."
        tar --strip-components=1 -xf $name $tmp/calls.dat
        commhistory-tool import calls.dat
        pkill voicecall-ui
        rm calls.dat
fi

if [ "$messages" = 1 ]; then
        echo "MESSAGES RESTORING..."
        tar --strip-components=1 -xf $name $tmp/groups.dat
        commhistory-tool import groups.dat
        pkill jolla-messages
        rm groups.dat
fi

echo "RESTORED!"
