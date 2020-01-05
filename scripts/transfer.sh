#!/bin/bash

ipaddress=$1
user=nemo
password=$2
apps=$3
apporder=$4
appdata=$5
calls=$6
messages=$7
documents=$8
downloads=$9
music=${10}
pictures=${11}
videos=${12}
name=$(date +%Y-%m-%d_%H-%M)
tmp=mdt-blobs

echo "transferring..."

echo "creating backup..."

name=$(date +%Y%m%d%H%M)
destination=$1
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
if [ "$destination" = 1 ]; then
    folder=/media/sdcard/$(ls /media/sdcard)
else
    folder=/home/nemo
fi

echo "creating backup..."

cd /home/nemo
mkdir -p $tmp
touch $tmp/list.txt

if [ "$app" = 1 ]; then
        echo "apps backup..."
        /usr/share/harbour
fi

if [ "$apporder" = 1 ]; then
        echo "app order backup..."
        cp -p .config/lipstick/applications.menu $tmp/
        echo $tmp/"applications.menu" >> $tmp/list.txt
fi

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
        echo "downloads backup..."
        echo "Downloads" >> $tmp/list.txt
fi

if [ "$music" = 1 ]; then
        echo "music backup..."
        echo "Music" >> $tmp/list.txt
fi

if [ "$pictures" = 1 ]; then
        echo "pictures backup..."
        echo "Pictures" >> $tmp/list.txt
fi

if [ "$videos" = 1 ]; then
        echo "videos backup..."
        echo "Videos" >> $tmp/list.txt
fi

if [ "$calls" = 1 ]; then
        echo "call log backup..."
        commhistory-tool export -calls $tmp/calls.dat
        echo $tmp/calls.dat >> $tmp/list.txt
fi

if [ "$messages" = 1 ]; then
        echo "messages backup..."
        commhistory-tool export -groups $tmp/groups.dat
        echo $tmp/groups.dat >> $tmp/list.txt
fi

# versioning
touch $tmp/mdt01
echo $tmp/mdt01 >> $tmp/list.txt

tar -cf $folder/$name.mydatatransfer -T $tmp/list.txt
chown nemo:nemo $folder/$name.mydatatransfer
rm -rf $tmp

echo "backuped!"

echo "start transfer..."

sshpass -p $password \
        rsync --progress -avz -e \
        'ssh -o StrictHostKeyChecking=no' ~/$name.mydatatransfer $user@$ipaddress:~/


sshpass -p $password \
        ssh -o StrictHostKeyChecking=no $user@$ipaddress \
        'bash -s' < /usr/share/harbour-mydatatransfer/scripts/restore.sh ~/$name.mydatatransfer $apps $apporder $appdata $calls $messages $documents $downloads $music $pictures $videos

sshpass -p $password \
        ssh -o StrictHostKeyChecking=no $user@$ipaddress \
        rm $name.mydatatransfer

rm $name.mydatatransfer

echo "transferred!"
