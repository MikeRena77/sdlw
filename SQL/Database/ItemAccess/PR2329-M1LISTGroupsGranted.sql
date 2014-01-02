--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- Before conversion: Usergroups that will be GRANTED access to items

SELECT GP.UserGroupName, (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM 
  HARUSERGROUP GP,
  HARITEMS IT, 
  HARPATHFULLNAME PF,
  ( ( SELECT G1.UsrGrpObjId, I1.ItemObjId FROM HARUSERGROUP G1, (SELECT DISTINCT ItemObjId FROM HARITEMACCESS) I1
      MINUS
      SELECT IA.UsrGrpObjId, IA.ItemObjId FROM HARITEMACCESS IA WHERE IA.ViewAccess = 'N'
    )
    UNION
    SELECT 2, I1.ItemObjId FROM HARITEMS I1, HARITEMACCESS IA WHERE I1.ItemObjId = IA.ItemObjID (+) AND IA.ItemObjId IS NULL
  ) IA1
WHERE 
  IA1.UsrGrpObjId = GP.UsrGrpObjId AND
  IA1.ItemObjId = IT.ItemObjId AND
  IT.ParentObjId > 0 AND
  IT.ParentObjId = PF.ItemObjId
ORDER BY GP.UsrGrpObjId, IT.ParentObjId, IT.ItemObjId;