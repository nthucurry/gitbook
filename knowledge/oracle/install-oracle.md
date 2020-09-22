# 如何安裝 Oracle DB ?
## 建立帳號、群組
```bash
groupadd -g 501 dba
groupadd -g 502 oinstall
useradd -G 501,502 -u 501 -m demo
passwd demo
```

## 環境設定
### 環境變數
```bash
su - demo
vi ~/.bash_profile

# User specific environment and startup programs
export ORACLE_SID=DEMO
export ORACLE_UNQNAME=${ORACLE_SID} # it is difference between primary and standby database
export ORACLE_BASE=/u01/oracle
export ORACLE_HOME=$ORACLE_BASE/11204
export TNS_ADMIN=$ORACLE_HOME/network/admin
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib;
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib;
export CLASSPATH
PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export PATH

# Alias
alias sqlp='sqlplus / as sysdba'
alias rm='rm -i'
alias vi='vim'
alias grep='grep --color=always'
alias tree='tree --charset ASCII'
alias bdump="cd $ORACLE_BASE/diag/rdbms/${ORACLE_UNQNAME,,}/$ORACLE_SID/trace"
```

### 磁碟格式(LVM)
```bash
# 找目標 disk
fdisk -l

# 檔案格式轉換
fdisk /dev/sdb

# 建立 PV(Physical Volume)
pvscan
pvcreate /dev/sdb

# 建立 VG(Volume Group)
vgcreate vg_demo /dev/sdb
vgdisplay vg_demo

# 建立 LV(Logical Volume)
lvcreate -L 50G -n lv_demo vg_demo

# 格式化
mkfs.xfs /dev/vg_demo/lv_demo

# 掛載
mount /dev/mapper/vg_demo-lv_u01 /u01

# 開機掛載
vi /etc/fstab # mount it
# /dev/mapper/vg_demo-lv_u01  /u01        xfs     defaults        0 0

# restart
reboot
```

### Remote by GUI
#### 安裝 VNC server(option)
```bash
# 安裝
yum install tigervnc-server -y

# 複製 service config
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service

# 修改 service config
sed -i 's/<USER>/demo/g' /etc/systemd/system/vncserver@:1.service

# 確認 root 的路徑是否正確(option)
vi /etc/systemd/system/vncserver@:1.service
PIDFile=/home/demo/.vnc/%H%i.pid

# 登入各個帳號去設定以下(systemctl daemon-reload??)
systemctl status vncserver@:1.service
systemctl start vncserver@:1.service
systemctl enable vncserver@:1.service

# 設定密碼
vncserver -kill :1
vncserver(啟動 vnc server，需依照各別 user account)
vncpasswd

# 重啟
reboot

# 檢查
netstat -tln
tcp 0 0 0.0.0.0:5901 0.0.0.0:* LISTEN
```

#### X Window System
```bash
# 需要直接 login demo
cd ~
vi .Xclients
# xterm &
# exec /usr/bin/matchbox-window-manager

chmod +x .Xclients
~/.Xclients # remember open xming
```

## 如果 Swap 不足
- `dd if=/dev/zero of=/swapfile count=4096 bs=1MiB`
- `chmod 600 /swapfile`
- `mkswap /swapfile`
- `swapon /swapfile`
- `swapon -s`
- `free -m`
- `vi /etc/fstab`
	- /swapfile swap  swap  sw  0 0

## Pretreatment(option)
- 更新 EPEL repository: `yum install epel-release -y`
    - `wget http://public-yum.oracle.com/public-yum-ol7.repo -O /etc/yum.repos.d/public-yum-ol7.repo`
    - `wget http://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol7 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle`
- 安裝懶人包
    - `yum install oracle-rdbms-server-11gR2-preinstall -y`
