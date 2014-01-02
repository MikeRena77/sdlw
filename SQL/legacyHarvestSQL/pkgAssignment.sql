select u.email
from haruser u, harpackage p
where p.packagename='$pkgname'
and p.assigneeid=u.usrobjid