# RMAN script
## Backup
```bash
#### filename: backup.sh
#!/bin/bash
NOW=`date +%Y%m%d`
$ORACLE_HOME/bin/rman target / nocatalog log=$HOME/backup-$NOW.log << EOF
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
#### filename: restore.sh
#!/bin/bash
. ~/.bash_profile
NOW=`date +%Y%m%d`
$ORACLE_HOME/bin/rman target / nocatalog log=$HOME/restore-$NOW.log << EOF
run {
    startup nomount;
    restore controlfile from '/backup_new/2020-06-10/DEMO_cntl_71803_1_1042710468.bak';

    alter database mount;
    restore database;
    restore archivelog all;
    recover database;
}
EOF
```

## Troubleshooting
### Control file 太新
- 執行此動作後出現錯誤: `recover database;`
```txt
channel c1: reading from backup piece /backup/20201124/DEMO_arch_128556_1_1057277750.bak
channel c1: piece handle=/backup/20201124/DEMO_arch_128556_1_1057277750.bak tag=TAG20201124T001547
channel c1: restored backup piece 1
channel c1: restore complete, elapsed time: 00:01:05
archived log file name=/u01/oraarch/DEMO/DEMO_1_528774_767540243.dbf thread=1 sequence=528774
archived log file name=/u01/oraarch/DEMO/DEMO_1_528775_767540243.dbf thread=1 sequence=528775
archived log file name=/u01/oraarch/DEMO/DEMO_1_528776_767540243.dbf thread=1 sequence=528776
archived log file name=/u01/oraarch/DEMO/DEMO_1_528777_767540243.dbf thread=1 sequence=528777
unable to find archived log
archived log thread=1 sequence=528778
released channel: c1
released channel: c2
RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: failure of recover command at 11/25/2020 10:18:32
RMAN-06054: media recovery requesting unknown archived log for thread 1 with sequence 528778 and starting SCN of 12341005809871

RMAN>

Recovery Manager complete.
```
- 檢查 archive log 是否存在: `ls -l /backup/20201124/DEMO_arch_12855*`
    ```txt
    -rw-r----- 1 demo dba  663282176 Nov 24 00:18 /backup/20201124/DEMO_arch_128550_1_1057277750.bak
    -rw-r----- 1 demo dba  613153792 Nov 24 00:18 /backup/20201124/DEMO_arch_128551_1_1057277750.bak
    -rw-r----- 1 demo dba  598154240 Nov 24 00:18 /backup/20201124/DEMO_arch_128552_1_1057277750.bak
    -rw-r----- 1 demo dba  586725888 Nov 24 00:18 /backup/20201124/DEMO_arch_128553_1_1057277750.bak
    -rw-r----- 1 demo dba  612353024 Nov 24 00:18 /backup/20201124/DEMO_arch_128554_1_1057277750.bak
    -rw-r----- 1 demo dba  600257024 Nov 24 00:18 /backup/20201124/DEMO_arch_128555_1_1057277750.bak
    -rw-r----- 1 demo dba  535184384 Nov 24 00:17 /backup/20201124/DEMO_arch_128556_1_1057277750.bak
    -rw-r----- 1 demo dba  993781760 Nov 24 08:04 /backup/20201124/DEMO_arch_128558_1_1057305618.bak
    -rw-r----- 1 demo dba 1045881856 Nov 24 08:04 /backup/20201124/DEMO_arch_128559_1_1057305618.bak
    ```
- 確實缺少
- 缺 DEMO_arch_128557_1_1057277750.bak，需補齊
    - recover database until sequence 528778;
- 假設連備份區都沒了檔案，直接試試看這個: alter database backup controlfile to trace;
- shutdown immediate
- startup nomount
- @cr.sql
- alter database open resetlogs;
- select name, open_mode, database_role, switchover_status from v$database
    ```txt
    NAME      OPEN_MODE            DATABASE_ROLE    SWITCHOVER_STATUS
    --------- -------------------- ---------------- --------------------
    DEMO      READ WRITE           PRIMARY          NOT ALLOWED
    ```

### Control file 是 standby 模式