#!/bin/bash

service_type="dev"
check_time=`date +%Y-%m%d`

ssh dev-nfs 'df -h' > /mnt/backup/nfs-disk-space/$service_type/disk-space-$check_time.log