WHENEVER SQLERROR CONTINUE
spool &4

define DUSER = &1
define PERCENT = &2
define CASCADE = &3

set heading off
set feedback off
set timing off
set verify off

EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS (OWNNAME=>'&DUSER', ESTIMATE_PERCENT=>&PERCENT, CASCADE=>&CASCADE);

commit;
spool off
exit






