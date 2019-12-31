#!/bin/bash

name=$1
apps=$2
documents=$3
downloads=$4
music=$5
pictures=$6
videos=$7
calls=$8
messages=$9
tmp=mydatatransfer

echo "RESTORING MYDATATRANSFER BACKUP..."

cd ~

if [ "$apps" = 1 ]; then
	echo "APPS RESTORING..."
	# restore config and local folders
        tar --strip-components=1 -xf $name $tmp/.config && tar --strip-components=1 -xvf $name $tmp/.local
fi

if [ "$documents" = 1 ]; then
	echo "DOCUMENTS RESTORING..."
	# restore documents
        tar --strip-components=1 -xf $name $tmp/Documents
fi

if [ "$downloads" = 1 ]; then
	echo "DOWLOADS RESTORING..."
	# restore downloads
        tar --strip-components=1 -xf $name $tmp/Downloads
fi

if [ "$music" = 1 ]; then
	echo "MUSIC RESTORING..."
	# restore music
        tar --strip-components=1 -xf $name $tmp/Music
fi

if [ "$pictures" = 1 ]; then
	echo "PICTURES RESTORING..."
	# restore pictures
        tar --strip-components=1 -xf $name $tmp/Pictures
fi

if [ "$videos" = 1 ]; then
	echo "VIDEOS RESTORING..."
	# restore videos
        tar --strip-components=1 -xf $name $tmp/Videos
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

