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
    sum_squares
FROM DBA_HIST_SYSMETRIC_SUMMARY
WHERE
    metric_name = 'Host CPU Utilization (%)'
    AND begin_time BETWEEN sysdate - 1 AND sysdate - 0
ORDER BY begin_time DESC;