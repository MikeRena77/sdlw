SELECT environmentname, statename
FROM harenvironment he, harstate hs
WHERE hs.envobjid=he.envobjid
ORDER BY environmentname,
	 statename