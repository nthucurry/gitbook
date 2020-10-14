#/bin/bash

month=`date +%Y-%m`
output_file="${month}-cpu-utility.csv"

sqlplus -s system/oracle << EOF

set term off
set heading off
set pagesize 0
set linesize 200
set trimout on
set trimspool on
set echo off
set termout off

spool temp.log
@os-utility.sql
spool off
quit
/
EOF

cat temp.log >> $output_file
sed -i "/^$/d" $output_file