--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
SPOOL harinventory.log
set linesize 9999
set pagesize 9999
set trimspool on
set feedback on
set verify on
set echo on

-- Harvest table version
select versionindicator "Table Version" from hartableinfo;

-- List of tables owned by Harvest table owner
select table_name "Table List" from user_tables order by 1;

-- List of explicit indexes owned by Harvest table owner
select index_name "Index", table_name "Table", status "Status" from user_indexes where index_name not like 'SYS_%' order by 1;

-- List of explicit constraints owned by Harvest table owner
select constraint_name "Constraint", constraint_type "Type", table_name "Table", status "Status" from user_constraints where constraint_name not like 'SYS_%' order by 1;

-- List of triggers owned by Harvest table owner
select trigger_name "Trigger", table_name "Table", status "Status" from user_triggers order by 1;

-- List of views owned by Harvest table owner
select View_name "View" from user_views order by 1;

select count(*) "# of Active Env"   from harenvironment where envisactive = 'Y';
select count(*) "# of Inactive Env" from harenvironment where envisactive = 'N';
select count(*) "# of Users" from haruser;
select count(*) "# of Packages" from harpackage;

select formtypename "Form Types Installed", formtypeobjid "Type ID" from harformtype order by 2;

select formtypename "Form Type Used", count(*) "Quantity" from harformtype, harform where harform.formtypeobjid = harformtype.formtypeobjid group by formtypename;

break on "UDP Program" skip 0 on "UDP Input" skip 0
column "UDP Input" format a100 wrap
select
  U.programname "UDP Program", U.inputparm "UDP Input", U.udptype "Type",
  E.environmentname "Environment", S.statename "State", U.processname "UDP Name", 'Standalone' "Linked to",
  ' ' "Link Type" 
from
  harudp U, harenvironment E, harstate S
where
  U.stateobjid = S.stateobjid and
  S.envobjid = E.envobjid
UNION
select
  U.programname "UDP Program", U.inputparm "UDP Input", U.udptype "Type",
  E.environmentname "Environment", S.statename "State", U.processname "UDP Name", P.processname "Linked to",
  decode(L.processprelink, 'Y', 'Prelink', 'N', 'Postlink') "Link Type"
from
  harudp U, harstateprocess P, harlinkedprocess L, harenvironment E, harstate S
where
  U.parentprocobjid = P.processobjid and
  L.processobjid = U.processobjid and
  P.stateobjid = S.stateobjid and
  S.envobjid = E.envobjid
ORDER BY
  1,2,4,5,6
;

column "Project File Version" format a128
SELECT E.environmentname "VCI Environment", rtrim(D.pathfullname) || rtrim(I.itemname) || ';' || rtrim(V.mappedversion) "Project File Version", TO_CHAR (V.creationtime, 'MM/DD/YYYY;HH24:MI:SS') "Created"
FROM harenvironment E, haritem I, harversion V, harpathfullname D
WHERE E.envobjid = V.envobjid and E.envobjid != 0 
AND I.pathobjid = D.pathobjid
AND V.itemobjid = I.Itemobjid
AND I.itemname like '%.hp~'
order by 1,2;

select count(*) "# of Repositories" from harrepository;
select count(*) "# of Items" from haritem;
select count(*) "# of Versions" from harversion;

select * from harobjidgen;

column "Item Extension" format a20

select (SUBSTR (itemname, INSTR (itemname, '.'))) "Item Extension", count(itemname) "# of Items" from haritem group by (SUBSTR (itemname, INSTR (itemname, '.')));

break on report
compute sum label 'Size of all Versions' of "Size of versions in Rep" on report
SELECT repositname "Repository", SUM(TO_NUMBER(VERSIONFILESIZE)) "Size of versions in Rep" FROM ( select distinct R.repositname, I.itemobjid, V.deltaversion, V.versionfilesize from harversion V, haritem I, harrepository R WHERE V.VERSIONFILESIZE IS NOT NULL AND V.VERSIONFILESIZE <> ' ' and V.itemobjid = I.itemobjid and I.repositobjid = R.repositobjid) group by repositname;
clear computes
clear breaks

column "Item" format a128

SELECT distinct V.versionfilesize "Size of largest Version", rtrim(D.pathfullname) || rtrim(I.itemname) "Item"
FROM haritem I, harversion V, harpathfullname D
WHERE I.pathobjid = D.pathobjid AND V.itemobjid = I.Itemobjid
AND to_number(V.versionfilesize) = (SELECT MAX( to_number(VERSIONFILESIZE)) FROM harVersion 
WHERE VERSIONFILESIZE IS NOT NULL AND VERSIONFILESIZE <> ' ')
and VERSIONFILESIZE IS NOT NULL AND VERSIONFILESIZE <> ' ';

SPOOL OFF
exit;

