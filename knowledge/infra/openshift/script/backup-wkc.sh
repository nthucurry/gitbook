#!/bin/bash

backup_time=`date +%Y-%m%d`

/home/azadmin/ibm/cpd-cli backup-restore quiesce -n zen \
    > /home/azadmin/cmd/log/wkc-backup-quiesce-$backup_time.log
/home/azadmin/ibm/cpd-cli backup-restore volume-backup create -n zen cpdbk-$backup_time --skip-quiesce=true \
    > /home/azadmin/cmd/log/wkc-backup-volume-$backup_time.log
/home/azadmin/ibm/cpd-cli backup-restore unquiesce -n zen \
    > /home/azadmin/cmd/log/wkc-backup-unquiesce-$backup_time.log

delete_time=`date +%Y-%m%d --date="-7 day"`
/home/azadmin/ibm/cpd-cli backup-restore volume-backup purge cpdbk-$delete_time