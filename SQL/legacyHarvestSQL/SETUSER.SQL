WHENEVER SQLERROR EXIT FAILURE
spool &3
set heading on
set feedback on
set timing off
set verify off
define NEWNAME = &1
define NEWPASS = &2
create user &NEWNAME identified by &NEWPASS;

grant exp_full_database to &NEWNAME;
grant imp_full_database to &NEWNAME;
grant connect to &NEWNAME;
grant resource to &NEWNAME;

grant alter session to &NEWNAME;
grant create cluster to &NEWNAME;
grant create database link to &NEWNAME;
grant create sequence to &NEWNAME;
grant create session to &NEWNAME;
grant create synonym to &NEWNAME;
grant create table to &NEWNAME;
grant create view to &NEWNAME;
grant create procedure to &NEWNAME;
grant create trigger to &NEWNAME;
grant unlimited tablespace to &NEWNAME;
commit;
spool off
exit
