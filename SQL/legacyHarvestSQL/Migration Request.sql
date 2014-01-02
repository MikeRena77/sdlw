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
    VALUES(tobjid, 'migrationrequest', 'Migration Request');
 
    SELECT MAX(attrid) INTO aobjid
    FROM harFormTypeDefs;
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGREQDATE', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGREQNAME', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migmigtype', 'varchar', 15);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migapptype', 'varchar', 8);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migstate', 'varchar', 6);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migdesc1', 'varchar', 200);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migpri1', 'varchar', 11);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGHARPACK', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migsrcenv', 'varchar', 22);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migtgtenv1', 'varchar', 22);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGDESMIGDATE1', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGLATEMIGDATE1', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGSCHEDMIGDATE1', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migtgtenv2', 'varchar', 22);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGDESMIGDATE2', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGLATEMIGDATE2', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGSCHEDMIGDATE2', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migtgtenv3', 'varchar', 22);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGDESMIGDATE3', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGLATEMIGDATE3', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGSCHEDMIGDATE3', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migtgtenv4', 'varchar', 22);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGDESMIGDATE4', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGLATEMIGDATE4', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGSCHEDMIGDATE4', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migactstat1', 'varchar', 16);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migactstat2', 'varchar', 16);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migactstat3', 'varchar', 16);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migactstat4', 'varchar', 16);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migmigsteps', 'varchar', 200);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'migspecinst', 'varchar', 200);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGASSIGNEDTO', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'MIGCLOSEDATE', 'date', 25);
 
END;
/
CREATE TABLE migrationrequest (
   formobjid INTEGER PRIMARY KEY,
   MIGREQDATE DATE,
   MIGREQNAME VARCHAR(30),
   migmigtype VARCHAR(15),
   migapptype VARCHAR(8),
   migstate VARCHAR(6),
   migdesc1 VARCHAR(200),
   migpri1 VARCHAR(11),
   MIGHARPACK VARCHAR(30),
   migsrcenv VARCHAR(22),
   migtgtenv1 VARCHAR(22),
   MIGDESMIGDATE1 DATE,
   MIGLATEMIGDATE1 DATE,
   MIGSCHEDMIGDATE1 DATE,
   migtgtenv2 VARCHAR(22),
   MIGDESMIGDATE2 DATE,
   MIGLATEMIGDATE2 DATE,
   MIGSCHEDMIGDATE2 DATE,
   migtgtenv3 VARCHAR(22),
   MIGDESMIGDATE3 DATE,
   MIGLATEMIGDATE3 DATE,
   MIGSCHEDMIGDATE3 DATE,
   migtgtenv4 VARCHAR(22),
   MIGDESMIGDATE4 DATE,
   MIGLATEMIGDATE4 DATE,
   MIGSCHEDMIGDATE4 DATE,
   migactstat1 VARCHAR(16),
   migactstat2 VARCHAR(16),
   migactstat3 VARCHAR(16),
   migactstat4 VARCHAR(16),
   migmigsteps VARCHAR(200),
   migspecinst VARCHAR(200),
   MIGASSIGNEDTO VARCHAR(30),
   MIGCLOSEDATE DATE,
   FOREIGN KEY(formobjid) REFERENCES harForm ON DELETE CASCADE);
 
COMMIT;
spool off;
EXIT
