set pagesize 0;
set trimspool on;
set heading off;
set headsep off;
set recsep off;
set verify off;
set feedback off;
select hpig.packageobjid 
from harpkgsinpkggrp hpig 
where hpig.pkggrpobjid = (select pkggrpobjid 
                          from harpackagegroup hpg, harenvironment he 
                          where hpg.envobjid=he.envobjid and 
                          environmentname='&1' and
                          pkggrpname='&2');
exit;