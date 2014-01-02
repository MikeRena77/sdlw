/*
 * Upgrade.sql
 *
 * Upgrade Harvest 5 schema and data.
 */
WHENEVER SQLERROR EXIT FAILURE
SPOOL &1

DEFINE HARVESTINDEXTSNAME = &2
DEFINE HARVESTBLOBTSNAME = &3

SET document ON
--
-- Changes for Harvest 5.01
--
DECLARE
   CURSOR ver_cursor
   IS
      SELECT versionindicator
        FROM hartableinfo;

   ver_ind   hartableinfo.versionindicator%TYPE;
BEGIN
   OPEN ver_cursor;
   FETCH ver_cursor INTO ver_ind;

   IF ver_cursor%FOUND
   THEN
      IF ver_ind = 50000
      THEN
         INSERT INTO harallusers
                     (
                        usrobjid,
                        username,
                        loggedin,
                        creationtime,
                        creatorid,
                        modifiedtime,
                        modifierid
                     )
              VALUES (-1, ' ', 'N', SYSDATE, -1, SYSDATE, -1);

--
-- PR# 1559: Dynamically execute Update on previously altered table HarPackage
--

         EXECUTE IMMEDIATE 'UPDATE harpackage
            SET assigneeid = -1
          WHERE assigneeid IS NULL';

--
--

         INSERT INTO harrepositoryaccess
                     (
                        repositobjid,
                        usrgrpobjid,
                        secureaccess,
                        updateaccess,
                        viewaccess
                     )
              VALUES (0, 2, 'N', 'N', 'Y');

         UPDATE hartableinfo
            SET versionindicator = 50100;

         COMMIT;
      END IF;
   ELSE
      raise_application_error (-20000, 'Missing Harvest version indicator.');
   END IF;
END;
/
--
/*
 * Some schema changes may fail because the changes were already made
 * in a prior installation.
 */
--
-- Unable to use DDL in PL/SQL block
WHENEVER SQLERROR CONTINUE
-- Ignore errors due to repeated execution
ALTER table harPackage modify ( assigneeid default -1 not null );
--
-- Harvest 5.02 changes
--
WHENEVER SQLERROR EXIT FAILURE

DECLARE
   CURSOR ver_cursor
   IS
      SELECT versionindicator
        FROM hartableinfo;

   ver_ind   hartableinfo.versionindicator%TYPE;
BEGIN
   OPEN ver_cursor;
   FETCH ver_cursor INTO ver_ind;

   IF ver_cursor%FOUND
   THEN
      IF ver_ind = 50100
      THEN
         DELETE harversioninview viv
          WHERE NOT EXISTS (SELECT v.viewobjid
                              FROM harview v
                             WHERE viv.viewobjid = v.viewobjid);

         UPDATE harpackage
            SET packagename = RTRIM (packagename)
          WHERE packagename != RTRIM (packagename);

         COMMIT;
      END IF;
   END IF;
END;
/

-- Unable to use DDL in PL/SQL block
WHENEVER SQLERROR CONTINUE
-- Ignore errors due to repeated execution
ALTER TABLE harVersionInView
ADD CONSTRAINT HARVERSIONINVIEW_VIEWID_FK
 FOREIGN KEY (VIEWOBJID)
  REFERENCES HARVIEW(VIEWOBJID)
  ON DELETE CASCADE;

CREATE TABLE HARUSERDATA
(
 USROBJID      NUMBER NOT NULL,
 ENCRYPTPSSWD  BLOB NULL,
 CONSTRAINT HARUSERDATA_FK FOREIGN KEY (USROBJID)
   REFERENCES HARALLUSERS (USROBJID),
 CONSTRAINT HARUSERDATA_PK PRIMARY KEY (USROBJID)
);

ALTER TABLE HARTABLEINFO
ADD(SYSVARPW CHAR(1) DEFAULT 'N' NOT NULL);

-- Update version indicator last
WHENEVER SQLERROR EXIT FAILURE
UPDATE hartableinfo
   SET versionindicator = 50200
 WHERE versionindicator = 50100;
