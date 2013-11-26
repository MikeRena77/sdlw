SET NEWPAGE 0
SET SPACE 0
SET LINESIZE 80
SET PAGESIZE 0
SET ECHO OFF
SET FEEDBACK ON
SET HEADING ON
SET MARKUP HTML ON
SET ESCAPE \

spool hungPackageReportSummary.htm

PRINT

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES Administrative Support'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename;
PRINT e.environmentname
select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES.HR.Common.Utilities'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename;

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES.HR.Functions'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES.HR.Functions.Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES.HR.RankingBoardImages.2008'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES.HR.Workers'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES.HR.Workers.2k8'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES.HR.Workers.History'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'AAFES.HR.Workers.Prod'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'ECM Dev'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'ECM Prod'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-CASMaint-2005'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-CASMaint-Prod'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Deployment'
and s.statename = 'Development'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Facade-2005'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Facade-Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Global-2008'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Global-Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Images-2008'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Images-Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-NEP'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-NEP-Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-OPF-GetImages'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-OPFWebService-2008'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-OPFWebService-Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-OnLineReports'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'XPS-Endevor'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'yContractor_2k5'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'PACE Merchandise Planning'
and s.statename = 'Development'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'Operation Blowtorch'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'LCE Production'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'LCE Development'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'LCE Base 1'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'LCE Base'
and s.statename = 'Import'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'IT-Enterprise Content Management'
and s.statename = 'Development'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'Hyperion9'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'Retek Production'
and s.statename = 'Development'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'Hyperion'
and s.statename = 'Development'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR.3rdParty.Dlls'
and s.statename = 'Receive Code'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Reports-Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-Reports-2003'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-PostAllowance-Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-PostAllowance-2005'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-POPs-Prod'
and s.statename = 'Merge'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-POPs-2008'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

select p.packagename, p.status, p.packageobjid
from hrvstuser.harPackage p, hrvstuser.harEnvironment e, hrvstuser.harState s
where p.envobjid = e.envobjid
and p.stateobjid = s.stateobjid
and e.environmentname = 'HR-OnLineReports-Prod'
and s.statename = 'Alpha'
and not p.status = 'Idle'
order by p.packagename; 

PRINT

spool off

exit

/* 
*/
Meister-Test
POPS
RETEK DEV Training
RETEK RMS PROD Train
Retek Base Code
Retek CR% Wave 2 Development Model
Retek CR1 - Wave 2 Development
Retek CR2 - Wave 2 Development
Retek CR3 - Wave 2 Development
Retek Conversion - History Only
Retek Dev Wave 1
Retek Production
Retek Wave 2 Release Consolidation
Retek Wave 2 Release Consolidation Model
SRMS
WebCentral