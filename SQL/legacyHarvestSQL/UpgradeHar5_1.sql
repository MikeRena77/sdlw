/*
 * Upgrade.sql
 *
 * PR#3525- PROMOTE PKG TAKING TOO LONG
 *
 * Copyright (c) 2004 Computer Associates inc. All rights reserved.
 *
 * Upgrade Harvest 5 schema and data.
 */
WHENEVER SQLERROR EXIT FAILURE
SPOOL &1;
SET document ON

define HARVESTINDEX=HARVESTINDEX
define HARVESTMETA=HARVESTMETA
define HARVESTBLOB=HARVESTBLOB

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

         UPDATE harpackage
            SET assigneeid = -1
          WHERE assigneeid IS NULL;

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
 * in a prior installation. These failures are benign and should be ignored.
 */
--
-- Unable to use DDL in PL/SQL block
WHENEVER SQLERROR CONTINUE  
/*
 * Errors due to repeated execution are benign and should be ignored.
 */
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
/*
 * Errors due to repeated execution are benign and should be ignored.
 */
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
/*
 * Errors due to repeated execution are benign and should be ignored.
 */
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
   USING INDEX TABLESPACE "&HARVESTINDEX",
   CONSTRAINT HARFORMATTACHMENT_FORMOBJID_FK FOREIGN KEY (FORMOBJID) 
      REFERENCES HARFORM (FORMOBJID)
      ON DELETE CASCADE
)
TABLESPACE "&HARVESTBLOB";

CREATE INDEX HARFORMATTACHMENT_IND
   ON HARFORMATTACHMENT(FORMOBJID)
   TABLESPACE "&HARVESTINDEX";

CREATE UNIQUE INDEX HARFORMATTACHMENT_IND2
   ON HARFORMATTACHMENT(ATTACHMENTNAME, FORMOBJID)
   TABLESPACE "&HARVESTINDEX";

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
/*
 * Errors due to repeated execution are benign and should be ignored.
 */
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
    TABLESPACE "&HARVESTBLOB";
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
/*
 * Errors due to repeated execution are benign and should be ignored.
 */
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
  FROM harallchildrenpath
 WHERE 51100 = (SELECT versionindicator
                  FROM hartableinfo)
   AND NOT EXISTS (SELECT i.itemobjid
                     FROM haritems i
                    WHERE itemtype = 0
                      AND harallchildrenpath.childitemid = i.itemobjid);
COMMIT;
--
/* 
 * Errors due to repeated execution are benign and should be ignored.
 */
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
    TABLESPACE "&HARVESTINDEX";

--
-- Harvest 5.2 changes
--
ALTER TABLE harCheckinProc 
ADD(FORCECOMMENT CHAR(1)  DEFAULT 'N' NOT NULL);

CREATE TABLE HARSWITCHPKGPROC
(
 PROCESSOBJID  INT NOT NULL,
 PROCESSNAME   CHAR(128) NOT NULL,
 STATEOBJID    INT NOT NULL,
 CREATIONTIME  DATE NOT NULL,
 CREATORID     INT NOT NULL,
 MODIFIEDTIME  DATE NOT NULL,
 MODIFIERID    INT NOT NULL,
 NOTE          VARCHAR2(2000) NULL,
 CONSTRAINT HARSWITCHPKGPROC_PK PRIMARY KEY (PROCESSOBJID)
    USING INDEX TABLESPACE "&HARVESTINDEX", 
 CONSTRAINT HARSWITCHPKGPROC_SPID_FK FOREIGN KEY (STATEOBJID, PROCESSOBJID) 
   REFERENCES HARSTATEPROCESS (STATEOBJID, PROCESSOBJID) ON DELETE CASCADE
)
TABLESPACE "&HARVESTMETA"
;


COMMIT;

-- ADD PRIMARY KEY TO HARASSOCPKG
DROP INDEX HARASSOCPKG_IND;
CREATE UNIQUE INDEX "HARASSOCPKG_PK" 
	ON "HARASSOCPKG" 
	("FORMOBJID" 
	, "ASSOCPKGID" )         
	TABLESPACE "&HARVESTINDEX" LOGGING;