--
-- Harvest 5.1 changes
--
-- Unable to use DDL in PL/SQL block
WHENEVER SQLERROR CONTINUE
-- Ignore errors due to repeated execution
--
-- Schema changes for form attachments
--
CREATE TABLE HARFORMATTACHMENT
(
   ATTACHMENTOBJID      NUMBER,
   ATTACHMENTNAME    VARCHAR2(512) NOT NULL,
   ATTACHMENTTYPE    NUMBER NOT NULL,
   FORMOBJID         NUMBER NOT NULL,
   CREATORID         NUMBER NOT NULL,
   CREATIONTIME      DATE NOT NULL,
   FILESIZE       NUMBER NOT NULL,
   FILEDATA       BLOB NULL,
   CONSTRAINT HARFORMATTACHMENT_PK PRIMARY KEY (ATTACHMENTOBJID)
   USING INDEX TABLESPACE &HARVESTINDEXTSNAME,
   CONSTRAINT HARFORMATTACHMENT_FORMOBJID_FK FOREIGN KEY (FORMOBJID)
      REFERENCES HARFORM (FORMOBJID)
      ON DELETE CASCADE
)
TABLESPACE &HARVESTBLOBTSNAME;

CREATE INDEX HARFORMATTACHMENT_IND
   ON HARFORMATTACHMENT(FORMOBJID)
   TABLESPACE &HARVESTINDEXTSNAME;

CREATE UNIQUE INDEX HARFORMATTACHMENT_IND2
   ON HARFORMATTACHMENT(ATTACHMENTNAME, FORMOBJID)
   TABLESPACE &HARVESTINDEXTSNAME;

CREATE SEQUENCE HARFORMATTACHMENTSEQ
   INCREMENT BY 1 NOMAXVALUE MINVALUE 1 NOCYCLE CACHE 5 NOORDER;

INSERT INTO harobjectsequenceid
            (hartablename, harsequenceid)
   SELECT 'harFormAttachment', 'harFormAttachmentSeq'
     FROM hartableinfo
    WHERE versionindicator = 50200;
--
-- Schema change after 5.1 Beta release
--
ALTER TABLE HARFORMATTACHMENT
ADD(FILECOMPRESSED      CHAR(1) DEFAULT 'N' NOT NULL);
--
-- End of Form attachment changes
--
WHENEVER SQLERROR EXIT FAILURE

UPDATE hartableinfo
   SET versionindicator = 51000
 WHERE versionindicator = 50200;

COMMIT;
--
-- Harvest 5.1.1 changes
--
-- Unable to use DDL in PL/SQL block
WHENEVER SQLERROR CONTINUE
-- Ignore errors due to repeated execution
--
-- Changes for Password policy
--
CREATE TABLE harPasswordPolicy (MaxAge NUMBER DEFAULT -1 NOT NULL,
                                MinAge NUMBER DEFAULT 0 NOT NULL,
                                MinLen NUMBER DEFAULT 6 NOT NULL,
                                ReuseRule NUMBER DEFAULT 0 NOT NULL,
                                MaxFailures NUMBER DEFAULT -1 NOT NULL,
                                AllowUsrChgExp CHAR(1) DEFAULT 'Y' NOT NULL,
                                WarningAge NUMBER DEFAULT -1 NOT NULL,
                                ChRepetition NUMBER DEFAULT -1 NOT NULL,
                                MinNumeric NUMBER DEFAULT 0 NOT NULL,
                                LowerCase NUMBER DEFAULT 0 NOT NULL,
                                UpperCase NUMBER DEFAULT 0 NOT NULL,
                                NonAlphaNum NUMBER DEFAULT 0 NOT NULL,
                                AllowUserName CHAR(1) DEFAULT 'Y' NOT NULL,
                                MODIFIEDTIME  DATE NOT NULL,
                                MODIFIERID    NUMBER NOT NULL,
    CONSTRAINT harPasswordPolicy_ModId_FK FOREIGN KEY (MODIFIERID)
                                 REFERENCES HARAllUSERs(USROBJID));


CREATE TABLE harPasswordHistory (UsrObjId NUMBER NOT NULL,
                                 PrevPsswds BLOB NOT NULL,
    CONSTRAINT harPasswordHistory_PK PRIMARY KEY (UsrObjId))
    TABLESPACE &HARVESTBLOBTSNAME;
--
-- Change foreign key in harUserData to reference harUser (current users)
-- instead of harAllUsers (current and deleted users)
--
ALTER TABLE HARUSERDATA DROP CONSTRAINT HARUSERDATA_FK CASCADE;

