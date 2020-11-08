# Oracle Cloud Control
## 安裝 OEM
### dbconsole
```bash
emca -repos drop
emca -config dbcontrol db -repos create
# SYSMAN = SYS password
```

## Cloud Control
### Reference
- [Oracle Enterprise Manager Cloud Control 13c Release 1 (13.1.0.0) Installation on Oracle Linux 6 and 7](https://oracle-base.com/articles/13c/cloud-control-13cr1-installation-on-oracle-linux-6-and-7)
    - 13c 版本需要安裝 [12c 資料庫](https://www.oracle.com/database/technologies/oracle12c-linux-12201-downloads.html#license-lightbox)
- [Oracle Enterprise Manager Cloud Control 12c Release 2 Installation on Oracle Linux 5.8 and 6.3](https://oracle-base.com/articles/12c/cloud-control-12cr2-installation-on-oracle-linux-5-and-6)
- https://oracledbwr.com/installation-of-oracle-enterprise-manager-13c/

### 環境設定
```bash
su - oracle
vi ~/.bash_profile

# User specific environment and startup programs
export ORACLE_SID=OCC
export ORACLE_UNQNAME=${ORACLE_SID} # it is difference between primary and standby database
export ORACLE_BASE=/u01/oracle
export ORACLE_HOME=$ORACLE_BASE/12201
export OMS_HOME=/oracle/middleware
export AGENT_HOME=/oracle/agent
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

### Step
#### Prerequisites
```bash
yum groupinstall "GNOME Desktop" -y
yum install zip unzip -y
yum install tigervnc-server -y
yum install dkms gcc make kernel-devel bzip2 binutils patch libgomp glibc-headers glibc-devel kernel-headers -y

yum install ksh -y
yum install make -y
yum install binutils -y
yum install gcc -y
yum install libaio -y
yum install glibc-common -y
yum install libstdc++ -y
yum install libXtst -y
yum install sysstat -y
yum install glibc -y
yum install glibc-devel -y
yum install glibc-devel.i686 -y
```

- https://www.oracle.com/enterprise-manager/downloads/cloud-control-downloads.html
- `/usr/bin/make -f ins_sqlplus.mk install ORACLE_HOME=/u01/oracle/12201`
- step
    ```bash
    $ORACLE_HOME/middleware/allroot.sh
    ```
- debug
    - [Check if the parameter _allow_insert_with_update_check is set to True](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=243960029504400&parent=EXTERNAL_SEARCH&sourceId=PROBLEM&id=2254373.1&_afrWindowMode=0&_adf.ctrl-state=619vyroih_4)
        ```sql
        alter system set "_allow_insert_with_update_check"=true;
        ```
    - [Check if all adaptive features parameters are unset](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=30402886325103&parent=EXTERNAL_SEARCH&sourceId=PROBLEM&id=2635383.1&_afrWindowMode=0&_adf.ctrl-state=ke9nvuv68_4)
        ```sql
        alter system set "_optimizer_nlj_hj_adaptive_join"=FALSE scope=both sid='*';
        alter system set "_optimizer_strans_adaptive_pruning"=FALSE scope=both sid='*';
        alter system set "_px_adaptive_dist_method"=OFF scope=both sid='*';
        alter system set "_sql_plan_directive_mgmt_control"=0 scope=both sid='*';
        alter system set "_optimizer_dsdir_usage_control"=0 scope=both sid='*';
        alter system set "_optimizer_use_feedback"=FALSE scope=both sid='*';
        alter system set "_optimizer_gather_feedback"=FALSE scope=both sid='*';
        alter system set "_optimizer_performance_feedback"=OFF scope=both sid='*';
        alter system set session_cached_cursors=200 scope=spfile;
        ```

#### Cloud Control 13c Installation
- `mkdir /oracle`(建立管理資料夾)
- `./em13100_linux64.bin`
    - /oracle/middleware
    - /oracle/agent
- agent
    - 安裝帳號設定 sudo 權限: `visudo`
        ```txt
        # Defaults !visiblepw
        Defaults visiblepw
        oracle ALL=(ALL) ALL
        ```
    - `alter user dbsnmp identified by dbsnmp account unlock;`

### 指令
- 站台: https://cloud-control:7803/em
- 啟動 cloud control
    - `SQL> startup`
    - `lsnrctl start`
    - `$OMS_HOME/bin/emctl start oms`