- 確認記憶體是否足夠
    - memory requirements
        ```bash
        grep MemTotal /proc/meminfo
        grep SwapTotal /proc/meminfo
        ```
    - automatic memory management
        - `df -h /dev/shm/`
        - 永久有效(7G 的置換空間)
            - `shmfs /dev/shm tmpfs size=7g 0`
            - `mount -t tmpfs shmfs -o size=7g /dev/shm`
- `yum install gcc* libaio-devel* glibc-* libXi* libXtst* unixODBC* compat-libstdc* libstdc* binutils* compat-libcap1* ksh -y`

## 安裝 Oracle
`vi ~/database/stage/cvu/cv/admin/cvu_config`
    ```txt
    # CV_ASSUME_DISTID=OEL4 (x)
    CV_ASSUME_DISTID=OEL6 (o)
    ```
- `~/database/runInstaller`(用 oracle 帳號，不能用 root)
- [x] install database software only
- [x] single instance database installation
- [x] enterprise edition(企業版才有 data guard)
- [x] prerequisite checks
    - `vi /etc/sysctl.conf`(有用懶人包會自動生成)
        ```txt
        fs.file-max = 6815744
        kernel.shmall = 2097152
        kernel.shmmax = 536870912
        kernel.shmmni = 4096
        kernel.sem = 250 32000 100 128
        net.ipv4.ip_local_port_range = 9000 65500
        net.core.rmem_default = 262144
        net.core.rmem_max = 4194304
        net.core.wmem_default = 262144
        net.core.wmem_max = 1048576
        ```
    - 執行 `/tmp/CVU_11.2.0.1.0_oracle/runfixup.sh`
        - install error
            - ![](../../img/oracle/runinstaller-error-1.png)
            - ![](../../img/oracle/runinstaller-error-2.png)
        - `vi $ORACLE_HOME/ctx/lib/ins_ctx.mk`
            ```bash
            # 原本
            ctxhx: $(CTXHXOBJ)
                $(LINK_CTXHX)  $(CTXHXOBJ)  $(INSO_LINK)

            # 改成(也要 tab)
            ctxhx: $(CTXHXOBJ)
                -static $(LINK_CTXHX) $(CTXHXOBJ) $(INSO_LINK) /usr/lib/gcc/x86_64-redhat-linux/4.8.2/libstdc++.so

            # tip
            sed -i 's/$(LINK_CTXHX) $(CTXHXOBJ) $(INSO_LINK)/-static $(LINK_CTXHX) $(CTXHXOBJ) $(INSO_LINK) \/usr\/lib\/gcc\/x86_64-redhat-linux\/4.8.2\/libstdc++.so/g' $ORACLE_HOME/ctx/lib/ins_ctx.mk
            ```
        - `vi $ORACLE_HOME/sysman/lib/ins_emagent.mk`
            ```bash
            # 原本
            $(SYSMANBIN)emdctl:
                $(MK_EMAGENT_NMECTL)

            # 改成
            $(SYSMANBIN)emdctl:
                $(MK_EMAGENT_NMECTL) -lnnz11

            # tip
            sed -i 's/$(MK_EMAGENT_NMECTL)/$(MK_EMAGENT_NMECTL) -lnnz11/g' $ORACLE_HOME/sysman/lib/ins_emagent.mk
            ```
    - 執行
        ```bash
        /u01/oraInventory/orainstRoot.sh
        $ORACLE_HOME/root.sh
        ```

