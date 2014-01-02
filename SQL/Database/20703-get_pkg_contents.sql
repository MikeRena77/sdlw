-- get_pkg_contents -- report versions in a package
-- usage: sqlplus @get_pkg_contents &lt;out file&gt; &lt;env name&gt; &lt;package name&gt;
set pagesize 60;
spool &amp;1;
--set linesize 132;
--set heading off;
--set headsep off;
--set recsep off;
set verify off;
set feedback off;

SELECT mrdescript "Package description"
FROM HARMR hmr,HARASSOCPKG hasc,HARPACKAGE hpkg
WHERE hpkg.packagename='&amp;3'
and hpkg.packageobjid=hasc.assocpkgid
and hmr.formobjid=hasc.formobjid;

select
  rpad(rtrim(T.pathfullname)||rtrim(I.itemname)||';'||V.mappedversion,62) "Version",
  rpad(decode(V.versionstatus, 'N', 'Normal  ',
                               'R', 'Reserved',
                               'D', 'Deleted ',
                               'M', 'Merged  '),8) "Status",
  rpad(rtrim(U.username),8) "User"
from
  harpathfullname T,
  haritems I,
  harversions V,
  harpackage P,
  harenvironment E,
  harallusers U
where
  E.environmentname = '&amp;2' and
  P.packagename = '&amp;3' and
  P.envobjid = E.envobjid and
  V.packageobjid = P.packageobjid and
  V.itemobjid = I.itemobjid and
--  I.pathobjid = T.pathobjid and
  I.itemobjid = T.itemobjid and
  V.creatorid = U.usrobjid
ORDER BY
	pathfullname,itemname,mappedversion;

exit;
