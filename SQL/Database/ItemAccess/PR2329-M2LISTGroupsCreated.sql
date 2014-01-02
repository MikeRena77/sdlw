--
-- Copyright (c) 2004 Computer Associates inc. All rights reserved. 
--

-- New Usergroups that will be created

SELECT (RTRIM(US.UserName) || '_ITEMACCESS') UserGroupName
FROM HARUSER US
ORDER BY US.UsrObjId;