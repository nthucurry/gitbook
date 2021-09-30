#!/bin/bash

service_type="dev"
check_time=`date +%Y-%m%d`

ssh dev-nfs 'df -h | grep -E "Filesystem|sda2|vg-lv"' > /mnt/backup/nfs-disk-space/$service_type/disk-space-$check_time.log
# chmod 755 /mnt/backup/nfs-disk-space/$service_type/disk-space-$check_time.log