-- Version Status Report
-- Arguments are: env fullpath item logfile
set term off;
set verify off;
spool &4
SELECT
	rpad(rtrim(T.pathfullname)||rtrim(I.itemname)||';'||V.mappedversion,50) "Version        ",
	decode(V.versionstatus, 'N', 'Normal',
                            'R', 'Reserved',
                            'D', 'Deleted',
                            'M', 'Merged') "Status",
	rpad(rtrim(P.packagename),12) "Package",
	rpad(rtrim(S.statename),14) "State",
	rpad(rtrim(W.viewname),12) "View"
FROM
	harpathfullname T,
	haritem I,
	harversion V,
	harpackage P,
	harenvironment E,
	harstate S,
	harview W
WHERE
	E.environmentname = '&1' and
	T.pathfullname = '&2' and
	I.itemname = '&3' and
	I.pathobjid = T.pathobjid and
	P.envobjid = E.envobjid and
	P.stateobjid = S.stateobjid and
	V.packageobjid = P.packageobjid and
	V.itemobjid = I.itemobjid and
	W.viewobjid = S.viewobjid
ORDER BY
	pathfullname,itemname,mappedversion
;
exit;

