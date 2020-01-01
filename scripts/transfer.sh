#!/bin/bash

ipaddress=$1
user=nemo
password=$2
apps=$3
calls=$4
messages=$5
documents=$6
downloads=$7
music=$8
pictures=$9
videos=${10}
name=$(date +%Y%m%d%H%M)
tmp=mydatatransfer

echo "transferring..."

echo "creating backup..."

echo "start transfer..."

sshpass -p $password \
        rsync --progress -avz -e \
        'ssh -o StrictHostKeyChecking=no' ~/$name.mydatatransfer $user@$ipaddress:~/


sshpass -p $password \
        ssh -o StrictHostKeyChecking=no $user@$ipaddress \
        'bash -s' < /usr/share/harbour-mydatatransfer/scripts/restore.sh ~/$name.mydatatransfer $appdata $calls $messages $documents $downloads $music $pictures $videos

sshpass -p $password \
        ssh -o StrictHostKeyChecking=no $user@$ipaddress \
        rm $name.mydatatransfer

rm $name.mydatatransfer

echo "TRANSFERRED!"
