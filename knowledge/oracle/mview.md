# M-View
- create DB link
- https://oracle-base.com/articles/misc/materialized-views
- http://shingdong.blogspot.com/2014/08/materialized-view.html

## 說明
- oracle 8i 就有 mview
- 將資料值既存在 view 裡面
- 提升效能
- snapshot 的概念

## Build M-View
### Source
```sql
CREATE MATERIALIZED VIEW HR.MV_DEMO_EMPLOYEES
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM EMPLOYEES@DL_DEMO_EMPLOYEES;
```

### Target
```sql
-- step 1
/*
需注意該 user 是否有 tablespace usage privilege
*/
CREATE MATERIALIZED VIEW HR.MV_DEMO_EMPLOYEES
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM EMPLOYEES@DL_DEMO_EMPLOYEES;

-- step 1 (check)
SELECT * FROM SYS.DBA_MVIEWS;

-- step 2 (update source table by PL/SQL)
BEGIN
    dbms_mview.refresh('HR.MV_DEMO_EMPLOYEES','C');
END; -- ctrl + enter

-- step 3
SELECT * FROM HR.MV_DEMO_EMPLOYEES;
```

## Generate MView command(not completed)
### By SQL
```sql
-- source

-- target
SELECT
    ' CREATE MATERIALIZED VIEW '|| OWNER || '.' || MVIEW_NAME ||
    ' BUILD IMMEDIATE ' ||
    ' REFRESH FORCE ' ||
    ' ON DEMAND ' ||
    ' AS ' QUERY
FROM all_mviews;

-- PL/SQL
SELECT dbms_metadata.get_ddl('MATERIALIZED_VIEW','MV_DEMO_EMPLOYEES','HR') FROM dual;
```

### By shell
- `vi sql_gen_mview_log_list.txt`(log list)
    ```txt
    #HR MV_DEMO_EMPLOYEES
    SCM MV_DEMO_PRODUCT
    ```
- source
    ```bash
    #!/bin/bash

    cat sql_gen_mview_log_list.txt | while read line
    do
    check_string=`echo $line | grep '#' | wc -l`
    if [[ $check_string == "0" ]];then
        echo "****************************************************************************************"
        mview_name=$line
        schema=`echo $line | awk '{FS=" "} {print $1}'`
        table_name=`echo $line | awk '{FS=" "} {print $2}'`
        echo "DROP MATERIALIZED VIEW LOG ON $schema.$table_name;"
        echo "CREATE MATERIALIZED VIEW LOG ON $schema.$table_name WITH ROWID EXCLUDING NEW VALUES;"
    #    echo "GRANT SELECT ON $schema.$table_name TO $schema;"
    #    echo "GRANT SELECT ON $schema".MLOG\$_"$table_name TO $schema;"
        echo "****************************************************************************************"
    fi
    done
    ```
- target
    ```bash
    #!/bin/bash
    ```