DELETE haruserdata
 WHERE usrobjid NOT IN (SELECT usrobjid
                          FROM haruser);

ALTER TABLE HARUSERDATA
ADD(MaxAge NUMBER  DEFAULT -2 NOT NULL,
    Failures NUMBER DEFAULT 0 NOT NULL,
    PsswdTime DATE);
--
-- DML can be contingent on database versionindicator
--
WHENEVER SQLERROR EXIT FAILURE

DECLARE
   CURSOR ver_cursor
   IS
      SELECT versionindicator
        FROM hartableinfo;

   ver_ind   hartableinfo.versionindicator%TYPE;
BEGIN
   OPEN ver_cursor;
   FETCH ver_cursor INTO ver_ind;

   IF ver_cursor%FOUND
   THEN
      IF ver_ind = 51000
      THEN
        UPDATE haruserdata ud
           SET psswdtime =
                  (SELECT modifiedtime
                     FROM haruser u
                    WHERE u.usrobjid = ud.usrobjid)
        WHERE psswdtime IS NULL;

        INSERT INTO harpasswordpolicy
                    (
                       maxage,
                       minage,
                       minlen,
                       reuserule,
                       maxfailures,
                       allowusrchgexp,
                       warningage,
                       chrepetition,
                       minnumeric,
                       lowercase,
                       uppercase,
                       nonalphanum,
                       allowusername,
                       modifiedtime,
                       modifierid
                    )
             VALUES (-1, 0, 6, 0, -1, 'Y', -1, -1, 0, 0, 0, 0, 'Y', SYSDATE, 2);


             UPDATE hartableinfo
                SET versionindicator = 51100;

             COMMIT;
      END IF;
   ELSE
      raise_application_error (-20000, 'Missing Harvest version indicator.');
   END IF;
END;
/
-- Unable to use DDL in PL/SQL block
WHENEVER SQLERROR CONTINUE
-- Ignore errors due to repeated execution
ALTER TABLE HARUSERDATA
ADD( CONSTRAINT harUserData_UsrId_FK FOREIGN KEY (USROBJID)
     REFERENCES HARUSER(USROBJID)
     ON DELETE CASCADE);

ALTER TABLE HARUSERDATA
MODIFY ( PsswdTime DATE NOT NULL);

-- Drop constraint that was created in 5.1 Build 3
ALTER TABLE HARPASSWORDHISTORY
DROP CONSTRAINT HARPASSWORDHISTORY_FK CASCADE;

ALTER TABLE HARPASSWORDHISTORY
ADD( CONSTRAINT HARPASSWORDHISTORY_FK FOREIGN KEY (USROBJID)
     REFERENCES HARUSER(USROBJID)
     ON DELETE CASCADE);
--
-- Alter foreign keys in harAllChildrenPath
--
-- Delete orphans resulting from missing constraint in previous
-- release.
--
WHENEVER SQLERROR EXIT FAILURE
DELETE
  FROM harallchildrenpath p
 WHERE 51100 = (SELECT versionindicator
                  FROM hartableinfo)
   AND NOT EXISTS (SELECT itemobjid
                     FROM haritems
                    WHERE itemtype = 0
                      AND p.childitemid = itemobjid);

COMMIT;
--
-- Ignore errors due to repeated execution
WHENEVER SQLERROR CONTINUE
ALTER TABLE HARALLCHILDRENPATH
DROP CONSTRAINT HARALLCHILDPATH_ITEMID_FK;

ALTER TABLE HARALLCHILDRENPATH
ADD CONSTRAINT harAllChildrenPath_ItemId_FK 
FOREIGN KEY (ITEMOBJID) REFERENCES HARITEMS(ITEMOBJID);  

ALTER TABLE HARALLCHILDRENPATH
ADD CONSTRAINT harAllChildrenPath_ChildId_FK 
FOREIGN KEY (CHILDITEMID) REFERENCES HARITEMS(ITEMOBJID) ON DELETE CASCADE;

CREATE INDEX HARVIV_VERS_IND ON HARVERSIONINVIEW( VERSIONOBJID)
    TABLESPACE &HARVESTINDEXTSNAME;
/*
 * End of Upgrade.sql
 */
SPOOL off

EXIT

