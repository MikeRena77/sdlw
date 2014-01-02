--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

WHENEVER SQLERROR EXIT FAILURE

SPOOL M1CONVERTData.log

DECLARE
  DENY_Records INTEGER;
  GRANT_Records INTEGER;
BEGIN

  -- Get the number of DENY records

  SELECT COUNT(*) INTO DENY_Records
  FROM HARITEMACCESS
  WHERE ViewAccess = 'N';

  -- Get the number of GRANT records

  SELECT COUNT(*) INTO GRANT_Records
  FROM HARITEMACCESS
  WHERE ViewAccess = 'Y';

  IF (DENY_Records > 0) AND (GRANT_Records = 0) THEN

    -- Set new Item access for non-repository items

    INSERT INTO HARITEMACCESS (ItemObjId, UsrGrpObjId, ViewAccess)
    ( SELECT IA1.ItemObjId, IA1.UsrGrpObjId, 'Y'
      FROM
        ( SELECT G1.UsrGrpObjId, I1.ItemObjId FROM HARUSERGROUP G1, (SELECT DISTINCT ItemObjId FROM HARITEMACCESS) I1
          MINUS
          SELECT IA.UsrGrpObjId, IA.ItemObjId FROM HARITEMACCESS IA
        ) IA1,
        HARITEMS IT
      WHERE
        IA1.ItemObjId = IT.ItemObjId AND IT.ItemObjId > 0 AND IT.ParentObjId > 0
      UNION
      SELECT IT.ItemObjId, 2, 'Y'
      FROM HARITEMS IT, HARITEMACCESS IA
      WHERE IT.ItemObjId = IA.ItemObjID (+) AND IA.ItemObjId IS NULL AND IT.ItemObjId > 0 AND IT.ParentObjId > 0
    );

    -- Set new Item access for repository items

    INSERT INTO HARITEMACCESS (ItemObjId, UsrGrpObjId, ViewAccess)
    SELECT IT.ItemObjId, 2, 'Y'
    FROM HARITEMS IT
    WHERE IT.ItemObjId > 0 AND IT.ParentObjId = 0 AND IT.RepositObjId > 0;

    -- Remove denied access

    DELETE FROM HARITEMACCESS WHERE ViewAccess = 'N';
  
    -- Commit all changes

    COMMIT;

  END IF;   

EXCEPTION

  -- If an exception is raised, rollback before exiting. 

  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;  -- reraise the exception
END;
/

SPOOL OFF
EXIT;
