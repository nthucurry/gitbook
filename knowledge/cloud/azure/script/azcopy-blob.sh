#!/bin/bash

source ~/.bash_profile

exec_time=`date +%Y-%m%d-%H%M`

[[ -f sync-blob-command.sh ]] && rm sync-blob-command.sh || touch sync-blob-command.sh

cat storage-list.csv | while read line;
do

if [[ $line != *"#"* ]]; then

src_storage_account_name=`echo $line | awk 'BEGIN {FS=","} {print $1}' | tr -s [:space:]`
src_container_name=`echo $line | awk 'BEGIN {FS=","} {print $2}' | sed 's/\s//g'`
src_SAS_token=`echo $line | awk 'BEGIN {FS=","} {print $3}' | sed 's/\s//g'`
dst_storage_account_name=`echo $line | awk 'BEGIN {FS=","} {print $4}' | sed 's/\s//g'`
dst_container_name=`echo $line | awk 'BEGIN {FS=","} {print $5}' | sed 's/\s//g'`
dst_SAS_token=`echo $line | awk 'BEGIN {FS=","} {print $6}' | sed 's/\s//g'`

echo "$exec_time source: $src_storage_account_name / $src_container_name ---> destination: $dst_storage_account_name / $dst_container_name" >> azcopy.log

#azcopy cp \
#"https://$src_storage_account_name.blob.core.windows.net/$src_container_name$src_SAS_token" \
#"https://$dst_storage_account_name.blob.core.windows.net/$dst_container_name$dst_SAS_token" \
#--recursive"

echo "\
azcopy sync \
"\'https://$src_storage_account_name.blob.core.windows.net/$src_container_name$src_SAS_token\'" \
"\'https://$dst_storage_account_name.blob.core.windows.net/$dst_container_name$dst_SAS_token\'" \
--recursive\
" >> sync-blob-command.sh

fi

done

chmod +x sync-blob-command.sh
$HOME/sync-blob-command.sh