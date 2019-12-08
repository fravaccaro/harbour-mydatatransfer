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
tmp=mydatatransfer

echo "TRANSFERRING..."

echo "CREATING MYDATATRANSFER BACKUP..."

cd ~
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

sshpass -p $password \
        rsync --progress -avz -e \
        'ssh -o StrictHostKeyChecking=no' ~/$name.mydatatransfer $user@$ipaddress:~/


sshpass -p $password \
        ssh -o StrictHostKeyChecking=no $user@$ipaddress \
        'bash -s' < /usr/share/harbour-mydatatransfer/scripts/restore.sh ~/$name.mydatatransfer $apps $documents $downloads $music $pictures $videos

sshpass -p $password \
        ssh -o StrictHostKeyChecking=no $user@$ipaddress \
        rm $name.mydatatransfer

rm $name.mydatatransfer

echo "TRANSFERRED!"
