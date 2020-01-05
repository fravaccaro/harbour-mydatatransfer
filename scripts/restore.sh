#!/bin/bash

file=$1
apps=$2
apporder=$3
appdata=$4
calls=$5
messages=$6
documents=$7
downloads=$8
music=$9
pictures=${10}
videos=${11}
tmp=mdt-blobs

echo "restoring backup..."

if [[ ! -n $(tar -tf $file | grep mdt01) ]]; then
    echo "legacy file"
    /usr/share/harbour-mydatatransfer/scripts/restore_legacy.sh $file $appdata $calls $messages $documents $downloads $music $pictures $videos
fi

cd /home/nemo

if [ "$apps" = 1 ]; then
        echo "apps restoring..."
fi

if [ "$apporder" = 1 ]; then
        echo "app order restoring..."
        tar -xf $file $tmp/applications.menu
        cp -p $tmp/applications.menu .config/lipstick/
fi

if [ "$appdata" = 1 ]; then
        echo "app data restoring..."
        tar -xf $file .config && tar -xvf $file .local
fi

if [ "$documents" = 1 ]; then
	echo "documents restoring..."
        tar -xf $file Documents
fi

if [ "$downloads" = 1 ]; then
	echo "downloads restoring..."
        tar -xf $file Downloads
fi

if [ "$music" = 1 ]; then
	echo "music restoring.."
        tar -xf $file Music
fi

if [ "$pictures" = 1 ]; then
	echo "pictures restoring..."
        tar -xf $file Pictures
fi

if [ "$videos" = 1 ]; then
	echo "videos restoring..."
        tar -xf $file Videos
fi

if [ "$calls" = 1 ]; then
        echo "call log restoring..."
        tar $file $tmp/calls.dat
        commhistory-tool import $tmp/calls.dat
        pkill voicecall-ui
fi

if [ "$messages" = 1 ]; then
        echo "messages restoring..."
        tar -xf $file $tmp/groups.dat
        commhistory-tool import $tmp/groups.dat
        pkill jolla-messages
fi

# rm -rf $tmp

echo "restored!"
