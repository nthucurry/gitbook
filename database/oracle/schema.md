- [列出該 Schema 的所有物件](#列出該-schema-的所有物件)
- [列出該 Schema 的 Table](#列出該-schema-的-table)
- [更換 Tablespace](#更換-tablespace)

# 列出該 Schema 的所有物件
```sql
select * from dba_objects
where owner = '<schema_name>'
order by object_name;
```

# 列出該 Schema 的 Table
```sql
select * from dba_tables
where owner = '<schema_name>';
```

# 更換 Tablespace
```sql
alter table <table_name> move tablespace <tablespace_name>;
select
    'alter table ' || owner || '.' || table_name || ' move tablespace <tablespace_name>;'
from dba_tables where owner = '<schema_name>';

alter index <index_name> rebuild tablespace <tablespace_name>;
select
    'alter index ' || owner || '.'|| index_name ||' rebuild tablespace <tablespace_name> online;'
from dba_indexes where owner = 'schema_name';
```