# Reference
- [UTL_HTTP and SSL (HTTPS) using Oracle Wallets](https://oracle-base.com/articles/misc/utl_http-and-ssl)

# Oracle 錢包
- Check Oracle Version
  - more than 11.2.0.4 (support TLSv1)
- Get Site Certificates
    - 要使用 **Base-64 encoded X.509** 格式
- Copy the Certificates to OS
- Create an Oracle Wallet Containing the Certificates
    ```bash
    su - oracle
    mkdir -p /u01/app/oracle/admin/DB11G/wallet
    orapki wallet create -wallet /u01/app/oracle/admin/DB11G/wallet -pwd WalletPasswd123 -auto_login
    orapki wallet add -wallet /u01/app/oracle/admin/DB11G/wallet -trusted_cert -cert "/home/oracle/ssl/ca-base.cer" -pwd WalletPasswd123
    ```
- Test
```sql
SET SERVEROUTPUT ON
EXEC utl_http.set_wallet('file:/u01/app/oracle/admin/DB11G/wallet', 'WalletPasswd123');
SELECT utl_http.request('secret.encrypted-website.com') FROM dual;
```