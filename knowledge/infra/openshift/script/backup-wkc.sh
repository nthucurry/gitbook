#!/bin/bash

service_type="dev"
backup_time=`date +%Y-%m%d`

/home/azadmin/ibm/cpd-cli backup-restore quiesce -n zen \
    > /mnt/backup/wkc/$service_type/wkc-backup-quiesce-$backup_time.log
chmod 755 /mnt/backup/wkc/$service_type/wkc-backup-quiesce-$backup_time.log

/home/azadmin/ibm/cpd-cli backup-restore volume-backup create -n zen cpdbk-$backup_time --skip-quiesce=true \
    > /mnt/backup/wkc/$service_type/wkc-backup-volume-$backup_time.log
chmod 755 /mnt/backup/wkc/$service_type/wkc-backup-volume-$backup_time.log

/home/azadmin/ibm/cpd-cli backup-restore unquiesce -n zen \
    > /mnt/backup/wkc/$service_type/wkc-backup-unquiesce-$backup_time.log
chmod 755 /mnt/backup/wkc/$service_type/wkc-backup-unquiesce-$backup_time.log

delete_time=`date +%Y-%m%d --date="-7 day"`
/home/azadmin/ibm/purge-wkc-bk $delete_time