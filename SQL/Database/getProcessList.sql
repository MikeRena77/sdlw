select rpad(rtrim(he.environmentname),40) "Project",
       rpad(rtrim(hs.statename),20) "State",
       rpad(rtrim(hsp.processname),30) "Process",
       rpad(rtrim(he.envisactive),6) "Active"
from harenvironment he,
	harstate hs,
	harstateprocess hsp
where hsp.stateobjid=hs.stateobjid and
	hs.envobjid=he.envobjid and 
	he.envisactive='Y'
Group by he.environmentname,
	hs.statename,
	hsp.processname,
	he.envisactive
Order by he.environmentname,
	hs.statename,
	hsp.processname;
