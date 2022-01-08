# 排程
## 建立排程
```txt
0 1 * * * /home/demo/scripts/fullBackup.sh
0 3 * * * /home/demo/scripts/delFullBackup.sh
0 5 * * * /home/demo/scripts/delArch.sh
```

## 備份
- `vi fullBackup.sh`
    ```bash
    #!/bin/bash

    . ~/.bash_profile

    NOW=`date +%Y-%m-%d-%H%M`
    TODAY=`date +%Y-%m-%d`
    MONTH=`date +%Y-%m`
    BKDIR="/backup_new/$TODAY"
    LOGDIR="$HOME/log/$MONTH"

    mkdir -p $BKDIR
    mkdir -p $LOGDIR

    $ORACLE_HOME/bin/rman target / nocatalog log=$LOGDIR/rman-fullbk-$NOW.log << EOF
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

## 刪除不需要的 Backup File
- `vi delFullBackup.sh`
    ```bash
    #!/bin/bash

    NOW=`date +%Y-%m-%d-%H%M`
    TODAY=`date +%Y-%m-%d`
    MONTH=`date +%Y-%m`
    BKDIR="/backup_new"
    DAYS=7

    echo "================================="
    echo "delete backup file $DAYS days ago"
    echo "================================="

    echo $NOW >> $HOME/scripts/log/del-bak-$MONTH.errlog

    find $BKDIR -type f -mtime +$DAYS -name "$ORACLE_SID*.bak" -print | while read i;
    do
        echo "rm $BKDIR/$i" 2>> $HOME/scripts/log/del-bak-$MONTH.errlog
    #    rm $i
    done

    echo "================================="
    echo "delete empty folder"

    echo $NOW >> $HOME/scripts/log/del-empty-folder-$MONTH.errlog

    ls $BKDIR | while read line;
    do
        rmdir $BKDIR/$line 2>> $HOME/scripts/log/del-empty-folder-$MONTH.errlog
    done

    echo "================================="
    ```

## 刪除不需要的 Archive Log
- `vi delArch.sh`
    ```bash
    . ~/.bash_profile

    $ORACLE_HOME/bin/rman target / nocatalog << EOF
    run {
        delete force noprompt copy of archivelog all completed before 'sysdate-12/24';
    }
    EOF
    ```