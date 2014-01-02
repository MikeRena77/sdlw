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
    VALUES(tobjid, 'harTestingInfo', 'Testing Info');
 
    SELECT MAX(attrid) INTO aobjid
    FROM harFormTypeDefs;
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'DEVELOPER', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'DEVDATE', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'TESTCASES', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'DEVCOMMENTS', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'TESTER', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'TESTDATE', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'TESTRESULTS', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'TESTCOMMENTS', 'varchar', 2000);
 
END;
/
CREATE TABLE harTestingInfo (
   formobjid INTEGER PRIMARY KEY,
   DEVELOPER VARCHAR(30),
   DEVDATE DATE,
   TESTCASES VARCHAR(2000),
   DEVCOMMENTS VARCHAR(2000),
   TESTER VARCHAR(30),
   TESTDATE DATE,
   TESTRESULTS VARCHAR(2000),
   TESTCOMMENTS VARCHAR(2000),
   FOREIGN KEY(formobjid) REFERENCES harForm ON DELETE CASCADE);
 
COMMIT;
spool off;
EXIT
