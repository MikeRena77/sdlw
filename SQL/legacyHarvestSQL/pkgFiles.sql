SELECT 	harenvironment.environmentname,
 	harpathfullname.pathfullname,
 	haritem.itemname,
 	harversion.versionfiletime,
 	harversion.creationtime,
 	harversion.versionfilesize,
 	harpackage.packagename  
FROM 	harversion, 
	harenvironment, 
	haritem, 
	harpackage, 
	harpathfullname
WHERE 	harenvironment.environmentname LIKE 'TUAV2%' AND
	harenvironment.envobjid = harversion.envobjid AND
	harversion.itemobjid = haritem.itemobjid AND
	harpackage.packageobjid = harversion.packageobjid AND
	harpathfullname.pathobjid = haritem.pathobjid
ORDER BY harenvironment.environmentname, 
	harpackage.packagename, 
	haritem.itemname

SELECT 	harenvironment.environmentname, harpathfullname.pathfullname, haritem.itemname, harversion.versionfiletime, harversion.creationtime, harversion.versionfilesize, harpackage.packagename FROM harversion, harenvironment, haritem, harpackage, harpathfullname 
WHERE 	harenvironment.environmentname LIKE 'TUAV2%' AND
	harenvironment.envobjid = harversion.envobjid AND
	harversion.itemobjid = haritem.itemobjid AND
	harpackage.packageobjid = harversion.packageobjid AND
	harpathfullname.pathobjid = haritem.pathobjid
ORDER BY harenvironment.environmentname, 
	harpackage.packagename, 
	haritem.itemname

SELECT 	harenvironment.environmentname ENVIRONMENT, harpathfullname.pathfullname PATH, harpackage.packagename PACKAGE, haritem.itemname ITEM, harversion.versionfiletime CHECKIN, harversion.creationtime FILETIME, harversion.versionfilesize SIZE FROM harversion, harenvironment, haritem, harpackage, harpathfullname 
WHERE 	harenvironment.environmentname LIKE 'TUAV2%' AND
	harenvironment.envobjid = harversion.envobjid AND
	harversion.itemobjid = haritem.itemobjid AND
	harpackage.packageobjid = harversion.packageobjid AND
	harpathfullname.pathobjid = haritem.pathobjid
ORDER BY harenvironment.environmentname, 
	harpackage.packagename, 
	haritem.itemname

SELECT harenvironment.environmentname "ENV", harpathfullname.pathfullname "PATH", harpackage.packagename "PKG", haritem.itemname "ITEM", harversion.versionfiletime "CHECKIN", harversion.creationtime "CREATED", harversion.versionfilesize "SIZE" 
FROM harversion, harenvironment, haritem, harpackage, harpathfullname
WHERE harenvironment.environmentname LIKE 'TUAV2%' AND
harenvironment.envobjid = harversion.envobjid AND
harversion.itemobjid = haritem.itemobjid AND
harpackage.packageobjid = harversion.packageobjid AND
harpathfullname.pathobjid = haritem.pathobjid
ORDER BY harenvironment.environmentname, harpackage.packagename, haritem.itemname