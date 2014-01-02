WHENEVER SQLERROR EXIT FAILURE
SPOOL DBPatch.log

--
-- Database updates for Harvest 5.2.1 maintenance patches
--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved.
--

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
-- PR# 3525 CREATING TEMPORARY TABLE HARPROMOTETEMP FOR PROMOTE PROCESS
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
-- PR# 3525 - END

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
 -- PR# 4100 HARVERSIONS_INBRANCH should not remain once patch has completed.
 --
 
 DECLARE
   Index_Count INTEGER;
   Table_Count INTEGER;
   cid INTEGER;
 BEGIN
 
    cid := DBMS_SQL.OPEN_CURSOR;
 
 -- Check if INDEX HARVERSIONS_INBRANCH(ItemObjId) ON HarVersions exists. 
 
    SELECT COUNT(*) INTO Index_Count
    FROM USER_IND_COLUMNS I1 
    WHERE 
       Table_Name = 'HARVERSIONS' AND 
       Column_Name = 'INBRANCH' AND 
       1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
 
 -- Drop INDEX HARVERSIONS_INBRANCH(ItemObjId) ON HarVersions if it exists. 
 
    IF (Index_Count > 0) THEN
       DBMS_SQL.PARSE(cid, 'DROP INDEX HARVERSIONS_INBRANCH', DBMS_SQL.NATIVE);
 
    END IF;   	
 
    DBMS_SQL.CLOSE_CURSOR(cid);
 
 EXCEPTION
    WHEN OTHERS THEN
       DBMS_SQL.CLOSE_CURSOR(cid);
       RAISE;  -- reraise the exception
END;
/


--
--

SPOOL OFF
EXIT;


