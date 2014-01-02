-- script to create a read-only Oracle user
-- creates grants and synonyms for all tables owned
-- syntax: sqlplus DBA/DBAPASS@SERVICENAME @create_reader TABLE_OWNER TABLE_OWNER_PASS NEW_READER NEW_READER_PASS CONNECTSTRING1 CONNECTSTRING2
-- example:
-- 1. Specify Service name: sqlplus system/manager@harvest @create_reader harvest harvest harrep harrep harvest/harvest@harvest harrep/harrep@harvest
-- 2. Do not specify Service name: sqlplus system/manager@harvest @create_reader harvest harvest harrep harrep harvest/harvest harrep/harrep


define T_OWNER = &1
define T_OWNERPASS = &2
define T_READER = &3
define T_READERPASS = &4
define T_CONNSTRING1 = &5
define T_CONNSTRING2 = &6

set termout off
set feedback off
set verify off
set echo off
set heading off
set pages 0
set lines 999
set trimspool on

-- create a script to create the grants
spool tmp_reader_grants.sql
select
'grant select on ' || table_name || ' to &T_READER;' || chr(10)
from dba_tables where owner = upper('&T_OWNER')
order by table_name;
spool off

-- create a script to (re)create the synonyms
spool tmp_reader_synonyms.sql
select
'drop synonym ' || table_name || ';' || chr(10) ||
'create synonym ' || table_name || ' for &T_OWNER' || '.' || table_name || ';' || chr(10)
from dba_tables where owner = upper('&T_OWNER')
order by table_name;
spool off

spool create_reader.log

set termout on
set echo on
set feedback on
set heading on

-- create the read-only Oracle user
create user &T_READER identified by &T_READERPASS;
alter user &T_READER identified by &T_READERPASS;
grant create session to &T_READER;
grant create synonym to &T_READER;
grant alter session to &T_READER;
disconnect


-- connect as the owner and create the grants
connect &T_CONNSTRING1
start tmp_reader_grants.sql
disconnect

-- connect as the reader and create the synonyms
connect &T_CONNSTRING2
start tmp_reader_synonyms.sql
disconnect

exit

