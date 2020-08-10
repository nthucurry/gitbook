# MView
- create DB link
- https://oracle-base.com/articles/misc/materialized-views
- http://shingdong.blogspot.com/2014/08/materialized-view.html

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