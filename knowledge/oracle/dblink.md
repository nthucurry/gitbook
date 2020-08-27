# Database Link
## 說明
- 兩個資料庫之間的連結
- 不侷限於 oracle
- 每個資料庫需設定連結字串(connection string & tnsnames.ora)

## 範例
```sql
create public database link DL_DEMO_EMPLOYEES connect to HR identified by hr Using 'DEMO_STB';
-- drop database link DL_DEMO_EMPLOYEES;
```

## 建立現存的 DB Link 語法
```sql
select * from
(
    select
        host as tnsname,
        owner,
        db_link db_link_name,
        username as "USER",
        case
            when host = 'DEMO'
                then 'create database link ' || db_link ||
                     ' connect to ' || username || ' identified by demo' ||
                     ' using "DEMO";'
        end as dblink
    from dba_db_links
) t
where t.dblink is not null
order by tnsname, owner;
```

## tnsnames.ora
```txt
DEMO =
    (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = primary)(PORT = 1521))
        (CONNECT_DATA =
            (SERVER = DEDICATED)
            (SERVICE_NAME = DEMO)
        )
    )

DEMO_STB =
    (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = standby)(PORT = 1521))
        (CONNECT_DATA =
            (SERVER = DEDICATED)
            (SERVICE_NAME = DEMO)
        )
    )
```