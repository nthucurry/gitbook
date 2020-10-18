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

-- http://pawaramitdba.blogspot.com/2014/12/how-to-find-history-of-sgapaga-usage.html
SELECT * FROM dba_hist_snapshot;
SELECT * FROM DBA_HIST_SGASTAT;
SELECT * FROM DBA_HIST_PGASTAT;
SELECT
	(SELECT name FROM v$database) SID,
	sn.instance_number,
	to_char(sn.begin_interval_time,'YYYY-MM-DD HH24:MI:SS') begin_time,
    to_char(sn.end_interval_time,'YYYY-MM-DD HH24:MI:SS') end_time,
	sga.allo SGA,
	pga.allo PGA,
    (sga.allo + pga.allo) TOT
FROM
    (SELECT snap_id,instance_number,round(sum(bytes)/1024/1024/1024,3) allo
        FROM DBA_HIST_SGASTAT
        GROUP BY snap_id,instance_number) sga,
    (SELECT snap_id,instance_number,round(sum(value)/1024/1024/1024,3) allo
        FROM DBA_HIST_PGASTAT 
        WHERE name = 'total PGA allocated'
        GROUP BY snap_id,instance_number) pga,
    dba_hist_snapshot sn
WHERE
    sn.snap_id = sga.snap_id
    AND sn.instance_number = sga.instance_number
    AND sn.snap_id = pga.snap_id
    AND sn.instance_number = pga.instance_number
ORDER BY sn.snap_id DESC, sn.instance_number;

SELECT
	(SELECT name FROM v$database)||','||
	sn.instance_number||','||
	to_char(sn.begin_interval_time,'YYYY-MM-DD HH24:MI:SS')||','||
    to_char(sn.end_interval_time,'YYYY-MM-DD HH24:MI:SS')||','||
	/*sga.allo||','||*/
	/*pga.allo||','||*/
    (sga.allo + pga.allo)
FROM dba_hist_snapshot sn
INNER JOIN 
    (SELECT snap_id,instance_number,round(sum(bytes)/1024/1024/1024,3) allo
        FROM DBA_HIST_SGASTAT
        GROUP BY snap_id,instance_number) sga ON sga.snap_id = sn.snap_id
INNER JOIN 
    (SELECT snap_id,instance_number,round(sum(value)/1024/1024/1024,3) allo
        FROM DBA_HIST_PGASTAT 
        WHERE name = 'total PGA allocated'
        GROUP BY snap_id,instance_number) pga ON pga.snap_id = sn.snap_id
WHERE
    sn.instance_number = sga.instance_number
    AND sn.instance_number = pga.instance_number
ORDER BY sn.snap_id desc, sn.instance_number;