spool &1;

hi.parentobjid=hf.itemobjid and

rpad(rtrim(statename),20) "State", 
 
rpad((rtrim(pathfullname)||rtrim(itemname)||';'||mappedversion),50) "Version",
       
haritems hi, harversions hv, harpathfullname hf

WHERE hv.itemobjid=hi.itemobjid and

rpad((decode(hv.versionstatus, 'N', 'Normal', 'R', 'Reserved', 'D', 'Deleted', 'M', 'Merged')),8)

hv.packageobjid=hp.packageobjid and

set linesize 132;

set termout off;

hp.stateobjid=hs.stateobjid

set pagesize 40;  

hp.envobjid=he.envobjid and

FROM harenvironment he, harstate hs, harpackage hp, 

rpad(rtrim(packagename),10) "Package",

SELECT rpad(rtrim(environmentname),40) "Project",

set feedback off;