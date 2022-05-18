backup_source="cpdbk-2021-0727"
restore_name_identifier=$backup_source

~/ibm/cpd-cli backup-restore quiesce -n zen
~/ibm/cpd-cli backup-restore volume-restore create --from-backup $backup_source -n zen $restore_name_identifier --skip-quiesce=true
~/ibm/cpd-cli backup-restore unquiesce -n zen