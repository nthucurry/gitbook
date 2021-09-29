#!/bin/bash

service_type="dev"
check_time=`date +%Y-%m%d`
backup_time=`date +%Y-%m%d`

#/home/azadmin/cmd/check-nfs-disk.sh

nfs_disk_space=`cat /mnt/backup/nfs-disk-space/$service_type/disk-space-$check_time.log`
wkc_shutdown=`cat /mnt/backup/wkc/$service_type/wkc-backup-quiesce-$backup_time.log`
wkc_backup=`cat /mnt/backup/wkc/$service_type/wkc-backup-volume-$backup_time.log`
wkc_startup=`cat /mnt/backup/wkc/$service_type/wkc-backup-unquiesce-$backup_time.log`

cat << EOF | tee /home/azadmin/cmd/mail.exp
#!/usr/bin/expect -f

spawn /usr/bin/telnet mail-relay.axo.com 25
expect "220 mail-relay.axo.com ESMTP Postfix"
send "EHLO axo.com\r"
expect "250 DNS"
send "MAIL FROM: <alert@axo.com>\r"
expect "250 2.1.0 Ok"
send "RCPT TO: <test@axo.com>\r"
expect "250 2.1.5 Ok"
send "DATA\r"
expect "354 End data with <CR><LF>.<CR><LF>"
send "Subject: WKC Status ($service_type)\r"
send "NFS disk space:\r"
send "$nfs_disk_space\r"
send "\r"
send "\r"
send "WKC Volume Backup Status:\r"
send "$wkc_shutdown\r"
send "\r"
send "$wkc_backup\r"
send "\r"
send "$wkc_startup\r"
send ".\r"
expect "250 2.0.0 Ok: queued as E73FDE07B6"
send "quit\r"

EOF

/home/azadmin/cmd/mail.exp