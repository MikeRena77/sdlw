SELECT 	harpackage.packagename "PACKAGE", 

	harenvironment.environmentname "ENVIRONMENT",
	harstate.statename,
        harpathfullname.pathfullname "PATH", 

	haritem.itemname "ITEM", 

	harversion.versionfiletime "CHECKIN", 

	harversion.creationtime "FILETIME", 

	harversion.versionfilesize "SIZE" 

	FROM harversion, harenvironment,harstate, haritem, harpackage, harpathfullname 

WHERE 	harenvironment.environmentname LIKE '%FBCB2%' AND

	harenvironment.envobjid = harversion.envobjid AND

	harenvironment.stateobjid = harstate.htateobjid AND
	harversion.itemobjid = haritem.itemobjid AND

	harpackage.packageobjid = harversion.packageobjid AND

	harpathfullname.pathobjid = haritem.pathobjid

ORDER BY 

        harpackage.packagename, 

        harenvironment.environmentname, 

	harstate.statename,
	haritem.itemname

SELECT 	harpackage.packagename "PACKAGE", 
	harenvironment.environmentname "ENVIRONMENT",	harstate.statename "STATE" 	FROM harenvironment, harstate, harpackage 
WHERE 	harenvironment.environmentname LIKE '%FBCB2-LOT1%' AND
	harenvironment.envobjid = harpackage.envobjid AND
	harpackage.stateobjid = harstate.Stateobjid	ORDER BY 
        harpackage.packagename, 
        harenvironment.environmentname, 
	harstate.statename
