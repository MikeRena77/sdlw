--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- After conversion: Users GRANTED access to items

SELECT US.UserName, (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM 
  HARUSER US,
  HARITEMS IT, 
  HARPATHFULLNAME PF,
  ( SELECT DISTINCT UG.UsrObjId, IA.ItemObjId FROM HARITEMACCESS IA, HARUSERSINGROUP UG WHERE IA.UsrGrpObjId = UG.UsrGrpObjId AND IA.ViewAccess = 'Y' ) IA1
WHERE 
  IA1.UsrObjId = US.UsrObjId AND
  IA1.ItemObjId = IT.ItemObjId AND
  IT.ParentObjId > 0 AND
  IT.ParentObjId = PF.ItemObjId
ORDER BY US.UsrObjId, IT.ParentObjId, IT.ItemObjId;