# MView
- create DB link
- https://oracle-base.com/articles/misc/materialized-views
- http://shingdong.blogspot.com/2014/08/materialized-view.html

## 說明
- oracle 8i 就有 mview
- 將資料值既存在 view 裡面
- 提升效能
- snapshot 的概念

## Source
```sql
CREATE MATERIALIZED VIEW HR.MV_DEMO_EMPLOYEES
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM EMPLOYEES@DL_DEMO_EMPLOYEES;
```

## Target
```sql
-- step 1
CREATE MATERIALIZED VIEW HR.MV_DEMO_EMPLOYEES
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM EMPLOYEES@DL_DEMO_EMPLOYEES;

-- step 1 (check)
SELECT * FROM SYS.DBA_MVIEWS;

-- step 2
BEGIN
	dbms_mview.refresh('HR.MV_DEMO_EMPLOYEES','C');
END;

-- step 3
SELECT * FROM HR.MV_DEMO_EMPLOYEES;
```