ALTER TABLE "HARASSOCPKG" 
	ADD CONSTRAINT "HARASSOCPKG_PK" PRIMARY KEY 
	("FORMOBJID" 
	, "ASSOCPKGID" ) USING INDEX        
	TABLESPACE "&HARVESTINDEX" LOGGING;



-- FOREIGN KEYS NECESSARY FOR IMPROVED CASCADE PERFORMANCE

CREATE INDEX "HARBRANCH_ITEMID_FK" 
ON "HARBRANCH" 
	("ITEMOBJID") 
	TABLESPACE "&HARVESTINDEX";

CREATE INDEX "HARITEMS_PID_FK" 
ON "HARITEMS" 
	("PARENTOBJID") 
	TABLESPACE "&HARVESTINDEX";

CREATE INDEX "HARVERSIONDATA_ITMID_FK" 
ON "HARVERSIONDATA" 
	("ITEMOBJID") 
	TABLESPACE "&HARVESTINDEX";

-- Enhancement Request 11463248/2
-- Convert CHAR(128) to VARCHAR2(128) where applicable
ALTER TABLE HARENVIRONMENT    MODIFY ENVIRONMENTNAME VARCHAR2(128);
ALTER TABLE HARSTATE          MODIFY STATENAME       VARCHAR2(128);

WHENEVER SQLERROR EXIT FAILURE
      
      	-- Enhancement Request 11463248/2 : Convert CHAR(128) to VARCHAR2(128)
      	update harstate s set s.statename = rtrim(s.statename) 
      	where length(rtrim(s.statename)) > 0
      	and 51100 = (SELECT versionindicator
                 FROM hartableinfo);
                 
	update harenvironment e set e.environmentname = rtrim(e.environmentname) 
	where length(rtrim(e.environmentname)) > 0
	and 51100 = (SELECT versionindicator
                 FROM hartableinfo);
      

WHENEVER SQLERROR CONTINUE
      
        -- New Default extensions
        insert into harfileextension(repositobjid,fileextension) values (0,'XML');
	insert into harfileextension(repositobjid,fileextension) values (0,'PROPERTIES');
	insert into harfileextension(repositobjid,fileextension) values (0,'CLASSPATH');
	insert into harfileextension(repositobjid,fileextension) values (0,'TEMPLATE');
	insert into harfileextension(repositobjid,fileextension) values (0,'PROJECT');

	-- For create empty path
	insert into harpackage
	(
		PACKAGEOBJID,
		PACKAGENAME,
		ENVOBJID,
		STATEOBJID,
		VIEWOBJID,
		APPROVED,
		STATUS,
		CREATIONTIME,
		CREATORID,
		MODIFIEDTIME,
		MODIFIERID,
		PACKAGEDES,
		NOTE,
		PRIORITY,
		ASSIGNEEID,
		STATEENTRYTIME,
		CLIENTNAME,
		SERVERNAME
	) 
	values(-1,'EMPTY_PATHS',0,0,-1, 'N', 'Idle',SYSDATE,1,SYSDATE,1,'undefined package',' ',0,-1, SYSDATE,' ',' ');
    
 COMMIT;
     
-- HASCHILD INDEX
CREATE INDEX HARVERSIONS_MERGED_IDX 
ON HARVERSIONS        
	(MERGEDVERSIONID)    
TABLESPACE "&HARVESTINDEX";

ALTER TABLE HARCRPKGPROC
ADD(DISABLENAMECHANGE CHAR(1)  DEFAULT 'N' NOT NULL);

-- PR1885 Index Version Status
CREATE INDEX HARVERSIONS_VSTATUS 
ON HARVERSIONS
( itemobjid, versionstatus )
TABLESPACE "&HARVESTINDEX";

WHENEVER SQLERROR EXIT FAILURE

-- PR1034 Index Updates
set serveroutput on
DECLARE
  Index_Count INTEGER;
  cid INTEGER;
