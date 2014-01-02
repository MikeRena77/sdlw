--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- Before conversion: Usergroups that will be granted access to items

SELECT (RTRIM(US.UserName) || '_ITEMACCESS') UserGroupName, (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM 
  HARUSER US,
  HARITEMS IT, 
  HARPATHFULLNAME PF,
  ( SELECT U1.UsrObjId, I1.ItemObjId FROM (SELECT DISTINCT UsrObjId FROM HARUSERSINGROUP) U1, (SELECT DISTINCT ItemObjId FROM HARITEMACCESS) I1
    MINUS
    SELECT UG.UsrObjId, IA.ItemObjId FROM HARITEMACCESS IA, HARUSERSINGROUP UG WHERE IA.UsrGrpObjId = UG.UsrGrpObjId AND IA.ViewAccess = 'N'
  ) IA1
WHERE 
  IA1.UsrObjId = US.UsrObjId AND
  IA1.ItemObjId = IT.ItemObjId AND
  IT.ParentObjId > 0 AND
  IT.ParentObjId = PF.ItemObjId
UNION
SELECT 'Public' UserGroupName, (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM HARITEMS IT, HARITEMACCESS IA, HARPATHFULLNAME PF
WHERE IT.ItemObjId = IA.ItemObjID (+) AND IA.ItemObjId IS NULL AND IT.ParentObjId > 0 AND IT.ParentObjId = PF.ItemObjId
ORDER BY 1, 2;