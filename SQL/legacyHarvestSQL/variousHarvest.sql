Connect system/****@EWA AS SYSDBA
UPDATE "TESCOCM"."HARCHECKOUTPROC"
    SET "PATHOPTION" = 2
    WHERE "PATHOPTION" = 1

Connect system/****@EWA AS SYSDBA
select statename from tescocm.harstate where stateobjid = 678

Connect system/****@EWA AS SYSDBA
select statename from tescocm.harstate where stateobjid = 233

Connect system/****@EWA AS SYSDBA
UPDATE "TESCOCM"."HARCHECKOUTPROC"
    SET "USECHECKINTIMESTAMP" = 'N'
    WHERE  "USECHECKINTIMESTAMP" = 'Y'

    select "TESCOCM"."HARENVIRONMENT"."ENVOBJID",
    "TESCOCM"."HARENVIRONMENT"."ENVIRONMENTNAME",
    "TESCOCM"."HARENVIRONMENT"."ENVISACTIVE",
    "TESCOCM"."HARENVIRONMENT"."BASELINEVIEWID",
    "TESCOCM"."HARENVIRONMENT"."CREATIONTIME",
    "TESCOCM"."HARENVIRONMENT"."CREATORID",
    "TESCOCM"."HARENVIRONMENT"."MODIFIEDTIME",
    "TESCOCM"."HARENVIRONMENT"."MODIFIERID",
    "TESCOCM"."HARENVIRONMENT"."NOTE",
    "TESCOCM"."HARENVIRONMENT"."ISARCHIVE",
    "TESCOCM"."HARENVIRONMENT"."ARCHIVEBY",
    "TESCOCM"."HARENVIRONMENT"."ARCHIVEMACHINE",
    "TESCOCM"."HARENVIRONMENT"."ARCHIVEFILE",
    "TESCOCM"."HARENVIRONMENT"."ARCHIVETIME"
    from "TESCOCM"."HARENVIRONMENT"
    where "TESCOCM"."HARENVIRONMENT"."ENVIRONMENTNAME" LIKE 'TIMS %'

    select harenvironment.environmentname, harrepository.repositname, haritempath.pathname, harrepository.modifiedtime, harrepository.creationtime
from harenvironment, harrepository, harenvrepository, haritempath
where harenvironment.envobjid=harenvrepository.envobjid and
harrepository.repositobjid=harenvrepository.repositobjid and
haritempath.pathobjid=harrepository.rootpathid AND harenvironment.environmentname LIKE 'TIMS%'

order by harenvironment.environmentname, harrepository.repositname, haritempath.pathname




select i.itemname, e.environmentname, r.repositname, v.viewname
from haritems i, harenvironment e, harrepinview r, harview v
where e.envobjid=v.envobjid and
v.viewobjid=r.viewobid and
r.repositobjid=i.repositobjid and
e.environmentname LIKE 'TIMS%'
order by harenvironment.environmentname, harrepository.repositname, haritempath.pathname


select i.itemname, e.environmentname, p.repositname, v.viewname
from tescocm.haritems i, tescocm.harenvironment e, tescocm.harrepository p, tescocm.harrepinview r, tescocm.harview v
where e.envobjid=v.envobjid and
v.viewobjid=r.viewobjid and
r.repositobjid=p.repositobjid and
p.repositobjid=i.repositobjid and
e.environmentname LIKE 'TIMS%'
order by e.environmentname, p.repositname, i.itemname


spool c:\report\timsReportVersions.out
select distinct e.environmentname, count(s.versionobjid)
from tescocm.haritems i, tescocm.harenvironment e, tescocm.harrepository p, tescocm.harrepinview r, tescocm.harview v, tescocm.harversions s
where e.envobjid=v.envobjid and
v.viewobjid=r.viewobjid and
r.repositobjid=p.repositobjid and
p.repositobjid=i.repositobjid and
i.itemobjid=s.itemobjid and
e.environmentname LIKE 'TIMS%' and 
v.viewname = 'baselineview'
group by e.environmentname
order by e.environmentname;
spool off

SELECT count("TESCOCM"."HARITEMS"."ITEMOBJID")
    FROM "TESCOCM"."HARITEMS"


SELECT count("TESCOCM"."HARVERSIONS"."VERSIONOBJID")
    FROM "TESCOCM"."HARVERSIONS"