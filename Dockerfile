FROM alpine:latest

# TARGETARCH will be amd64 or arm64
ARG TARGETARCH

RUN \
  # install packages
  apk --no-cache add \
    borgbackup \
    rclone && \
  # create rclone config
  mkdir -p /root/.config/rclone && \
  echo "[remote]" > /root/.config/rclone/rclone.conf && \
  echo "type = b2" >> /root/.config/rclone/rclone.conf && \
  echo "hard_delete = true" >> /root/.config/rclone/rclone.conf

ADD init_cron.sh /usr/local/bin/
ADD localbackup_remotesync.sh /usr/local/bin/

# hours between backups(maximum 24 hours) - every 24 hours by default
ENV BACKUP_EVERY_X_HOURS="24"
ENV BACKUP_PATHS="/source"

# borgbackup env vars
# keep 7 daily backups by default
# keep 4 weekly backups by default
# keep 12 monthly backups by default
ENV BORG_KEEP_HOURLY=""
ENV BORG_KEEP_DAILY="7"
ENV BORG_KEEP_WEEKLY="4"
ENV BORG_KEEP_MONTHLY="12"
ENV BORG_KEEP_YEARLY=""
ENV BORG_PASSPHRASE=""
ENV BORG_REPOSITORY="/backups/backup.borgbackup"

# rclone env vars for Backblaze B2
ENV B2_ACCOUNT_ID=""
ENV B2_ACCOUNT_KEY=""
ENV B2_BUCKET=""

# create the cron job and start the cron daemon
ENTRYPOINT /usr/local/bin/init_cron.sh && /usr/sbin/crond -f
