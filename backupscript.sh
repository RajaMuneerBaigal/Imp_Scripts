#!/bin/bash

#chmod -R 755 /var/lib/docker/volumes
# What to backup. 
cd /var/lib/docker/
backup_files="volumes"

# Where to backup to.
dest="/home/raju/backups"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"
# Print start status message.
echo "Backing up $File to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file $File

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest

