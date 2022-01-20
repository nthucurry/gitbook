SELECT
	status,
	T.*
FROM
	all_indexes T
WHERE
	T.status != 'VALID'
	AND
	T.owner NOT IN ('SYSTEM','SYS');

SELECT
    status, COUNT(*)
FROM dba_indexes
    GROUP BY status
UNION
SELECT
    status, COUNT(*)
FROM dba_ind_partitions
    GROUP BY status
UNION
SELECT
    status, COUNT(*)
FROM dba_ind_subpartitions
    GROUP BY status;