select
T.pathfullname,
I.itemname,
V.mappedversion
from
harpathfullname T,
haritems I,
harversions V,
harpackage P,
harenvironment E
where
E.environmentname = 'DEMO' and
P.packagename = 'MR- 00001' and
P.envobjid = E.envobjid and
V.packageobjid = P.packageobjid and
V.itemobjid = I.itemobjid and
I.parentobjid = T.itemobjid
ORDER BY
pathfullname,itemname,mappedversion