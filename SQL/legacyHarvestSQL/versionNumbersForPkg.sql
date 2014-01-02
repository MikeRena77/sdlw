select
T.pathfullname,
I.itemname,
V.mappedversion
from
harpathfullname T,
haritem I,
harversion V,
harpackage P,
harenvironment E
where
E.environmentname = 'your_environmment_name' and
P.packagename = 'your_package_name' and
P.envobjid = E.envobjid and
V.packageobjid = P.packageobjid and
V.itemobjid = I.itemobjid and
I.pathobjid = T.pathobjid
ORDER BY
pathfullname,itemname,mappedversion