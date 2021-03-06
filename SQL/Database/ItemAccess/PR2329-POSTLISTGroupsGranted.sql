--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- After conversion: Usergroups GRANTED access to items

SELECT GP.UserGroupName, (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM 
  HARUSERGROUP GP,
  HARITEMS IT, 
  HARPATHFULLNAME PF,
  ( SELECT IA.UsrGrpObjId, IA.ItemObjId FROM HARITEMACCESS IA WHERE IA.ViewAccess = 'Y' ) IA1
WHERE 
  IA1.UsrGrpObjId = GP.UsrGrpObjId AND
  IA1.ItemObjId = IT.ItemObjId AND
  IT.ParentObjId > 0 AND
  IT.ParentObjId = PF.ItemObjId
ORDER BY GP.UsrGrpObjId, IT.ParentObjId, IT.ItemObjId;