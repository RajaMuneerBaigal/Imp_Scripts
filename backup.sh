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
        archive_file="$hostname-$f.tgz"
	echo "Copying to $dest1"
	cp -r  $f  $dest1
	sudo chmod 777 -R $dest1
	echo "Backing up $File to $dest/$archive_file"
        tar czf $dest/$archive_file $f
	echo "Backup finished"
	date
	echo 
	echo 
    fi
done

echo
echo 
ls -lh $dest

echo "Backup created successfully"
echo
echo
echo "Now trying to push every volume to github"
cd 
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
curl -u $username:$pat  https://api.github.com/user/repos -d '{"name":"'$reponame'","private":false}' 
echo " done."

#setting the visibility or previously created repositories to private
curl   -X PATCH   -H "Accept: application/vnd.github+json"  https://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@api.github.com/repos/RajaMuneerBaigal/$file   -d '{"name":"'$file'>

# create empty README.md
echo "Creating README ..."
touch README.md
echo " done."

# push to remote repo
echo "Pushing to remote ..."
git init
git add -A
git commit -m "first commit"
git remote rm origin
git remote add origin https://$username:$pat@github.com/$username/$reponame.git
git push -u origin master
echo " done."
echo
echo
echo  "--------------------------pushed successfully-----------------------------"
echo
echo
done
