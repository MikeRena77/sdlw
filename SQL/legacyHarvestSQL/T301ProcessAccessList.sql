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
       rpad(rtrim(processname),25) "Process",
       rpad(rtrim(usergroupname),20) "User Group"
from harenvironment he,
     harstate hs,
     harstateprocess hsp,
     harstateprocessaccess hsa,
     harusergroup hug
where hsa.stateobjid=hs.stateobjid and
      hsa.processobjid=hsp.processobjid and
      hsa.usrgrpobjid=hug.usrgrpobjid and
      hs.envobjid=he.envobjid and
      he.envisactive='Y'
order by environmentname,
         stateorder,
         processname,
         usergroupname;
         
exit;