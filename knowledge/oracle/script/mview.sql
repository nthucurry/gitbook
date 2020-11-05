SELECT * FROM dba_sys_privs;

-- step 1: DB link
create public database link DL_ERP connect to HR identified by hr using 'ERP';
select * from dba_db_links;

-- step 2: MView log
create materialized view log on HR.PLAYER
	tablespace ts_hr
	with rowid
	including new values;

-- insert data
select * from HR.PLAYER;
insert into HR.PLAYER values (8, 'Bosh', 8);
commit;

-- step 1: 需注意該 user 是否有 tablespace usage privilege
create materialized view HR.MV_ERP_PLAYER
	build immediate
	refresh force
	with rowid
	start with sysdate next sysdate + 1/1440 for update
	as
	select * from HR.PLAYER@DL_ERP;

-- step 1 (check)
select * from DBA_MVIEWS;

-- step 2 (update source table by PL/SQL)
begin
    dbms_mview.refresh('HR.MV_ERP_PLAYER','C');
end; -- ctrl + enter

-- step 3
select * from HR.MV_ERP_PLAYER;

-- job
select
	*
	/*job, -- job id,
	broken, -- 是否停用(Y=停用,N=啟用),
	what, -- job 內容,
	last_date, -- 最新更新的時間,
	next_date, -- 下次更新的時間,
	INTERVAL,  -- 更新頻率*/
from dba_jobs;
--where Log_user = 'SYSTEM'; -- 帳號

--
BEGIN
	DBMS_REFRESH.ADD(
		NAME => 'HR."RG_DEMO_EMPLOYEES"',
		LIST => 'HR.MV_ERP_PLAYER',
		LAX => TRUE);
END;

-- drop
DROP MATERIALIZED VIEW HR.MV_ERP_PLAYER;