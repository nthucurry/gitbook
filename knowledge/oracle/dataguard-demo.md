# Data Guard 環境配置
## bash_profile
```bash
export ORACLE_SID=DEMO
export ORACLE_UNQNAME=DEMO # distinguish between primary and standby database
export ORACLE_BASE=/u01/oracle
export ORACLE_HOME=$ORACLE_BASE/11204
export TNS_ADMIN=$ORACLE_HOME/network/admin
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
export CLASSPATH
PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export PATH

# Alias
alias sqlp='sqlplus / as sysdba'
alias rm='rm -i'
alias vi='vim'
alias grep='grep --color=always'
alias tree='tree --charset ASCII'
#alias bdump="cd /u01/oracle/diag/rdbms/demo/DEMO/trace"
#alias bdump="cd /u01/oracle/diag/rdbms/demo_stb/DEMO/trace"
```

## listener.ora
### primary
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

## Automatic Diagnostic Repository
ADR_BASE_LISTENER = /u01/oracle
```

### standby
```txt
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = standby)(PORT = 1521))
    )
  )

SID_LIST_LISTENER =
    (SID_LIST =
        (SID_DESC =
            (SID_NAME = DEMO)
            (ORACLE_HOME = /u01/oracle/11204)
        )
    )

## Automatic Diagnostic Repository
ADR_BASE_LISTENER = /u01/oracle
```

## tnsname.ora
### primary
```txt
DEMO =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = primary)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = DEMO)
    )
  )

DEMO_STB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = standby)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = DEMO)
    )
  )
```

### standby
```txt
DEMO =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = primary)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = DEMO)
    )
  )

DEMO_STB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = standby)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = DEMO)
    )
  )
```

## init[DEMO].ora
### init[DEMO].ora
```txt
##### main config #####
#*.audit_file_dest='/u01/oracle/admin/DEMO/adump'
*.audit_trail='db'
*.compatible='11.2.0.0.0'
*.control_files='/u01/oradata/DEMO/control01.ctl','/u01/oradata/DEMO/control02.ctl'
*.db_block_size=8192
*.db_domain='world'
*.db_name='DEMO'
*.diagnostic_dest='/u01/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=DEMOXDB)'
*.log_archive_dest_1='LOCATION=/u01/oraarch'
*.log_archive_format='DEMO-%t_%s_%r.dbf'
*.memory_target=1588592640
*.open_cursors=300
*.processes=150
*.remote_login_passwordfile='EXCLUSIVE'
#*.undo_tablespace='UNDOTBS1'

IFILE=/u01/oracle/11204/dbs/initDEMO_ifile.ora
```

### primary ifile
```txt
##### data guard config #####
*.db_unique_name='DEMO'
#*.fal_server='DEMO' # where to get archived logs
*.job_queue_processes=1000
*.log_archive_config='DG_CONFIG=(DEMO,DEMO_STB)'
*.log_archive_dest_2='SERVICE=DEMO_STB NOAFFIRM ASYNC VALID_FOR=(ALL_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=DEMO_STB COMPRESSION=ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_min_succeed_dest=1
*.standby_file_management='AUTO'
```

### standby ifile
```txt
##### data guard config #####
*.db_unique_name='DEMO_STB'
*.fal_server='DEMO'
*.job_queue_processes=0
*.log_archive_config='DG_CONFIG=(DEMO,DEMO_STB)'
*.log_archive_dest_2='SERVICE=DEMO NOAFFIRM ASYNC VALID_FOR=(ALL_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=DEMO COMPRESSION=ENABLE'
*.log_archive_dest_state_2='DEFER'
*.log_archive_min_succeed_dest=1
*.log_file_name_convert='dummy','dummy'
*.standby_file_management='AUTO'
```

## check command
### Update spfile
```sql
create spfile from pfile;
```

### Primary
```sql
alter database force logging;
alter system switch logfile;
```

### Standby
```sql
alter database recover managed standby database disconnect from session;
```

### Check
#### Software
```sql
-- 增加視窗寬度
set linesize 200

-- sequence and & applied redo log(standby: redo apply YES)
select
    name,
    sequence#,
    applied,
    creator,
    registrar,
    FAL,
    to_char(first_time,'mm/dd hh24:mi') as first,
    to_char(next_time,'mm/dd hh24:mi') as next
from v$archived_log
order by first_time;

-- primary DB archive status
select * from v$archive_dest_status where status != 'INACTIVE';

-- switchover status(primary: TO STANDBY;standby: NOT ALLOWED)
select name, open_mode, database_role, switchover_status from v$database;

-- there are missing archive logs on the standby database server(no selected rows is right)
select * from v$archive_gap;
```

#### Hardware
```bash
ping [IP]
telnet [IP] [port]
traceroute [IP]
```

## Debug
### Archive gap sequence
```sql
-- 確認是否有 gap
select thread#, low_sequence#, high_sequence# from v$archive_gap;

-- 找出最小 SCN on standby
select to_char(current_scn) from v$database;
    /*
    TO_CHAR(CURRENT_SCN)
    ----------------------------------------
    XXXXXXXX
    */

-- 確認 primary 沒有在 update datafile
select file#,name from v$datafile where creation_change# >= XXXXXXXX;

-- 停止 redo apply from primary to standby
alter database recover managed standby database cancel;

-- incremental backup on primary (RMAN)
backup incremental from scn 12325911764204 database format '/backup_new/resovle-archive-gap/%d_%u.bak';

-- create standby controlfile on primary (RMAN, option)
backup format '/backup_new/resovle-archive-gap/%d_%U_stbctl.bak' current controlfile;

-- backup files 複製到 standby
scp -r -l 30000 /backup_new/resovle-archive-gap/ demo@standby:/backup_new/

-- recover standby (RMAN)
alter database dismount;
restore standby controlfile from '/backup_new/resovle-archive-gap/DEMO_71v61r4r_1_1_stbctl.bak';
alter database mount;
recover database noredo;

-- 重開 DB
shutdown immediate;
startup mount;

-- 執行 redo apply on standby (RMAN)
alter database recover managed standby database disconnect from session;

-- switch redo log (RMAN)
alter system switch logfile;
```

### Change standby to primary database
```sql
-- initiate the failover operation on the target standby database.
alter database recover managed standby database finish;

-- convert standby database to the primary role.
alter database commit to switchover to primary;

-- 重啟 the new primary database.
shutdown immediate;
startup;
```