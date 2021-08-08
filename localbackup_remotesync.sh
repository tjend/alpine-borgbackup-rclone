#!/bin/sh
# environment variables:
#   - BACKUP_PATHS is a directory that contains the files to be backed up
#   - BORG_REPOSITORY is the borgbackup repository(including path)

# initialise the borgbackup repository
if [ ! -d "${BORG_REPOSITORY}" ]; then
  borg init --encryption=repokey --info --make-parent-dirs "${BORG_REPOSITORY}"
fi

# run borgbackup
ARCHIVE=$(date +%Y%m%d-%H%M) # date+time based archive name, eg 20210807-1132
borg create --info --stats --compression zstd "${BORG_REPOSITORY}::${ARCHIVE}" ${BACKUP_PATHS}

# create prune parameters
PRUNE_PARAMETERS=""
if [ ! -z ${BORG_KEEP_HOURLY} ]; then
  PRUNE_PARAMETERS="${PRUNE_PARAMETERS} --keep-hourly=${BORG_KEEP_HOURLY}"
fi
if [ ! -z ${BORG_KEEP_DAILY} ]; then
  PRUNE_PARAMETERS="${PRUNE_PARAMETERS} --keep-daily=${BORG_KEEP_DAILY}"
fi
if [ ! -z ${BORG_KEEP_WEEKLY} ]; then
  PRUNE_PARAMETERS="${PRUNE_PARAMETERS} --keep-weekly=${BORG_KEEP_WEEKLY}"
fi
if [ ! -z ${BORG_KEEP_MONTHLY} ]; then
  PRUNE_PARAMETERS="${PRUNE_PARAMETERS} --keep-monthly=${BORG_KEEP_MONTHLY}"
fi
if [ ! -z ${BORG_KEEP_YEARLY} ]; then
  PRUNE_PARAMETERS="${PRUNE_PARAMETERS} --keep-yearly=${BORG_KEEP_YEARLY}"
fi

# remove old backups
echo "Pruning borgbackup archive ${BORG_REPOSITORY} with prune parameters, ${PRUNE_PARAMETERS}."
borg prune --info --list --stats "${BORG_REPOSITORY}" ${PRUNE_PARAMETERS}

# sync to backblaze b2 using rclone
echo "Running rclone to sync ${BORG_REPOSITORY} to backblaze b2 bucket ${RCLONE_B2_BUCKET}."
rclone sync --b2-hard-delete --fast-list --stats-log-level NOTICE $(dirname ${BORG_REPOSITORY}) remote:${RCLONE_B2_BUCKET}
