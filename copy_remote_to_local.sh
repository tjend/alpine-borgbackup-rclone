#!/bin/sh
# copy remote b2 bucket to local directory

echo "Copying Backblaze B2 Bucket, ${RCLONE_B2_BUCKET}, to local dir ./${RCLONE_B2_BUCKET}."
rclone sync --b2-hard-delete --fast-list --stats-log-level NOTICE \
  remote:${RCLONE_B2_BUCKET} \
  ./${RCLONE_B2_BUCKET}
if [ $? -eq 0 ]; then
  echo "Copy completed"
else
  echo "Problem with copy."
fi
