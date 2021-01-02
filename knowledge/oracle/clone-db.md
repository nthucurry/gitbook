# Oracle E-Shipment Clone
## Referfence
- [shm size insufficient](http://alexlucy99.blogspot.com/2013/12/ora-00845-memorytarget-not-supported-on.html)
    ```text
    RMAN-04014: startup failed:
    ORA-00845: MEMORY_TARGET not supported on this system
    ```

## SOP
### 1. 建置 VM 環境
#### (1) 安裝 RedHat 5.6
#### (2) 安裝 VM tools
```bash
cp -r /media/VMware\ Tools/ ~/Desktop/
cd ~/Desktop/VMware\ Tools/
tar zxvf VMwareTools-10.3.10-12406962.tar.gz
./Desktop/vmware-tools-distrib/vmware-install.pl
```

### 2. 建置 OS 環境
```bash
# DB directory
mkdir -p /u01/oraarch/ESHIP
mkdir -p /u01/oradata/ESHIP

# LVM setting
fdisk /dev/sdb
pvcreate /dev/sdb
vgcreate vg_eship /dev/sdb
lvcreate -l 127990 -n lv_u01 vg_eship
mkfs.ext3 /dev/vg_eship/lv_u01
mount /dev/mapper/vg_eship-lv_u01 /u01
echo "/dev/mapper/vg_eship-lv_u01 /u01 ext3 defaults 0 0" >> /etc/fstab
```

### 3. 環境 DB 建置
```bash
# group
groupadd -g 501 dba
groupadd -g 502 oinstall

# privilege
chown -R oraeship:dba /u01
usermod -G 501,502 -u 501 oraeship

# mount backup data
mkdir /backup
mount target:/backup /backup

# swap
dd if=/dev/zero of=/swapfile count=16 bs=1GiB
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
echo "/swapfile swap swap sw 0 0" >> /etc/fstab

# shm size
mount -o remount,size=31G /dev/shm
vi /etc/fstab
## tmpfs                   /dev/shm                tmpfs   defaults,size=31G        0 0

# firewall status
service iptables stop
chkconfig iptables off # correctory is or not ?
```

### 4. 安裝 DB
```bash
# 先下載 oracle 11204: \\auo\gfs\APFS\Software\Oracle\Oracle 11g 11.2.0.4.0 for linux

# install instance
./database/runInstaller

# install listener
$ORACLE_HOME/bin/netca

# copy listener from production DB and rename prodction parameter(ex: IP, hostname)
vi listener.ora

# copy profile from production database
vi ~/.bash_profile
```

### 5. 還原 DB (一定不會一次成功，會死在 Recover)
#### (1) 基本動作
```bash
#/bin/bash
TODAY=`date +%Y%m%d`
$ORACLE_HOME/bin/rman target / nocatalog log=$HOME/restore_$TODAY.log << EOF

run {
    startup nomount;
    restore controlfile from '/backup/20201105/eship_cntl_127607_1_1055664276.bak';

    alter database mount;
    restore database;
    recover database;
}
EOF
```
- error message
    ```txt
    RMAN-00571: ===========================================================
    RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
    RMAN-00571: ===========================================================
    RMAN-03002: failure of recover command at 12/24/2020 14:37:50
    RMAN-06054: media recovery requesting unknown archived log for thread 1 with sequence 537443 and starting SCN of 12345027446029

    RMAN> list backup of archivelog sequence 537443 thread 1;
    specification does not match any backup in the repository
    RMAN> list backup of archivelog sequence 537442 thread 1;
    Piece Name: /backup/20201224/eship_arch_130089_1_1059956234.bak

    造成原因是缺少 eship_arch_130090_1_1059956234.bak
    -rw-r----- 1 oraeship dba 524424704 Dec 24 00:19 /backup/20201224/eship_arch_130089_1_1059956234.bak
    -rw-r----- 1 oraeship dba 839235072 Dec 24 08:03 /backup/20201224/eship_arch_130091_1_1059984020.bak
    ```
- 建立 tempfile
    ```sql
    alter tablespace temp add tempfile '/u01/oradata/ESHIP/temp1.dbf' size 1000M;
    ```

#### (2) 進階動作: 重製 Control File
```sql
alter database backup controlfile to trace;
```
```bash
# 到 trace folder 找最新的 xxx.trc
bdump
ls -lrt
vi ESHIP_ora_20354.trc

# 找到 create controlfile 並複製下來
# 改建立規則
## 原本: CREATE CONTROLFILE REUSE DATABASE "ESHIP" NORESETLOGS FORCE LOGGING ARCHIVELOG
## 改為: CREATE CONTROLFILE REUSE SET DATABASE "ESHIP" RESETLOGS NOARCHIVELOG
```
```txt
SQL> startup nomount
SQL> @cr.sql
SQL> alter database open resetlogs;
```

### 6. 確認 DB 狀態
```sql
-- open_mode 需為 read write 狀態
select
    name, open_mode, database_role, switchover_status
from
    v$database;
```

### 7. 設定 dbconsole (option)
```sql
-- 改密碼
alter user DBSNMP identified by oracle;
alter user SYS identified by oracle;
alter user SYSMAN identified by oracle;
alter user SYSTEM identified by oracle;
```
```bash
emca -repos drop
emca -config dbcontrol db -repos create
```