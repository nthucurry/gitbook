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