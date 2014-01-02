select * from harstate where stateobjid IN (select stateobjid from harcrpkgproc where defaultpkgformname LIKE 'HRPMW%') order by statename; 

select environmentname from harenvironment where envobjid IN (select envobjid from harstate where stateobjid IN (select stateobjid from harcrpkgproc where defaultpkgformname LIKE 'HRPMW%')); 
