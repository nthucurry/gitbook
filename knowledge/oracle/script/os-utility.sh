#/bin/bash

. ~/.bash_profile

month=`date +%Y-%m`
main_path=$HOME/get_os_usage
utility_type=$1 # cpu & ram

cat $main_path/login-info.csv | while read line
do

if [[ $line == *"$"* ]]; then
echo $line
else

account=`echo $line | awk 'BEGIN {FS=","} {print $1}'`
password=`echo $line | awk 'BEGIN {FS=","} {print $2}'`
sid=`echo $line | awk 'BEGIN {FS=","} {print $3}'`
output_file=${main_path}/${month}-${sid}-${1}-utility.csv

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

spool $main_path/temp.log
@$main_path/os-$1.sql
spool off
quit
/
EOF

cat $main_path/temp.log >> $output_file
sed -i "/^$/d" $output_file
rm $main_path/temp.log

fi

done