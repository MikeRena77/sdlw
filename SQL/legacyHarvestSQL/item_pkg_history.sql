SELECT	harenvironment.environmentname, 
		harpathfullname.pathfullname, 
		haritem.itemname, 
		harversion.versionfiletime, 
		harversion.creationtime, 
		harversion.versionfilesize, 
		harpackage.packagename  
FROM harversion, harenvironment, haritem, harpackage, harpathfullname
WHERE harenvironment.environmentname LIKE 'TUAV2%' AND
harenvironment.envobjid = harversion.envobjid AND
harversion.itemobjid = haritem.itemobjid AND
harpackage.packageobjid = harversion.packageobjid AND
harpathfullname.pathobjid = haritem.pathobjid
ORDER BY harenvironment.environmentname, 
		harpackage.packagename, 
		haritem.itemname