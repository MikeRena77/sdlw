SELECT environmentname, statename, packagename
FROM harenvironment he, harstate hs, harpackage hp
WHERE hp.envobjid=he.envobjid and
      hp.stateobjid=hs.stateobjid