/*
 * ConvertFormAssoc.sql
 *
 * Convert form associations
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
--
-- Transform form - form association to form - package
--
INSERT INTO harassocpkg
(
	formobjid,
	assocpkgid
)
SELECT ff.formobjid, fp.assocpkgid
FROM OLDharAssocForm ff, harAssocPkg fp
WHERE ff.assocformid = fp.formobjid
MINUS
SELECT formobjid, assocpkgid
FROM harAssocPkg;
--
-- If there are forms with no package, create a package
-- for them, and create a state and environment for the package.
--
DECLARE
   CURSOR select_orphans
   IS
      SELECT f.formobjid
      FROM harform f
      WHERE NOT EXISTS (SELECT a.formobjid
                        FROM harassocpkg a
                        WHERE f.formobjid = a.formobjid);

   CURSOR get_nextenvid
   IS
      SELECT MAX (envobjid) + 1
        FROM harenvironment;

   CURSOR get_nextstateid
   IS
      SELECT MAX (stateobjid) + 1
        FROM harstate;

   CURSOR get_nextpkgid
   IS
      SELECT MAX (packageobjid) + 1
        FROM harpackage;

   newenvid     harenvironment.envobjid%TYPE DEFAULT 1;
   newstateid   harstate.stateobjid%TYPE     DEFAULT 1;
   newpkgid     harpackage.packageobjid%TYPE DEFAULT 1;
   orphan       harform.formobjid%TYPE;
BEGIN
   OPEN select_orphans;
   FETCH select_orphans INTO orphan;

   IF select_orphans%FOUND
   THEN
      OPEN get_nextenvid;
      FETCH get_nextenvid INTO newenvid;
      OPEN  get_nextstateid;
      FETCH get_nextstateid INTO newstateid;
      OPEN get_nextpkgid;
      FETCH get_nextpkgid INTO newpkgid;

      INSERT INTO harenvironment
                  (
                     creationtime,
                     creatorid,
                     modifiedtime,
                     modifierid,
                     envobjid,
                     baselineviewid,
                     environmentname,
                     envisactive,
                     isarchive,
                     archiveby,
                     note
                  )
           VALUES (
              SYSDATE,
              1,
              SYSDATE,
              1,
              newenvid,
              0,
              'Conversion Orphanage',
              'Y',
              'N',
              1,
              'Created by Harvest 5 database conversion for unassociated forms.'
           );

      INSERT INTO harenvironmentaccess
                  (
                     envobjid,
                     usrgrpobjid,
                     secureaccess,
                     updateaccess,
                     viewaccess,
                     executeaccess
                  )
           VALUES (newenvid, 2, 'N', 'N', 'N', 'Y');

      INSERT INTO harstate
                  (
                     creationtime,
                     creatorid,
                     modifiedtime,
                     modifierid,
                     stateobjid,
                     envobjid,
                     statename,
                     note,
                     locationx,
                     locationy,
                     pmstatusindex,
                     snapshot,
                     stateorder,
                     viewobjid
                  )
           VALUES (
              SYSDATE,
              1,
              SYSDATE,
              1,
              newstateid,
              newenvid,
              'Conversion Orphanage',
              '',
              0,
              0,
              0,
              'N',
              0,
              -1
           );
--
-- PR# 1559: Dynamically execute Insert on previously altered table HarPackage
--

EXECUTE IMMEDIATE 'INSERT INTO harpackage
                  (
                     packageobjid,
                     stateobjid,
                     packagename,
                     envobjid,
                     status,
                     viewobjid,
                     approved,
                     creatorid,
                     creationtime,
                     modifierid,
                     modifiedtime,
                     stateentrytime
                  )
           VALUES (
              :newpkgid,
              :newstateid,
              ''Conversion Orphanage'',
              :newenvid,
              ''Idle'',
              -1,
              ''N'',
              1,
              SYSDATE,
              1,
              SYSDATE,
              SYSDATE
           )' USING newpkgid, newstateid, newenvid;

--
--

      INSERT INTO harpkghistory
                  (
                     packageobjid,
                     action,
                     statename,
                     environmentname,
                     execdtime,
                     usrobjid
                  )
           VALUES (
              newpkgid,
              'Created',
              'Conversion Orphanage',
              'Conversion Orphanage',
              SYSDATE,
              1
           );

      INSERT INTO harassocpkg
                  (formobjid, assocpkgid)
            SELECT f.formobjid, newpkgid
            FROM harform f
            WHERE NOT EXISTS (SELECT a.formobjid
                              FROM harassocpkg a
                              WHERE f.formobjid = a.formobjid);
   END IF;
END;
/