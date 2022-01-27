#!/bin/bash

source $HOME/.bash_profile

getYY=`date +%Y`
getMM=`date +%m`
getDD=`date +%d`
getHH=`date +%H`

cat $HOME/db-tb-list.csv | while read line
do

sid=`echo $line | awk 'BEGIN {FS=","} {print $1}'`
schema=`echo $line | awk 'BEGIN {FS=","} {print $2}'`
account=`echo $line | awk 'BEGIN {FS=","} {print $3}'`
password=`echo $line | awk 'BEGIN {FS=","} {print $4}'`

# delete monitor SQL
[[ -f $HOME/monitor-script.sql ]] && rm $HOME/monitor-script.sql

# update monitor SQL
$HOME/update-monitor-script.sh $schema

$ORACLE_HOME/bin/sqlplus -s ${account}/${password}@${sid} << EOF
set term off
set heading off
set pagesize 24
set linesize 200
set trimout on
set trimspool on
set echo off
set termout off
set feedback off
spool $HOME/log/$sid-$schema-$getYY-$getMM$getDD-$getHH.log
@$HOME/monitor-script.sql
spool off
quit
/
EOF

sed -i "/^$/d" $HOME/log/$sid-$schema-$getYY-$getMM$getDD-$getHH.log

done