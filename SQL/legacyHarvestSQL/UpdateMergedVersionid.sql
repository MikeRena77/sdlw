--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

--
-- PR# 1421: Take into consideration that Trunk-Versions in Harvest 4
--           created as a consequence of a Merge (Concurrent or Cross-Project Merge) 
--           do not always have the corresponding Merged-Version in the Harvest 4 Database.
--

CREATE INDEX harMergedversion_rightVid_ind ON OLDharMergedversion( rightversionid );

UPDATE harVersions 
SET    mergedversionid =
      	(SELECT V1.versionobjid
       	FROM    harVersions V1, OLDharMergedVersion MVT1, OLDharVersion OLDV1,
		harVersions V2, OLDharVersion OLDV2
	WHERE   V1.itemobjid = OLDV1.itemobjid
	AND     V1.packageobjid = OLDV1.packageobjid
	AND     V1.mappedversion = OLDV1.mappedversion
	AND	V1.mappedversion != '0'
	AND	V1.creatorid = OLDV1.creatorid
	AND	V1.creationtime = OLDV1.creationtime
	AND	OLDV1.versionobjid = MVT1.rightversionid
	AND     V2.itemobjid = OLDV2.itemobjid
	AND     V2.packageobjid = OLDV2.packageobjid
	AND     V2.mappedversion = OLDV2.mappedversion
	AND	V2.mappedversion != '0'
	AND	V2.creatorid = OLDV2.creatorid
	AND	V2.creationtime = OLDV2.creationtime
	AND	OLDV2.versionobjid = MVT1.versionobjid
	AND	harVersions.versionobjid = V2.versionobjid
	)
WHERE  EXISTS
      	(SELECT V1.versionobjid
       	FROM    harVersions V1, OLDharMergedVersion MVT1, OLDharVersion OLDV1,
		harVersions V2, OLDharVersion OLDV2
	WHERE   V1.itemobjid = OLDV1.itemobjid
	AND     V1.packageobjid = OLDV1.packageobjid
	AND     V1.mappedversion = OLDV1.mappedversion
	AND	V1.mappedversion != '0'
	AND	V1.creatorid = OLDV1.creatorid
	AND	V1.creationtime = OLDV1.creationtime
	AND	OLDV1.versionobjid = MVT1.rightversionid
	AND     V2.itemobjid = OLDV2.itemobjid
	AND     V2.packageobjid = OLDV2.packageobjid
	AND     V2.mappedversion = OLDV2.mappedversion
	AND	V2.mappedversion != '0'
	AND	V2.creatorid = OLDV2.creatorid
	AND	V2.creationtime = OLDV2.creationtime
	AND	OLDV2.versionobjid = MVT1.versionobjid
	AND	harVersions.versionobjid = V2.versionobjid
	);

Commit;	

EXIT