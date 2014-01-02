WHENEVER SQLERROR EXIT FAILURE

SET document ON
set feedback on
set timing off
set verify off
SET heading ON

prompt
prompt 'You can run this script multiple times.'
prompt

define HARUSER = &1
GRANT "EXP_FULL_DATABASE" TO &HARUSER;
ALTER USER &HARUSER DEFAULT ROLE ALL;

select TO_NUMBER(value) as DB_BLOCK_SIZE from V$system_parameter 
where name='db_block_size';

prompt 'Press return key to end...'
pause;

EXIT