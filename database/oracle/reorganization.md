- [Reference](#reference)
- [Reorganization](#reorganization)
    - [Step](#step)
- [How to move table from one tablespace to another](#how-to-move-table-from-one-tablespace-to-another)
    - [In oracle 11g](#in-oracle-11g)
    - [In oracle 12c](#in-oracle-12c)

# Reference
- [oracle 12.2 alter table move online](https://www.796t.com/article.php?id=105433)

# Reorganization
- Move down the HWM
- Releases unused extents

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
- this will invalidate all table's indexes. So this command is usually followed by
    - `alter index <ts_audit> rebuild online;`
    - `select 'alter index '||owner||'.'||index_name||' rebuild tablespace TO_TABLESPACE_NAME;' from all_indexes where owner='OWNERNAME';`
- check index
    - `select index_name, status from user_indexes order by 1;`
## In oracle 12c
- `alter table <test.book> move tablespace <ts_audit>;`
- check index
    - `select index_name, status from user_indexes order by 1;`