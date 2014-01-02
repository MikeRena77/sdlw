--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- Before conversion: Usergroups DENIED access to items

SELECT GP.UserGroupName, (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM 
  HARUSERGROUP GP,
  HARITEMS IT, 
  HARPATHFULLNAME PF,
  HARITEMACCESS IA 
WHERE 
  IA.UsrGrpObjId = GP.UsrGrpObjId AND
  IA.ItemObjId = IT.ItemObjId AND
  IT.ParentObjId > 0 AND
  IT.ParentObjId = PF.ItemObjId
ORDER BY GP.UsrGrpObjId, IT.ParentObjId, IT.ItemObjId;