SELECT 
    hu.username "User Id:", 
    he.environmentname "Environment:", 
    hpf.pathfullname "Full Path:", 
    hi.itemname "Item Name:",
    hp.packagename "Package Name:"
FROM
    haruser hu, 
    harenvironment he, 
    harpathfullname hpf, 
    haritem hi, 
    harversion hv,
    harPackage hp
WHERE 
    hv.versionstatus='R'
    and hv.itemobjid = hi.itemobjid
    and hv.envobjid = he.envobjid  
    and hi.pathobjid = hpf.pathobjid 
    and hu.usrobjid = hv.creatorid 
    and hp.packageobjid = hv.packageobjid
    and he.environmentname = 'MyEnvironment'
#    and hi.itemname = '<ENTER FULL ITEM NAME HERE>'
ORDER BY  1