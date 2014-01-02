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
    VALUES(tobjid, 'harESD', 'ESD Change Request');
 
    SELECT MAX(attrid) INTO aobjid
    FROM harFormTypeDefs;
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDREQUESTDATE', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDINITIATOR', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDTYPE', 'varchar', 52);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDPRIORITY', 'varchar', 10);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDDESCRIPTION', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDID', 'varchar', 40);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDRISKLEVEL', 'varchar', 10);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDIMPACTNOTES', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDSCOPE', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDSWDEPENDENCYNOTES', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDHWDEPENDENCYNOTES', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDSCRIPTNOTES', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDIMPLEMENTATIONDATE', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDREQUIREDSPACE', 'varchar', 40);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDINVESTIGATOR', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDTESTPLAN', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDCERTIFICATIONRESULTS', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDTESTEDBY', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDDEPLOYMENTPLAN', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDBACKOUTPLAN', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDTRAININGPLAN', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDPLANNEDBY', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDREVIEWNOTES', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDREVIEWEDBY', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDREJECTNOTES', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'ESDREJECTEDBY', 'varchar', 30);
 
END;
/
CREATE TABLE harESD (
   formobjid INTEGER PRIMARY KEY,
   ESDREQUESTDATE DATE,
   ESDINITIATOR VARCHAR(30),
   ESDTYPE VARCHAR(52),
   ESDPRIORITY VARCHAR(10),
   ESDDESCRIPTION VARCHAR(2000),
   ESDID VARCHAR(40),
   ESDRISKLEVEL VARCHAR(10),
   ESDIMPACTNOTES VARCHAR(2000),
   ESDSCOPE VARCHAR(2000),
   ESDSWDEPENDENCYNOTES VARCHAR(2000),
   ESDHWDEPENDENCYNOTES VARCHAR(2000),
   ESDSCRIPTNOTES VARCHAR(2000),
   ESDIMPLEMENTATIONDATE DATE,
   ESDREQUIREDSPACE VARCHAR(40),
   ESDINVESTIGATOR VARCHAR(30),
   ESDTESTPLAN VARCHAR(2000),
   ESDCERTIFICATIONRESULTS VARCHAR(2000),
   ESDTESTEDBY VARCHAR(30),
   ESDDEPLOYMENTPLAN VARCHAR(2000),
   ESDBACKOUTPLAN VARCHAR(2000),
   ESDTRAININGPLAN VARCHAR(2000),
   ESDPLANNEDBY VARCHAR(30),
   ESDREVIEWNOTES VARCHAR(2000),
   ESDREVIEWEDBY VARCHAR(30),
   ESDREJECTNOTES VARCHAR(2000),
   ESDREJECTEDBY VARCHAR(30),
   FOREIGN KEY(formobjid) REFERENCES harForm ON DELETE CASCADE);
 
COMMIT;
spool off;
EXIT
