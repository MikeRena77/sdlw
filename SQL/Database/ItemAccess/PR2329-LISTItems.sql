--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- Current Items

SELECT (PF.PathFullname || '\' || IT.Itemname) FullpathItemname
FROM HARITEMS IT, HARPATHFULLNAME PF
WHERE IT.ParentObjId != 0 AND IT.ParentObjId = PF.ItemObjId
ORDER BY IT.ParentObjId, IT.ItemObjId;