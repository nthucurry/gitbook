# 開機時啟動
## crontab
```txt
@reboot /bin/vncserver :1
@reboot /home/oracle/startup.sh
@reboot /home/oracle/del_arch.sh # 刪除 archive log
```

## Startup DB, listener and EM
```bash
#/bin/bash

. ~/.bash_profile
NOW=`date +%Y-%m-%d-%H%M`
$ORACLE_HOME/bin/lsnrctl start
$ORACLE_HOME/bin/sqlplus / as sysdba << EOF
startup
quit;
EOF

# $ORACLE_HOME/bin/emctl start dbconsole
# $HOME/fullBackup.sh
```

## Backup
```bash
#!/bin/bash

. ~/.bash_profile
NOW=`date +%Y-%m-%d-%H%M`
TODAY=`date +%Y-%m-%d`
MONTH=`date +%Y-%m`
BKDIR="/backup_new/$TODAY"
LOGDIR="$HOME/log/"

mkdir -p $BKDIR
mkdir -p $LOGDIR

$ORACLE_HOME/bin/rman target / nocatalog log=$LOGDIR/fullbk-$NOW.log << EOF
run {
    # backup database
    backup as compressed backupset
    incremental level 0
    check logical
        database format '$BKDIR/%d_%s_%p_%t.bak';

    # backup archive log
    backup as compressed backupset
        archivelog all format '$BKDIR/%d_arch_%s_%p_%t.bak';
    delete force noprompt copy of archivelog all completed before 'sysdate-1';

    # backup control file
    allocate channel d1 type disk;
    backup
        format '$BKDIR/%d_cntl_%s_%p_%t.bak'
        current controlfile;
    release channel d1;
}
EOF
```
