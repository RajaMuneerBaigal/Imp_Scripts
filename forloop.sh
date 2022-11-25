#!/usr/bin/env bash

for f in *; do
    if [ -d "$f" ]; then
        # Will not run if no directories are available
        echo "$f"
    fi
done
