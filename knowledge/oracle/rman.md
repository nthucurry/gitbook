# RMAN script
## Backup
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
- 如果 archive log 有缺
    ```txt
    RMAN-00571: ===========================================================
    RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
    RMAN-00571: ===========================================================
    RMAN-03002: failure of backup command at 11/18/2020 23:17:32
    RMAN-06059: expected archived log not found, loss of archived log compromises recoverability
    ORA-19625: error identifying file /u01/oraarch/ERP/ERP_1_13_1054646243.dbf
    ORA-27037: unable to obtain file status
    Linux-x86_64 Error: 2: No such file or directory
    ```
    - `RMAN> crosscheck archivelog all;`

## Restore
```bash
#!/bin/bash
NOW=`date +%Y-%m-%d-%H%M`
$ORACLE_HOME/bin/rman target / nocatalog log=$HOME/log/rman-restore-$NOW.log << EOF
run {
    shutdown immediate;
    startup nomount;
    restore standby controlfile from '/backup_new/2020-06-10/DEMO_cntl_71803_1_1042710468.bak';

    alter database mount;
    restore database;
    restore archivelog all;
}
EOF
```