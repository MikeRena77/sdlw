/*
 * Upgrade.sql
 *
 * PR#3525- PROMOTE PKG TAKING TOO LONG
 * PR#3727- DEMOTE PKG TAKING TOO LONG
 *
 * Copyright (c) 2004 Computer Associates inc. All rights reserved.
 *
 * Upgrade Harvest 5 schema and data.
 */
WHENEVER SQLERROR EXIT FAILURE
SPOOL &1;
SET document ON
SET serveroutput ON
SET verify OFF
SET term ON
SET echo OFF
SET SERVEROUTPUT ON SIZE 1000000

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
      
        DBMS_OUTPUT.PUT_LINE('Upgrade to 5.0.1 ...');
        
        
        
         -- Insert Default user into HarAllUsers
         --
         
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
         
         DBMS_OUTPUT.PUT_LINE('Default user added to HarAllUsers');  
         
         

         -- Change NULL assigneeid to -1
         -- 
         
         UPDATE harpackage
            SET assigneeid = -1
          WHERE assigneeid IS NULL;
          
         DBMS_OUTPUT.PUT_LINE('HarPackage assigneeid updated from NULL to -1');
         
         
         
         -- Add default repository access
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
              
         DBMS_OUTPUT.PUT_LINE('Default repository access added to HarRepositoryAccess');     
             
             
             
         -- Modify column HarPackage (assigneeid) to default -1 not null
         --
         
         BEGIN
           execute immediate
             'ALTER table harPackage modify ( assigneeid default -1 not null )';
           DBMS_OUTPUT.PUT_LINE('HarPackage (assigneeid) modified to default -1 not null');
         EXCEPTION 
           WHEN OTHERS THEN RAISE; 
         END;
         
         

         UPDATE hartableinfo
            SET versionindicator = 50100;
            
            
            
         DBMS_OUTPUT.PUT_LINE('Upgrade to 5.0.1 complete.');   

         COMMIT;
         
      END IF;
   ELSE
      raise_application_error (-20000, 'Missing Harvest version indicator.');
   END IF;
   
   EXCEPTION
     WHEN OTHERS THEN
       RAISE PROGRAM_ERROR;
END;
/




--
-- Harvest 5.02 changes
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
      IF ver_ind = 50100
      THEN
      
         DBMS_OUTPUT.PUT_LINE('Upgrade to 5.0.2 ...');
         
         
         
         -- HARVERSIONINVIEW orphan records cleanup
         --
         
         BEGIN
           DELETE harversioninview viv
            WHERE NOT EXISTS (SELECT v.viewobjid
                              FROM harview v
                             WHERE viv.viewobjid = v.viewobjid);
                             
           DBMS_OUTPUT.PUT_LINE('HARVERSIONINVIEW orphan records removed.');
         EXCEPTION 
            WHEN OTHERS THEN  
              RAISE;
         END;
         
         
         
         -- HARPACKAGE (packagename) spaces removal
         --
         
         UPDATE harpackage
            SET packagename = RTRIM (packagename)
          WHERE packagename != RTRIM (packagename);
          
         DBMS_OUTPUT.PUT_LINE('HARPACKAGE (packagename) spaces removed.'); 
          
          
          
         -- HARVERSIONINVIEW_VIEWID_FK creation
         --
         
         BEGIN
            execute immediate 
              'ALTER TABLE harVersionInView 
               ADD CONSTRAINT HARVERSIONINVIEW_VIEWID_FK
               FOREIGN KEY (VIEWOBJID)
               REFERENCES HARVIEW(VIEWOBJID)
               ON DELETE CASCADE';
            
            DBMS_OUTPUT.PUT_LINE('HARVERSIONINVIEW_VIEWID_FK constraint created.');
         EXCEPTION 
            WHEN OTHERS THEN 
              DBMS_OUTPUT.PUT_LINE('HARVERSIONINVIEW_VIEWID_FK creation failed.'); 
              RAISE;
         END;



         -- HARUSERDATA table creation
         --
         
         BEGIN
            execute immediate
            'CREATE TABLE HARUSERDATA
             (
                USROBJID      NUMBER NOT NULL,
                ENCRYPTPSSWD  BLOB NULL,
                CONSTRAINT HARUSERDATA_FK FOREIGN KEY (USROBJID) 
                REFERENCES HARALLUSERS (USROBJID),
                CONSTRAINT HARUSERDATA_PK PRIMARY KEY (USROBJID) 
             )';
          
            DBMS_OUTPUT.PUT_LINE('HARUSERDATA table created.');
         EXCEPTION 
            WHEN OTHERS THEN 
              DBMS_OUTPUT.PUT_LINE('HARUSERDATA table creation failed.'); 
              RAISE;
         END;



         -- SYSVARPW column addition to HARTABLEINFO
         --
         
         BEGIN
            execute immediate
            'ALTER TABLE HARTABLEINFO ADD(SYSVARPW CHAR(1) DEFAULT ''N'' NOT NULL)';
            DBMS_OUTPUT.PUT_LINE('SYSVARPW column added to HARTABLEINFO.');
         EXCEPTION 
            WHEN OTHERS THEN 
              DBMS_OUTPUT.PUT_LINE('SYSVARPW addition failed.');
              RAISE; 
         END;



         UPDATE hartableinfo
           SET versionindicator = 50200;
           
           
           
         DBMS_OUTPUT.PUT_LINE('Upgrade to 5.0.2 complete.');  
          
         COMMIT;
         
      END IF;
   END IF;
   
   EXCEPTION
   WHEN OTHERS THEN
      RAISE PROGRAM_ERROR;
END;
/



 
 
--
-- Harvest 5.1 changes
--
DECLARE
   CURSOR ver_cursor
   IS
      SELECT versionindicator
        FROM hartableinfo;

   ver_ind   hartableinfo.versionindicator%TYPE;
   
   UNIQUE_CONSTRAINT EXCEPTION;
   PRAGMA EXCEPTION_INIT(UNIQUE_CONSTRAINT, -1);
   
