#!/bin/bash

script=""
file=""
destination=""
apps=0
appdata=0
documents=0
downloads=0
music=0
pictures=0
videos=0
calls=0
messages=0
ipaddress=""
user=nemo
password=""

guide () {
	cat << EOF
My Data Transfer. Backup and transfer app data, documents, music, pictures and videos on your Sailfish OS devices.
Usage: mydatatransfer [job] [options] [parameters]

Examples:
    mydatatransfer -b sdcard --appdata --downloads				# Backup app data and downloaded files on the SD card
    mydatatransfer -r /home/nemo/20193131.mydatatransfer --calls --messages	# Restore call log and messages from a backup file
    mydatatransfer -t --ip 192.168.1.77 --pw 1234 --documents			# Transfer documents onto the target device

    -h, --help			Show this guide

Jobs:
    -b, --backup		Execute the backup job (requires additional parameters)
    -r, --restore		Execute the restore job (requires additional parameters)
    -t, --transfer		Execute the transfer job (requires additional parameters)

Job-specific options:
    --destination 
        [internal | sdcard]	Destination for the backup file
    --file [file]		File (including path) to be restored
    --ip [address]		IP address of the target device
    --pw [password]		Password of the target device

Parameters:
    --appdata			Include app data in the job
    --calls			Include call log in the job
    --messages			Include messages in the job
    --documents			Include documents in the job
    --downloads			Include downloads in the job
    --music			Include music in the job
    --pictures			Include pictures in the job
    --videos			Include videos in the job
EOF
}


while true; do
  case "$1" in
    -b | --backup ) script=backup; shift ;;
    -r | --restore ) script=restore; shift ;;
    -t | --transfer ) script=transfer; shift ;;
    --destination ) destination=$2; shift 2 ;;
    --file ) file=$2; shift 2 ;;
    --apps ) apps=0; shift ;;
    --appdata ) appdata=1; shift ;;
    --calls ) calls=1; shift ;;
    --messages ) messages=1; shift ;;
    --documents ) documents=1; shift ;;
    --downloads ) downloads=1; shift ;;
    --music ) music=1; shift ;;
    --pictures ) pictures=1; shift ;;
    --videos ) videos=1; shift ;;
    --ip ) ipaddress=$2; shift 2 ;;
    --pw ) password=$2; shift 2 ;;
    -h | --help ) guide; shift ;;
    -- ) shift; break ;;
    * ) guide; break ;;
  esac
done

if [[ $script == "backup" ]]; then
	echo $script $destination $appdata $calls $messages $documents $downloads $music $pictures $videos
fi


if [[ $script == "restore" ]]; then
	echo $script $file $appdata $calls $messages $documents $downloads $music $pictures $videos
fi


if [[ $script == "transfer" ]]; then
	echo $script $ipaddress $user $password $appdata $calls $messages $documents $downloads $music $pictures $videos
fi
