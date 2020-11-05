SELECT
    name,
    sequence#,
    applied,
    creator,
    registrar,
    FAL,
    to_char(first_time,'mm/dd hh24:mi') as first,
    to_char(next_time,'mm/dd hh24:mi') as next
FROM v$archived_log
ORDER BY first_time DESC;

SELECT * FROM v$archive_dest_status WHERE status != 'INACTIVE';

SELECT name, open_mode, database_role, switchover_status FROM v$database;
