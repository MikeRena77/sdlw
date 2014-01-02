spool resetHungPackageReport.rtf
update TESCOCM.HARPACKAGE
set STATUS = 'Idle'
where PACKAGEOBJID = 660;
spool off