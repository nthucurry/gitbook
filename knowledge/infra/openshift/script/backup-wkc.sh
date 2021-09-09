#!/bin/bash

service_type="dev"
backup_time=`date +%Y-%m%d`
delete_time=`date +%Y-%m%d --date="-7 day"`

# backup wkc volume
/home/azadmin/ibm/cpd-cli backup-restore quiesce -n zen \
    > /mnt/backup/wkc/$service_type/wkc-backup-quiesce-$backup_time.log

/home/azadmin/ibm/cpd-cli backup-restore volume-backup create -n zen cpdbk-$backup_time --skip-quiesce=true \
    > /mnt/backup/wkc/$service_type/wkc-backup-volume-$backup_time.log

/home/azadmin/ibm/cpd-cli backup-restore unquiesce -n zen \
    > /mnt/backup/wkc/$service_type/wkc-backup-unquiesce-$backup_time.log

# download wkc backup volume to file
/home/azadmin/ibm/cpd-cli backup-restore volume-backup download cpdbk-$backup_time
mv /home/azadmin/*cpdbk-$backup_time* /mnt/backup/wkc/

# delete expired wkc backup volume and file
/home/azadmin/cmd/purge-wkc-bk.exp $delete_time
rm /mnt/backup/wkc/*cpdbk-$delete_time*