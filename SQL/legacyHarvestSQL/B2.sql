/*
 * B2.sql
 *
 * Upgrade database from Harvest 5 Beta 2.x to current release
 *
 * Ignore errors so this script can be run more than once
 */
WHENEVER SQLERROR CONTINUE;
spool &1;

ALTER TABLE harPackage DROP CONSTRAINT harPackage_AID_FK;
ALTER TABLE harPackage ADD( CONSTRAINT harPackage_AID_FK 
                            FOREIGN KEY (ASSIGNEEID) 
                            REFERENCES HARALLUSERS(USROBJID));

CREATE INDEX harPkgsInPkgGrp_IND 
    ON harPkgsInPkgGrp (PKGGRPOBJID ) 
    TABLESPACE HARVESTINDEX;
/*
 *  Upgrade from B2_05 
 */
 INSERT INTO harVersions
            (
               versionobjid,
               itemobjid,
               packageobjid,
               parentversionid,
               mergedversionid,
               inbranch,
               creationtime,
               creatorid,
               modifiedtime,
               modifierid,
               versiondataobjid,
               description
            )
     VALUES (0, 0, 0, 0, 0, 0, SYSDATE, 1, SYSDATE, 1, 0, 'Dummy version');

INSERT INTO harItemAccess
            (itemobjid, usrgrpobjid, viewaccess)
     VALUES (0, 2, 'N');

DROP INDEX HARITEMACCESS_IND2;
/*
 *  Upgrade from B2_07 
 */
DROP TABLE harPackageMovement;

commit;
spool off
EXIT
