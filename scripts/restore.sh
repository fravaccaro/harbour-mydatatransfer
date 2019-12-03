#!/bin/bash

name=$1
apps=$2
documents=$3
downloads=$4
music=$5
pictures=$6
videos=$7

echo "RESTORING MYDATATRANSFER BACKUP..."

cd ~

if [ "$apps" = 1 ]; then
	echo "APPS RESTORING..."
	# restore config and local folders
        tar -xf $name -C ./ .config && tar -xvf $name -C ./ .local
fi

if [ "$documents" = 1 ]; then
	echo "DOCUMENTS RESTORING..."
	# restore documents
        tar -xf $name -C ./ Documents
fi

if [ "$downloads" = 1 ]; then
	echo "DOWLOADS RESTORING..."
	# restore downloads
        tar -xf $name -C ./ Downloads
fi

if [ "$music" = 1 ]; then
	echo "MUSIC RESTORING..."
	# restore music
        tar -xf $name -C ./ Music
fi

if [ "$pictures" = 1 ]; then
	echo "PICTURES RESTORING..."
	# restore pictures
        tar -xf $name -C ./ Pictures
fi

if [ "$videos" = 1 ]; then
	echo "VIDEOS RESTORING..."
	# restore videos
        tar -xf $name -C ./ Videos
fi

echo "RESTORED!"