BEGIN
   OPEN ver_cursor;
   FETCH ver_cursor INTO ver_ind;

   IF ver_cursor%FOUND
   THEN
      IF ver_ind = 50200
      THEN
      
        DBMS_OUTPUT.PUT_LINE('Upgrade to 5.1 ...');



        -- Create HARFORMATTACHMENT table
        --
        
        BEGIN
          execute immediate
          'CREATE TABLE HARFORMATTACHMENT
           (
                ATTACHMENTOBJID   NUMBER,
    		ATTACHMENTNAME    VARCHAR2(512) NOT NULL,
   		ATTACHMENTTYPE    NUMBER NOT NULL,
   		FORMOBJID         NUMBER NOT NULL,
   		CREATORID         NUMBER NOT NULL,
   		CREATIONTIME      DATE NOT NULL,
   		FILESIZE          NUMBER NOT NULL,
   		FILEDATA          BLOB NULL,
   		CONSTRAINT HARFORMATTACHMENT_PK PRIMARY KEY (ATTACHMENTOBJID) 
        	  USING INDEX TABLESPACE "&HARVESTINDEX",
   		CONSTRAINT HARFORMATTACHMENT_FORMOBJID_FK FOREIGN KEY (FORMOBJID) 
      		  REFERENCES HARFORM (FORMOBJID)
      		ON DELETE CASCADE
	    )
	    TABLESPACE "&HARVESTBLOB"';
	  
	   DBMS_OUTPUT.PUT_LINE('HarFormAttachment table created.');
         EXCEPTION 
           WHEN OTHERS THEN 
             DBMS_OUTPUT.PUT_LINE('HarFormAttachment table creation failed.'); 
             RAISE;
         END;
         
         
         
       -- Create HARFORMATTACHMENT Index on (FORMOBJID)
       --
       
       BEGIN
         execute immediate
          'CREATE INDEX HARFORMATTACHMENT_IND
           ON HARFORMATTACHMENT(FORMOBJID)
           TABLESPACE "&HARVESTINDEX"';
           
         DBMS_OUTPUT.PUT_LINE('INDEX HARFORMATTACHMENT_IND ON HARFORMATTACHMENT (FORMOBJID) created.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('HARFORMATTACHMENT_IND index creation failed.'); 
           RAISE;
       END;
       
       
       
       -- Create HARFORMATTACHMENT Index on (ATTACHMENTNAME, FORMOBJID)  
       --
       
       BEGIN
         execute immediate
          'CREATE UNIQUE INDEX HARFORMATTACHMENT_IND2
           ON HARFORMATTACHMENT(ATTACHMENTNAME, FORMOBJID)
           TABLESPACE "&HARVESTINDEX"';
           
         DBMS_OUTPUT.PUT_LINE('HARFORMATTACHMENT_IND2 ON HARFORMATTACHMENT(ATTACHMENTNAME, FORMOBJID) created.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('HARFORMATTACHMENT_IND2 creation failed.'); 
           RAISE;
       END;
       
       
       
       -- Create HARFORMATTACHMENT Sequence
       --
       
       BEGIN
         execute immediate
          'CREATE SEQUENCE HARFORMATTACHMENTSEQ 
           INCREMENT BY 1 NOMAXVALUE MINVALUE 1 NOCYCLE CACHE 5 NOORDER';
           
         DBMS_OUTPUT.PUT_LINE('SEQUENCE HARFORMATTACHMENTSEQ created.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('SEQUENCE HARFORMATTACHMENTSEQ creation failed.'); 
           RAISE;
       END;

    
    
      -- Add HARFORMATTACHMENT sequence to sequence table
      --
      
      BEGIN
        insert into harobjectsequenceid (hartablename, harsequenceid) values ('harFormAttachment', 'harFormAttachmentSeq');
        DBMS_OUTPUT.PUT_LINE('HarFormAttachmentSeq added to harobjectsequenceid table');
      EXCEPTION 
        WHEN UNIQUE_CONSTRAINT 
           THEN DBMS_OUTPUT.PUT_LINE('harFormAttachmentSeq already exists');
        WHEN OTHERS 
           THEN RAISE; 
      END;     
         
       DBMS_OUTPUT.PUT_LINE('HARFORMATTACHMENTSEQ added to harobjectsequenceid table.');
       
       
         
       --
       -- Schema change after 5.1 Beta release
       --
         
         
       -- Add FILECOMPRESSED column to table HARFORMATTACHMENT
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARFORMATTACHMENT 
           ADD(FILECOMPRESSED      CHAR(1) DEFAULT ''Y'' NOT NULL)';
          
         DBMS_OUTPUT.PUT_LINE('FILECOMPRESSED column added to table HARFORMATTACHMENT.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('FILECOMPRESSED column addition failed.'); 
           RAISE;
       END;
       
       

       UPDATE hartableinfo
       SET versionindicator = 51000;
       

       DBMS_OUTPUT.PUT_LINE('Upgrade to 5.1 complete.');

       COMMIT;

      END IF;
   END IF;
   
   EXCEPTION
   WHEN OTHERS THEN
      RAISE PROGRAM_ERROR;
      
END;
/



--
-- Harvest 5.1.1 changes
--

DECLARE
   CURSOR ver_cursor
   IS
      SELECT versionindicator
        FROM hartableinfo;

   ver_ind   hartableinfo.versionindicator%TYPE;
   
   NAME_USED EXCEPTION;
   PRAGMA EXCEPTION_INIT(NAME_USED, -955);
   
   NOT_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(NOT_EXIST, -1418);
   
   FK_NOT_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(FK_NOT_EXIST, -2443);
   
BEGIN
   OPEN ver_cursor;
   FETCH ver_cursor INTO ver_ind;

   IF ver_cursor%FOUND
   THEN
      IF ver_ind = 51000
      THEN
      
      DBMS_OUTPUT.PUT_LINE('Upgrade to 5.1.1 ...');
      
      
      
       -- Changes for Password policy
       --  
       
       BEGIN
         execute immediate
          'CREATE TABLE harPasswordPolicy 
                               (MaxAge NUMBER DEFAULT -1 NOT NULL, 
                                MinAge NUMBER DEFAULT 0 NOT NULL, 
                                MinLen NUMBER DEFAULT 6 NOT NULL, 
                                ReuseRule NUMBER DEFAULT 0 NOT NULL, 
                                MaxFailures NUMBER DEFAULT -1 NOT NULL, 
                                AllowUsrChgExp CHAR(1) DEFAULT ''Y'' NOT NULL, 
                                WarningAge NUMBER DEFAULT -1 NOT NULL, 
                                ChRepetition NUMBER DEFAULT -1 NOT NULL, 
                                MinNumeric NUMBER DEFAULT 0 NOT NULL, 
                                LowerCase NUMBER DEFAULT 0 NOT NULL, 
                                UpperCase NUMBER DEFAULT 0 NOT NULL, 
                                NonAlphaNum NUMBER DEFAULT 0 NOT NULL, 
                                AllowUserName CHAR(1) DEFAULT ''Y'' NOT NULL,
                                MODIFIEDTIME  DATE NOT NULL,
                                MODIFIERID    NUMBER NOT NULL,  
           CONSTRAINT harPasswordPolicy_ModId_FK FOREIGN KEY (MODIFIERID) 
                                 REFERENCES HARAllUSERs(USROBJID))';
                                 
         DBMS_OUTPUT.PUT_LINE('TABLE harPasswordPolicy created.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('TABLE harPasswordPolicy creation failed.');
           RAISE; 
       END;


       
       -- CREATE TABLE harPasswordHistory
       --
       
       BEGIN
         execute immediate
          'CREATE TABLE harPasswordHistory (UsrObjId NUMBER NOT NULL, 
                                 PrevPsswds BLOB NOT NULL,  
	    CONSTRAINT harPasswordHistory_PK PRIMARY KEY (UsrObjId)) 
	    TABLESPACE "&HARVESTBLOB"';
	    
         DBMS_OUTPUT.PUT_LINE('TABLE harPasswordHistory created.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('TABLE harPasswordHistory creation failed.'); 
           RAISE;
       END;
       
       

       -- Change foreign key in harUserData to reference harUser (current users)
       -- instead of harAllUsers (current and deleted users)
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARUSERDATA DROP CONSTRAINT HARUSERDATA_FK CASCADE';
          
          DBMS_OUTPUT.PUT_LINE('CONSTRAINT HARUSERDATA_FK dropped.');
       EXCEPTION 
          WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('CONSTRAINT HARUSERDATA_FK drop failed.'); 
            RAISE;
       END;
       
       
       
       -- Remove Orphan Users from HarUserData table
       --
       
       BEGIN
         execute immediate
          'DELETE haruserdata
 	   WHERE usrobjid NOT IN (SELECT usrobjid
                                  FROM haruser)';
                                  
         DBMS_OUTPUT.PUT_LINE('Orphan Users Removed from HarUserData table');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('Orphan Users removal from harUserData failed.'); 
           RAISE;
       END;

       
       
       -- Add new columns for password policy enhancement
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARUSERDATA 
	   ADD(MaxAge NUMBER  DEFAULT -2 NOT NULL, 
           Failures NUMBER DEFAULT 0 NOT NULL, 
           PsswdTime DATE)';
           
         DBMS_OUTPUT.PUT_LINE('HARUSERDATA (MaxAge, Failures, PsswdTime) columns added.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('HARUSERDATA (MaxAge, Failures, PsswdTime) column addition failed.'); 
           RAISE;
       END;
       
       
       
       -- Update HARUSERDATA (PsswdTime) to last modified time
       --
       
       BEGIN
         execute immediate
         'UPDATE haruserdata
          SET PsswdTime =
                  (SELECT modifiedtime
                     FROM haruser u
                    WHERE u.usrobjid = haruserdata.usrobjid)
          WHERE PsswdTime IS NULL';
        
        DBMS_OUTPUT.PUT_LINE('HARUSERDATA (PsswdTime) updated to last modified time.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('HARUSERDATA (PsswdTime) update failed.'); 
           RAISE;
       END;
       
       
       
       -- Insert defaults into HARPASSWORDPOLICY table
       --
       
       BEGIN
         execute immediate
         'INSERT INTO harpasswordpolicy
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
         VALUES (-1, 0, 6, 0, -1, ''Y'', -1, -1, 0, 0, 0, 0, ''Y'', SYSDATE, 2)';
         
         DBMS_OUTPUT.PUT_LINE('HARPASSWORDPOLICY defaults set.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('HARPASSWORDPOLICY defaults failed.'); 
           RAISE;
       END;
       
       
         
       -- HARUSERDATA (PsswdTime) modification to NOT NULL
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARUSERDATA 
           MODIFY ( PsswdTime DATE NOT NULL)';
           
         DBMS_OUTPUT.PUT_LINE('HARUSERDATA (PsswdTime) modified.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('HARUSERDATA (PsswdTime) modification failed.'); 
           RAISE;
       END;

       
       
       -- Add CONSTRAINT harUserData_UsrId_FK to HARUSERDATA
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARUSERDATA 
           ADD( CONSTRAINT harUserData_UsrId_FK FOREIGN KEY (USROBJID) 
           REFERENCES HARUSER(USROBJID)
           ON DELETE CASCADE)';
           
         DBMS_OUTPUT.PUT_LINE('CONSTRAINT harUserData_UsrId_FK on HARUSERDATA added.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('CONSTRAINT harUserData_UsrId_FK on HARUSERDATA failed.'); 
           RAISE;
       END;
       
       
       
       -- Drop constraint HARPASSWORDHISTORY_FK that was created in 5.1 Build 3
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARPASSWORDHISTORY 
           DROP CONSTRAINT HARPASSWORDHISTORY_FK CASCADE';
            
         DBMS_OUTPUT.PUT_LINE('HARPASSWORDHISTORY_FK constraint dropped.');
       EXCEPTION 
         WHEN FK_NOT_EXIST THEN
           DBMS_OUTPUT.PUT_LINE('HARPASSWORDHISTORY_FK constraint does not exist.');
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('HARPASSWORDHISTORY_FK constraint drop failed.');
           RAISE; 
       END;

        
       
       -- Recreate correct HARPASSWORDHISTORY_FK constraint
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARPASSWORDHISTORY 
           ADD( CONSTRAINT HARPASSWORDHISTORY_FK FOREIGN KEY (USROBJID) 
           REFERENCES HARUSER(USROBJID)
           ON DELETE CASCADE)';
           
         DBMS_OUTPUT.PUT_LINE('HARPASSWORDHISTORY_FK constraint added.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('HARPASSWORDHISTORY_FK addition failed.'); 
           RAISE;
       END;



       -- Delete orphans resulting from missing constraint in previous release.
       --  
       
       BEGIN
         execute immediate
          'DELETE FROM harallchildrenpath
           WHERE NOT EXISTS (SELECT i.itemobjid
                             FROM haritems i
                             WHERE i.itemtype = 0
                             AND harallchildrenpath.childitemid = i.itemobjid)';
                            
         DBMS_OUTPUT.PUT_LINE('HarAllChildrenPath orphans removed.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('Warning: HarAllChildrenPath orphan removal failed.'); 
           RAISE;
       END;



       --
       -- Alter foreign keys in harAllChildrenPath
       --
       
       -- CONSTRAINT HARALLCHILDPATH_ITEMID_FK
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARALLCHILDRENPATH
           DROP CONSTRAINT HARALLCHILDPATH_ITEMID_FK';
           
         DBMS_OUTPUT.PUT_LINE('CONSTRAINT HARALLCHILDPATH_ITEMID_FK dropped.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('CONSTRAINT HARALLCHILDPATH_ITEMID_FK correctly failed.'); 
       END;

       
       
       -- CONSTRAINT harAllChildrenPath_ItemId_FK
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARALLCHILDRENPATH
           ADD CONSTRAINT harAllChildrenPath_ItemId_FK 
           FOREIGN KEY (ITEMOBJID) REFERENCES HARITEMS(ITEMOBJID)';  
           
         DBMS_OUTPUT.PUT_LINE('CONSTRAINT harAllChildrenPath_ItemId_FK created.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('CONSTRAINT harAllChildrenPath_ItemId_FK failed.'); 
           RAISE;
       END;



       -- CONSTRAINT harAllChildrenPath_ChildId_FK
       --
       
       BEGIN
         execute immediate
          'ALTER TABLE HARALLCHILDRENPATH
           ADD CONSTRAINT harAllChildrenPath_ChildId_FK 
           FOREIGN KEY (CHILDITEMID) REFERENCES HARITEMS(ITEMOBJID) 
           ON DELETE CASCADE';
         
         DBMS_OUTPUT.PUT_LINE('CONSTRAINT harAllChildrenPath_ChildId_FK created.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('CONSTRAINT harAllChildrenPath_ChildId_FK failed.'); 
           RAISE;
       END;
         
         
       
       -- INDEX HARVIV_VERS_IND ON HARVERSIONINVIEW( VERSIONOBJID)
       --
       
       BEGIN
         execute immediate
          'CREATE INDEX HARVIV_VERS_IND ON HARVERSIONINVIEW( VERSIONOBJID)
           TABLESPACE "&HARVESTINDEX"';
           
         DBMS_OUTPUT.PUT_LINE('INDEX HARVIV_VERS_IND ON HARVERSIONINVIEW( VERSIONOBJID) created.');
       EXCEPTION 
         WHEN OTHERS THEN 
           DBMS_OUTPUT.PUT_LINE('INDEX HARVIV_VERS_IND ON HARVERSIONINVIEW (VERSIONOBJID) failed.');
           RAISE; 
       END;


             
       UPDATE hartableinfo
        SET versionindicator = 51100;
        
        
    
       DBMS_OUTPUT.PUT_LINE('Upgrade to 5.1.1 complete.');
    
       COMMIT;
             
      END IF;
   ELSE
      raise_application_error (-20000, 'Missing Harvest version indicator.');
   END IF;
   
   EXCEPTION
   WHEN OTHERS THEN
      RAISE PROGRAM_ERROR;
      
END;
/



--
-- Harvest 5.2 changes
--
DECLARE
   CURSOR ver_cursor
   IS
      SELECT versionindicator
        FROM hartableinfo;

   ver_ind   hartableinfo.versionindicator%TYPE;
   Table_Count INTEGER;
   Index_Count INTEGER;
   cid INTEGER;
   
   NAME_USED EXCEPTION;
   PRAGMA EXCEPTION_INIT(NAME_USED, -955);
   
   NOT_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(NOT_EXIST, -1418);
   
   PRIMARY_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(PRIMARY_EXIST, -2260);
   
   UNIQUE_CONSTRAINT EXCEPTION;
   PRAGMA EXCEPTION_INIT(UNIQUE_CONSTRAINT, -1);
 
BEGIN
   OPEN ver_cursor;
   FETCH ver_cursor INTO ver_ind;

   IF ver_cursor%FOUND
   THEN
      IF ver_ind = 51100
      THEN
      
        DBMS_OUTPUT.PUT_LINE('Upgrade to 5.2 ...');
        
        cid := DBMS_SQL.OPEN_CURSOR;
        
        
        
        -- Enhancement Request 11463248/2
        -- Convert CHAR(128) to VARCHAR2(128) on Environment
        --
        
        BEGIN
          execute immediate
          'ALTER TABLE HARENVIRONMENT MODIFY ENVIRONMENTNAME VARCHAR2(128)';
          DBMS_OUTPUT.PUT_LINE('HarEnvironment EnvironmentName modified from CHAR(128) to VARCHAR(128)');
        EXCEPTION 
          WHEN OTHERS THEN RAISE; 
        END;
        
        
        
        -- Enhancement Request 11463248/2
	-- Convert CHAR(128) to VARCHAR2(128) on StateName
        --
        
        BEGIN
          execute immediate
          'ALTER TABLE HARSTATE MODIFY STATENAME VARCHAR2(128)';
          DBMS_OUTPUT.PUT_LINE('HarState StateName modified from CHAR(128) to VARCHAR(128)');
        EXCEPTION 
          WHEN OTHERS THEN RAISE; 
        END;
        
        
        
        -- Enhancement Request 11463248/2
	-- Padded spaces removal on StateName
        --
        
        BEGIN
      	  update harstate s set s.statename = rtrim(s.statename) 
      	  where length(rtrim(s.statename)) > 0;
      	  DBMS_OUTPUT.PUT_LINE('HarState (StateName) column padded spaces removed.');
        EXCEPTION 
          WHEN OTHERS THEN RAISE; 
        END;
        
        
        
        -- Enhancement Request 11463248/2
	-- Padded spaces removal on Environment Name
        --
        
        BEGIN         
	  update harenvironment e set e.environmentname = rtrim(e.environmentname) 
	  where length(rtrim(e.environmentname)) > 0;
	  DBMS_OUTPUT.PUT_LINE('HarEnvironment (EnvironmentName) column padded spaces removed.');
	EXCEPTION 
          WHEN OTHERS THEN RAISE; 
        END;
	
	
	
	-- New Default extension to Global Repository Text List
	--
	
	BEGIN
          insert into harfileextension(repositobjid,fileextension) values (0,'XML');
          DBMS_OUTPUT.PUT_LINE('XML added to Global Repository Text List');
        EXCEPTION 
          WHEN UNIQUE_CONSTRAINT 
            THEN DBMS_OUTPUT.PUT_LINE('XML already exists');
          WHEN OTHERS 
            THEN RAISE; 
        END;
        
        
        
        -- New Default extension PROPERTIES to Global Repository Text List
	--
	
        BEGIN
          insert into harfileextension(repositobjid,fileextension) values (0,'PROPERTIES');
          DBMS_OUTPUT.PUT_LINE('PROPERTIES added to Global Repository Text List');
        EXCEPTION 
          WHEN UNIQUE_CONSTRAINT 
            THEN DBMS_OUTPUT.PUT_LINE('PROPERTIES already exists');
          WHEN OTHERS 
            THEN RAISE; 
        END;
        
        
        
        -- New Default extension CLASSPATH to Global Repository Text List
	--
	
        BEGIN
          insert into harfileextension(repositobjid,fileextension) values (0,'CLASSPATH');
          DBMS_OUTPUT.PUT_LINE('CLASSPATH added to Global Repository Text List');
        EXCEPTION 
          WHEN UNIQUE_CONSTRAINT 
            THEN DBMS_OUTPUT.PUT_LINE('CLASSPATH already exists');
          WHEN OTHERS 
            THEN RAISE; 
        END;
        
        
        
        -- New Default TEMPLATE extension to Global Repository Text List
	--
	
        BEGIN
          insert into harfileextension(repositobjid,fileextension) values (0,'TEMPLATE');
          DBMS_OUTPUT.PUT_LINE('TEMPLATE added to Global Repository Text List');
        EXCEPTION 
          WHEN UNIQUE_CONSTRAINT 
            THEN DBMS_OUTPUT.PUT_LINE('TEMPLATE already exists');
          WHEN OTHERS 
            THEN RAISE; 
        END;
        
        
        
        -- New Default extension PROJECT to Global Repository Text List
	--
	
        BEGIN
          insert into harfileextension(repositobjid,fileextension) values (0,'PROJECT');
          DBMS_OUTPUT.PUT_LINE('PROJECT added to Global Repository Text List');
        EXCEPTION 
          WHEN UNIQUE_CONSTRAINT 
            THEN DBMS_OUTPUT.PUT_LINE('PROJECT already exists');
          WHEN OTHERS 
            THEN RAISE; 
        END;
        
        
        
	-- Drop depreciated index HARASSOCPKG_IND
	--
	
	BEGIN
	  execute immediate 
	  'DROP INDEX HARASSOCPKG_IND';
	   
	   DBMS_OUTPUT.PUT_LINE('Depreciated index HARASSOCPKG_IND dropped');
	EXCEPTION 
            WHEN NOT_EXIST
              THEN DBMS_OUTPUT.PUT_LINE('HARASSOCPKG_IND does not exist'); 
            WHEN OTHERS 
              THEN RAISE;
	END; 
        
        
        
	-- AUTO CREATE PRIMARY KEY INDEX TO HARASSOCPKG
	--  
	
	BEGIN
	  execute immediate 
	  'CREATE UNIQUE INDEX "HARASSOCPKG_PK" 
	   ON "HARASSOCPKG" 
	   ("FORMOBJID" , "ASSOCPKGID" )         
	   TABLESPACE "&HARVESTINDEX" LOGGING';
	  
	  DBMS_OUTPUT.PUT_LINE('INDEX HARASSOCPKG_PK on HARASSOCPKG (FormObjId, AssocPkgId) CREATED');	
	EXCEPTION 
            WHEN NAME_USED
              THEN DBMS_OUTPUT.PUT_LINE('HARASSOCPKG_PK on HARASSOCPKG (FormObjId, AssocPkgId) already exists.');
            WHEN OTHERS 
              THEN RAISE;
	END; 
	
	
	
	-- ADD PRIMARY KEY TO HARASSOCPKG
	--  
	
	BEGIN
	  execute immediate 
	  'ALTER TABLE "HARASSOCPKG" 
	  ADD CONSTRAINT "HARASSOCPKG_PK" PRIMARY KEY 
	  ("FORMOBJID" 
	  , "ASSOCPKGID" ) USING INDEX        
	  TABLESPACE "&HARVESTINDEX" LOGGING';
	  
	  DBMS_OUTPUT.PUT_LINE('Primary Key on HarAssocPkg addded.');
	EXCEPTION 
          WHEN PRIMARY_EXIST
            THEN DBMS_OUTPUT.PUT_LINE('Primary Key on HarAssocPkg already exists.');
          WHEN OTHERS 
            THEN RAISE;
	END;           
          
          
          
        -- Create special package EMPTY_PATHS for custom user created paths to belong to
        --
        
        BEGIN
        execute immediate '
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
	  values(-1,''EMPTY_PATHS'',0,0,-1, ''N'', ''Idle'',SYSDATE,1,SYSDATE,1,''undefined package'','' '',0,-1, SYSDATE,'' '','' '')';
	  
	  DBMS_OUTPUT.PUT_LINE('Package for Empty Paths Feature inserted into HarPackage table.');
        EXCEPTION 
          WHEN UNIQUE_CONSTRAINT 
            THEN DBMS_OUTPUT.PUT_LINE('HarPackage already contains package EMPTY_PATHS'); 
          WHEN OTHERS 
            THEN RAISE; 
        END;
	
	
	
	-- Add new column for the "Disable Name Change" Feature
	--
	
        SELECT COUNT(*) INTO Table_Count
        FROM USER_TABLES T1
   	WHERE Table_Name IN
      	(
            SELECT Table_Name
            FROM USER_TAB_COLUMNS
            WHERE Table_Name = 'HARCRPKGPROC' AND Column_Name = 'DISABLENAMECHANGE'
     	);     
      
   	IF (Table_Count = 0) THEN
	  execute immediate
	  'ALTER TABLE HARCRPKGPROC ADD(DISABLENAMECHANGE CHAR(1)  DEFAULT ''N'' NOT NULL)';
          DBMS_OUTPUT.PUT_LINE('COLUMN (DisableNameChange) ADDED TO HARCRPKGPROC');
   	ELSE
      	  DBMS_OUTPUT.PUT_LINE('HARCRPKGPROC ALREADY CONTAINS ROW DISABLENAMECHANGE');
   	END IF; 
   	
   	
   	
   	-- Add new column for the Force Comment Feature
   	--
   	
        SELECT COUNT(*) INTO Table_Count
        FROM USER_TABLES T1
   	WHERE Table_Name IN
      	(
            SELECT Table_Name
            FROM USER_TAB_COLUMNS
            WHERE Table_Name = 'HARCHECKINPROC' AND Column_Name = 'FORCECOMMENT'
     	);     
      
   	IF (Table_Count = 0) THEN
	  execute immediate
	  ' ALTER TABLE harCheckinProc ADD(FORCECOMMENT CHAR(1)  DEFAULT ''N'' NOT NULL)';
          DBMS_OUTPUT.PUT_LINE('COLUMN (ForceComment) ADDED TO HARCHECKINPROC');
   	ELSE
      	  DBMS_OUTPUT.PUT_LINE('HARCHECKINPROC ALREADY CONTAINS ROW FORCECOMMENT');
   	END IF; 
   	
   	
   	
   	-- CREATE TABLE HARSWITCHPKGPROC for Switch Package Feature
   	--
   	
   	BEGIN
          execute immediate
	  'CREATE TABLE HARSWITCHPKGPROC
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
	   TABLESPACE "&HARVESTMETA"'; 
	 
	 DBMS_OUTPUT.PUT_LINE('HarSwitchPkgProc table created.');
	EXCEPTION 
	  WHEN NAME_USED 
	    THEN DBMS_OUTPUT.PUT_LINE('HarSwitchPkgProc table already exists.');
          WHEN OTHERS
            THEN DBMS_OUTPUT.PUT_LINE('ERROR: HarSwitchPkgProc table creation failed.'); 
            RAISE; 
        END;
       	
       	

	 -- HASCHILD INDEX
	 --
	 
	 SELECT COUNT(*) INTO Index_Count
	   FROM USER_IND_COLUMNS I1
	   WHERE Index_Name IN
	      (  (
	            SELECT Index_Name 
	            FROM USER_IND_COLUMNS
	            WHERE Table_Name = 'HARVERSIONS' AND Column_Name = 'MERGEDVERSIONID' AND Column_Position = 1
	         )     
	      ) AND
	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
	
	   -- Create INDEX(MergedVersionId) ON HarVersions if it does not exist. 
	   IF (Index_Count = 0) THEN
	     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_MERGED_IDX ON HARVERSIONS (MERGEDVERSIONID) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_MERGED_IDX ON HARVERSIONS (MergedVersionId) CREATED');
	   ELSE
	     DBMS_OUTPUT.PUT_LINE('INDEX ON HARVERSIONS (MergedVersionId) ALREADY EXISTS');
	   END IF;  
	   
	   
	   
	   -- PR1885 Index Version Status   
	   -- CREATE INDEX HARVERSIONS_VSTATUS ON HARVERSIONS (ItemObjId, VersionStatus)
	   -- 
	   
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
	            WHERE Table_Name = 'HARVERSIONS' AND Column_Name = 'VERSIONSTATUS' AND Column_Position = 2
	         )
	      ) AND
	      2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
	
	   -- Create INDEX(ItemObjId, VersionStatus) ON HarVersions if it does not exist. 
	   IF (Index_Count = 0) THEN
	     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_VSTATUS ON HARVERSIONS (ItemObjId, VersionStatus) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_VSTATUS ON HARVERSIONS (ItemObjId, VersionStatus) CREATED');
	   ELSE
	     DBMS_OUTPUT.PUT_LINE('INDEX ON HARVERSIONS (ItemObjId, VersionStatus) ALREADY EXISTS');
	   END IF;   
	   
	   
	   -- 
	   -- PR1034 Index Update
	   --
	   
	   -- DROP INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId)
	   --
	   
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
	
	
	   -- CREATE INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId)
	   --
	   
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
	 
	   IF (Index_Count = 0) THEN
	     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId) CREATED');
	   ELSE
	     DBMS_OUTPUT.PUT_LINE('INDEX ON HARVERSIONS (ItemObjId, VersionObjId) ALREADY EXISTS');
	   END IF;  
	   
	    
	
	   -- PR1034 Index Update
	   -- CREATE INDEX HARVIEW_VIEWTYPE ON HARVIEW (ViewType, EnvObjId, ViewObjId)
	   --
	   
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
	
	   IF (Index_Count = 0) THEN
	     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVIEW_VIEWTYPE ON HARVIEW (ViewType, EnvObjId, ViewObjId) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	     DBMS_OUTPUT.PUT_LINE('INDEX HARVIEW_VIEWTYPE ON HARVIEW (ViewType, EnvObjId, ViewObjId) CREATED');
	   ELSE
	     DBMS_OUTPUT.PUT_LINE('INDEX ON HARVIEW (ViewType, EnvObjId, ViewObjId) ALREADY EXISTS');
	   END IF;   
	   
	   
	   
	   --
	   -- FOREIGN KEYS NECESSARY FOR IMPROVED CASCADE PERFORMANCE
	   -- HARBRANCH_ITEMID_FK, HARITEMS_PID_FK, HARVERSIONDATA_ITMID_FK
	   --

	   -- CREATE INDEX HARBRANCH_ITEMID_FK ON HARBRANCH (ITEMOBJID)
	   --
	   
	   SELECT COUNT(*) INTO Index_Count
	   FROM USER_IND_COLUMNS I1
	   WHERE Index_Name IN
	      (  (
	            SELECT Index_Name 
	            FROM USER_IND_COLUMNS
	            WHERE Table_Name = 'HARBRANCH' AND Column_Name = 'ITEMOBJID' AND Column_Position = 1
	         )
	      ) AND
	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
	
	   IF (Index_Count = 0) THEN
	     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARBRANCH_ITEMID_FK ON HARBRANCH (ITEMOBJID) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	     DBMS_OUTPUT.PUT_LINE('INDEX HARBRANCH_ITEMID_FK ON HARBRANCH (ItemObjId) CREATED');
	   ELSE
	     DBMS_OUTPUT.PUT_LINE('INDEX ON HARBRANCH (ItemObjId) ALREADY EXISTS');
	   END IF;   
	 
	 
	   
	   -- CREATE INDEX HARITEMS_PID_FK ON HARITEMS (PARENTOBJID)
	   --
	   
	   SELECT COUNT(*) INTO Index_Count
	   FROM USER_IND_COLUMNS I1
	   WHERE Index_Name IN
	      (  (
	            SELECT Index_Name 
	            FROM USER_IND_COLUMNS
	            WHERE Table_Name = 'HARITEMS' AND Column_Name = 'PARENTOBJID' AND Column_Position = 1
	         )
	      ) AND
	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
	
	   IF (Index_Count = 0) THEN
	     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARITEMS_PID_FK ON HARITEMS (PARENTOBJID) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	     DBMS_OUTPUT.PUT_LINE('INDEX HARITEMS_PID_FK ON HARITEMS (PARENTOBJID) CREATED');
	   ELSE
	     DBMS_OUTPUT.PUT_LINE('INDEX ON HARITEMS (PARENTOBJID) ALREADY EXISTS');
	   END IF;
	   
	   
	   
	   -- CREATE INDEX HARVERSIONDATA_ITMID_FK ON HARVERSIONDATA (ITEMOBJID)
	   --
	   
	   SELECT COUNT(*) INTO Index_Count
	   FROM USER_IND_COLUMNS I1
	   WHERE Index_Name IN
	      (  (
	            SELECT Index_Name 
	            FROM USER_IND_COLUMNS
	            WHERE Table_Name = 'HARVERSIONDATA' AND Column_Name = 'ITEMOBJID' AND Column_Position = 1
	         )
	      ) AND
	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
		 
	   IF (Index_Count = 0) THEN
	     DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONDATA_ITMID_FK ON HARVERSIONDATA (ITEMOBJID) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONDATA_ITMID_FK ON HARVERSIONDATA (ItemObjId) CREATED');
	   ELSE
	     DBMS_OUTPUT.PUT_LINE('INDEX ON HARVERSIONDATA (ItemObjId) ALREADY EXISTS');
	   END IF;
	   


         DBMS_SQL.CLOSE_CURSOR(cid);
       
       
         UPDATE harTableInfo
           SET versionindicator = 52000;
         
         
         DBMS_OUTPUT.PUT_LINE('Upgrade to 5.2 complete');

      END IF;
   ELSE
      raise_application_error (-20000, 'Missing Harvest version indicator.');
      
   END IF;
   
   EXCEPTION
     WHEN OTHERS THEN
       DBMS_SQL.CLOSE_CURSOR(cid);
       RAISE PROGRAM_ERROR;
END;
/




--
-- Harvest 5.2.1 changes
--
DECLARE
   CURSOR ver_cursor
   IS
      SELECT versionindicator
        FROM hartableinfo;

   ver_ind   hartableinfo.versionindicator%TYPE;
   Table_Count INTEGER;
   Index_Count INTEGER;
   cid INTEGER;
   
   NAME_USED EXCEPTION;
   PRAGMA EXCEPTION_INIT(NAME_USED, -955);
   
   NOT_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(NOT_EXIST, -1418);
   
   PRIMARY_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(PRIMARY_EXIST, -2260);
 
BEGIN
   OPEN ver_cursor;
   FETCH ver_cursor INTO ver_ind;

   IF ver_cursor%FOUND
   THEN
      IF ver_ind = 52000
      THEN
      
        DBMS_OUTPUT.PUT_LINE('Upgrade to 5.2.1 ...');
        
        cid := DBMS_SQL.OPEN_CURSOR;



	--
	-- PR# 1426 DELETE A STATE'S WORKING VIEW DOES NOT UPDATE ASSOCIATE PACKAGES
	--
	
	UPDATE HarPackage PK
	SET ViewObjId = -1
	WHERE NOT EXISTS(SELECT * FROM HarView VW WHERE VW.ViewObjId = PK.ViewObjId);

        DBMS_OUTPUT.PUT_LINE('HarPackage views set to default for views that no longer exist.');    


	--
	-- PR# 1208 - 13253128 - PERFORMANCE:VCI UNDO CHK OUT
	--  Add indexes from Harvest 5.1.1 DB Patches that are helpful to  
	--  Undo Checkout 

	-- CREATE INDEX HARVERSIONS_STATUS ON HARVERSIONS (VersionStatus, ItemObjId, VersionObjId) if not exist
	--
	

	SELECT COUNT (*)
	INTO Index_Count
        FROM user_ind_columns i1
        WHERE i1.index_name IN ((SELECT index_name
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

	   IF (Index_Count = 0)
	   THEN
	      DBMS_SQL.parse (
		 cid,
		 'CREATE INDEX HARVERSIONS_STATUS ON HARVERSIONS (VersionStatus, ItemObjId, VersionObjId) TABLESPACE &HARVESTINDEX',
		 DBMS_SQL.native  );

		 DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_STATUS ON HARVERSIONS (VersionStatus, ItemObjId, VersionObjId) CREATED');    
	   END IF;
   
   
   
        -- DROP INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId) 
        --
        
        SELECT COUNT(*) INTO Index_Count
   	FROM USER_IND_COLUMNS I1 
   	WHERE 
      	   Index_Name = 'HARVERSIONS_ITEM_IND' AND
     	   Table_Name = 'HARVERSIONS' AND 
      	   Column_Name = 'ITEMOBJID' AND 
           1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
 
        IF (Index_Count > 0) THEN
           DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_ITEM_IND', DBMS_SQL.NATIVE);
           DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId) DROPPED');    
        END IF;   



        -- CREATE INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId)
        --
        
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

      IF (Index_Count = 0) THEN
         DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId) TABLESPACE HARVESTINDEX', DBMS_SQL.NATIVE);
         DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEM_IND ON HARVERSIONS (ItemObjId, VersionObjId) CREATED');    
      END IF;   



   -- CREATE INDEX HARVERSIONS_ITEMOBJID ON HARVERSIONS (ItemObjId)
   --

   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Table_Name = 'HARVERSIONS' AND 
      Column_Name = 'ITEMOBJID' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   IF (Index_Count = 0) THEN
      DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_ITEMOBJID ON HARVERSIONS (ItemObjId) TABLESPACE HARVESTINDEX', DBMS_SQL.NATIVE);
      DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_ITEMOBJID ON HARVERSIONS (ItemObjId) CREATED');    
   END IF; 
   
   
   
   --
   -- Drop indexes introduced by Conversion
   --
   
   -- Drop INDEX HARVERSIONS_DATAID_IND(VersionDataObjId) ON HarVersions if exists. 
   --
   
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Index_Name  = 'HARVERSIONS_DATAID_IND' AND
      Table_Name  = 'HARVERSIONS' AND 
      Column_Name = 'VERSIONDATAOBJID' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   IF (Index_Count > 0) THEN
     DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_DATAID_IND', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_DATAID_IND ON HARVERSIONS (VersionDataObjId) DROPPED');
   END IF; 



   -- Drop INDEX HARVERSIONS_DATAOBJID(VersionDataObjId) ON HarVersions if exists. 
   --
   
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Index_Name  = 'HARVERSIONS_DATAOBJID' AND
      Table_Name  = 'HARVERSIONS' AND 
      Column_Name = 'VERSIONDATAOBJID' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   IF (Index_Count > 0) THEN
     DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_DATAOBJID', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_DATAOBJID ON HARVERSIONS (VersionDataObjId) DROPPED');
   END IF; 



   -- Drop INDEX HARVERSIONS_INBRANCH(INBRANCH) ON HarVersions if exists. 
   --
   
   SELECT COUNT(*) INTO Index_Count
   FROM USER_IND_COLUMNS I1 
   WHERE 
      Index_Name  = 'HARVERSIONS_INBRANCH' AND
      Table_Name  = 'HARVERSIONS' AND 
      Column_Name = 'INBRANCH' AND 
      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);

   IF (Index_Count > 0) THEN
     DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_INBRANCH', DBMS_SQL.NATIVE);
     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_INBRANCH ON HARVERSIONS (InBranch) DROPPED');
   END IF; 


   DBMS_SQL.CLOSE_CURSOR(cid);
       
       UPDATE harTableInfo
         SET versionindicator = 52100;
         
       DBMS_OUTPUT.PUT_LINE('Upgrade to 5.2.1 complete');

      END IF;
   ELSE
      raise_application_error (-20000, 'Missing Harvest version indicator.');
      
   END IF;
   
   EXCEPTION
     WHEN OTHERS THEN
       DBMS_SQL.CLOSE_CURSOR(cid);
       RAISE PROGRAM_ERROR;
END;
/



--
-- Harvest R7 Update
--
DECLARE
   CURSOR ver_cursor
   IS
      SELECT versionindicator
        FROM hartableinfo;

   ver_ind   hartableinfo.versionindicator%TYPE;
   Table_Count INTEGER;
   Index_Count INTEGER;
   cid INTEGER;
   
   NAME_USED EXCEPTION;
   PRAGMA EXCEPTION_INIT(NAME_USED, -955);
   
   INVALID_IDENT EXCEPTION;
   PRAGMA EXCEPTION_INIT(INVALID_IDENT, -904);
   
   NOT_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(NOT_EXIST, -1418);
   
   TABLE_NOT_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(TABLE_NOT_EXIST, -942);
   
   PRIMARY_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(PRIMARY_EXIST, -2260);
   
   COLUMN_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(COLUMN_EXIST, -1430);
   
   NOTNULL_EXIST EXCEPTION;
   PRAGMA EXCEPTION_INIT(NOTNULL_EXIST, -1442);
   
   UNIQUE_CONSTRAINT EXCEPTION;
   PRAGMA EXCEPTION_INIT(UNIQUE_CONSTRAINT, -1);
 
BEGIN
   OPEN ver_cursor;
   FETCH ver_cursor INTO ver_ind;

   IF ver_cursor%FOUND
   THEN
      IF ver_ind = 52100
      THEN
      
        DBMS_OUTPUT.PUT_LINE('Upgrade to R7 ...');
        
        cid := DBMS_SQL.OPEN_CURSOR;

      --
      -- PR# 1897 CREATE global temporary table haritemidtemp for cross project merge
      --

      -- CREATE GLOBAL TEMPORARY TABLE HARITEMIDTEMP 

      SELECT COUNT(*) INTO Table_Count
      FROM USER_TABLES 
      WHERE Table_Name = 'HARITEMIDTEMP';

      IF (Table_Count = 0) THEN
         DBMS_SQL.PARSE(cid, 'CREATE GLOBAL TEMPORARY TABLE HARITEMIDTEMP (ItemObjId NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);
         DBMS_OUTPUT.PUT_LINE('GLOBAL TEMPORARY TABLE HARITEMIDTEMP (ItemObjId NUMBER) CREATED');
      END IF;  
      

-- PR#3727 - CREATING TEMPORARY TABLE HARMOTETEMP FOR PROMOTE AND DEMOTE PROCESSES

-- Check if TABLE(HARMOTETEMP) exists. 

   SELECT COUNT(*) INTO Table_Count
   FROM USER_TABLES 
   WHERE Table_Name = 'HARMOTETEMP';

-- Create TABLE(HARMOTETEMP) if it does not exist. 

   IF (Table_Count = 0) THEN
   -- Parse and immediately execute dynamic SQL statement.

      DBMS_SQL.PARSE(cid, 'CREATE GLOBAL TEMPORARY TABLE HARMOTETEMP (ITEMOBJID NUMBER,VERSIONOBJID NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);
      DBMS_OUTPUT.PUT_LINE('HarMoteTemp table created.');

   END IF;  

-- PR#3727 - END      
      
      --
      -- PR3143 Add Temp Tables for improved performance
      --
      
      -- CREATE GLOBAL TEMPORARY TABLE VCTEMP1
      --
      
      SELECT COUNT(*) INTO Table_Count
      FROM USER_TABLES 
      WHERE Table_Name = 'VCTEMP1';
      
      IF (Table_Count = 0) THEN
         DBMS_SQL.PARSE(cid, 'CREATE GLOBAL TEMPORARY TABLE VCTEMP1 (itemobjid NUMBER, versionobjid NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);
         DBMS_OUTPUT.PUT_LINE('GLOBAL TEMPORARY TABLE VCTEMP1 (itemobjid NUMBER, versionobjid NUMBER) CREATED');
      END IF;  
      
      
      
      -- CREATE GLOBAL TEMPORARY TABLE VCTEMP2
      --
      
      SELECT COUNT(*) INTO Table_Count
      FROM USER_TABLES 
      WHERE Table_Name = 'VCTEMP2';
      
      IF (Table_Count = 0) THEN
         DBMS_SQL.PARSE(cid, 'CREATE GLOBAL TEMPORARY TABLE VCTEMP2 (itemobjid NUMBER, versionobjid NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);
         DBMS_OUTPUT.PUT_LINE('GLOBAL TEMPORARY TABLE VCTEMP2 (itemobjid NUMBER, versionobjid NUMBER) CREATED');
      END IF;  



      -- CREATE GLOBAL TEMPORARY TABLE RECURSIVE
      --
      
      SELECT COUNT(*) INTO Table_Count
      FROM USER_TABLES 
      WHERE Table_Name = 'RECURSIVE';
      
      IF (Table_Count = 0) THEN
         DBMS_SQL.PARSE(cid, 'CREATE GLOBAL TEMPORARY TABLE RECURSIVE (childitemid NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);
         DBMS_OUTPUT.PUT_LINE('GLOBAL TEMPORARY TABLE RECURSIVE (childitemid NUMBER) CREATED');      
      END IF;  
      
      
      
      -- CREATE GLOBAL TEMPORARY TABLE HARITEMTEMP
      --
      
      SELECT COUNT(*) INTO Table_Count
      FROM USER_TABLES 
      WHERE Table_Name = 'HARITEMTEMP';
      
      IF (Table_Count = 0) THEN
         DBMS_SQL.PARSE(cid, 'CREATE GLOBAL TEMPORARY TABLE HARITEMTEMP (ItemObjId NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);
         DBMS_OUTPUT.PUT_LINE('GLOBAL TEMPORARY TABLE HARITEMTEMP (ItemObjId NUMBER) CREATED');      
      END IF;   
      
      

      --
      -- PR# 3143 Add Columns for improved performance
      --    
      
      -- Add Column HARPATHFULLNAME(PATHFULLNAMEUPPER)
      --
      
      BEGIN
	  execute immediate 
	  'ALTER TABLE HARPATHFULLNAME
	   ADD(PATHFULLNAMEUPPER  varchar2(1024))';
	  
	  DBMS_OUTPUT.PUT_LINE('Column HARPATHFULLNAME (PATHFULLNAMEUPPER) addded.');
        EXCEPTION 
          WHEN COLUMN_EXIST
            THEN DBMS_OUTPUT.PUT_LINE('Column HARPATHFULLNAME (PATHFULLNAMEUPPER) already exists.');
          WHEN OTHERS 
            THEN RAISE;
      END;  
      
      
      -- Initialize Column HARPATHFULLNAME (PATHFULLNAMEUPPER) with Default Data
      BEGIN 
          execute immediate
      	  'update harpathfullname set pathfullnameupper = UPPER(pathfullname)';
      	  DBMS_OUTPUT.PUT_LINE('HARPATHFULLNAME (PATHFULLNAMEUPPER) column initialized.');
        EXCEPTION 
          WHEN OTHERS
            THEN RAISE; 
      END;
      
      
      -- Modify column  HARPATHFULLNAME(PATHFULLNAMEUPPER) to not null
      --   
      BEGIN
          execute immediate
             'ALTER table HARPATHFULLNAME modify ( PATHFULLNAMEUPPER not null )';
           DBMS_OUTPUT.PUT_LINE('HARPATHFULLNAME (PATHFULLNAMEUPPER) modified to not null');
        EXCEPTION 
           WHEN NOTNULL_EXIST
              THEN DBMS_OUTPUT.PUT_LINE('HARPATHFULLNAME (PATHFULLNAMEUPPER) already NOT NULL'); 
           WHEN OTHERS THEN RAISE;
           
      END;
      
      
      -- Modify column HARPATHFULLNAME(PATHFULLNAME) to not null
      --   
      BEGIN
          execute immediate
             'ALTER table HARPATHFULLNAME modify ( PATHFULLNAME not null )';
           DBMS_OUTPUT.PUT_LINE('HARPATHFULLNAME (PATHFULLNAME) modified to not null');
        EXCEPTION 
           WHEN NOTNULL_EXIST
	      THEN DBMS_OUTPUT.PUT_LINE('HARPATHFULLNAME (PATHFULLNAME) already NOT NULL'); 
           WHEN OTHERS THEN RAISE;
      END;      
      
      
      -- Create index HARPATHFULLNAME_PUPPER on HARPATHFULLNAME (PATHFULLNAMEUPPER, ITEMOBJID) 
      SELECT COUNT(*) INTO Index_Count
      FROM USER_IND_COLUMNS I1
      WHERE Index_Name IN
      	(  
          (
      	    SELECT Index_Name 
      	    FROM USER_IND_COLUMNS
      	    WHERE Table_Name = 'HARPATHFULLNAME' AND Column_Name = 'PATHFULLNAMEUPPER' AND Column_Position = 1
      	  )
      	  INTERSECT
      	  (
	    SELECT Index_Name 
	    FROM USER_IND_COLUMNS
	    WHERE Table_Name = 'HARPATHFULLNAME' AND Column_Name = 'ITEMOBJID' AND Column_Position = 2
      	  )
      	) AND
      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
      	
      IF (Index_Count = 0) THEN
      	DBMS_SQL.PARSE(cid, 'CREATE INDEX HARPATHFULLNAME_PUPPER ON HARPATHFULLNAME (PATHFULLNAMEUPPER, ITEMOBJID) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
      	DBMS_OUTPUT.PUT_LINE('INDEX HARPATHFULLNAME_PUPPER ON HARPATHFULLNAME (PATHFULLNAMEUPPER, ITEMOBJID) CREATED');
      ELSE
      	DBMS_OUTPUT.PUT_LINE('INDEX ON HARPATHFULLNAME (PATHFULLNAMEUPPER, ITEMOBJID) ALREADY EXISTS');
      END IF;
        
        
        
      -- Add Column HARITEMS(ITEMNAMEUPPER)
      --
      
      BEGIN
      	  execute immediate 
      	  'ALTER TABLE HARITEMS
           ADD(ITEMNAMEUPPER varchar2(256))';
      	  
      	  DBMS_OUTPUT.PUT_LINE('Column HARITEMS (ITEMNAMEUPPER) addded.');
        EXCEPTION 
          WHEN COLUMN_EXIST
            THEN DBMS_OUTPUT.PUT_LINE('Column HARITEMS (ITEMNAMEUPPER) already exists.');
          WHEN OTHERS 
            THEN RAISE;
      END;


      -- Initialize Column HARITEMS(ITEMNAMEUPPER) with Default Data
      BEGIN  
          execute immediate
      	  'update haritems set itemnameupper = UPPER(itemname)';
      	  DBMS_OUTPUT.PUT_LINE('HARITEMS (ITEMNAMEUPPER) column initialized.');
        EXCEPTION 
          WHEN OTHERS 
            THEN RAISE; 
      END;
      
      
      -- Modify column HARITEMS(ITEMNAMEUPPER) to not null
      --   
      BEGIN
          execute immediate
             'ALTER table HARITEMS modify ( ITEMNAMEUPPER not null )';
           DBMS_OUTPUT.PUT_LINE('HARITEMS (ITEMNAMEUPPER) modified to not null');
        EXCEPTION 
           WHEN NOTNULL_EXIST
	     THEN DBMS_OUTPUT.PUT_LINE('HARITEMS (ITEMNAMEUPPER) already NOT NULL'); 
           WHEN OTHERS THEN RAISE;
      END;


      -- Create index HARITEMS_UPPER on HARITEMS(ITEMNAMEUPPER) 
      SELECT COUNT(*) INTO Index_Count
      FROM USER_IND_COLUMNS I1
      WHERE Index_Name IN
      	(  
          (
      	    SELECT Index_Name 
      	    FROM USER_IND_COLUMNS
      	    WHERE Table_Name = 'HARITEMS' AND Column_Name = 'ITEMNAMEUPPER' AND Column_Position = 1
      	  )
      	) AND
      	1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
      	
      IF (Index_Count = 0) THEN
      	DBMS_SQL.PARSE(cid, 'CREATE INDEX HARITEMS_UPPER ON HARITEMS (ITEMNAMEUPPER) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
      	DBMS_OUTPUT.PUT_LINE('INDEX HARITEMS_UPPER ON HARITEMS (ITEMNAMEUPPER) CREATED');
      ELSE
      	DBMS_OUTPUT.PUT_LINE('INDEX ON HARITEMS (ITEMNAMEUPPER) ALREADY EXISTS');
      END IF;

     
      --
      -- Add Global Repository Extensions XSL JS JSP CSS DTD
      --    

    

      BEGIN
        insert into harfileextension(repositobjid,fileextension) values (0,'XSL');
        DBMS_OUTPUT.PUT_LINE('XSL added to Global Repository Text List');
      EXCEPTION 
        WHEN UNIQUE_CONSTRAINT 
           THEN DBMS_OUTPUT.PUT_LINE('XSL already exists');
        WHEN OTHERS 
           THEN RAISE; 
      END;
      

      BEGIN
        insert into harfileextension(repositobjid,fileextension) values (0,'JS');
        DBMS_OUTPUT.PUT_LINE('JS added to Global Repository Text List');
      EXCEPTION 
        WHEN UNIQUE_CONSTRAINT 
           THEN DBMS_OUTPUT.PUT_LINE('JS already exists');
        WHEN OTHERS 
           THEN RAISE; 
      END;

      

      BEGIN
        insert into harfileextension(repositobjid,fileextension) values (0,'JSP');
        DBMS_OUTPUT.PUT_LINE('JSP added to Global Repository Text List');
      EXCEPTION 
        WHEN UNIQUE_CONSTRAINT 
           THEN DBMS_OUTPUT.PUT_LINE('JSP already exists');
        WHEN OTHERS 
           THEN RAISE; 
      END;     

      

      BEGIN
        insert into harfileextension(repositobjid,fileextension) values (0,'CSS');
        DBMS_OUTPUT.PUT_LINE('CSS added to Global Repository Text List');
      EXCEPTION 
        WHEN UNIQUE_CONSTRAINT 
           THEN DBMS_OUTPUT.PUT_LINE('CSS already exists');
        WHEN OTHERS 
           THEN RAISE; 
      END;      
      

      BEGIN
        insert into harfileextension(repositobjid,fileextension) values (0,'DTD');
        DBMS_OUTPUT.PUT_LINE('DTD added to Global Repository Text List');
      EXCEPTION 
        WHEN UNIQUE_CONSTRAINT 
           THEN DBMS_OUTPUT.PUT_LINE('DTD already exists');
        WHEN OTHERS 
           THEN RAISE; 
      END;
      
      
      --
      -- Change TEMPAPPROVE tables to global temporary.
      --    
     
      BEGIN
        DBMS_SQL.PARSE(cid,  'DROP TABLE TEMPAPPROVEHIST', DBMS_SQL.NATIVE);
        DBMS_OUTPUT.PUT_LINE('TEMPAPPROVEHIST table dropped.');
      EXCEPTION 
        WHEN TABLE_NOT_EXIST 
           THEN DBMS_OUTPUT.PUT_LINE('TEMPAPPROVEHIST table does not exist.');
        WHEN OTHERS 
           THEN RAISE; 
      END;
      
      
      BEGIN
        DBMS_SQL.PARSE(cid,  'DROP TABLE TEMPAPPROVELIST', DBMS_SQL.NATIVE);
        DBMS_OUTPUT.PUT_LINE('TEMPAPPROVELIST table dropped.');
      EXCEPTION 
        WHEN TABLE_NOT_EXIST 
           THEN DBMS_OUTPUT.PUT_LINE('TEMPAPPROVELIST table does not exist.');
        WHEN OTHERS 
           THEN RAISE; 
      END;
      
      
      SELECT COUNT(*) INTO Table_Count
      FROM USER_TABLES 
      WHERE Table_Name = 'TEMPAPPROVEHIST';
      
      IF (Table_Count = 0) THEN
         DBMS_SQL.PARSE(cid,  'CREATE GLOBAL TEMPORARY TABLE TEMPAPPROVEHIST (USROBJID NUMBER NOT NULL, ACTION VARCHAR2(100) NOT NULL, EXECDTIME DATE NOT NULL) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);
         DBMS_OUTPUT.PUT_LINE('GLOBAL TEMPORARY TABLE TEMPAPPROVEHIST (USROBJID NUMBER NOT NULL, ACTION VARCHAR2(100) NOT NULL, EXECDTIME DATE NOT NULL) CREATED');
      END IF;  


      SELECT COUNT(*) INTO Table_Count
      FROM USER_TABLES 
      WHERE Table_Name = 'TEMPAPPROVELIST';
      
      IF (Table_Count = 0) THEN
         DBMS_SQL.PARSE(cid,  'CREATE GLOBAL TEMPORARY TABLE TEMPAPPROVELIST (ISGROUP CHAR(1) NOT NULL, USROBJID NUMBER, USRGRPOBJID NUMBER) ON COMMIT DELETE ROWS', DBMS_SQL.NATIVE);
         DBMS_OUTPUT.PUT_LINE('GLOBAL TEMPORARY TABLE TEMPAPPROVELIST (ISGROUP CHAR(1) NOT NULL, USROBJID NUMBER, USRGRPOBJID NUMBER) CREATED');
      END IF;  

     BEGIN
          execute immediate
	  'CREATE TABLE HARPKGSINCMEW
	   (
		EPACKAGEOBJID	 NUMBER(38) NOT NULL ,
  		EPACKAGENAME  	 VARCHAR2(200) NOT NULL,
		PACKAGEOBJID	 NUMBER(38) NOT NULL,
		CMEWSTATUS	 VARCHAR2(1) NOT NULL, 
 		CONSTRAINT HARPKGSINCMEW_PK PRIMARY KEY (EPACKAGEOBJID,PACKAGEOBJID)
    	     USING INDEX TABLESPACE "&HARVESTINDEX", 
 		CONSTRAINT HARPKGSINCMEW_FK FOREIGN KEY (PACKAGEOBJID) 
   			 REFERENCES HARPACKAGE (PACKAGEOBJID) ON DELETE CASCADE
	   )
	   TABLESPACE "&HARVESTMETA"'; 
	 
	 DBMS_OUTPUT.PUT_LINE('HarPkgsInCMEW table created.');
	EXCEPTION 
	  WHEN NAME_USED 
	    THEN DBMS_OUTPUT.PUT_LINE('HarPkgsInCMEW table already exists.');
          WHEN OTHERS
            THEN DBMS_OUTPUT.PUT_LINE('ERROR: HarHarPkgsInCMEW table creation failed.'); 
            RAISE; 
        END;
        

	 
	--
	-- When DB setup is executed, every package should have Idle status.
	-- Every Idle package should have NULL clientname and servername.
	-- (May need to verify that first to avoid failure below).
	--
	BEGIN
          execute immediate
	  'ALTER TABLE HARPACKAGE
    	   DROP (CLIENTNAME, SERVERNAME) CASCADE CONSTRAINTS';
    	   
    	   DBMS_OUTPUT.PUT_LINE('HarPackage columns (CLIENTNAME, SERVERNAME) dropped.');
	       	EXCEPTION 
	       	  WHEN INVALID_IDENT 
	       	    THEN DBMS_OUTPUT.PUT_LINE('HarPackage columns (CLIENTNAME, SERVERNAME) does not exist.');
	                 WHEN OTHERS
	                   THEN DBMS_OUTPUT.PUT_LINE('ERROR: HarPackage columns (CLIENTNAME, SERVERNAME) drop failed.'); 
	                   RAISE; 
	END;	


	--
	-- Status information for non-Idle packages are stored in this new table.
	--
	BEGIN
          execute immediate
	  'CREATE TABLE HARPACKAGESTATUS (
    	PACKAGEOBJID NUMBER NOT NULL, 
	CLIENTNAME VARCHAR2(1024) NOT NULL, 
	SERVERNAME VARCHAR2(1024) NOT NULL, 
	STATUSINFO VARCHAR2(1) NULL,		
    	CONSTRAINT HARPACKAGESTATUS_PK PRIMARY KEY(PACKAGEOBJID) 
    	USING INDEX  TABLESPACE &HARVESTINDEX, 
    	CONSTRAINT HARPACKAGESTATUS_FK FOREIGN KEY(PACKAGEOBJID) 
    	REFERENCES HARPACKAGE(PACKAGEOBJID) 
    	ON DELETE CASCADE)
    	TABLESPACE "&HARVESTMETA"'; 
    
    	DBMS_OUTPUT.PUT_LINE('HARPACKAGESTATUS table created.');
    	EXCEPTION 
    	  WHEN NAME_USED 
    	    THEN DBMS_OUTPUT.PUT_LINE('HARPACKAGESTATUS table already exists.');
              WHEN OTHERS
                THEN DBMS_OUTPUT.PUT_LINE('ERROR: HARPACKAGESTATUS table creation failed.'); 
                RAISE; 
        END;	
        
        
	--
	-- PR 1407 - Reset package status will search for statusinfo = 'P' and 
	-- clientname = dead client name.
	--
	-- Create index HARPACKAGESTATUS_C_IDX on HARPACKAGESTATUS (CLIENTNAME, STATUSINFO )
	
	SELECT COUNT(*) INTO Index_Count
	      FROM USER_IND_COLUMNS I1
	      WHERE Index_Name IN
		(  
		  (
		    SELECT Index_Name 
		    FROM USER_IND_COLUMNS
		    WHERE Table_Name = 'HARPACKAGESTATUS' AND Column_Name = 'CLIENTNAME' AND Column_Position = 1
		  )
		  INTERSECT
		  (
		    SELECT Index_Name 
	            FROM USER_IND_COLUMNS
	            WHERE Table_Name = 'HARPACKAGESTATUS' AND Column_Name = 'STATUSINFO' AND Column_Position = 2
		  )
		) AND
      	        2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
	      	
	IF (Index_Count = 0) THEN
	      	DBMS_SQL.PARSE(cid, 'CREATE INDEX HARPACKAGESTATUS_C_IDX ON HARPACKAGESTATUS (CLIENTNAME, STATUSINFO ) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	      	DBMS_OUTPUT.PUT_LINE('INDEX HARPACKAGESTATUS_C_IDX ON HARPACKAGESTATUS (CLIENTNAME, STATUSINFO ) CREATED');
	ELSE
	      	DBMS_OUTPUT.PUT_LINE('INDEX ON HARPACKAGESTATUS (CLIENTNAME, STATUSINFO ) ALREADY EXISTS');
	END IF;

        
        
        -- Drop depreciated index HARVERSIONS_INBRANCH
	--
	
	BEGIN
	  execute immediate 
	  'DROP INDEX HARVERSIONS_INBRANCH';
	   
	   DBMS_OUTPUT.PUT_LINE('Depreciated index HARVERSIONS_INBRANCH dropped');
	EXCEPTION 
            WHEN NOT_EXIST
              THEN DBMS_OUTPUT.PUT_LINE('HARVERSIONS_INBRANCH does not exist'); 
            WHEN OTHERS 
              THEN RAISE;
	END; 
     


	--
	-- PR 3571 - Reset package status on shutdown searches for servername
	--	
	-- Create index HARPACKAGESTATUS_S_IDX on HARPACKAGESTATUS (SERVERNAME)
	SELECT COUNT(*) INTO Index_Count
	FROM USER_IND_COLUMNS I1
	WHERE Index_Name IN
	      	(  
	          (
	      	    SELECT Index_Name 
	      	    FROM USER_IND_COLUMNS
	      	    WHERE Table_Name = 'HARPACKAGESTATUS' AND Column_Name = 'SERVERNAME' AND Column_Position = 1
	      	  )
	      	) AND
	      	1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
	      	
	IF (Index_Count = 0) THEN
	      	DBMS_SQL.PARSE(cid, 'CREATE INDEX HARPACKAGESTATUS_S_IDX ON HARPACKAGESTATUS (SERVERNAME) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	      	DBMS_OUTPUT.PUT_LINE('INDEX HARPACKAGESTATUS_S_IDX ON ARPACKAGESTATUS (SERVERNAME) CREATED');
	ELSE
	      	DBMS_OUTPUT.PUT_LINE('INDEX ON HARPACKAGESTATUS (SERVERNAME) ALREADY EXISTS');
	END IF;	


	-- Drop INDEX HARVERSIONS_VC if exists. 
	--
	SELECT COUNT(*) INTO Index_Count
	FROM USER_IND_COLUMNS I1 
	WHERE 
	      Index_Name  = 'HARVERSIONS_VC' AND
	      Table_Name  = 'HARVERSIONS';
	
	IF (Index_Count > 0) THEN
	     DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_VC', DBMS_SQL.NATIVE);
	     DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_VC ON HARVERSIONS DROPPED TO BE RECREATED');
        END IF; 

	--
	-- PR 4081 - New Index for Improved Version Chooser Performance
	--	
	-- CREATE INDEX HARVERSIONS_VC ON HARVERSIONS (  ITEMOBJID, VERSIONOBJID, VERSIONSTATUS, INBRANCH)
	SELECT COUNT(*) INTO Index_Count
	FROM USER_IND_COLUMNS I1
	WHERE Index_Name IN
	      	(  
	          (
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
		  INTERSECT
		  (
		    SELECT Index_Name 
	            FROM USER_IND_COLUMNS
	            WHERE Table_Name = 'HARVERSIONS' AND Column_Name = 'VERSIONSTATUS' AND Column_Position = 3
		  )
		  INTERSECT
		  (
		    SELECT Index_Name 
	            FROM USER_IND_COLUMNS
	            WHERE Table_Name = 'HARVERSIONS' AND Column_Name = 'INBRANCH' AND Column_Position = 4
		  )
	      	) AND
	      	4 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
	      	
	IF (Index_Count = 0) THEN
		DBMS_SQL.PARSE(cid, 'CREATE INDEX HARVERSIONS_VC ON HARVERSIONS (  ITEMOBJID, VERSIONOBJID, VERSIONSTATUS, INBRANCH) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	      	DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_VC ON HARVERSIONS (  ITEMOBJID, VERSIONOBJID, VERSIONSTATUS, INBRANCH) CREATED');
	ELSE
	      	DBMS_OUTPUT.PUT_LINE('INDEX HARVERSIONS_VC ON HARVERSIONS (  ITEMOBJID, VERSIONOBJID, VERSIONSTATUS, INBRANCH) ALREADY EXISTS');
	END IF;	
	
	
      --
      -- PR 4091 - HARSTATEPROCESS (PROCESSTYPE) updated: ListDifferenceProcess renamed to CompareViewProcess
      --
      BEGIN 
          execute immediate
      	  'UPDATE HARSTATEPROCESS  SET PROCESSTYPE = ''CompareViewProcess''  WHERE PROCESSTYPE = ''ListDifferenceProcess'' ';
      	  DBMS_OUTPUT.PUT_LINE('HARSTATEPROCESS (PROCESSTYPE) updated: ListDifferenceProcess renamed to CompareViewProcess.');
        EXCEPTION 
          WHEN OTHERS
            THEN RAISE; 
      END;
      
      
      --
      -- PR 4114 - CREATE UNIQUE INDEX HARAPPROVE_PK ON HARAPPROVE (PROCESSOBJID,STATEOBJID) TABLESPACE &HARVESTINDEX
      --
      SELECT COUNT(*) INTO Index_Count
      FROM USER_IND_COLUMNS I1
      WHERE Index_Name IN
	      	(  
	          (
	      	    SELECT Index_Name 
	      	    FROM USER_IND_COLUMNS
	      	    WHERE Table_Name = 'HARAPPROVE' AND Column_Name = 'PROCESSOBJID' AND Column_Position = 1
	      	  )
	  	  INTERSECT
		  (
		    SELECT Index_Name 
	            FROM USER_IND_COLUMNS
	            WHERE Table_Name = 'HARAPPROVE' AND Column_Name = 'STATEOBJID' AND Column_Position = 2
                  )
	      	) AND
	      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
	      	
      IF (Index_Count = 0) THEN
		DBMS_SQL.PARSE(cid, 'CREATE UNIQUE INDEX HARAPPROVE_PK ON HARAPPROVE (PROCESSOBJID,STATEOBJID) TABLESPACE &HARVESTINDEX', DBMS_SQL.NATIVE);
	      	DBMS_OUTPUT.PUT_LINE('INDEX HARAPPROVE_PK ON HARAPPROVE (PROCESSOBJID,STATEOBJID) CREATED');
      ELSE
	      	DBMS_OUTPUT.PUT_LINE('INDEX ON HARAPPROVE (PROCESSOBJID,STATEOBJID) ALREADY EXISTS');
      END IF;	

      
     

     DBMS_SQL.CLOSE_CURSOR(cid);
     
       
     UPDATE harTableInfo
       SET versionindicator = 70000;
       
         
     DBMS_OUTPUT.PUT_LINE('Upgrade to R7 Complete');

     END IF;
   ELSE
      raise_application_error (-20000, 'Missing Harvest version indicator.');
      
   END IF;
   
   EXCEPTION
     WHEN OTHERS THEN
       DBMS_SQL.CLOSE_CURSOR(cid);
       RAISE PROGRAM_ERROR;
END;
/






-- END OF UPGRADE.SQL
/*
 * UPGRADE.SQL has completed successfully.
 *
 */ 

SPOOL off

EXIT


