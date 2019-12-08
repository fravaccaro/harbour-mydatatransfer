#!/bin/bash

name=$(date +%Y%m%d%H%M)
apps=$1
documents=$2
downloads=$3
music=$4
pictures=$5
videos=$6
destination=$7
tmp=mydatatransfer

echo "CREATING MYDATATRANSFER BACKUP..."

if [ "$destination" = 1 ]; then
    cd /media/sdcard/*/
else
    cd ~
fi

mkdir -p $tmp

if [ "$apps" = 1 ]; then
	echo "APPS BACKUP..."
	# copy .config and .local folders into working dir
        rsync -av --progress .config $tmp \
	--exclude .config/Jolla \
	--exclude .config/QtProject \
	--exclude .config/dconf \
	--exclude .config/libaccounts-glib \
	--exclude .config/lipstick \
	--exclude .config/nemo \
	--exclude .config/nemomobile \
	--exclude .config/pulse \
	--exclude .config/signond \
	--exclude .config/systemd \
	--exclude .config/tracker \
	--exclude .config/user-dirs.dirs \
	--exclude .config/user-dirs.locale \
	--exclude .config/.sailfish-gallery-reindex

        rsync -av --progress .local $tmp \
	--exclude .local/nemo-transferengine \
	--exclude .local/share/ambienced \
	--exclude .local/share/applications \
	--exclude .local/share/commhistory \
	--exclude .local/share/dbus-1 \
	--exclude .local/share/gsettings-data-convert \
	--exclude .local/share/maliit-server \
	--exclude .local/share/org.sailfishos \
	--exclude .local/share/system \
	--exclude .local/share/systemd \
	--exclude .local/share/telepathy \
	--exclude .local/share/tracker \
	--exclude .local/share/xt9
fi


if [ "$documents" = 1 ]; then
	echo "DOCUMENTS BACKUP..."
	# copy documents folder into working dir
        rsync -av --progress Documents $tmp
fi

if [ "$downloads" = 1 ]; then
	echo "DOWLOADS BACKUP..."
	# copy downloads folder into working dir
        rsync -av --progress Downloads $tmp
fi

if [ "$music" = 1 ]; then
	echo "MUSIC BACKUP..."
	# copy music folder into working dir
        rsync -av --progress Music $tmp
fi

if [ "$pictures" = 1 ]; then
	echo "PICTURES BACKUP..."
	# copy music folder into working dir
        rsync -av --progress Pictures $tmp
fi

if [ "$videos" = 1 ]; then
	echo "VIDEOS BACKUP..."
	# copy videos folder into working dir
        rsync -av --progress Videos $tmp
fi

tar -cf $name.mydatatransfer $tmp

rm -rf $tmp

echo "BACKUPED!"
