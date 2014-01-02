update harpackage set (clientname=null,servername=null,status='Idle')where packageobjid in (select packageobjid from harpackage s where s.STATUS not like 'Idle' and s.PACKAGENAME not like 'BASE');

/*
update harpackage set (clientname=null,servername=null,status='Idle')where packageobjid in (select packageobjid from harpackage s where s.packageobjid <> 0 and s.STATUS not like 'Idle');