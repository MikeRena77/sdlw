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