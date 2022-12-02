#!/usr/bin/env bash
cd /home/raju/backups/volumes



pat=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
for file in *; do
        if [ -d "$file" ]; then
        echo $file
        fi

cd /home/raju/backups/volumes/$file
username="RajaMuneerBaigal"
if [ "$username" = "" ]; then
    echo "Could not find username, run 'git config --global github.user <username>'"
    invalid_credentials=1
fi

reponame=$file
# create repo
echo "Creating Github repository '$reponame' ..."
curl   -X PATCH   -H "Accept: application/vnd.github+json"  https://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@api.github.com/repos/RajaMuneerBaigal/$file   -d '{"name":"'$file'","private":true}'
echo " done."
done
