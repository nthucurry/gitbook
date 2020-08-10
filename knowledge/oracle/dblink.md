# DB link
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