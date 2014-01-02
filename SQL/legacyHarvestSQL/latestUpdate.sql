select pathfullname, itemname, mappedversion, packagename, username, realname, to_char(v.creationtime, 'dd-Mon-yy hh:mi:ss')
from harpathfullname pfn, haritems i, harversions v, harpackage p, haruser u,
harenvironment e
where v.creationtime > sysdate-1
and v.itemobjid = i.itemobjid
and i.parentobjid = pfn.itemobjid
and v.packageobjid = p.packageobjid
and p.envobjid = e.envobjid
and v.creatorid = u.usrobjid
and e.environmentname = 'your project here'
