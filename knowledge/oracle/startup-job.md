# Schedule of startup OS
## crontab
```txt
@reboot /bin/vncserver :1
@reboot /home/oraeship/startup-init.sh
@reboot /home/oraeship/del_arch.sh # 刪除 archive log
```

## Startup DB, listener and EM
```bash
#/bin/bash

export ORACLE_SID=DEMO
export ORACLE_HOME=/u01/oracle/11204
export TNS_ADMIN=$ORACLE_HOME/network/admin

NOW=`date +%Y-%m-%d-%H%M`
$ORACLE_HOME/bin/lsnrctl start > /home/oraeship/log/lsnrctl-$NOW.log
$ORACLE_HOME/bin/sqlplus / as sysdba > /home/oraeship/log/startup-$NOW.log << EOF
startup;
quit;
EOF

$ORACLE_HOME/bin/emctl start dbconsole > /home/oraeship/log/emctl-$NOW.log

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

## Delete archive log
```bash
. ~/.bash_profile # = source ~/.bash_profile

$ORACLE_HOME/bin/rman target / nocatalog << EOF
run {
    delete force noprompt copy of archivelog all completed before 'sysdate-1';
}
EOF
```