BEGIN

   -- Open new cursor and return cursor ID. 
   cid := DBMS_SQL.OPEN_CURSOR;

   -- Check if INDEX HARVERSIONS_ITEM_IND(ItemObjId) ON HarVersions exists. 
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Index_Name = 'HARVERSIONS_ITEM_IND' AND
      Table_Name = 'HARVERSIONS' AND 
      Column_Name = 'ITEMOBJID' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   -- Drop INDEX HARVERSIONS_ITEM_IND(ItemObjId) ON HarVersions if it exists. 
   IF (Index_Count > 0) THEN
     DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_ITEM_IND', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId) DROPPED');
   END IF;   

   -- Check if INDEX(ItemObjId, VersionObjId) ON HarVersions exists. 
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1
   WHERE Index_Name IN
      (  (
            SELECT Index_Name 
            FROM USER_IND_COLUMNS
            WHERE Table_Name = 'HARVERSIONS' AND Column_Name = 'ITEMOBJID' AND Column_Position = 1
         )
         INTERSECT
         (
            SELECT Index_Name 
            FROM USER_IND_COLUMNS
            WHERE Table_Name = 'HARVERSIONS' AND Column_Name = 'VERSIONOBJID' AND Column_Position = 2
         )
      ) AND
      2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   -- Create INDEX(ItemObjId, VersionObjId) ON HarVersions if it does not exist. 
   IF (Index_Count = 0) THEN
     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId) TABLESPACE HARVESTINDEX', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId) CREATED');
   ELSE
     DBMS_OUTPUT.PUT_LINE('INDEX ON HARVERSIONS (ItemObjId, VersionObjId) ALREADY EXISTS');
   END IF;   

   -- Check if INDEX(ViewType, EnvObjId, ViewObjId) ON HarView exists. 
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1
   WHERE Index_Name IN
      (  (
            SELECT Index_Name 
            FROM USER_IND_COLUMNS
            WHERE Table_Name = 'HARVIEW' AND Column_Name = 'VIEWTYPE' AND Column_Position = 1
         )
         INTERSECT
         (
            SELECT Index_Name 
            FROM USER_IND_COLUMNS
            WHERE Table_Name = 'HARVIEW' AND Column_Name = 'ENVOBJID' AND Column_Position = 2
         )
         INTERSECT
         (
            SELECT Index_Name 
            FROM USER_IND_COLUMNS
            WHERE Table_Name = 'HARVIEW' AND Column_Name = 'VIEWOBJID' AND Column_Position = 3
         )
      ) AND
      3 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   -- Create INDEX(ViewType, EnvObjId, ViewObjId) ON HarView if it does not exist. 
   IF (Index_Count = 0) THEN
     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVIEW_VIEWTYPE ON HARVIEW (ViewType, EnvObjId, ViewObjId) TABLESPACE HARVESTINDEX', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVIEW_VIEWTYPE ON HARVIEW (ViewType, EnvObjId, ViewObjId) CREATED');
   ELSE
     DBMS_OUTPUT.PUT_LINE('INDEX ON HARVIEW (ViewType, EnvObjId, ViewObjId) ALREADY EXISTS');
   END IF;   

   DBMS_SQL.CLOSE_CURSOR(cid);

EXCEPTION

-- If an exception is raised, close cursor before exiting. 

   WHEN OTHERS THEN
      DBMS_SQL.CLOSE_CURSOR(cid);
      RAISE;  -- reraise the exception
END;
/

WHENEVER SQLERROR EXIT FAILURE

UPDATE harTableInfo
   SET versionindicator = 52000;

--
-- PR# 1426 DELETE A STATE'S WORKING VIEW DOES NOT UPDATE ASSOCIATE PACKAGES
--

UPDATE HarPackage PK
SET ViewObjId = -1
WHERE NOT EXISTS(SELECT * FROM HarView VW WHERE VW.ViewObjId = PK.ViewObjId)
AND 52100 > (SELECT versionindicator
               FROM hartableinfo);
--
-- PR# 1208 - 13253128 - PERFORMANCE:VCI UNDO CHK OUT
--
set serveroutput on
DECLARE
  Index_Count INTEGER;
  cid INTEGER;
