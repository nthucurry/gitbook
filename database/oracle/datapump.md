# Datapump
## 權限
```sql
-- 建立角色
CREATE ROLE datapump_exp_full_database;
CREATE ROLE datapump_imp_full_database;

-- 設定權限
GRANT exp_full_database TO datapump_exp_full_database;
GRANT imp_full_database TO datapump_imp_full_database;

GRANT datapump_exp_full_database TO TONYLEE;
GRANT datapump_imp_full_database TO TONYLEE;
```

## SOP 1
```sql
CREATE OR REPLACE DIRECTORY datapump AS '/backup/datapump';
```

```bash
# ./gen-expdp-full.sh
expdp system/ncu5540 directory=datapump dumpfile=FULL.dmp full=y content=metadata_only

# ./gen-impdp-full.sh
impdp system/ncu5540 directory=datapump dumpfile=FULL.dmp full=y

# ./gen-impdp-sch.sh
expdp system/ncu5540 directory=datapump dumpfile=SCH_HR_METADATA.dmp schemas=HR content=metadata_only
expdp system/ncu5540 directory=datapump dumpfile=SCH_HR.dmp schemas=HR content=data_only
expdp system/ncu5540 directory=datapump dumpfile=SCH_SCM_METADATA.dmp schemas=SCM content=metadata_only
expdp system/ncu5540 directory=datapump dumpfile=SCH_SCM.dmp schemas=SCM content=data_only

# ./gen-impdp-sch.sh
impdp system/ncu5540 directory=datapump dumpfile=SCH_SCM_METADATA.dmp schemas=SCM
impdp system/ncu5540 directory=datapump dumpfile=SCH_SCM.dmp schemas=SCM
impdp system/ncu5540 directory=datapump dumpfile=SCH_HR_METADATA.dmp schemas=HR
impdp system/ncu5540 directory=datapump dumpfile=SCH_HR.dmp schemas=HR
```
- 新增 datafile
    ```txt
    ORA-39171: Job is experiencing a resumable wait.
    ORA-01653: unable to extend table AUKM.EPO_CUST_TO by 8192 in tablespace TS_AUKM
    ```
- 重新 reload impdp
    ```txt
    Processing object type SCHEMA_EXPORT/TABLE/STATISTICS/TABLE_STATISTICS
    ORA-39126: Worker unexpected fatal error in KUPW$WORKER.PUT_DDLS [TABLE_STATISTICS]
    ORA-06502: PL/SQL: numeric or value error
    LPX-00225: end-element tag "HIST_GRAM_LIST_ITEM" does not match start-element tag "EPVALUE"
    ORA-06512: at "SYS.DBMS_SYS_ERROR", line 95
    ORA-06512: at "SYS.KUPW$WORKER", line 9715
    ----- PL/SQL Call Stack -----
    object      line  object
    handle    number  name
    0x53f6f9cb8     21979  package body SYS.KUPW$WORKER
    0x53f6f9cb8      9742  package body SYS.KUPW$WORKER
    0x53f6f9cb8     17950  package body SYS.KUPW$WORKER
    0x53f6f9cb8      4058  package body SYS.KUPW$WORKER
    0x53f6f9cb8     10450  package body SYS.KUPW$WORKER
    0x53f6f9cb8      1824  package body SYS.KUPW$WORKER
    0x53a262460         2  anonymous block
    ```

## SOP 2
# 雙方主機建立 directory
```sql
CREATE OR REPLACE DIRECTORY DMPDIR AS '/backup/auorpt/datapump'; -- source
CREATE OR REPLACE DIRECTORY datapump AS '/backup_from_source/datapump'; -- target
```

# table list

# source 匯出: `execute_expdp.sh`
```bash
#!/bin/bash

cat table_list.txt | while read line
do

  expdp system/oracle \
  directory=DMPDIR \
  dumpfile=EXPDP_$line.dmp \
  logfile=EXPDP_$line.log \
  tables=$line

done
```

# target 匯入: `execute_impdp.sh`
```bash
#!/bin/bash

cat table_list.txt | while read line
do

  impdp system/oracle \
  directory=DMPDIR \
  dumpfile=EXPDP_$line.dmp \
  logfile=EXPDP_$line.log \
  table_exists_action=replace \
  tables=$line

done
```

## Test
- TABLE_EXISTS_ACTION: Action to take if imported object already exists
    - APPEND(附加)
    - REPLACE
    - SKIP: 有資料就不匯入
    - TRUNCATE

### 某資料表中，某區間的資料
- https://www.linuxidc.com/Linux/2016-05/131838.htm
- https://www.twblogs.net/a/5b7e886d2b7177683857e97c
- https://topic.alibabacloud.com/tc/a/table_exists_action-parameter-option-of-impdp_1_13_32463978.html
- https://www.linuxidc.com/Linux/2016-03/129616.htm
- `expdp system/ncu5540 parfile=gen-expdp.par`
    ```txt
    buffer     = 2000000
    file       = /backup/datapump/expdat.dmp
    log        = /backup/datapump/expdat.log
    statistics = NONE
    triggers   = N
    tables     = HR.EMPLOYEES
    query      = "WHERE hire_date BETWEEN TO_DATE('2002','yyyy') AND TO_DATE('2003','yyyy')"
    ```
- `impdp system/ncu5540 parfile=gen-impdp.par`
    ```txt
    buffer      = 2000000
    file        = /backup/datapump/expdat.dmp
    log         = /backup/datapump/impdat.log
    statistics  = NONE
    tables      = HR.EMPLOYEES
    table_exists_action = append
    data_options = skip_constraint_errors
    ```
    - 匯入時，如果限制條件衝突，就無法匯入，要用 data_options 處置
        ```txt
        ORA-00001: unique constraint (HR.EMP_EMAIL_UK) violated
        ```
    - 如果是不同 schema 的話，parfile 條件改為
        - https://support.oracle.com/epmos/faces/SearchDocDisplay?_adf.ctrl-state=1631wrq88k_4&_afrLoop=487209820791877#SYMPTOM
        - source 不用變
            ```txt
            file       = /backup/datapump/expdat.dmp
            log        = /backup/datapump/expdat.log
            tables     = HR.EMPLOYEES
            query      = "WHERE start_day BETWEEN to_date('2018-01-01','yyyy-mm-dd') AND to_date('2020-09-24','yyyy-mm-dd')"
            ```
        - target 需改變
            ```txt
            file        = /backup/datapump/expdat.dmp
            log         = /backup/datapump/impdat.log
            remap_schema= HR:HR_DEV
            table_exists_action = append
            ```