spool &1;
set pagesize 40;
set linesize 132;
--set heading off;
--set headsep off;
--set recsep off;
--set verify off;
set feedback off;
set termout off;
select rpad(rtrim(environmentname),40) "Project",
       rpad(rtrim(statename),15) "State",
       rpad(rtrim(hsp.processname),20) "Parent Process",
       rpad(rtrim(hlp.processname),20) "Notify Process",
       rpad(rtrim(usergroupname),15) "User Group"
from harenvironment he,
     harstate hs,
     harlinkedprocess hlp,
     harstateprocess hsp,
     harnotifylist hnl,
     harusergroup hug
where hlp.stateobjid=hs.stateobjid and
      hlp.parentprocobjid=hsp.processobjid and
      hlp.processobjid=hnl.processobjid and
      hnl.usrgrpobjid=hug.usrgrpobjid and
      hs.envobjid=he.envobjid and
      he.envisactive='Y'
order by environmentname,
         stateorder,
         hsp.processname,
         hlp.processname;
         
exit;