BEGIN

   -- Open new cursor and return cursor ID. 
   cid := DBMS_SQL.OPEN_CURSOR;
   --
   --  Add indexes from Harvest 5.1.1 DB Patches that are helpful to  
   --  Undo Checkout 
   --
   -- Check if INDEX(VersionStatus, ItemObjId, VersionObjId) ON HarVersions exists. 

   SELECT COUNT (*)
     INTO index_count
     FROM user_ind_columns i1
    WHERE index_name IN ((SELECT index_name
                            FROM user_ind_columns
                           WHERE table_name = 'HARVERSIONS'
                             AND column_name = 'VERSIONSTATUS'
                             AND column_position = 1)
                         INTERSECT
                         (SELECT index_name
                            FROM user_ind_columns
                           WHERE table_name = 'HARVERSIONS'
                             AND column_name = 'ITEMOBJID'
                             AND column_position = 2)
                         INTERSECT
                         (SELECT index_name
                            FROM user_ind_columns
                           WHERE table_name = 'HARVERSIONS'
                             AND column_name = 'VERSIONOBJID'
                             AND column_position = 3))
      AND 3 =
           (SELECT COUNT (*)
              FROM user_ind_columns i2
             WHERE i1.index_name = i2.index_name);

-- Create INDEX(VersionStatus, ItemObjId, VersionObjId) ON HarVersions if it does not exist. 

   IF (index_count = 0)
   THEN
      -- Parse and immediately execute dynamic SQL statement.

      DBMS_SQL.parse (
         cid,
         'CREATE INDEX HARVERSIONS_STATUS ON HARVERSIONS (VersionStatus, ItemObjId, VersionObjId) TABLESPACE HARVESTINDEX',
         DBMS_SQL.native  );

         DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_STATUS ON HARVERSIONS (VersionStatus, ItemObjId, VersionObjId) CREATED');    
   END IF;
-- Check if INDEX HARVERSIONS_ITEM_IND(ItemObjId) ON HarVersions exists. 

   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Index_Name = 'HARVERSIONS_ITEM_IND' AND
      Table_Name = 'HARVERSIONS' AND 
      Column_Name = 'ITEMOBJID' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

-- Drop INDEX HARVERSIONS_ITEM_IND(ItemObjId) ON HarVersions if it exists. 

   IF (Index_Count > 0) THEN

   -- Parse and immediately execute dynamic SQL statement.

      DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_ITEM_IND', DBMS_SQL.NATIVE);
      DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId) DROPPED');    
   END IF;   

-- Check if INDEX(ItemObjId, VersionObjId) ON HarVersions exists. 

   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1
   WHERE Index_Name IN
      (  (
            SELECT Index_Name 
            FROM USER_IND_COLUMNS
            WHERE Table_Name = 'HARVERSIONS' AND Column_Name = 'ITEMOBJID' AND Column_Position = 1
         )
         INTERSECT
         (
            SELECT Index_Name 
            FROM USER_IND_COLUMNS
            WHERE Table_Name = 'HARVERSIONS' AND Column_Name = 'VERSIONOBJID' AND Column_Position = 2
         )
      ) AND
      2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

-- Create INDEX(ItemObjId, VersionObjId) ON HarVersions if it does not exist. 

   IF (Index_Count = 0) THEN

   -- Parse and immediately execute dynamic SQL statement.

      DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId) TABLESPACE HARVESTINDEX', DBMS_SQL.NATIVE);
      DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId) CREATED');    

   END IF;   

   -- Check if INDEX(ItemObjId) ON HarVersions exists. 

   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Table_Name = 'HARVERSIONS' AND 
      Column_Name = 'ITEMOBJID' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

-- Create INDEX(ItemObjId) ON HarVersions if it does not exist. 

   IF (Index_Count = 0) THEN

   -- Parse and immediately execute dynamic SQL statement.

      DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_ITEMOBJID ON HARVERSIONS (ItemObjId) TABLESPACE HARVESTINDEX', DBMS_SQL.NATIVE);
      DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEMOBJID ON HARVERSIONS (ItemObjId) CREATED');    

   END IF;   
