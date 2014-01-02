--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--
  
-- Before conversion: Users that will be granted access to items

SELECT US.UserName, (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM 
  HARUSER US,
  HARITEMS IT, 
  HARPATHFULLNAME PF,
  ( ( SELECT U1.UsrObjId, I1.ItemObjId FROM (SELECT DISTINCT UsrObjId FROM HARUSERSINGROUP) U1, (SELECT DISTINCT ItemObjId FROM HARITEMACCESS) I1
      MINUS
      SELECT UG.UsrObjId, IA.ItemObjId FROM HARITEMACCESS IA, HARUSERSINGROUP UG WHERE IA.UsrGrpObjId = UG.UsrGrpObjId AND IA.ViewAccess = 'N'
    )
    UNION
    ( SELECT U1.UsrObjId, A1.ItemObjId 
      FROM
        ( SELECT DISTINCT UsrObjId FROM HARUSERSINGROUP WHERE UsrGrpObjId = 2 ) U1,
        ( SELECT I1.ItemObjId FROM HARITEMS I1, HARITEMACCESS IA WHERE I1.ItemObjId = IA.ItemObjID (+) AND IA.ItemObjId IS NULL ) A1
    )
  ) IA1
WHERE 
  IA1.UsrObjId = US.UsrObjId AND
  IA1.ItemObjId = IT.ItemObjId AND
  IT.ParentObjId > 0 AND
  IT.ParentObjId = PF.ItemObjId
ORDER BY US.UsrObjId, IT.ParentObjId, IT.ItemObjId;




