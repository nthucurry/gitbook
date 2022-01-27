#!/bin/bash

schema=$1

cat >> $HOME/monitor-script.sql << EOF
SELECT
owner,
table_name,
num_rows,
ROUND(blocks * (SELECT value FROM v\$parameter WHERE name = 'db_block_size')/1024/1024,3) "Size MB",
TO_CHAR(last_analyzed, 'YYYY-MM-DD HH24:MI:SS') "last_analyzed",
TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') "query_time",
tablespace_name
FROM dba_tables
WHERE owner NOT IN ('SYS','SYSTEM','SYSMAN') AND blocks IS NOT NULL AND owner = '$schema'
ORDER BY blocks DESC;
EOF