sqlplus hrvstuser/har2vest@DEVDBS
sqlplus hrvstuser/har2vest@HARVEST2_PRODDBS1

spool contextDef.log;


select envobjid, environmentname, baselineviewid from harenvironment where environmentname='AdminWeb';
select stateobjid, statename from harstate where envobjid = 315;
select processobjid ID, processname NAME, updmode U, concurupdmode C, browsemode B, reservemode R, syncmode S from harcheckoutproc where stateobjid = 1248;
select processobjid ID, processname NAME, modeoption MD from harcheckinproc where stateobjid = 1248;
select viewobjid, viewname from harview where envobjid = 325;
select packageobjid, packagename from harpackage where envobjid = 315 and stateobjid = 1363;
select processobjid, processname from harremitemproc where stateobjid = 1248;
select processobjid, processname from harrenameitemproc where stateobjid = 1248;
select * from harcheckoutproc where stateobjid = 1363;
select processobjid, processname from harlistversproc where stateobjid = 1363;
select usrobjid, username from haruser;
select v.clientpath from harversions v, haritems i, harrepinview x where v.itemobjid= i.itemobjid and i.repositobjid=x.repositobjid and x.viewobjid=1379;
select processobjid, processname from harcrpkgproc where stateobjid = 1363;
select viewobjid, viewname, viewtype from harview where envobjid = 315;
select processobjid, processname from harstateprocess where stateobjid = 1363;
select itemobjid, itemname from haritems where repositobjid=118;
select repositobjid from harrepinview where viewobjid=1379;
select repositobjid from harrepository where repositname='FacadeConversion';

133365
104914

select itemname, repositobjid from haritems where parentobjid=0;
select itemobjid, repositobjid from haritems where itemname='SCManagement';