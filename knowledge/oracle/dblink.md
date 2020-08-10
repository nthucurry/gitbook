# DB link
## 說明
- 兩個資料庫之間的連結
- 不侷限於 oracle
- 每個資料庫需設定連結字串(connection string & tnsnames.ora)

## SQL
```sql
create public database link DEMO_STB connect to HR identified by hr Using 'DEMO_STB';
```

## tnsnames.ora
```txt
DEMO_STB =
    (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = standby)(PORT = 1521))
        (CONNECT_DATA =
            (SERVER = DEDICATED)
            (SERVICE_NAME = DEMO)
        )
    )
```