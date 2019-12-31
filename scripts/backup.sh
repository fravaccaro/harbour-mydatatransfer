#!/bin/bash

name=$(date +%Y%m%d%H%M)
destination=$1
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
if [ "$destination" = 1 ]; then
    folder=/media/sdcard/$(ls /media/sdcard)
else
    folder=~
fi

echo "CREATING MYDATATRANSFER BACKUP..."

cd ~
mkdir -p $tmp
touch $tmp/list.txt

if [ "$appdata" = 1 ]; then
	echo "app data backup..."
	ls -rtd .config/* >> $tmp/list.txt
	ls -rtd .local/share/* >> $tmp/list.txt
	sed -i "/^\.config\/Jolla$/d;\
	/^\.config\/QtProject$/d;\
	/^\.config\/dconf$/d;\
	/^\.config\/libaccounts-glib$/d;\
	/^\.config\/lipstick$/d;\
	/^\.config\/nemo$/d;\
	/^\.config\/nemomobile$/d;\
	/^\.config\/pulse$/d;\
	/^\.config\/signond$/d;\
	/^\.config\/systemd$/d;\
	/^\.config\/tracker$/d;\
	/^\.config\/user-dirs\.dirs$/d;\
	/^\.config\/user-dirs\.locale$/d;\
	/^\.config\/\.sailfish-gallery-reindex$/d;
	/^\.local\/nemo-transferengine$/d;\
	/^\.local\/share\/ambienced$/d;\
	/^\.local\/share\/applications$/d;\
	/^\.local\/share\/commhistory$/d;\
	/^\.local\/share\/dbus-1$/d;\
	/^\.local\/share\/gsettings-data-convert$/d;\
    /^\.local\/share\/maliit-server$/d;\
	/^\.local\/share\/system$/d;\
	/^\.local\/share\/systemd$/d;\
	/^\.local\/share\/telepathy$/d;\
	/^\.local\/share\/tracker$/d;\
	/^\.local\/share\/xt9$/d" \
	$tmp/list.txt	
fi


if [ "$documents" = 1 ]; then
	echo "documents backup..."
        echo "Documents" >> $tmp/list.txt
fi

if [ "$downloads" = 1 ]; then
	echo "DOWLOADS BACKUP..."
	# copy downloads folder into working dir
        echo "Downloads" >> $tmp/list.txt
fi

if [ "$music" = 1 ]; then
	echo "MUSIC BACKUP..."
	# copy music folder into working dir
        echo "Music" >> $tmp/list.txt
fi

if [ "$pictures" = 1 ]; then
	echo "PICTURES BACKUP..."
	# copy music folder into working dir
        echo "Pictures" >> $tmp/list.txt
fi

if [ "$videos" = 1 ]; then
	echo "VIDEOS BACKUP..."
	# copy videos folder into working dir
        echo "Videos" >> $tmp/list.txt
fi

if [ "$calls" = 1 ]; then
        echo "CALL LOG BACKUP..."
        # dump call log into working dir
        commhistory-tool export -calls $tmp/calls.dat
        echo $tmp/calls.dat >> $tmp/list.txt
fi

if [ "$messages" = 1 ]; then
        echo "MESSAGES BACKUP..."
        # dump messages into working dir
        commhistory-tool export -groups $tmp/groups.dat
        echo $tmp/groups.dat >> $tmp/list.txt
fi

# versioning
touch $tmp/mdt01
echo $tmp/mdt01 >> $tmp/list.txt

tar -cf $folder/$name.mydatatransfer -T $tmp/list.txt

rm -rf $tmp

echo "BACKUPED!"
