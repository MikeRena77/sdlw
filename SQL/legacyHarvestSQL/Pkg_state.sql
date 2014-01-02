-- get all packages belongs to  this state
set pagesize 0;
set trimspool on;
set heading off;
set headsep off;
set recsep off;
set verify off;
set feedback off;
select
  distinct rtrim(P.packagename)
from
  harpackage P,
  harstate S,
  harenvironment E
where
  P.stateobjid = S.stateobjid and
  P.envobjid = E.envobjid and
  S.statename = '&2' and
  E.environmentname = '&1'
order by 1
;
exit;
