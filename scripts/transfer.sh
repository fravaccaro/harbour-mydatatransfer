#!/bin/bash

ipaddress=$1
user=nemo
password='$2'

sshpass -p $password \
	rsync --progress -avz -e \
	"ssh -o StrictHostKeyChecking=no" ~/backup.mydatatransfer $user@$ipaddress:~/


sshpass -p $password \
	ssh -o StrictHostKeyChecking=no $user@$ipaddress \
	'tar -xvf ./backup.mydatatransfer -C .'

exit 0
