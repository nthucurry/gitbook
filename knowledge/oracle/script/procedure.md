# Stored Procedure
## 修改語系
```sql
-- nls_lang = <language>_<territory>.<charset>

ALTER SESSION SET nls_language='AMERICAN';
ALTER SESSION SET nls_territory='AMERICA';
ALTER SESSION SET nls_characterset='AL32UTF8';
ALTER SESSION SET nls_date_format='"YYYY-MM-DD"';

CREATE OR REPLACE PROCEDURE update_global_language IS
BEGIN
    dbms_session.set_nls('nls_language','AMERICAN');
    dbms_session.set_nls('nls_territory','AMERICA');
END;

EXEC update_global_language;
```