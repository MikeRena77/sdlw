set pagesize 0;
set trimspool on;
set heading off;
set headsep off;
set recsep off;
set verify off;
set feedback off;
delete harpkgsinpkggrp 
where packageobjid = (select packageobjid 
                      from harpackage hp, harenvironment he 
                      where hp.envobjid=he.envobjid and
                                 environmentname='&1' and
                                 packagename='&2');
commit;
exit;
		           
