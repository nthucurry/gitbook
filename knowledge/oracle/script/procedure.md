# Stored Procedure
## 修改語系
```sql
-- nls_lang = <language>_<territory>.<charset>

alter session set nls_language='AMERICAN';
alter session set nls_territory='AMERICA';
alter session set nls_characterset='AL32UTF8';

create or replace procedure update_global_language_to_us is
begin
    dbms_session.set_nls('nls_language','AMERICAN');
    dbms_session.set_nls('nls_territory','AMERICA');
end;

exec update_global_language_to_us;
```