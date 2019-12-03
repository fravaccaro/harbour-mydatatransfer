#!/bin/bash

ipaddress=$1
user=nemo
password=\'$2\'
apps=$3
documents=$4
downloads=$5
music=$6
pictures=$7
videos=$8

sshpass -p $password \
	rsync --progress -avz -e \
	"ssh -o StrictHostKeyChecking=no" ~/backup.mydatatransfer $user@$ipaddress:~/


sshpass -p $password \
	ssh -o StrictHostKeyChecking=no $user@$ipaddress \
	'bash -s' < restore.sh ~/backup.mydatatransfer $apps $documents $downloads $music $pictures $videos

exit 0
