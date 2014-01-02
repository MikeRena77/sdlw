SELECT 	harpackage.packagename "PACKAGE", 
	harenvironment.environmentname "ENVIRONMENT",        harpathfullname.pathfullname "PATH", 
	haritem.itemname "ITEM", 
	harversion.versionfiletime "CHECKIN", 
	harversion.creationtime "FILETIME", 
	harversion.versionfilesize "SIZE",
	harversion.mappedversion "MAPPED",
	harversion.deltaversion "DELTA" 
FROM 	harversion, harenvironment, haritem, harpackage, harpathfullname 
WHERE 	harenvironment.environmentname LIKE '%TUAV2%' AND
	harenvironment.envobjid = harversion.envobjid AND
	harversion.itemobjid = haritem.itemobjid AND
	harpackage.packageobjid = harversion.packageobjid AND
	harpathfullname.pathobjid = haritem.pathobjid
ORDER BY 
        harpackage.packagename, 
        harenvironment.environmentname, 
	haritem.itemname