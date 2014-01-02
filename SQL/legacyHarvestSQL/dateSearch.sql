These queries should do what you want.

Created between Jan 1, 2003 and Jun 1, 2003
===========================================

select r.repositname, i.itemname, i.creationtime
from haritems i, harrepository r
where i.repositobjid=r.repositobjid
and i.itemtype != 0
and i.creationtime between to_date('01/01/2003', 'MM/DD/YYYY') and to_date ('06/01/2003', 'MM/DD/YYYY')

the itemtype query will remove the repositories and directories from the returned data set.
 
Modified after Jan 1, 2003
==========================

select r.repositname, i.itemname, i.modifiedtime
from haritems i, harrepository r
where i.repositobjid=r.repositobjid
and i.itemtype != 0
and i.modifiedtime > to_date('01/01/2003', 'MM/DD/YYYY')
and i.modifiedtime != i.creationtime


I have also added in the repository name to the query so you can see where it was created/modified.  It will be easy to add users to this query using the usrobjid column and haruser (or harallusers actually for deleted users).
