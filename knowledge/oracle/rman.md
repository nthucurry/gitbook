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