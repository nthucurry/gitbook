# Oracle Cloud Control
## 安裝 OEM
### dbconsole
```bash
emca -repos drop
emca -config dbcontrol db -repos create
# SYSMAN = SYS password
```

## Cloud Control
### Reference
- [Oracle Enterprise Manager Cloud Control 13c Release 1 (13.1.0.0) Installation on Oracle Linux 6 and 7](https://oracle-base.com/articles/13c/cloud-control-13cr1-installation-on-oracle-linux-6-and-7)
- [Oracle Enterprise Manager Cloud Control 12c Release 2 Installation on Oracle Linux 5.8 and 6.3](https://oracle-base.com/articles/12c/cloud-control-12cr2-installation-on-oracle-linux-5-and-6)
- 13c 版本需要安裝 [12c 資料庫](https://www.oracle.com/database/technologies/oracle12c-linux-12201-downloads.html#license-lightbox)

### Step
#### Prerequisites
```bash
yum install make -y
yum install binutils -y
yum install gcc -y
yum install libaio -y
yum install glibc-common -y
yum install libstdc++ -y
yum install libXtst -y
yum install sysstat -y
yum install glibc -y
yum install glibc-devel -y
yum install glibc-devel.i686 -y
```

- https://www.oracle.com/enterprise-manager/downloads/cloud-control-downloads.html
- `/usr/bin/make -f ins_sqlplus.mk install ORACLE_HOME=/u01/oracle/12010`
- step
    ```bash
    $ORACLE_HOME/middleware/allroot.sh
    ```
- debug
    - [Check if the parameter _allow_insert_with_update_check is set to True](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=243960029504400&parent=EXTERNAL_SEARCH&sourceId=PROBLEM&id=2254373.1&_afrWindowMode=0&_adf.ctrl-state=619vyroih_4)
        ```sql
        alter system set "_allow_insert_with_update_check"=true;
        ```
    - [Check if all adaptive features parameters are unset](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=30402886325103&parent=EXTERNAL_SEARCH&sourceId=PROBLEM&id=2635383.1&_afrWindowMode=0&_adf.ctrl-state=ke9nvuv68_4)
        ```sql
        alter system set "_optimizer_nlj_hj_adaptive_join"= FALSE scope=both sid='*';
        alter system set "_optimizer_strans_adaptive_pruning" = FALSE scope=both sid='*';
        alter system set "_px_adaptive_dist_method" = OFF scope=both sid='*';
        alter system set "_sql_plan_directive_mgmt_control" = 0 scope=both sid='*';
        alter system set "_optimizer_dsdir_usage_control" = 0 scope=both sid='*';
        alter system set "_optimizer_use_feedback" = FALSE scope=both sid='*';
        alter system set "_optimizer_gather_feedback" = FALSE scope=both sid='*';
        alter system set "_optimizer_performance_feedback" = OFF scope=both sid='*';
        alter system set session_cached_cursors=200 scope=spfile;
        ```

#### Cloud Control 13c Installation
- 建立管理資料夾
    ```bash
    mkdir -p /oracle/middleware
    mkdir -p /oracle/agent
    ```
- `./em13100_linux64.bin`