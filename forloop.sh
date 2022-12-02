#!/usr/bin/env bash
dest1="/home/raju/backups/volumes"
cd $dest1
for f in *; do
    if [ -d "$f" ]; then
        # Will not run if no directories are available
        echo "$f"
    fi
done
