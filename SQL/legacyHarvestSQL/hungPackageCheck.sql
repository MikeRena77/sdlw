spool hungPackageReport.rtf
select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'OT-TES WPS ACMS'
and s.statename = 'Development'
and not p.status = 'Idle'
order by p.packagename;
spool off