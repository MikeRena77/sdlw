- get_item_details. Returns all the projects/states in
- which a specified item can be found.
-
- Phil Gibbs (pgibbs@trinem.co.uk)
-
create or replace procedure get_item_details(
  ITEMID	haritems.itemobjid%type) is
-- local variables
--
-- envcur is the main driving "outer" loop. It selects all the environment(s)
-- in which the specified item resides.
--
CURSOR envcur(	itemid haritems.itemobjid%TYPE) IS
select          c.envobjid,
                a.repfromviewid,
                c.environmentname
from            harrepinview    a,
                haritems        b,
                harenvironment  c
where           b.itemobjid=itemid
and             a.repositobjid=b.repositobjid
and             c.baselineviewid=a.viewobjid
order by        c.envobjid;
--
-- versioncur is the "inner" loop. For each environment it retrieves the
-- mapped versions of the specified item. Note the "union" clause. This
-- forces the select of "version 0" items that are present due to either an
-- initial load (through the repository editor) or due to the environment
-- being based on a snapshot from another environment.
--
CURSOR versioncur(	envid	harenvironment.envobjid%TYPE,
			itemid	haritems.itemobjid%TYPE) IS
select  a.mappedversion,
	decode(a.versionstatus,'N','',rtrim(a.versionstatus)) versionstatus,
        e.createtime,
        a.creationtime,
        a.parentversionid,
        d.username,
        b.packageobjid,
        b.packagename,
        c.statename,
        a.versionobjid
from    harversions     a,
        harpackage      b,
        harstate        c,
        harallusers     d,
        harversiondata  e
where   b.envobjid=envid
and     a.itemobjid=itemid
and     b.packageobjid=a.packageobjid
and     c.stateobjid=b.stateobjid
and     a.creatorid=d.usrobjid
and     e.versiondataobjid=a.versiondataobjid
union
select  a.mappedversion,
	decode(a.versionstatus,'N','',rtrim(a.versionstatus)) versionstatus,
        e.createtime,
        a.creationtime,
        0,
        '',
        0,
        '',
        '',
        a.versionobjid
from    harversions             a,
        harversioninview        b,
        harview                 c,
        harversiondata          e
where   a.versionobjid=b.versionobjid
and     a.itemobjid=itemid
and     a.mappedversion='0'
and     b.viewobjid=c.viewobjid
and     c.viewtype='Baseline'
and     c.envobjid=envid
and     e.versiondataobjid=a.versiondataobjid
order by 10;



--
snapshotname	harview.viewname%TYPE;
sourceenvname	harenvironment.environmentname%TYPE;
sourceversion	harversions.mappedversion%TYPE;
sourceenvobjid	harenvironment.envobjid%TYPE;
sourceview	harview.viewobjid%TYPE;
--
-- end local variables
--
--
-- ENTRY POINT to "get_item_details"
--
begin
--
FOR env IN envcur(ITEMID) LOOP
	FOR ver IN versioncur(env.envobjid,ITEMID) LOOP
		IF ver.packageobjid=0 AND ver.parentversionid=0 THEN
			-- This environment is based on a snapshot and this is
			-- the "BASE" version. Get the details of the "source"
			-- environment.
			--
			SELECT	a.viewname,
				b.environmentname,
				b.envobjid
			INTO	snapshotname,
				sourceenvname,
				sourceenvobjid
			FROM	harview		a,
				harenvironment	b
			WHERE	b.envobjid=a.envobjid
			AND	a.viewobjid=env.repfromviewid;
			--
			-- Now get the version of the item from which this
			-- version was taken.
			--
			BEGIN
				SELECT	mappedversion
				INTO	sourceversion
				FROM	harversioninview	a,
					harview			b,
					harenvironment		c,
					harversions		d
				WHERE	a.viewobjid=env.repfromviewid
				AND	d.itemobjid=ITEMID
				AND	a.viewobjid=b.viewobjid
				AND	b.envobjid=c.envobjid
				AND	d.versionobjid=a.versionobjid;
			EXCEPTION
				WHEN NO_DATA_FOUND
				THEN
					sourceversion:='1';	-- pretend initial load
			END;
		ELSE
			snapshotname:='';
			sourceenvname:='';
			sourceversion:='';
			sourceenvobjid:=0;
		END IF;
		dbms_output.put_line(
		env.envobjid||'|'||
		rtrim(env.environmentname)||'|'||
		ver.versionobjid||'|'||
		rtrim(ver.mappedversion)||
		ver.versionstatus||'|'||
		rtrim(ver.username)||'|'||
		ver.packageobjid||'|'||
		rtrim(ver.packagename)||'|'||
		rtrim(ver.statename)||'|'||
		to_char(ver.creationtime,'DD/MM/YYYY HH24:MI:SS')||'|'||
		to_char(ver.createtime,'DD/MM/YYYY HH24:MI:SS')||'|'||
		rtrim(snapshotname)||'|'||
		rtrim(sourceenvname)||'|'||
		rtrim(sourceversion)||'|'||
		env.repfromviewid||'|'||
		sourceenvobjid
		);
	END LOOP;
END LOOP;
--
end get_item_details;
/
show errors
/
grant execute on get_item_details to harrep
/

