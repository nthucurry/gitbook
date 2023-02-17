- [Reference](#reference)
- [Check table size](#check-table-size)
- [Reorganization](#reorganization)
  - [Table static](#table-static)
  - [FSFI (Free Space Fragmentation Index)](#fsfi-free-space-fragmentation-index)
  - [Step](#step)
- [How to move table from one tablespace to another](#how-to-move-table-from-one-tablespace-to-another)
  - [In oracle 11g](#in-oracle-11g)
  - [In oracle 12c](#in-oracle-12c)
- [Index Status](#index-status)

# Reference
- [oracle 12.2 alter table move online](https://www.796t.com/article.php?id=105433)
- [Table Reorganization(shrink space)](https://shinchuan1.blogspot.com/2014/01/table-reorganizationshrink-space.html)

# Check table size
```sql
select
    owner,
    table_name,
    num_rows,
    blocks * (select value from v$parameter where name = 'db_block_size')/1024/1024 "size mb",
    last_analyzed
from dba_tables
where owner not in ('sys','system','sysman') and blocks is not null and owner = 'gaudit_ca'
order by blocks desc;
```

# Reorganization
- Move down the HWM
- Releases unused extents

## Table static
This procedure gathers table and column (and index) statistics.
```sql
begin
  dbms_stats.gather_table_stats(ownname => '<schema>', tabname => '<table>', estimate_percent => dbms_stats.auto_sample_size, method_opt => 'for all indexed columns', degree => 1, granularity => 'all', cascade => dbms_stats.auto_cascade);
end;
```

## FSFI (Free Space Fragmentation Index)
```sql
select
    tablespace_name,
    sqrt(max(blocks)/sum(blocks))*(100/sqrt(sqrt(count(blocks)))) FSFI
  from dba_free_space
  group by tablespace_name
  order by FSFI desc;
```

## Step
1. Reorganization
    - `alter table test.book move;`
        - index, M-View 會失效，需重建
    - `alter table test.book shrink space;`
2. Rebuild Index
    - `alter index idx_book rebuild online;`

# How to move table from one tablespace to another
## In oracle 11g
- `alter table <test.book> move tablespace <ts_audit>;`
- this will invalidate all table's indexes, so this command is usually followed by
    - `alter index <ts_audit> rebuild online;`
    - `select 'alter index '||owner||'.'||index_name||' rebuild tablespace TO_NEW_TABLESPACE_NAME;' from all_indexes where owner = '<schema_name>';`
- check index
    - `select index_name, status from user_indexes order by 1;`
## In oracle 12c
- `alter table <test.book> move tablespace <ts_audit>;`
- check index
    - `select index_name, status from user_indexes order by 1;`

# Index Status
```sql
select
    status, t.*
  from all_indexes t
  where t.status = 'unusable' and t.owner not in ('system','sys')
  order by t.status desc;

select status, count(*), sysdate
  from dba_indexes
  group by status
union
select status, count(*), sysdate
  from dba_ind_partitions
  group by status
union
select status, count(*), sysdate
  from dba_ind_subpartitions
  group by status;
```