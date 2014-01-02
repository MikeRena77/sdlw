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


