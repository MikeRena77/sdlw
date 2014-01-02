--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

WHENEVER SQLERROR EXIT FAILURE

SPOOL M2CONVERTData.log

DECLARE
  CURSOR CUser IS SELECT UsrObjId, UserName FROM HARUSER;
  IUsrGrpObjId INTEGER;
  Table_Count INTEGER;
  Row_Count INTEGER;
  cid INTEGER;

  DENY_Records INTEGER;
  GRANT_Records INTEGER;
BEGIN

  -- Open new cursor and return cursor ID. 

  cid := DBMS_SQL.OPEN_CURSOR;

  -- Get the number of DENY records

  SELECT COUNT(*) INTO DENY_Records
  FROM HARITEMACCESS
  WHERE ViewAccess = 'N';

  -- Get the number of GRANT records

  SELECT COUNT(*) INTO GRANT_Records
  FROM HARITEMACCESS
  WHERE ViewAccess = 'Y';

  IF (DENY_Records > 0) AND (GRANT_Records = 0) THEN

    -- Check if TABLE TEMPCONVACCESS exists. 

    SELECT COUNT(*) INTO Table_Count
    FROM USER_TABLES  
    WHERE Table_Name = 'TEMPCONVACCESS';  

    IF (Table_Count > 0) THEN

      -- Drop table TEMPCONVACCESS 

      DBMS_SQL.PARSE(cid, 'DROP TABLE TEMPCONVACCESS', DBMS_SQL.NATIVE);

    END IF;   

    -- Create table TEMPCONVACCESS 

    DBMS_SQL.PARSE(cid, 'CREATE TABLE TEMPCONVACCESS (UsrObjId NUMBER CONSTRAINT TEMPCONVACCESS_PK PRIMARY KEY USING INDEX TABLESPACE HARVESTINDEX, UsrGrpObjId NUMBER) TABLESPACE HARVESTMETA', DBMS_SQL.NATIVE);

    FOR RUser IN CUser LOOP

      -- Get new usergroup id

      SELECT HARUSERGROUPSEQ.NEXTVAL INTO IUsrGrpObjId FROM DUAL;

      -- Create new usergroup

      INSERT 
        INTO HARUSERGROUP (USRGRPOBJID, USERGROUPNAME, CREATIONTIME, CREATORID, MODIFIEDTIME, MODIFIERID)
        VALUES ( IUsrGrpObjId, (RTRIM(RUser.UserName) || '_ITEMACCESS'), SYSDATE, 1, SYSDATE, 1 );

      -- Associate user with new usergroup

      INSERT INTO HARUSERSINGROUP (USROBJID, USRGRPOBJID) VALUES ( RUser.UsrObjId, IUsrGrpObjId ); 

      -- Save user-usergroup association

      DBMS_SQL.PARSE(cid, 'INSERT INTO TEMPCONVACCESS (USROBJID, USRGRPOBJID) VALUES (' || RUser.UsrObjId || ',' || IUsrGrpObjId || ')', DBMS_SQL.NATIVE);
      Row_Count := DBMS_SQL.EXECUTE(cid);

    END LOOP;

    -- Set new Item access for non-repository items

    DBMS_SQL.PARSE(cid, ' 
      INSERT INTO HARITEMACCESS (ItemObjId, UsrGrpObjId, ViewAccess) 
      ( SELECT IA1.ItemObjId, IA.UsrGrpObjId, ''Y'' 
        FROM 
          ( SELECT U1.UsrObjId, I1.ItemObjId FROM (SELECT DISTINCT UsrObjId FROM HARUSERSINGROUP) U1, (SELECT DISTINCT ItemObjId FROM HARITEMACCESS) I1
            MINUS
            SELECT U1.UsrObjId, I1.ItemObjId FROM HARITEMACCESS I1, HARUSERSINGROUP U1 WHERE I1.UsrGrpObjId = U1.UsrGrpObjId
          ) IA1, 
          TEMPCONVACCESS IA,
          HARITEMS IT 
        WHERE 
          IA1.UsrObjId = IA.UsrObjId AND IA1.ItemObjId = IT.ItemObjId AND IT.ItemObjId > 0 AND IT.ParentObjId > 0  
        UNION
        SELECT IT.ItemObjId, 2, ''Y'' 
        FROM HARITEMS IT, HARITEMACCESS IA
        WHERE IT.ItemObjId = IA.ItemObjID (+) AND IA.ItemObjId IS NULL AND IT.ItemObjId > 0 AND IT.ParentObjId > 0
      )
    ', DBMS_SQL.NATIVE);
    Row_Count := DBMS_SQL.EXECUTE(cid);

    -- Set new Item access for repository items

    INSERT INTO HARITEMACCESS (ItemObjId, UsrGrpObjId, ViewAccess)
    SELECT IT.ItemObjId, 2, 'Y'
    FROM HARITEMS IT
    WHERE IT.ItemObjId > 0 AND IT.ParentObjId = 0 AND IT.RepositObjId > 0;

    -- Remove denied access

    DELETE FROM HARITEMACCESS
    WHERE ViewAccess = 'N';

    -- Drop table TEMPCONVACCESS 

    DBMS_SQL.PARSE(cid, 'DROP TABLE TEMPCONVACCESS', DBMS_SQL.NATIVE);

    -- Commit all changes

    COMMIT;

  END IF;   

  -- Close cursor.

  DBMS_SQL.CLOSE_CURSOR(cid);

EXCEPTION

  -- If an exception is raised, rollback and close cursor before exiting. 

  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_SQL.CLOSE_CURSOR(cid);
    RAISE;  -- reraise the exception
END;
/

SPOOL OFF
EXIT;
