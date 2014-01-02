SELECT environmentname, statename, packagename, pathfullname, itemname
FROM harenvironment he, harstate hs, harpackage hp, haritems hi, harversions hv, harpathfullname hf
WHERE hv.itemobjid=hi.itemobjid and
      hi.parentobjid=hf.itemobjid and
      hv.packageobjid=hp.packageobjid and
      hp.envobjid=he.envobjid and
      hp.stateobjid=hs.stateobjid and
      he.envobji>0
      