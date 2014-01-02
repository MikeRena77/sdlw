SELECT COUNT(haritem.itemname)
FROM harversion, harenvironment, haritem, harpackage, harpathfullname

WHERE harversion.versionfiletime > '01-OCT-01' AND

harenvironment.envobjid = harversion.envobjid AND

harversion.itemobjid = haritem.itemobjid AND

harpackage.packageobjid = harversion.packageobjid AND

harpathfullname.pathobjid = haritem.pathobjid