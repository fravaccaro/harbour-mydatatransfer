#!/bin/bash

name=$(date +%Y%m%d%H%M)

echo "CREATING MYDATATRANSFER BACKUP..."

cd /home/nemo

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
	-cvf ./$name.mydatatransfer .config

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
	-rvf ./$name.mydatatransfer .local

echo "DONE!"

exit 0
