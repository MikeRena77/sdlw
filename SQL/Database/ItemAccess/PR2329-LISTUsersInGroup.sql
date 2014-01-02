--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- Current Users in Usergroups

SELECT G.UserGroupName, U.UserName
FROM HARUSERGROUP G, HARUSERSINGROUP UG, HARUSER U
WHERE G.UsrGrpObjId = UG.UsrGrpObjId AND UG.UsrObjId = U.UsrObjId
ORDER BY G.UsrGrpObjId, U.UsrObjId;