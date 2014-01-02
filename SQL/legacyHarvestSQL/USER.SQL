WHENEVER SQLERROR EXIT FAILURE
spool &2
set heading off
set timing off
set verify off
select TO_CHAR(count(username)) from all_users
  where username = UPPER('&1');
spool off
exit
