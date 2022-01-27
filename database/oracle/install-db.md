# Install Oracle Database
## Download
- [p13390677_112040_Linux-x86-64](https://updates.oracle.com/Orion/PatchDetails/process_form?patch_num=13390677&aru=16716375&release=80112040&plat_lang=226P&patch_num_id=1730815&)
- [Oracle Database 11g Release 2 (11.2) Installation On Oracle Linux 7 (OL7)](https://oracle-base.com/articles/11g/oracle-db-11gr2-installation-on-oracle-linux-7)

## 建立帳號、群組
```bash
groupadd -g 501 dba
groupadd -g 502 oinstall
useradd -G 501,502 -u 501 -m oracle
passwd oracle
```

## 環境設定
### 環境變數
```bash
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
```

## Prerequisites(option)
- 更新 EPEL repository: `yum install epel-release -y`
    - `wget http://public-yum.oracle.com/public-yum-ol7.repo -O /etc/yum.repos.d/public-yum-ol7.repo`
    - `wget http://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol7 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle`
- 安裝懶人包
    - `yum install oracle-rdbms-server-11gR2-preinstall -y`
- 確認記憶體是否足夠
    - automatic memory management(此設定會影響 MEMORY_TARGET)
    - `df -h /dev/shm/`
    - 永久有效(7G 的置換空間)
        - `shmfs /dev/shm tmpfs size=7g 0`
        - `mount -t tmpfs shmfs -o size=7g /dev/shm`
- `yum install gcc* libaio-devel* glibc-* libXi* libXtst* unixODBC* compat-libstdc* libstdc* binutils* compat-libcap1* ksh -y`

## 解壓縮
- `unzip p13390677_112040_Linux-x86-64_1of7.zip`
- `unzip p13390677_112040_Linux-x86-64_2of7.zip`

## 安裝 Oracle Software
- 改參數
    - `sed -i 's/CV_ASSUME_DISTID=OEL4/CV_ASSUME_DISTID=OEL6/g' ~/database/stage/cvu/cv/admin/cvu_config`
- `~/database/runInstaller`(用 oracle 帳號，不能用 root)
    - 遇到 xdpyinfo 問題的解決方法: https://support.oracle.com/epmos/faces/SearchDocDisplay?_adf.ctrl-state=m8p0v6j86_4&_afrLoop=63722001626700
    - `ssh -Y oracle@t-db.southeastasia.cloudapp.azure.com`
- [x] install database software only
- [x] single instance database installation
- [x] enterprise edition(企業版才有 data guard)
- [x] prerequisite checks
    - `vi /etc/sysctl.conf`(有用懶人包會自動生成)
        ```
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
            <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/oracle/runinstaller-error-1.png">
            <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/oracle/runinstaller-error-2.png">
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
        - `/u01/oraInventory/orainstRoot.sh`
        - `/u01/oracle/11204/root.sh`

### 設定 Listener
- [Oracle Listener 教學](http://shinchuan1.blogspot.com/2014/04/oracle-listener.html)
- 執行 `$ORACLE_HOME/bin/netca`
- 一直下一步
    - [不容易發現的問題](https://www.itread01.com/content/1549111156.html)
- `vi $TNS_ADMIN/listener.ora`(如果沒有就新增)
    ```
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

### 安裝 Database
- Reference
    - [How to Use the Database Configuration Assistant (DBCA) to Create Databases in Oracle 12c](https://www.dummies.com/programming/databases/how-to-use-the-database-configuration-assistant-dbca-to-create-databases-in-oracle-12c/)
- 執行 `$ORACLE_HOME/bin/dbca`
    - operations
        - [x] create a database
            <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/oracle/dbca-db-install-1.png">
    - database templates
        - [x] customer database
    - database identification
        - global database name / SID 要和環境變數一樣
            <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/oracle/dbca-db-install-2.png">
    - managerment options
        - enterprise managerment 不設定
    - database file locations
        - storage type: file system
            <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/oracle/dbca-db-install-3.png">
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

### Alter Install
- 設定 audit 位置
    - `mkdir -p $ORACLE_BASE/admin/$ORACLE_SID/adump`

### Option Setting
#### Mail relay
```bash
vi /etc/postfix/main.cf
relayhost = domain.com
```
```sql
BEGIN
    DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
        acl => 'XXX_ACL.xml',
        description => 'Permissions for smtp gate',
        principal => 'XXX', -- schema account
        is_grant => TRUE,
        privilege => 'resolve');
    COMMIT;
END;
BEGIN
    DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
        acl => 'XXX_ACL.xml',
        principal => 'XXX', -- schema account
        is_grant => TRUE,
        privilege => 'connect');
    COMMIT;
END;
BEGIN
    DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
        acl => 'XXX_ACL.xml',
        host => '*');
    COMMIT;
END;
COMMIT;
```
