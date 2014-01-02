spool &1;
set pagesize 40;
set linesize 132;
set feedback off;
set termout off;
SELECT rpad(rtrim(environmentname),40) "Project", 
       rpad(rtrim(statename),20) "State", 
       rpad(rtrim(packagename),10) "Package", 
       rpad((rtrim(pathfullname)||rtrim(itemname)||';'||mappedversion),50) "Version",
       rpad((decode(hv.versionstatus, 'N', 'Normal', 'R', 'Reserved', 'D', 'Deleted', 'M', 'Merged')),8)
FROM harenvironment he, harstate hs, harpackage hp, haritems hi, harversions hv, harpathfullname hf
WHERE hv.itemobjid=hi.itemobjid and
      hi.parentobjid=hf.itemobjid and
      hv.packageobjid=hp.packageobjid and
      hp.envobjid=he.envobjid and
      hp.stateobjid=hs.stateobjid
      