SELECT environmentname, statename, packagename, itemname
FROM harenvironment he, harstate hs, harpackage hp, haritems hi, harversions hv
WHERE hv.itemobjid=hi.itemobjid and
      hv.packageobjid=hp.packageobjid and
      hp.envobjid=he.envobjid and
      hp.stateobjid=hs.stateobjid
      