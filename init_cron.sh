#!/bin/sh
# create cronjob entry to run local backup and remote sync script

# run the backup script every ${BACKUP_EVERY_X_HOURS} hours at 13 minutes past the hour
echo "13 */${BACKUP_EVERY_X_HOURS} * * * /usr/local/bin/localbackup_remotesync.sh" > /var/spool/cron/crontabs/root
