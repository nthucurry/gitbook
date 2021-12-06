#!/bin/bash

service_type="dev"
nfs_hostname="dev-nfs"
check_time=`date +%Y-%m%d --date="-1 day"`
backup_time=`date +%Y-%m%d --date="-1 day"`

nfs_disk_space=`cat /mnt/backup/nfs-disk-space/$service_type/disk-space-$check_time.log`
wkc_shutdown=`tail -1 /mnt/backup/wkc/$service_type/wkc-backup-quiesce-$backup_time.log`
wkc_backup=`tail -3 /mnt/backup/wkc/$service_type/wkc-backup-volume-$backup_time.log`
wkc_startup=`tail -3 /mnt/backup/wkc/$service_type/wkc-backup-unquiesce-$backup_time.log | head -1`


cat << EOF | tee /home/azadmin/cmd/mail.exp
#!/usr/bin/expect -f
spawn /usr/bin/telnet mail-relay.corpnet.axo.com 25
expect "220 mail-relay.corpnet.axo.com ESMTP Postfix"
send "EHLO axo.com\r"
expect "250 DNS"
send "MAIL FROM: <alert@axo.com>\r"
expect "250 2.1.0 Ok"
send "RCPT TO: <test@axo.com>\r"
expect "250 2.1.5 Ok"
send "DATA\r"
expect "354 End data with <CR><LF>.<CR><LF>"
send "Subject: WKC Backup Status ($service_type)\r"
send "========== NFS Disk Space (hostname: $nfs_hostname) ==========\r"
send "\n$nfs_disk_space\r"
send "\n"
send "\r"
send "========== WKC Volume Backup Status ==========\r"
send "\r"
send "(Step 1) WKC Shutdown Result:\n"
send "\t$wkc_shutdown\r"
send "\trawdata: https://wkcnfs.blob.core.windows.net/wkc/$service_type/wkc-backup-quiesce-$backup_time.log\r"
send "\n"
send "(Step 2) WKC Volume Backup Result:\n"
send "\t$wkc_backup\r"
send "\trawdata: https://wkcnfs.blob.core.windows.net/wkc/$service_type/wkc-backup-volume-$backup_time.log\r"
send "\n"
send "(Step 3) WKC Startup Result:\n"
send "\t$wkc_startup\r"
send "\trawdata: https://wkcnfs.blob.core.windows.net/wkc/$service_type/wkc-backup-unquiesce-$backup_time.log\r"
send ".\r"
expect "250 2.0.0 Ok: queued as E73FDE07B6"
send "quit\r"
EOF

/home/azadmin/cmd/mail.exp