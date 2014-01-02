WHENEVER SQLERROR CONTINUE
spool &2
set feedback ON
set timing off
set verify off
drop user &1 CASCADE;

spool off
exit