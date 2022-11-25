#!/usr/bin/env bash
cd /var/lib/docker/volumes    #changing directory
dest="/home/raju/backups"     #where the backups will be stored
dest1="/home/raju/backups/volumes"
day=$(date +%A)               # printng current day  
hostname=$(hostname -s)       #printing pc name
for f in *; do
    if [ -d "$f" ]; then
        # Will not run if no directories are available
        echo "volume name is:  $f"
        #archive_file="$hostname-$f.tgz"
	cp -r $f /home/raju/backups/volumes
	echo "Backing up $File to $dest/$archive_file"
        #tar czf $dest/$archive_file $f
	echo "Backup finished"
	date
	echo 
	echo 
    fi
done

