# Oracle Cloud Control
## 安裝 OEM
#### dbconsole
```bash
emca -repos drop
emca -config dbcontrol db -repos create
# SYSMAN = SYS password
```

## Cloud Control
- https://oracle-base.com/articles/12c/cloud-control-12cr2-installation-on-oracle-linux-5-and-6
- https://www.oracle.com/enterprise-manager/downloads/cloud-control-downloads.html
- `/usr/bin/make -f ins_sqlplus.mk install ORACLE_HOME=/u01/oracle/11204`
- step
    ```bash
    $ORACLE_HOME/middleware/allroot.sh
    ```
- debug
    - https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=30402886325103&parent=EXTERNAL_SEARCH&sourceId=PROBLEM&id=2635383.1&_afrWindowMode=0&_adf.ctrl-state=ke9nvuv68_4
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