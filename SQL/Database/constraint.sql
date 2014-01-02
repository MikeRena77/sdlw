SPOOL constraintChk.notes
set linesize 9999
set pagesize 9999
set trimspool on
set feedback on
set verify on
set echo on
select constraint_name, Table_name from user_constraints order by constraint_name;
SPOOL OFF
exit;