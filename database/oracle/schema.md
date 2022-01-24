- [列出該 Schema 的所有物件](#列出該-schema-的所有物件)
- [列出該 Schema 的 Table](#列出該-schema-的-table)

# 列出該 Schema 的所有物件
```sql
SELECT * FROM dba_objects
WHERE owner = 'GAUDIT_CA'
ORDER BY object_name;
```

# 列出該 Schema 的 Table
```sql
SELECT * FROM sys.dba_tables
WHERE owner = 'GAUDIT_CA';
```