# Reference
- [Data Guard Physical Standby Setup in Oracle Database 11g Release 2](https://oracle-base.com/articles/11g/data-guard-setup-11gr2)
- [資料庫容災——Oracle DataGuard原理介紹](https://kknews.cc/code/22zj5a9.html)
- [利用 RMAN 建置 Data Guard](https://blog.xuite.net/charley_ocp/mydba01/17915591-%E5%88%A9%E7%94%A8+RMAN+%E5%BB%BA%E7%BD%AE+Data+Guard)
- [11.2 Data Guard Physical Standby Switchover Best Practices using SQL*Plus (Doc ID 1304939.1)](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=173489396669358&id=1304939.1&_adf.ctrl-state=j20k0feh4_52)
- [Business Continuity for Oracle E-Business Release 12.1 Using Oracle 11g Release 2 Physical Standby Database (Doc ID 1070033.1)](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=173529160661802&id=1070033.1&_adf.ctrl-state=j20k0feh4_109)
- [Creating a 10gr1 Data Guard Physical Standby on Linux (Doc ID 248382.1)](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=173564896286084&id=248382.1&_adf.ctrl-state=j20k0feh4_166)
- [Manually Creating a Standby Database using RMAN](https://support.dbvisit.com/hc/en-us/articles/216837037-Manually-Creating-a-Standby-Database-using-RMAN)
- [Data Guard 的 DB_UNIQUE_NAME 設定](https://blog.xuite.net/charley_ocp/mydba01/37810823-Data+Guard+%E7%9A%84+DB_UNIQUE_NAME+%E8%A8%AD%E5%AE%9A)
- https://blog.csdn.net/Alen_Liu_SZ/article/details/77925238
- https://blog.csdn.net/chengxumengzhidui/article/details/77961524
- https://blog.csdn.net/cjb18099665642/article/details/100466318?utm_medium=distribute.pc_relevant.none-task-blog-OPENSEARCH-4.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-OPENSEARCH-4.nonecase

# Oracle Data Guard
- Typical Data Guard Configuration
    ![](https://docs.oracle.com/cd/E11882_01/server.112/e41134/img/sbydb042.gif)
- Automatic Updating of a Physical Standby Database
    ![](https://docs.oracle.com/cd/E11882_01/server.112/e41134/img/sbydb054.gif)
- Possible Standby Configurations
    ![](https://docs.oracle.com/cd/E11882_01/server.112/e41134/img/sbydb058.gif)
- Manual Recovery Mode
    ![](https://docs.oracle.com/cd/A84870_01/doc/server.816/a76995/sbr81098.gif)

# 環境變數
```bash
# User specific environment and startup programs
export ORACLE_SID=ESHIP
export ORACLE_BASE=/u01/oracle
export ORACLE_HOME=$ORACLE_BASE/11204
export TNS_ADMIN=$ORACLE_HOME/network/admin
#export ORACLE_HOSTNAME=
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib;
export CLASSPATH
PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export PATH

# alias
alias rm='rm -i'
alias vi='vim'
alias sqlp=' sqlplus / as sysdba'
alias grep='grep --color=always'
alias tree='tree --charset ASCII'
#alias bdump="cd /u01/oracle/diag/rdbms/eship/ESHIP/trace"
#alias bdump="cd /u01/oracle/diag/rdbms/eship_stb/ESHIP/trace"
```

# 連線資訊、參數檔設定
## Listener.ora
### Primary
```
SID_LIST_LISTENER =
    (SID_LIST =
        (SID_DESC =
            (SID_NAME = ESHIP)
            (ORACLE_HOME = /u01/oracle/11204)
        )
    )

LISTENER =
    (DESCRIPTION_LIST =
        (DESCRIPTION =
            (ADDRESS = (PROTOCOL = TCP)(HOST = primary)(PORT = 1521)(IP = FIRST))
            (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
        )
    )

ADR_BASE_LISTENER = /u01/oracle/11204
```

### Standby
```
SID_LIST_LISTENER =
    (SID_LIST =
        (SID_DESC =
            (SID_NAME = ESHIP_STB)
            (ORACLE_HOME = /u01/oracle/11204)
        )
    )

LISTENER =
    (DESCRIPTION_LIST =
        (DESCRIPTION =
            (ADDRESS = (PROTOCOL = TCP)(HOST = standby)(PORT = 1521))
            (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
        )
    )

ADR_BASE_LISTENER = /u01/oracle/11204
```

## Tnsnames.ora
### Same part
```
ESHIP =
    (DESCRIPTION =
        (ADDRESS_LIST =
            (ADDRESS = (PROTOCOL = TCP)(HOST = primary)(PORT = 1521))
        )
        (CONNECT_DATA =
            (SERVICE_NAME = ESHIP.WORLD)
        )
    )

ESHIP_STB =
    (DESCRIPTION =
        (ADDRESS_LIST =
            (ADDRESS = (PROTOCOL = TCP)(HOST = standby)(PORT = 1521))
        )
        (CONNECT_DATA =
            (SERVICE_NAME = ESHIP)
        )
    )
```

### Primary
```
LISTENER_ESHIP =
  (ADDRESS = (PROTOCOL = TCP)(HOST = primary)(PORT = 1521))

# Same part
```

### Standby
```
LISTENER_ESHIP =
    (ADDRESS = (PROTOCOL = TCP)(HOST = standby)(PORT = 1521))

# Same part
```

## Initial parameter
### Primary
```
*._ash_size=67108864
#*.audit_file_dest='/u01/p/oraeship/admin/ESHIP/adump'
*.audit_trail='NONE'
*.compatible='11.2.0.0.0'
*.control_files='/u01/oradata/ESHIP/control01.ctl','/u01/oradata/ESHIP/control02.ctl'
*.db_block_size=8192
*.db_domain='world'
*.db_name='ESHIP'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=ESHIPXDB)'
*.local_listener='LISTENER_ESHIP'
*.log_archive_dest_1='LOCATION=/u01/oraarch/ESHIP/'
*.log_archive_format='eship_%t_%s_%r.dbf'
*.log_archive_max_processes=10
#*.memory_max_target=32212254720
#*.memory_target=32212254720
*.open_cursors=300
*.optimizer_features_enable='11.2.0.2'
*.parallel_max_servers=12
*.parallel_servers_target=12
*.pga_aggregate_target=8G
*.processes=1000
*.remote_login_passwordfile='EXCLUSIVE'
*.resource_limit=TRUE
*.sga_max_size=20G
*.sga_target=20G
*.undo_tablespace='UNDOTBS2'

##### config #####
*.db_unique_name='ESHIP'
*.diagnostic_dest='/u01/oracle'
*.fal_server='ESHIP'
*.job_queue_processes=1000 # start until finish
*.log_archive_config='DG_CONFIG=(ESHIP,ESHIP_STB)'
*.log_archive_dest_2='SERVICE=ESHIP_STB NOAFFIRM ASYNC VALID_FOR=(ALL_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=ESHIP_STB COMPRESSION=ENABLE'
#*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_min_succeed_dest=1
*.standby_file_management='AUTO'
```

### Standby
```
*._ash_size=67108864
#*.audit_file_dest='/u01/oracle/admin/ESHIP/adump'
*.audit_trail='NONE'
*.compatible='11.2.0.0.0'
*.control_files='/u01/oradata/ESHIP/control01.ctl','/u01/oradata/ESHIP/control02.ctl'
*.db_block_size=8192
*.db_domain='world'
*.db_name='ESHIP'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=ESHIPXDB)'
*.local_listener='LISTENER_ESHIP'
*.log_archive_dest_1='LOCATION=/u01/oraarch/ESHIP/'
*.log_archive_format='eship_%t_%s_%r.dbf'
*.log_archive_max_processes=10
#*.memory_max_target=32212254720
#*.memory_target=32212254720
*.open_cursors=300
*.optimizer_features_enable='11.2.0.2'
*.parallel_max_servers=12
*.parallel_servers_target=12
*.pga_aggregate_target=8G
*.processes=1000
*.remote_login_passwordfile='EXCLUSIVE' # 密碼認證
*.resource_limit=TRUE
*.sga_max_size=20G
*.sga_target=20G
*.undo_tablespace='UNDOTBS2'

##### config #####
*.db_unique_name='ESHIP_STB'
*.diagnostic_dest='/u01/oracle'
*.fal_server='ESHIP'
*.job_queue_processes=0
*.log_archive_config='DG_CONFIG=(ESHIP,ESHIP_STB)'  # 從 primary 傳送 redo logs to standby
*.log_archive_dest_2='SERVICE=ESHIP NOAFFIRM ASYNC VALID_FOR=(ALL_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=ESHIP COMPRESSION=ENABLE'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ENABLE' # enable 代表開始傳輸 redo logs from primary to standby site
*.service_names='ESHIP.world'
*.standby_file_management='AUTO' # 當 primary 有變動時，standby 也會跟著變動
```

# 確認雙邊資料庫是否可以互通
`tnsping <hostname>`

# Set configuration on primary
- [x] 啟動 archive log mode
    ```sql
    archive log list;
    alter database force logging;
    select name, force_logging from v$database;
    ```
- [x] 設定 pfile: initESHIP.ora

# RMAN backup primary database
- `vi backup.sh`
    ```bash
    #!/bin/bash
    NOW=`date +%Y-%m-%d-%H%M`
    $ORACLE_HOME/bin/rman target / nocatalog log=$HOME/log/rman-backup-$NOW.log << EOF
    run {
        sql 'alter system checkpoint';
        allocate channel c1 type disk format '/backup_new/%d_%s_%p_%t.bak';
        backup database;
        release channel c1;

        allocate channel c1 type disk format '/backup_new/%d_arch_%s_%p_%t.bak';
        backup archivelog all delete input;
        release channel c1;
        delete force noprompt copy of archivelog all completed before 'sysdate-1';

        allocate channel c1 type disk format '/backup_new/%d_cntl_%s_%p_%t.bak';
        backup current controlfile for standby;
        release channel c1;
    }
    EOF
    ```

# Install standby instance
`./runInstaller`

# Same directory architecture with primary
- 三種備份方式: 手動冷備份、手動熱備份、[RMAN](https://oracle-base.com/articles/11g/data-guard-setup-11gr2)

## Set standby config
- [x] 設定 pfile: `vi initESHIP.ora`
    ```sql
    create spfile from pfile;
    ```

## RMAN restore(實測後差 12 天還可以做)
- `RMAN> sql 'shutdown immediate';`
- `RMAN> sql 'startup nomount';`
- `RMAN> restore standby controlfile from '/backup_new/eship_cntl_XX_X_XXXXXXXXXX.bak';`
- `RMAN> sql 'alter database mount';`
- `RMAN> restore database;`
- `RMAN> recover database;`
- `RMAN> restore archivelog all;`
    - 忽略此錯誤
        ```
        RMAN-03002: failure of recover command at 05/13/2020 16:50:20
        RMAN-06054: media recovery requesting unknown archived log for thread 1 with sequence 59 and starting SCN of 12317230020771

        The error above is due to RMAN looking for the next log for recovery which does not exit yet. This can be ignored in this case.
        ```
- [ ] ~~`rman TARGET sys/ncu5540@ESHIP AUXILIARY sys/ncu5540@ESHIP`(因網路頻寬限制不適用)~~
- script
    ```bash
    #!/bin/bash
    NOW=`date +%Y-%m-%d-%H%M`
    $ORACLE_HOME/bin/rman target / nocatalog log=$HOME/log/rman-restore-$NOW.log << EOF
    run {
        shutdown immediate;
        startup nomount;
        restore standby controlfile from '/backup_new/2020-06-10/ESHIP_cntl_71803_1_1042710468.bak';

        alter database mount;
        restore database;
        restore archivelog all;
    }
    EOF
    ```

## Mount the physical standby, start processing redo on the standby
```sql
shutdown immediate;
startup nomount;
alter database mount standby database;
alter database recover managed standby database disconnect from session;
```
- [11g 後可以用 read only 繼續接收 redo log](https://blogs.oracle.com/database4cn/11g-active-data-guard)
- 背景執行 log apply services
- 執行 managed recovery 後，standby database 就會吃 primary archived redo logs(開始 sync)
    - ![](https://docs.oracle.com/cd/B10501_01/server.920/a96653/redoapply.gif)

### 暫停 Standby Status
```sql
alter database recover managed standby database cancel;
alter database open read only;
```
- ![](https://docs.oracle.com/cd/B10501_01/server.920/a96653/sbr81099.gif)

## 檢查 Primary、Standby Site 狀態
- check log: `cd /u01/oracle/diag/rdbms/eship_stb/ESHIP/trace`
    - `cat alert_ESHIP.log | grep "RFS"`
        - RFS\[2\]: Opened log for thread 1 sequence 603 dbid 244859031 branch 1034179942
        - RFS: remote file server，從 primary 收集 redo logs
- check status: `select name, open_mode, protection_mode, database_role, switchover_status from v$database;`
    - primary: TO STANDBY；standby: NOT ALLOWED
- check sequence: `select process, status, thread#, sequence#, block#, blocks from v$managed_standby;`

###  Archive gap sequence
- 確認是否有 gap
    - if the LOW_SEQUENCE# is less than the HIGH_SEQUENCE# in the output, the database is having a gap sequence
    - `select thread#, low_sequence#, high_sequence# from v$archive_gap;`
        ![](../../../file/img/learning/oracle/dataguard/dg-archive-gap.png)
- 找出 standby 最小 SCN
    - `select to_char(current_scn) from v$database;`
        ```text
        TO_CHAR(CURRENT_SCN)
        ----------------------------------------
        XXXXXXXX
        ```
- 確認 primary 沒有在 update datafile
    - `select file#,name from v$datafile where creation_change# >= XXXXXXXX;`
- 停止 redo apply on standby
    - `alter database recover managed standby database cancel;`
- incremental backup on primary
    - `RMAN> backup incremental from scn 12325911764204 database format '/backup_new/resovle-archive-gap/%d_%u.bak';`
- create standby controlfile
    - `RMAN> backup format '/backup_new/resovle-archive-gap/%d_%U_stbctl.bak' current controlfile;`
- 複製到 standby
    - `scp -r -l 30000 /backup_new/ESHIP* root@autcrptdb1:/backup/ESHIP_NEW`
- recover standby
    - `RMAN> restore standby controlfile from '/backup_new/ESHIP_71v61r4r_1_1_stbctl.bak';`
    - `alter database mount;`
    - `RMAN> recover database noredo;`
- 重開 DB
    - `shutdown immediate;`
    - `startup mount;`
- 執行 redo apply on standby
    - `alter database recover managed standby database disconnect from session;`
- switch redo log
    - `alter system switch logfile;`

## Start shipping redo from the primary to the standby database server
- primary 的參數: log_archive_dest_state_2=ENABLE

## Verify redo is shipping
- [x] 到 primary 執行 log 轉換
    ```sql
    alter system switch logfile;
    ```
- 檢查一致性
    ```sql
    select * from v$archive_dest_status where status != 'INACTIVE';
    select sequence#, applied, to_char(first_time,'mm/dd/yy hh24:mi:ss') first from v$archived_log order by first_time;
    select sequence# from v$log order by sequence#;
    ```

## Add Temp Files to the Standby Database(用 RMAN 可忽略)

## Configure Data Guard Broker (optional)

## Role transitions
### 名詞解釋
- NOT ALLOWED
    1. primary 來說無 standby 設定
    2. standby 還沒轉換成 primary
- SESSIONS ACTIVE - Indicates that there are active SQL sessions attached to the primary or standby database that need to be disconnected before the switchover operation is permitted.
- SWITCHOVER PENDING - This is a standby database and the primary database switchover request has been received but not processed.
- SWITCHOVER LATENT - The switchover was in pending mode, but did not complete and went back to the primary database.
- TO PRIMARY - This is a standby database, with no active sessions, that is allowed to switch over to a primary database.
- TO STANDBY - This is a primary database, with no active sessions, that is allowed to switch over to a standby database.
- RECOVERY NEEDED - This is a standby database that has not received the switchover request.

### Switchover
此為計劃內的轉換，不會有 data loss
- [Oracle 11gR2 DataGuard switchover 切換的兩個錯誤狀態解決](https://www.twblogs.net/a/5b9581282b717750bda4ecb2)
- 確認 primary 是 open; sandby 是 mount(**read-only 似乎不能轉換 !?**)
- 確認 status: `select switchover_status from v$database;`
- primary 切換成 standby: `alter database recover managed standby database disconnect from session;`
- standby status: `select switchover_status from v$database;`
    - standby: NOT ALLOWED → TO PRIMARY
- standby 切斷 redo log apply，啓用日誌同步: `alter database recover managed standby database disconnect from session;`
- 切換 standby 為 primary: `alter database commit to switchover to primary with session shutdown;`
- 打開數據庫: `alter database open;`
- 丟 log: `alter system switch logfile;`
- 檢查 log 狀態: `select sequence#, standby_dest, archived, applied, status from v$archived_log;`

### Failover
- [Data Guard 高級玩法-閃回恢復 failover 備庫](https://kknews.cc/zh-tw/code/venb62.html)
- 掛載 primary's database，不要 open
    - `alter system flush redo to 'target_db_name(ESHIP_STB)';`
- 確認 sequence number 一致性
    - `select unique thread# as thread, max(sequence#) over (partition by thread#) as last from v$archived_log;`
- 解決 any archived redo log gaps
    - `select * from v$archive_gap;`
        ```
        THREAD# LOW_SEQUENCE# HIGH_SEQUENCE#
        ---------- ------------- --------------
                1            68            598
        ```
    - 如果以上語法有資料時，代表至少有一筆 standby archive log 是 missing，此時在 promary 執行以下語法
        ```sql
        select name from v$archived_log
        where thread# = 1 and
              sequence# between 68 and 598;
        ```

### Switchback

# Prepare
## To do list
- [x] group: `cat /etc/group | sort -i | grep -P "(dba|oinstall)"`
    ```
    dba:x:501:oraeship,oraoem
    oinstall:x:502:oraeship,oraoem
    ```
- [x] passwd: `cat /etc/passwd | sort -i | grep -P "(ora)"`
    ```
    oraeship:x:501:1001::/home/oraeship:/bin/bash
    oraoem:x:1001:501::/home/oraoem:/bin/bash
    ```

# 注意事項
## 傳輸限流
```bash
# 下班後做不會被 highlight
scp -p -l 30000 /backup_new/eship_\* root@autcrptdb1:/backup/ESHIP_NEW
scp -p -l 30000 /backup_new/2020-06-10/ESHIP_\* root@autcrptdb1:/backup/ESHIP_NEW
scp -r -l 30000 /backup_new/2020-06-10 root@autcrptdb1:/backup/ESHIP_NEW
```

## OS 狀態
- CPU
    - ![](../../../file/img/learning/oracle/dataguard/dg-cpu-info.png)
- RMA
    - ![](../../../file/img/learning/oracle/dataguard/dg-ram-info.png)

## 除錯專區
### Kill Session
- `ps -ef | grep dbw | grep -v grep`
    - `ps -ef | grep ora_dbw | grep -v grep | awk '{print $2}'`
- `ps -ef | grep tns | grep -v grep`

### Check firewall
`netstat -lnt | grep 1521`
```
tcp6       0      0 :::1521                 :::*                    LISTEN
```