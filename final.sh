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

# get repo name
#dir_name=$file
#read -p "Do you want to use '$dir_name' as a repo name?(y/n)" answer_dirname
#case $answer_dirname in
 # y)
    # use currently dir name as a repo name
   # reponame=$dir_name
  #  ;;
 # n)
   # read -p "Enter your new repository name: " reponame
   # if [ "$reponame" = "" ]; then
    #    reponame=$dir_name
   # fi
  #  ;;
 # *)
 #   ;;
#esac

reponame=$file
# create repo
echo "Creating Github repository '$reponame' ..."
curl  https://"RajaMuneerBaigal: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"@api.github.com/user/repos -d '{"name":"'$reponame'"}'
echo " done."

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
#git remote set-url origin git+ssh://git@github.com/$username/$reponame.git

git remote add origin https://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@github.com/$username/$reponame.git
git push -u origin master
echo " done."


# open in a browser
#read -p "Do you want to open the new repo page in browser?(y/n): " answer_browser

#case $answer_browser in
 # y)
  #  echo "Opening in a browser ..."
   # open https://github.com/$username/$reponame
   # ;;
 # n)
  #  ;;
  #*)
   # ;;
#esac
done
