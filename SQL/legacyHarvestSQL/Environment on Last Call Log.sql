WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
 
SPOOL &1
 
DECLARE
   tobjid NUMBER;
   aobjid NUMBER;
BEGIN
 
SELECT MAX(formtypeobjid) INTO tobjid
FROM harFormType;
 
    tobjid := tobjid + 1;
    INSERT INTO harFormType(formtypeobjid, formtablename, formtypename)
    VALUES(tobjid, 'harEnvOnLastCall', 'Environment on Last Call Log');
 
    SELECT MAX(attrid) INTO aobjid
    FROM harFormTypeDefs;
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVMAINTID', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVCOMPANY', 'varchar', 62);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVMAINTEXP', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVACCTSTATUS', 'varchar', 9);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVPRODUCT', 'varchar', 24);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVPRODOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVPRODREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVSRVOS', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVSRVOSOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVSRVOSREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVSRVGUI', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVSRVGUIOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVSRVGUIREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVCLIOS', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVCLIOSOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVCLIOSREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVCLIGUI', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVCLIGUIOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVCLIGUIREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVDBOS', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVDBOSOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVDBOSREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVDBTYPE', 'varchar', 11);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVDBTYPEOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVDBTYPEREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ENVADDLENVNOTES', 'varchar', 1000);
 
END;
/
CREATE TABLE harEnvOnLastCall (
   formobjid INTEGER PRIMARY KEY,
   ENVMAINTID VARCHAR(20),
   ENVCOMPANY VARCHAR(62),
   ENVMAINTEXP DATE,
   ENVACCTSTATUS VARCHAR(9),
   ENVPRODUCT VARCHAR(24),
   ENVPRODOTHER VARCHAR(49),
   ENVPRODREL VARCHAR(20),
   ENVSRVOS VARCHAR(18),
   ENVSRVOSOTHER VARCHAR(49),
   ENVSRVOSREL VARCHAR(20),
   ENVSRVGUI VARCHAR(18),
   ENVSRVGUIOTHER VARCHAR(49),
   ENVSRVGUIREL VARCHAR(20),
   ENVCLIOS VARCHAR(18),
   ENVCLIOSOTHER VARCHAR(49),
   ENVCLIOSREL VARCHAR(20),
   ENVCLIGUI VARCHAR(18),
   ENVCLIGUIOTHER VARCHAR(49),
   ENVCLIGUIREL VARCHAR(20),
   ENVDBOS VARCHAR(18),
   ENVDBOSOTHER VARCHAR(49),
   ENVDBOSREL VARCHAR(20),
   ENVDBTYPE VARCHAR(11),
   ENVDBTYPEOTHER VARCHAR(49),
   ENVDBTYPEREL VARCHAR(20),
   ENVADDLENVNOTES VARCHAR(1000),
   FOREIGN KEY(formobjid) REFERENCES harForm ON DELETE CASCADE);
 
COMMIT;
spool off;
EXIT
