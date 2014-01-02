select u.realname
from haruser u, harusergroup g, harusersingroup ig,
where u.usrobjid=ig.usrobjid
and ig.usrgrpobjid=g.usrgrpobjid
and g.usergroupname = 'App Developer'
/*
This is the type of query you would want to find only users in the App Developer user group.  You could use the LIKE  qualifier to find all the users in a number of groups:

and g.usergroupname like 'App%'
*/
