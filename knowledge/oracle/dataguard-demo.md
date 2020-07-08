# 建置 Data Guard 環境配置
## bash_profile
```bash
export ORACLE_SID=DEMO
export ORACLE_UNQNAME=DEMO
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
### init[DEMO]_ifile.ora
```txt
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
```

### primary
```txt
##### config #####
*.db_unique_name='DEMO'
*.fal_server='DEMO'
*.job_queue_processes=1000
*.log_archive_config='DG_CONFIG=(DEMO,DEMO_STB)'
*.log_archive_dest_2='SERVICE=DEMO_STB NOAFFIRM ASYNC VALID_FOR=(ALL_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=DEMO_STB COMPRESSION=ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_min_succeed_dest=1
*.standby_file_management='AUTO'

IFILE=/u01/oracle/11204/dbs/initDEMO_ifile.ora
```

### standby
```txt
##### config #####
*.db_unique_name='DEMO_STB'
*.fal_server='DEMO'
*.job_queue_processes=0
*.log_archive_config='DG_CONFIG=(DEMO,DEMO_STB)'
*.log_archive_dest_2='SERVICE=DEMO NOAFFIRM ASYNC VALID_FOR=(ALL_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=DEMO COMPRESSION=ENABLE'
*.log_archive_dest_state_2='DEFER'
*.log_archive_min_succeed_dest=1
*.log_file_name_convert='dummy','dummy'
*.standby_file_management='AUTO'

IFILE=/u01/oracle/11204/dbs/initDEMO_ifile.ora
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
# 增加視窗寬度
set linesize 170

# sequence and & applied redo log(standby: redo apply YES)
select
    name,sequence#,applied,creator,registrar,FAL,
    to_char(first_time,'mm/dd/yy hh24:mi:ss') as first,
    to_char(next_time,'mm/dd/yy hh24:mi:ss') next
from v$archived_log
order by first_time;

# primary DB archive status
select * from v$archive_dest_status where status != 'INACTIVE';

# switchover status(primary: TO STANDBY;standby: NOT ALLOWED)
select name, open_mode, database_role, switchover_status from v$database;

# there are missing archive logs on the standby database server(no selected rows is right)
select * from v$archive_gap;
```

#### Hardware
```bash
ping [IP]
telnet [IP] [port]
traceroute [IP]
```