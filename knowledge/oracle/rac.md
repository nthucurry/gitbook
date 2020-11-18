# RAC
## 安裝順序
1. grid infrastructure(ASM)
2. oracle database

## 前置作業
```bash
mkdir -p /u01/oracle/12201
mkdir -p /u01/oracle/grid
mkdir -p /u01/oraInventory

# ASM library
yum install kmod-oracleasm -y
```

- bash_profile
```bash
    export TMP=/tmp
    export TMPDIR=$TMP

    export ORACLE_SID=RAC1
    export ORACLE_UNQNAME=RAC # it is difference between primary and standby database
    export ORACLE_BASE=/u01/oracle
    export ORACLE_HOME=$ORACLE_BASE/12201
    export ORACLE_TERM=xterm
    export TNS_ADMIN=$ORACLE_HOME/network/admin
    LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib;
    export LD_LIBRARY_PATH
    CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib;
    export CLASSPATH
    PATH=$PATH:$ORACLE_HOME/bin:$ORACLE_HOME/bin
    export PATH

    # Alias
    alias sqlp='sqlplus / as sysdba'
    alias rm='rm -i'
    alias vi='vim'
    alias grep='grep --color=always'
    alias tree='tree --charset ASCII'
    alias bdump="cd $base/diag/rdbms/${uqname,,}/$sid/trace"
    ```

## 網路架構
- public IP
    - rac-1: 10.140.1.11
    - rac-2: 10.140.1.12
- private IP
    - rac-1: 192.168.182.11
    - rac-2: 192.168.182.12
- virtual IP(VIP)
    - rac-1: 10.140.1.11
    - rac-2: 10.140.1.12