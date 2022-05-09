# Recovery Manager (RMAN)
## Prompt
- control file 一定要最後，不然不會記錄到 datafile、archivelog 的資訊
- [大補帖](https://kknews.cc/code/ky5jo2b.html)
- https://docs.oracle.com/cd/B19306_01/backup.102/b14194/rcmsynta033.htm
- 轉換成 no-archive mode
    ```
    SQL> shutdown immediate
    SQL> startup mount
    SQL> alter database archivelog;
    SQL> alter database open;
    SQL> archive log list;
    ```

## Backup
- `vi backup.sh`
    ```bash
    #!/bin/bash
    source ~/.bash_profile
    TODAY=`date +%Y-%m-%d`
    BKDIR="/backup/$TODAY"
    $ORACLE_HOME/bin/rman target / nocatalog log=$HOME/backup-$TODAY.log << EOF
    run {
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
        ```
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
            - 手工清除 datafile 後，從 control fiile 去檢查缺少哪些 datafile

## Restore
- `vi restore.sh`
    ```bash
    #!/bin/bash
    . ~/.bash_profile
    TODAY=`date +%Y-%m-%d`
    $ORACLE_HOME/bin/rman target / nocatalog log=$HOME/restore-$TODAY.log << EOF
    run {
        startup nomount
        restore controlfile from '/backup_new/2020-06-10/DEMO_cntl_71803_1_1042710468.bak';

        alter database mount;
        restore database;
        restore archivelog all;
        recover database;
    }
    EOF
    ```

## Delete
- `vi delete_archive_log.sh`
    ```bash
    #/bin/bash
    source ~/.bash_profile # = source ~/.bash_profile
    $ORACLE_HOME/bin/rman target / nocatalog << EOF
    run {
        delete force noprompt copy of archivelog all completed before 'sysdate-1';
    }
    EOF
    ```
    - 只刪除一天以前的 archive log

## Check
### 清除人工刪除的檔案，但還留在 control file 的檔案(仍保留 metadata)
- `delete backup;`
- `crosscheck database;`
- `delete expired backup;`
- `report backup;`

## Troubleshooting
### inconsist restore 還原失敗
```
archived log for thread 1 with sequence 62 is already on disk as file /u01/oraarch/ERP/ERP_1_62_1054646243.dbf
archived log file name=/u01/oraarch/ERP/ERP_1_62_1054646243.dbf thread=1 sequence=62
archived log file name=/u01/oraarch/ERP/ERP_1_63_1054646243.dbf thread=1 sequence=63
unable to find archived log
archived log thread=1 sequence=64
RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: failure of recover command at 12/09/2020 23:21:13
RMAN-06054: media recovery requesting unknown archived log for thread 1 with sequence 64 and starting SCN of 3522838
```
- 執行
    ```
    RMAN> run {
    2> set until sequence 63 thread 1;
    3> restore database;
    4> recover database;
    5> }
    ```

### Control file 太新
- 執行此動作後出現錯誤: `recover database;`
```
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
    ```k
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
- select name, open_mode, database_role, switchover_status from v$database;
    ```
    NAME      OPEN_MODE            DATABASE_ROLE    SWITCHOVER_STATUS
    --------- -------------------- ---------------- --------------------
    DEMO      READ WRITE           PRIMARY          NOT ALLOWED
    ```

### Control file 是 standby 模式