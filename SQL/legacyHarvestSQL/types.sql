-- types.sql
-- by Tom Cameron
-- report what users created versions of what types (extensions), per repository.

SPOOL types.log
set linesize 9999
set pagesize 9999
set trimspool on
set feedback on
set verify on
set echo on

column "Item Extension" format a30

break on "Repository" skip 0 on "Item Extension" skip 0

select distinct
R.repositname "Repository",
decode(INSTR (I.itemname,'.',-1,1),0,'<NONE>',upper(SUBSTR (I.itemname, INSTR(I.itemname,'.',-1,1)+1))) "Item Extension",
U.username "User"
from
harrepository R, haritem I, harversion V, haruser U
where I.repositobjid = R.repositobjid
and I.itemobjid = V.itemobjid and V.creatorid = U.usrobjid
order by
R.repositname,
decode(INSTR (I.itemname,'.',-1,1),0,'<NONE>',upper(SUBSTR (I.itemname, INSTR(I.itemname,'.',-1,1)+1)))
;

SPOOL OFF
exit;

