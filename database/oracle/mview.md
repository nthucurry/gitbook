# M-View
- create DB link
- https://oracle-base.com/articles/misc/materialized-views
- http://shingdong.blogspot.com/2014/08/materialized-view.html

## 說明
- oracle 8i 就有 mview
- 將資料值存在 view 裡面(實體 table)
- 提升效能
- snapshot 概念
- 同步資料、傳輸資料

## Build M-View
### Privilege
```sql
grant create any materialized view to system;
```

### Source DB
```sql
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
```

### Target DB
```sql
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
select * from dba_jobs;

-- drop
DROP MATERIALIZED VIEW HR.MV_ERP_PLAYER;
```

## Generate MView command(not completed)
### By SQL
```sql
-- source

-- target
select
    ' create materialized view '|| owner || '.' || mview_name ||
    ' build immediate ' ||
    ' refresh force ' ||
    ' on demand ' ||
    ' as ' query
from all_mviews;

-- PL/SQL
SELECT dbms_metadata.get_ddl('MATERIALIZED_VIEW','MV_DEMO_EMPLOYEES','HR') FROM dual;
```

### By shell
- `vi sql_gen_mview_log_list.txt`(log list)
    ```
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

    dblink=DL_DEMO_EMPLOYEES
    refresh_group=RG_DEMO_EMPLOYEES

    cat sql_gen_src_mview_log_list.txt | while read line
    do
    check_string=`echo $line | grep '#' | wc -l`
    if [[ $check_string == "0" ]];then
        mview_name=$line
        schema=`echo $line | awk '{FS=" "} {print $1}'`
        table_name=`echo $line | awk '{FS=" "} {print $2}'`
        sql_output=$schema"_"$table_name".sql"
        echo "****************************************************************************************"
    #    echo $sql_output
    #    rm $sql_output
    #    echo "DROP MATERIALIZED VIEW $schema.$table_name;" >> sql_output
        echo "CREATE MATERIALIZED VIEW $schema.$table_name BUILD IMMEDIATE USING INDEX REFRESH FORCE WITH ROWID AS SELECT * FROM $schema.$table_name@$dblink;"

        echo "--BEGIN"
        echo "--    DBMS_REFRESH.ADD("
        echo "--        NAME => '$schema."RG_DEMO_EMPLOYEES"',"
        echo "--        LIST => '"$schema.$table_name"',"
        echo "--    LAX => TRUE);"
        echo "--END;"
        echo "--/"
        echo "SELECT * FROM dba_mviews WHERE mview_name = '"$table_name"';"
        echo "SELECT * FROM dba_db_links;"
        echo "--COMMIT;"
        echo "****************************************************************************************"
    fi
    done
    ```