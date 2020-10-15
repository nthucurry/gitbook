-- CPU
SELECT
    (SELECT name FROM v$database)||','||
    instance_number||','||
    to_char(begin_time,'YYYY-MM-DD HH24:MI:SS')||','||
    to_char(end_time,'YYYY-MM-DD HH24:MI:SS')||','||
    metric_name||','||
    /*metric_unit,*/
    minval||','||
    maxval||','||
    average||','||
    standard_deviation||','||
    sum_squares AS CPU
FROM DBA_HIST_SYSMETRIC_SUMMARY
WHERE
    metric_name = 'Host CPU Utilization (%)'
    AND end_time BETWEEN to_date(to_char(sysdate-1,'YYYY-MM-DD'),'YYYY-MM-DD HH24:MI:SS')
                     AND to_date(to_char(sysdate-1,'YYYY-MM-DD')||'23:59:59','YYYY-MM-DD HH24:MI:SS')
ORDER BY end_time;

-- RAM
SELECT * FROM v$sysmetric_summary WHERE metric_name LIKE '%PGA%';
SELECT
    (SELECT name FROM v$database)||','||
    instance_number||','||
    to_char(begin_time,'YYYY-MM-DD HH24:MI:SS')||','||
    to_char(end_time,'YYYY-MM-DD HH24:MI:SS')||','||
    metric_name||','||
    /*metric_unit,*/
    minval/1024/1024||','||
    maxval/1024/1024||','||
    average/1024/1024||','||
    standard_deviation/1024/1024||','||
    sum_squares/1024/1024 AS RAM
FROM DBA_HIST_SYSMETRIC_SUMMARY
WHERE
    metric_name = 'Total PGA Allocated'
    AND end_time BETWEEN to_date(to_char(sysdate-1,'YYYY-MM-DD'),'YYYY-MM-DD HH24:MI:SS')
                     AND to_date(to_char(sysdate-1,'YYYY-MM-DD')||'23:59:59','YYYY-MM-DD HH24:MI:SS')
ORDER BY end_time;