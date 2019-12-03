#!/bin/bash

name=$1
apps=$2
documents=$3
downloads=$4
music=$5
pictures=$6
videos=$7

echo "RESTORING MYDATATRANSFER BACKUP..."

cd /home/nemo

if [ "$apps" = 1 ]; then
	echo "APPS RESTORING..."
	# restore config and local folders
	tar -xvf $name -C ./ .config && tar -xvf $name -C ./ .local
fi

if [ "$documents" = 1 ]; then
	echo "DOCUMENTS RESTORING..."
	# restore documents
	tar -xvf $name -C ./ Documents
fi

if [ "$downloads" = 1 ]; then
	echo "DOWLOADS RESTORING..."
	# restore downloads
	tar -xvf $name -C ./ Downloads
fi

if [ "$music" = 1 ]; then
	echo "MUSIC RESTORING..."
	# restore music
	tar -xvf $name -C ./ Music
fi

if [ "$pictures" = 1 ]; then
	echo "PICTURES RESTORING..."
	# restore pictures
	tar -xvf $name -C ./ Pictures
fi

if [ "$videos" = 1 ]; then
	echo "VIDEOS RESTORING..."
	# restore videos
	tar -xvf $name -C ./ Videos
fi

echo "DONE!"
