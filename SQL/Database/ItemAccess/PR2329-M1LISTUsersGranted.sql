--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- Before conversion: Users that will be GRANTED access to items

SELECT US.UserName, (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM 
  HARUSER US,
  HARITEMS IT, 
  HARPATHFULLNAME PF,
  ( SELECT DISTINCT UG.UsrObjId, IA1.ItemObjId
    FROM
      ( ( SELECT G1.UsrGrpObjId, I1.ItemObjId FROM HARUSERGROUP G1, (SELECT DISTINCT ItemObjId FROM HARITEMACCESS) I1
          MINUS
          SELECT IA.UsrGrpObjId, IA.ItemObjId FROM HARITEMACCESS IA WHERE IA.ViewAccess = 'N'
        )
        UNION
        SELECT 2, I1.ItemObjId FROM HARITEMS I1, HARITEMACCESS IA WHERE I1.ItemObjId = IA.ItemObjID (+) AND IA.ItemObjId IS NULL
      ) IA1,
      HARUSERSINGROUP UG
    WHERE IA1.UsrGrpObjId = UG.UsrGrpObjId
  ) IA2
WHERE 
  IA2.UsrObjId = US.UsrObjId AND
  IA2.ItemObjId = IT.ItemObjId AND
  IT.ParentObjId > 0 AND
  IT.ParentObjId = PF.ItemObjId
ORDER BY US.UsrObjId, IT.ParentObjId, IT.ItemObjId;