WHENEVER SQLERROR EXIT FAILURE
spool &8
set heading on
set feedback on
set timing off
set verify off

define NEWNAME = &1
define NEWPASS = &2
define HARVESTMETATSNAME = &3
define HARVESTBLOBTSNAME = &4
define HARVESTINDEXTSNAME = &5
define TEMPTABLESPACE = &6
define ROLLBACKTABLESPACE = &7

CREATE USER &NEWNAME IDENTIFIED BY &NEWPASS
 DEFAULT TABLESPACE &HARVESTMETATSNAME
 TEMPORARY TABLESPACE &TEMPTABLESPACE
 PROFILE DEFAULT ACCOUNT UNLOCK;

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

-- GRANT unlimited tablespace to &NEWNAME;

alter user &NEWNAME quota UNLIMITED ON &HARVESTMETATSNAME;
alter user &NEWNAME quota UNLIMITED ON &HARVESTBLOBTSNAME;
alter user &NEWNAME quota UNLIMITED ON &HARVESTINDEXTSNAME;

alter user &NEWNAME quota UNLIMITED ON &TEMPTABLESPACE;


WHENEVER SQLERROR CONTINUE

alter user &NEWNAME quota UNLIMITED ON &ROLLBACKTABLESPACE;
REVOKE UNLIMITED TABLESPACE FROM &NEWNAME;

commit;
spool off
exit
