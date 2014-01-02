spool &1;
set pagesize 1000;
set linesize 132;
--set heading off;
--set headsep off;
--set recsep off;
--set verify off;
set feedback off;
set termout off;
break on Project skip 2
select rpad(rtrim(environmentname),40) "Project",
       rpad(rtrim(statename),20) "State",
       rpad(rtrim(hsp.processname),30) "Parent Process",
       rpad(rtrim(hlp.processname),30) "Linked Process",
       rpad(rtrim(envisactive),6) "Active"
from harenvironment he,
     harstate hs,
     harstateprocess hsp,
     harlinkedprocess hlp
where hlp.stateobjid=hs.stateobjid and
      hlp.parentprocobjid=hsp.processobjid and
      hs.envobjid=he.envobjid
order by envisactive,
         environmentname,
         stateorder,
         hsp.processname,
         hlp.processorder;
         
exit;