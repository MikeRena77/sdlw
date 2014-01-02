select 
    harpackage.packageobjid, 
    statename, 
    username, 
    action, 
    execdtime,
    packagename
from 
    harpkghistory, 
    haruser, 
    harpackage
where 
    harpkghistory.usrobjid = haruser.usrobjid AND
    harpkghistory.packageobjid = harpackage.packageobjid
order by 
    packageobjid;