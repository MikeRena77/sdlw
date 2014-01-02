--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
SPOOL &1
COLUMN ITEMNAME FORMAT A17
COLUMN STATENAME FORMAT A13
COLUMN VERSIONSTATUS FORMAT A1
COLUMN ENVIRONMENTNAME FORMAT A24
set heading off
set timing off
set verify on
set feedback on
SELECT HE.environmentname, HS.statename, HI.itemname, HV.versionstatus 
FROM harenvironment HE, haritem HI, harversion HV, harstate HS 
WHERE HE.envobjid = HV.envobjid 
AND HI.ITEMOBJID = HV.Itemobjid 
AND HS.stateobjid = HV.Stateobjid 
AND HV.versionstatus in ('M','R');
SPOOL OFF
EXIT