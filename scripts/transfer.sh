#!/bin/bash

ipaddress=$1
user=nemo
password=$2
apps=$3
documents=$4
downloads=$5
music=$6
pictures=$7
videos=$8
name=$(date +%Y%m%d%H%M)

echo "TRANSFERRING..."

cd ~

if [ "$apps" = 1 ]; then
        echo "APPS BACKUP..."
        # create archive with config folders, excluding system ones
        tar --exclude='.config/Jolla' \
        --exclude='.config/QtProject' \
        --exclude='.config/dconf' \
        --exclude='.config/libaccounts-glib' \
        --exclude='.config/lipstick' \
        --exclude='.config/nemo' \
        --exclude='.config/nemomobile' \
        --exclude='.config/pulse' \
        --exclude='.config/signond' \
        --exclude='.config/systemd' \
        --exclude='.config/tracker' \
        --exclude='.config/user-dirs.dirs' \
        --exclude='.config/user-dirs.locale' \
        --exclude='.config/.sailfish-gallery-reindex' \
        -rf $name.mydatatransfer .config

        # create archive with local folders, excluding system ones
        tar --exclude='.local/nemo-transferengine' \
        --exclude='.local/share/ambienced' \
        --exclude='.local/share/applications' \
        --exclude='.local/share/commhistory' \
        --exclude='.local/share/dbus-1' \
        --exclude='.local/share/gsettings-data-convert' \
        --exclude='.local/share/maliit-server' \
        --exclude='.local/share/org.sailfishos' \
        --exclude='.local/share/system' \
        --exclude='.local/share/systemd' \
        --exclude='.local/share/telepathy' \
        --exclude='.local/share/tracker' \
        --exclude='.local/share/xt9' \
        -rf $name.mydatatransfer .local
fi

if [ "$documents" = 1 ]; then
        echo "DOCUMENTS BACKUP..."
        # create archive with documents
        tar -rf $name.mydatatransfer Documents
fi

if [ "$downloads" = 1 ]; then
        echo "DOWLOADS BACKUP..."
        # create archive with downloads
        tar -rf $name.mydatatransfer Downloads
fi

if [ "$music" = 1 ]; then
        echo "MUSIC BACKUP..."
        # create archive with music
        tar -rf $name.mydatatransfer Music
fi

if [ "$pictures" = 1 ]; then
        echo "PICTURES BACKUP..."
        # create archive with pictures
        tar -rf $name.mydatatransfer Pictures
fi

if [ "$videos" = 1 ]; then
        echo "VIDEOS BACKUP..."
        # create archive with videos
        tar -rf $name.mydatatransfer Videos
fi

echo "BACKUPED!"

sshpass -p $password \
        rsync --progress -avz -e \
        'ssh -o StrictHostKeyChecking=no' ~/$name.mydatatransfer $user@$ipaddress:~/


sshpass -p $password \
        ssh -o StrictHostKeyChecking=no $user@$ipaddress \
        'bash -s' < /usr/share/harbour-mydatatransfer/scripts/restore.sh ~/$name.mydatatransfer $apps $documents $downloads $music $pictures $videos

echo "TRANSFERRED!"
