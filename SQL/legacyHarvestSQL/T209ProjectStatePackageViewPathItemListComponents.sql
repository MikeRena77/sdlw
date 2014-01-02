WHERE

FROM 

hp.envobjid=he.envobjid and

hp.stateobjid=hs.stateobjid

environmentname, statename, packagename, pathfullname, itemname 

hi.parentobjid=hf.itemobjid and

harenvironment he, harstate hs, harpackage hp, 

hv.itemobjid=hi.itemobjid and

SELECT
      
hv.packageobjid=hp.packageobjid and
      
haritems hi, harversions hv, harpathfullname hf
      
      