### 設定 Listener
- [Oracle Listener 教學](http://shinchuan1.blogspot.com/2014/04/oracle-listener.html)
- 執行 `$ORACLE_HOME/bin/netca`
- 一直下一步
    - [不容易發現的問題](https://www.itread01.com/content/1549111156.html)
- `vi $TNS_ADMIN/listener.ora`(如果沒有就新增)
    ```txt
    LISTENER =
        (DESCRIPTION_LIST =
            (DESCRIPTION =
                (ADDRESS = (PROTOCOL = TCP)(HOST = primary)(PORT = 1521))
            )
        )

    SID_LIST_LISTENER =
        (SID_LIST =
            (SID_DESC =
                (SID_NAME = DEMO)
                (ORACLE_HOME = /u01/oracle/11204)
            )
        )

    # Automatic Diagnostic Repository
    ADR_BASE_LISTENER = /u01/oracle
    ```

### 安裝資料庫
- Reference
    - [How to Use the Database Configuration Assistant (DBCA) to Create Databases in Oracle 12c](https://www.dummies.com/programming/databases/how-to-use-the-database-configuration-assistant-dbca-to-create-databases-in-oracle-12c/)
- 執行 `$ORACLE_HOME/bin/dbca`
    - operations
        - [x] create a database
    - database templates
        - [x] customer database
    - database identification
        - global database name / SID 要和環境變數一樣
    - managerment options
        - enterprise managerment 不設定
    - database file locations
        - storage type: file system
        - storage location: use common location for all database files
    - recovery configuration
        - 不用 specify flash recovery area
        - 檔名: `DEMO_%t_%s_%r.dbf`
        - 路徑: `/u01/oraarch/DEMO`
    - database content
        - 僅選 enterprise managerment repository
    - initialization parameters
        - sizing(option)
            - processes: 150 -> 1500
        - character sets
            - use unicode
    - 一直下一步
    - finish

### 安裝 OEM
#### dbconsole
```bash
emca -repos drop
emca -config dbcontrol db -repos create
# SYSMAN = SYS password
```

#### Cloud Control
- https://oracle-base.com/articles/12c/cloud-control-12cr2-installation-on-oracle-linux-5-and-6
- https://www.oracle.com/enterprise-manager/downloads/cloud-control-downloads.html
- `/usr/bin/make -f ins_sqlplus.mk install ORACLE_HOME=/u01/oracle/11204`

## 排程
- `crontab -e`
    ```txt
    @reboot /home/demo/scripts/start-lsn.sh
    @reboot /home/demo/scripts/start-db.sh
    ```
- `vi start-lsn.sh`
    ```bash
    #/bin/bash

    . ~/.bash_profile

    NOW=`date +%Y-%m-%d-%H%M`
    $ORACLE_HOME/bin/lsnrctl start > $HOME/log/lsnrctl-$NOW.log
    ```
- `vi start-db.sh`
    ```bash
    #/bin/bash

    . ~/.bash_profile

    NOW=`date +%Y-%m-%d-%H%M`
    $ORACLE_HOME/bin/sqlplus / as sysdba > $HOME/log/startup-$NOW.log << EOF
    startup;
    quit;
    EOF
    ```

### 建立 Account
```sql
CREATE USER DEMO IDENTIFIED BY demo DEFAULT tablespace ts_demo;
GRANT CONNECT TO demo_admin;
GRANT CREATE SESSION TO demo_admin; -- 必要
GRANT ALL ON DEMO.TEAM TO demo_admin;
GRANT demo_admin TO demo;
```

### 掛載 Disk by NFS
[CentOS 7 下 yum 安装和配置 NFS](https://qizhanming.com/blog/2018/08/08/how-to-install-nfs-on-centos-7)
- host
    ```bash
    # startup NFS(Network File System)
    systemctl start rpcbind
    systemctl start nfs
    systemctl enable rpcbind
    systemctl enable nfs

    # firewall setting
    firewall-cmd --zone=public --permanent --add-service={rpc-bind,mountd,nfs}
    firewall-cmd --reload

    # check NFS
    vi /etc/exports
    # /backup    192.168.56.0/224(rw,sync)

    systemctl restart nfs

    showmount -e localhost
    ```
- client
    ```bash
    systemctl start rpcbind
    systemctl enable rpcbind

    # mount NFS when startup
    vi /etc/fstab
    # 目標主機名稱:/backup_new         /backup_new                   nfs     defaults        0 0

    systemctl daemon-reload
    ```