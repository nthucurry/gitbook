# Data Pump
## 說明
- 跨平台
- 提供更細節資料庫物件選項供 DBA 利用
- 如果資料庫物件相依性高，在執行過程可能因不明錯誤遭到 oracle 強制中斷
- 轉移資料庫物件如果過於龐大複雜，發生錯誤失敗不容易找出兇手

## 從 source 匯入到全新 target
### 雙方資料庫建立 directory
```sql
CREATE OR REPLACE DIRECTORY datapump AS '/backup_new/datapump';
```

### 設定權限(option)
```sql
CREATE ROLE datapump_exp_full_database;
CREATE ROLE datapump_imp_full_database;

GRANT exp_full_database TO datapump_exp_full_database;
GRANT imp_full_database TO datapump_imp_full_database;

GRANT datapump_exp_full_database TO TONYLEE;
GRANT datapump_imp_full_database TO TONYLEE;
```

### 建立與 source 一致的 tablespace & user account
- 若沒建立，匯入時 privilege、role 可能會報錯
- 善用 create like !!

### 匯出 source data
- `vi gen_expdp_sch.sh`
    ```bash
    #/bin/bash
    # metadata only
    expdp system/ncu5540 directory=datapump dumpfile=SCH_HR_METADATA.dmp logfile=SCH_HR_METADATA.log schemas=HR content=metadata_only
    # data only
    expdp system/ncu5540 directory=datapump dumpfile=SCH_HR_DATA.dmp logfile=SCH_HR_DATA.log schemas=HR content=data_only
    ```

### 傳輸 dmp
- scp
- database link

### 匯入到 target
- `cat gen_impdp_sch.par.rawdata`
    ```txt
    DIRECTORY = datapump
    DUMPFILE = <schema>_<content>.dmp
    LOGFILE = SCH_<schema>_<content>_impdp.log
    SCHEMAS = <schema>
    CONTENT = <content>_ONLY
    #PARALLEL= 2
    #TABLE_EXISTS_ACTION = REPLACE
    #EXCLUDE = TABLE:" IN ('ESCH_LINE_HISTORY','ESCH_LINE','ESCH_LINE_HISTORY_BAK_201512')"
    ```
- `vi 1_gen_par.sh`
    ```bash
    #!/bin/bash
    echo $1 $2
    cp gen_impdp_sch.par.rawdata gen_impdp_sch.par
    sed -i 's/<schema>/$1/g' ~/scripts/gen_impdp_sch.par
    sed -i 's/<content>/$2/g' ~/scripts/gen_impdp_sch.par
    ```
- `./1_gen_par.sh AUS_VSSH METADATA`
- `vi 2_gen_impdp_sch.sh`
    ```bash
    #!/bin/bash
    impdp system/ncu5540 parfile=gen_impdp_sch.par
    ```
- `./2_gen_impdp_sch.sh`

## 遇到問題時
- 空間不夠，需新增 datafile
    ```txt
    ORA-39171: Job is experiencing a resumable wait.
    ORA-01653: unable to extend table AUKM.EPO_CUST_TO by 8192 in tablespace TS_AUKM
    ```
- 未知問題，重新 reload impdp 即可
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