--
-- Drop indexes introduced by Conversion
--
   -- Check if INDEX HARVERSIONS_DATAID_IND(VersionDataObjId) ON HarVersions exists. 
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Index_Name  = 'HARVERSIONS_DATAID_IND' AND
      Table_Name  = 'HARVERSIONS' AND 
      Column_Name = 'VERSIONDATAOBJID' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   -- Drop INDEX HARVERSIONS_DATAID_IND(VersionDataObjId) ON HarVersions if it exists. 
   IF (Index_Count > 0) THEN
     DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_DATAID_IND', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_DATAID_IND ON HARVERSIONS (VersionDataObjId) DROPPED');
   END IF; 

   -- Check if INDEX HARVERSIONS_DATAOBJID(VersionDataObjId) ON 
   -- HarVersions exists. 
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Index_Name  = 'HARVERSIONS_DATAOBJID' AND
      Table_Name  = 'HARVERSIONS' AND 
      Column_Name = 'VERSIONDATAOBJID' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   -- Drop INDEX HARVERSIONS_DATAID_IND(VersionDataObjId) ON HarVersions if it exists. 
   IF (Index_Count > 0) THEN
     DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_DATAOBJID', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_DATAOBJID ON HARVERSIONS (VersionDataObjId) DROPPED');
   END IF; 

   -- Check if INDEX HARVERSIONS_INBRANCH(INBRANCH) ON HarVersions exists. 
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Index_Name  = 'HARVERSIONS_INBRANCH' AND
      Table_Name  = 'HARVERSIONS' AND 
      Column_Name = 'INBRANCH' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   -- Drop INDEX HARVERSIONS_INBRANCH(InBranch) ON HarVersions if it exists. 
   IF (Index_Count > 0) THEN
     DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_INBRANCH', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_INBRANCH ON HARVERSIONS (InBranch) DROPPED');
   END IF; 
--
   DBMS_SQL.CLOSE_CURSOR(cid);


EXCEPTION

-- If an exception is raised, close cursor before exiting. 

   WHEN OTHERS THEN
      DBMS_SQL.CLOSE_CURSOR(cid);
      RAISE;  -- reraise the exception
END;
/

--
-- PR 2451, Issue 13101537. Update DB version indicator.
--
UPDATE harTableInfo
   SET versionindicator = 52100;

COMMIT;
--
-- Harvest 5.2.1 Maintenance Database Patch
--

WHENEVER SQLERROR EXIT FAILURE

DECLARE
  Table_Count INTEGER;
  cid INTEGER;
BEGIN

-- Open new cursor and return cursor ID. 

   cid := DBMS_SQL.OPEN_CURSOR;

--
-- PR# 1897 CREATE global temporary table haritemidtemp for cross project merge
--

-- Check if TABLE(HarItemIdTEMP) exists. 

   SELECT COUNT(*) INTO Table_Count
   FROM USER_TABLES 
   WHERE Table_Name = 'HARITEMIDTEMP';

-- Create TABLE(HarItemIdTEMP) if it does not exist. 

   IF (Table_Count = 0) THEN

   -- Parse and immediately execute dynamic SQL statement.

      DBMS_SQL.PARSE(cid, 'CREATE GLOBAL TEMPORARY TABLE HARITEMIDTEMP (ItemObjId NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);

   END IF;  
--
--
-- PR#3525 - CREATING TEMPORARY TABLE HARPROMOTETEMP FOR PROMOTE PROCESS
--

-- Check if TABLE(HARPROMOTETEMP) exists. 

   SELECT COUNT(*) INTO Table_Count
   FROM USER_TABLES 
   WHERE Table_Name = 'HARPROMOTETEMP';

-- Create TABLE(HARPROMOTETEMP) if it does not exist. 

   IF (Table_Count = 0) THEN

   -- Parse and immediately execute dynamic SQL statement.

      DBMS_SQL.PARSE(cid, 'CREATE GLOBAL TEMPORARY TABLE HARPROMOTETEMP (ITEMOBJID NUMBER,VERSIONOBJID NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);

   END IF;  

-- PR#3525 - END


-- Close cursor.

   DBMS_SQL.CLOSE_CURSOR(cid);

EXCEPTION

-- If an exception is raised, close cursor before exiting. 

   WHEN OTHERS THEN
      DBMS_SQL.CLOSE_CURSOR(cid);
      RAISE;  -- reraise the exception
END;
/

--
--

-- END OF UPGRADE.SQL
/*
 * Some schema changes may fail because the changes were already made
 * in a prior installation. These failures are benign and should be ignored.
 *
 * UPGRADE.SQL has completed successfully.
 *
 */ 

SPOOL off

EXIT


