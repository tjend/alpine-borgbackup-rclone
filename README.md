Build a borgbackup/rclone/backblaze b2/cron docker image.

This will create a local borgbackup repository that will be synced to Backblaze B2.

It is recommended to set the Backblaze B2 bucket lifecycle to only keep the last version of files, as this functionality is achieved by keeping multiple borgbackup achives within the borgbackup repository.
