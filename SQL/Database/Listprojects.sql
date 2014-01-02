SET NEWPAGE 0
SET SPACE 0
SET LINESIZE 80
SET PAGESIZE 0
SET ECHO ON
SET FEEDBACK ON
SET HEADING ON
SET MARKUP HTML ON
SET ESCAPE \
spool log/projects_090402.html
select he.environmentname, he.envobjid,
	hs.statename, hs.stateobjid
from harenvironment he,
	harstate hs
where he.envobjid=hs.envobjid and
	he.envisactive='Y';
/* Group by he.environmentname,hs.statename;  not used when seeking objids */
spool off
set markup html off

