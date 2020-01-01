#!/bin/bash

file=$1
apps=$2
appdata=$3
calls=$4
messages=$5
documents=$6
downloads=$7
music=$8
pictures=$9
videos=${10}
tmp=mydatatransfer

echo "restoring backup..."

if [[ ! -n $(tar -tf $file | grep mdt01) ]]; then
    /usr/share/harbour-mydatatransfer/scripts/restore_legacy.sh
fi

cd /home/nemo

if [ "$apps" = 1 ]; then
	echo "app data restoring..."
        tar -xf $file $tmp/.config && tar --strip-components=1 -xvf $file $tmp/.local
fi

if [ "$documents" = 1 ]; then
	echo "documents restoring..."
        tar -xf $file $tmp/Documents
fi

if [ "$downloads" = 1 ]; then
	echo "downloads restoring..."
        tar -xf $file $tmp/Downloads
fi

if [ "$music" = 1 ]; then
	echo "music restoring.."
        tar -xf $file $tmp/Music
fi

if [ "$pictures" = 1 ]; then
	echo "pictures restoring..."
        tar -xf $file $tmp/Pictures
fi

if [ "$videos" = 1 ]; then
	echo "videos restoring..."
        tar -xf $file $tmp/Videos
fi

if [ "$calls" = 1 ]; then
        echo "call log restoring..."
        tar --strip-components=1 -xf $file $tmp/calls.dat
        commhistory-tool import calls.dat
        pkill voicecall-ui
        rm calls.dat
fi

if [ "$messages" = 1 ]; then
        echo "messages restoring..."
        tar --strip-components=1 -xf $file $tmp/groups.dat
        commhistory-tool import groups.dat
        pkill jolla-messages
        rm groups.dat
fi

echo "RESTORED!"
