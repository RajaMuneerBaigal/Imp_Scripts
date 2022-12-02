#!/usr/bin/env bash

################################################################################
#                                                                              #
#     This Bash Script Allows User To Perform Following Tasks                  #
#       1. Stop all Container                                                  #
#       2. Iterating through '/var/lib/docker/volumes'                         #
#          2.1. Copying '/var/lib/docker/volumes/*' to                         #
#              /home/reginald/backups/volumes                                  #
#          2.2. Backing up '/var/lib/docker/volumes/wikijs' to                 #
#              '/home/reginald/backups/2022-11-26_22:29:18_wikijs.tgz'         #
#       3. Starting all Container                                              #
#       4. Pushing to Github                                                   #
#          4.1. Creating Github repository                                     #
#          4.2. Pushing branch to remote origin/branch                         #
#                                                                              #
#             Release Version: V1.0                Date: 26-11-2022            #
#                                                                              #
################################################################################


#######################################-########################################
################################   VARIABLES   #################################
#######################################-########################################

log_dest="/var/log/horus-lp/volume-backup.log"
github_username="backupMyVolumes"
github_api_token="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"
docker_volume_path="/var/lib/docker/volumes"
docker_volume_path_array=$(ls -h /var/lib/docker/volumes)
volume_backup_dest="/home/reginald/backups/volumes"
tar_backup_dest="/home/reginald/backups"
date_time=$(date '+%Y-%m-%d_%H:%M:%S')


#######################################-########################################
##################################   SCRIPT   ##################################
#######################################-########################################

echo "STARTING volume-backup.sh SCRIPT" >> $log_dest

if [[ ! -d "$tar_backup_dest" ]]
then
   mkdir $tar_backup_dest
   sudo chmod 777 -R $tar_backup_dest
fi

if [[ ! -d "$volume_backup_dest" ]]
then
   mkdir $volume_backup_dest
   sudo chmod 777 -R $volume_backup_dest
fi

### STEP 1 ###
echo "volume-backup.sh | STEP 01/04 | START | INFO | Stop all Container" >> $log_dest
docker container stop $(docker ps -q) >> $log_dest
echo "volume-backup.sh | STEP 01/04 | FINISH | INFO | Stop all Container" >> $log_dest

### STEP 2 ###
echo "volume-backup.sh | STEP 02/04 | START | INFO | Iterating through $docker_volume_path" >> $log_dest

for volume in ${docker_volume_path_array[@]}; 
do
   if [ -d "$docker_volume_path/$volume" ]; 
   then
      ### STEP 2.1 ###
      echo "volume-backup.sh | STEP 02.1/04 | START | INFO | Copying $docker_volume_path/$volume to $volume_backup_dest" >> $log_dest
      cp -r $docker_volume_path/$volume $volume_backup_dest
      echo "volume-backup.sh | STEP 02.1/04 | FINISH | INFO | Copying $docker_volume_path/$volume to $volume_backup_dest" >> $log_dest

      sudo chmod 777 -R $volume_backup_dest

      ### STEP 2.2 ###
      tar_file_name="$date_time-$volume.tgz"
      echo "volume-backup.sh | STEP 02.2/04 | START | INFO | Tar $docker_volume_path/$volume to $tar_backup_dest/$tar_file_name" >> $log_dest
      tar czf $tar_backup_dest/$tar_file_name $docker_volume_path/$volume
      echo "volume-backup.sh | STEP 02.2/04 | FINISH| INFO | Tar $docker_volume_path/$volume to $tar_backup_dest/$tar_file_name" >> $log_dest
   fi
done

### STEP 2 ###
echo "volume-backup.sh | STEP 02/04 | FINISH | INFO | Iterating through $docker_volume_path" >> $log_dest

### STEP 3 ###
echo "volume-backup.sh | STEP 03/04 | START | INFO | Starting all Container" >> $log_dest
docker container start $(docker ps -a -q) >> $log_dest
echo "volume-backup.sh | STEP 03/04 | FINISH | INFO | Starting all Container" >> $log_dest

volume_backup_dest_array=$(ls -h /home/reginald/backups/volumes)
echo "volume_backup_dest_array: $volume_backup_dest_array" >> $log_dest

### STEP 4 ###
echo "volume-backup.sh | STEP 04/04 | START | INFO | Pushing $volume_backup_dest_array to Github" >> $log_dest

for volume in ${volume_backup_dest_array[@]}; 
do
   if [ -d "$volume_backup_dest/$volume" ]; 
   then
      cd $volume_backup_dest/$volume

      ### STEP 4.1 ###
      echo "volume-backup.sh | STEP 04.1/04 | START | INFO | Creating Github repository $volume" >> $log_dest
      curl https://"$github_username:$github_api_token"@api.github.com/user/repos -d '{"name":"'$volume'","private":true}' >> $log_dest
      echo "volume-backup.sh | STEP 04.1/04 | FINSIH | INFO | Creating Github repository $volume" >> $log_dest
      echo "Updating the previously created repositories visibility to private"
      curl   -X PATCH   -H "Accept: application/vnd.github+json"  https://$github_api_token@api.github.com/repos/$github_username/$file   -d '{"name":"'$file'>	
      ### STEP 4.2 ###
      echo "volume-backup.sh | STEP 04.2/04 | START | INFO | Pushing $volume to remote origin/$volume" >> $log_dest

      echo "git init" >> $log_dest
      git init >> $log_dest

      echo "git add -A" >> $log_dest
      git add -A >> $log_dest
      
      echo "git commit -m" >> $log_dest
      git commit -m "$date_time" >> $log_dest
      
      echo "git remote rm origin" >> $log_dest
      git remote rm origin >> $log_dest
      
      echo "git remote add origin" >> $log_dest
      git remote add origin https://$github_api_token@github.com/$github_username/$volume.git >> $log_dest
      
      echo "git push -u origin master" >> $log_dest
      git push -u origin master >> $log_dest
      
      echo "volume-backup.sh | STEP 04.2/04 | FINISH | INFO | Pushing $volume to remote origin/$volume" >> $log_dest
   fi
done

### STEP 4 ###
echo "volume-backup.sh | STEP 04/04 | FINISH | INFO | Pushing to Github" >> $log_dest

echo "FINISH gd-dyndns.sh SCRIPT" >> $log_dest
