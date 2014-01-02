SET NEWPAGE 0
SET SPACE 0
SET LINESIZE 80
SET PAGESIZE 0
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET MARKUP HTML ON
SET ESCAPE \
SPOOL linkedProcessList.html

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
spool off
exit
