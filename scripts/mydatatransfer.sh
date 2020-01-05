#!/bin/bash

script=""
file=""
destination=0
apps=0
apporder=0
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

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
   echo "My Data Transfer must be run as root. Please gain root privileges and try again." 1>&2
   exit 1
fi

guide () {
	cat << EOF

My Data Transfer. Backup and transfer app data, documents, music, pictures and videos on your Sailfish OS devices.
Usage: mydatatransfer [job] [options] [parameters]

Examples:
    mydatatransfer -b --sdcard --appdata --downloads                                # Backup app data and downloaded files on the SD card
    mydatatransfer -r --file /home/nemo/20193131.mydatatransfer --calls --messages    # Restore call log and messages from a backup file
    mydatatransfer -t --ip 192.168.1.77 --pw 1234 --documents                       # Transfer documents onto the target device

    -h, --help			Show this guide
    -i, --info                  Show info

Jobs:
    -b, --backup		Execute the backup job (requires additional parameters)
    -r, --restore		Execute the restore job (requires additional parameters)
    -t, --transfer		Execute the transfer job (requires additional parameters)

Job-specific options:
--internal                      Save the backup file on the internal storage
--sdcard                      Save the backup file on the SD card
    --file [file]		File (including path) to be restored
    --ip [address]		IP address of the target device
    --pw [password]		Password of the target device

Parameters:
    --apporder			Include app order in the job
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

info () {
    cat << EOF

  My Data Transfer
  ================

            ~::::::::
         ?  ~~:::::~:   ~
      ?? +  ~~:::::~:    7
    =?  ?   ~~~::::~:      77
   ??I  ?   ~~~~:::~:       ,7
  ~?   ??   ~~~:~::~:        ?~
  ?        7?????????I        7
  ?        I777I7IIII?        7
  ?        I7???????I?        7
  ?        I7???????I?        7
  ~I       I7???????I+  77   I~
   ?,      I7???????I+  7  777
    ??     II???????I+  7  77
      ??   II??????+I+ +:77
           IIIIIIIIII+ 7=
           7????++++++

Backup and transfer app data, documents, music, pictures and videos on your Sailfish OS devices.

Use --help to get additional informations about the the usage via command line.

EOF
}

while true; do
  case "$1" in
    -b | --backup ) script=backup; shift ;;
    -r | --restore ) script=restore; shift ;;
    -t | --transfer ) script=transfer; shift ;;
    --internal ) destination=0; shift ;;
    --sdcard ) destination=1; shift ;;
    --file ) file="$2"; shift 2 ;;
    --apps ) apps=1; shift ;;
    --apporder ) apporder=1; shift ;;
    --appdata ) appdata=1; shift ;;
    --calls ) calls=1; shift ;;
    --messages ) messages=1; shift ;;
    --documents ) documents=1; shift ;;
    --downloads ) downloads=1; shift ;;
    --music ) music=1; shift ;;
    --pictures ) pictures=1; shift ;;
    --videos ) videos=1; shift ;;
    --ip ) ipaddress="$2"; shift 2 ;;
    --pw ) password="$2"; shift 2 ;;
    -h | --help ) guide; shift ;;
    -i | --info ) info; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [[ $script == "backup" ]]; then
    /usr/share/harbour-mydatatransfer/scripts/backup.sh $destination $apps $apporder $appdata $calls $messages $documents $downloads $music $pictures $videos
fi


if [[ $script == "restore" ]]; then
    /usr/share/harbour-mydatatransfer/scripts/restore.sh $file $apps $apporder $appdata $calls $messages $documents $downloads $music $pictures $videos
fi


if [[ $script == "transfer" ]]; then
    /usr/share/harbour-mydatatransfer/scripts/transfer.sh $ipaddress $user $password $apps $apporder $appdata $calls $messages $documents $downloads $music $pictures $videos
fi
