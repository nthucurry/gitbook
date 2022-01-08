# ORA Error Code
## ORA-01207: file is more recent than control file - old control file
## ORA-01033: ORACLE initialization or shutdown in progress
## ORA-01034: ORACLE not available
## ORA-27101: shared memory realm does not exist
- oracle 沒開

## ORA-09925: Unable to create audit trail file
## ORA-01075: you are currently logged on
## ORA-00942: table or view does not exist
- 可能是用到權限不足的 table or view

## ORA-00439: feature not enabled: Managed Standby
- 需安裝企業版

## ORA-01078: failure in processing system parameters
- LRM-00123: invalid character 158 found in the input file
    不能有中文

## ORA-10456: cannot open standby database; media recovery session may be in progress
## ORA-00119: invalid specification for system parameter LOCAL_LISTENER
- ORA-00132: syntax error or unresolved network name 'LISTENER_ORCL'
- 確認是否有設定環境變數: `echo $TNS_ADMIN`，此資料夾裡面會有 listener.ora & tnsnames.ora ...等等

## ORA-27102: out of memory
Linux-x86_64 Error: 28: No space left on device
- 修改 init.ora 的記憶體部分

## ORA-16191: Primary log shipping client not logged on standby
```bash
scp orapwESHIP oraeship@dg-2:/u01/oracle/11204/dbs/
```

## ORA-19527: physical standby redo log must be renamed
https://blog.toadworld.com/2018/03/08/ora-19527-physical-standby-redo-log-must-be-renamed

## ORA-00313: open failed for members of log group 3 of thread 1

## ORA-02019: connection description for remote database not found
- DB link 失效

## ORA-12154: TNS:could not resolve the connect identifier specified
- 在 tnsnames.ora 內，找不到 SID
- [https://dotblogs.com.tw/nemochen/2011/01/30/21138](https://dotblogs.com.tw/nemochen/2011/01/30/21138)

## ORA-12454: connect failed because target host or object does not exist
- making sure that your listener is running (lsnrcrl status)
- testing connectivity with ping, and then tnsping.
- verifying connectivity via the DNS (e.g. /etc/hosts)
- make sure to check your tnsnames.ora parms.

## ORA-12545: Connect failed because target host or object does not exist
在 tnsnames.ora 內，hostname 寫錯

## ORA-12541: TNS:no listener
在 tnsnames.ora 內，port 寫錯

## ORA-12170: TNS:Connect timeout occurred
## ORA-12162: TNS:net service name is incorrectly specified
SP2-0157: unable to CONNECT to ORACLE after 3 attempts, exiting SQL*Plus
## ORA-12525: TNS:listener has not received client's request in time allowed