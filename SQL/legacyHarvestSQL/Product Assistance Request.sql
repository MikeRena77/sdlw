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
    VALUES(tobjid, 'harPAR', 'Product Assistance Request');
 
    SELECT MAX(attrid) INTO aobjid
    FROM harFormTypeDefs;
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARMAINTID', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCOMPANY', 'varchar', 62);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARMAINTEXP', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARACCTSTATUS', 'varchar', 9);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCONTACT', 'varchar', 62);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARPHONE', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARFAX', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PAREMAIL', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARPAGER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARPRODUCT', 'varchar', 24);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARPRODOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARPRODREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSRVOS', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSRVOSOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSRVOSREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSRVGUI', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSRVGUIOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSRVGUIREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCLIOS', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCLIOSOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCLIOSREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCLIGUI', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCLIGUIOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCLIGUIREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARDBOS', 'varchar', 18);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARDBOSOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARDBOSREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARDBTYPE', 'varchar', 11);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARDBTYPEOTHER', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARDBTYPEREL', 'varchar', 20);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARADDLENVNOTES', 'varchar', 1000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARQUESPROB', 'varchar', 8);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCUSTPRIORITY', 'varchar', 7);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARINTSUPPPRI', 'varchar', 7);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSHORTDESC', 'varchar', 62);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSYMPTOM1', 'varchar', 15);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSYMPTOM2', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSYMPTOM3', 'varchar', 49);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARPROBDESC', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCONTACTLOG', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARRESOLUTION', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSUPPREPASSIGNED', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARTIMESPENTHH', 'varchar', 3);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARTIMESPENTMM', 'varchar', 2);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARNEXTACTION', 'varchar', 62);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARTICKLEDATE', 'date', 25);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARNEXTACTIONASSIGNED', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCONTACTLOG2', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCONTACTLOG3', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCONTACTLOG4', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCONTACTLOG5', 'varchar', 2000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARINTEXT', 'varchar', 8);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSTATUSTYPE', 'varchar', 7);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCATEGORY', 'varchar', 8);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARMANUALDOCUMENT', 'varchar', 30);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARPREDEVNOTES', 'varchar', 202);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARESTEFFORT', 'varchar', 12);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARINTDEVPRIORITY', 'varchar', 7);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARCOMMITMENT', 'varchar', 62);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARUNKSUGGREQ', 'varchar', 9);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARHOLDPRODSHIP', 'char', 5);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARPRNTYPE', 'varchar', 23);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARINCORPINSTR', 'varchar', 27);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARINITIALSHIPINSTR', 'varchar', 66);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARSHIPTOASSOCACCTS', 'char', 5);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARFUTURESHIPINSTR', 'varchar', 66);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARREPLACEALLORONREQUEST', 'varchar', 29);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARDEVELOPERS', 'varchar', 40);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARDEVSUMMARY', 'varchar', 1000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARTECHWRITERS', 'varchar', 40);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARTECHWRITERSSUMMARY', 'varchar', 1000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARQAREPS', 'varchar', 40);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PARQASUMMARY', 'varchar', 1000);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PAROPERPERSONNEL', 'varchar', 40);
 
    aobjid := aobjid + 1;
    INSERT INTO harFormTypeDefs(attrid, formtypeobjid, columnname, columntype, columnsize)
    VALUES(aobjid, tobjid, 'PAROPERSUMMARY', 'varchar', 1000);
 
END;
/
CREATE TABLE harPAR (
   formobjid INTEGER PRIMARY KEY,
   PARMAINTID VARCHAR(20),
   PARCOMPANY VARCHAR(62),
   PARMAINTEXP DATE,
   PARACCTSTATUS VARCHAR(9),
   PARCONTACT VARCHAR(62),
   PARPHONE VARCHAR(49),
   PARFAX VARCHAR(49),
   PAREMAIL VARCHAR(49),
   PARPAGER VARCHAR(49),
   PARPRODUCT VARCHAR(24),
   PARPRODOTHER VARCHAR(49),
   PARPRODREL VARCHAR(20),
   PARSRVOS VARCHAR(18),
   PARSRVOSOTHER VARCHAR(49),
   PARSRVOSREL VARCHAR(20),
   PARSRVGUI VARCHAR(18),
   PARSRVGUIOTHER VARCHAR(49),
   PARSRVGUIREL VARCHAR(20),
   PARCLIOS VARCHAR(18),
   PARCLIOSOTHER VARCHAR(49),
   PARCLIOSREL VARCHAR(20),
   PARCLIGUI VARCHAR(18),
   PARCLIGUIOTHER VARCHAR(49),
   PARCLIGUIREL VARCHAR(20),
   PARDBOS VARCHAR(18),
   PARDBOSOTHER VARCHAR(49),
   PARDBOSREL VARCHAR(20),
   PARDBTYPE VARCHAR(11),
   PARDBTYPEOTHER VARCHAR(49),
   PARDBTYPEREL VARCHAR(20),
   PARADDLENVNOTES VARCHAR(1000),
   PARQUESPROB VARCHAR(8),
   PARCUSTPRIORITY VARCHAR(7),
   PARINTSUPPPRI VARCHAR(7),
   PARSHORTDESC VARCHAR(62),
   PARSYMPTOM1 VARCHAR(15),
   PARSYMPTOM2 VARCHAR(49),
   PARSYMPTOM3 VARCHAR(49),
   PARPROBDESC VARCHAR(2000),
   PARCONTACTLOG VARCHAR(2000),
   PARRESOLUTION VARCHAR(2000),
   PARSUPPREPASSIGNED VARCHAR(30),
   PARTIMESPENTHH VARCHAR(3),
   PARTIMESPENTMM VARCHAR(2),
   PARNEXTACTION VARCHAR(62),
   PARTICKLEDATE DATE,
   PARNEXTACTIONASSIGNED VARCHAR(30),
   PARCONTACTLOG2 VARCHAR(2000),
   PARCONTACTLOG3 VARCHAR(2000),
   PARCONTACTLOG4 VARCHAR(2000),
   PARCONTACTLOG5 VARCHAR(2000),
   PARINTEXT VARCHAR(8),
   PARSTATUSTYPE VARCHAR(7),
   PARCATEGORY VARCHAR(8),
   PARMANUALDOCUMENT VARCHAR(30),
   PARPREDEVNOTES VARCHAR(202),
   PARESTEFFORT VARCHAR(12),
   PARINTDEVPRIORITY VARCHAR(7),
   PARCOMMITMENT VARCHAR(62),
   PARUNKSUGGREQ VARCHAR(9),
   PARHOLDPRODSHIP CHAR(5),
   PARPRNTYPE VARCHAR(23),
   PARINCORPINSTR VARCHAR(27),
   PARINITIALSHIPINSTR VARCHAR(66),
   PARSHIPTOASSOCACCTS CHAR(5),
   PARFUTURESHIPINSTR VARCHAR(66),
   PARREPLACEALLORONREQUEST VARCHAR(29),
   PARDEVELOPERS VARCHAR(40),
   PARDEVSUMMARY VARCHAR(1000),
   PARTECHWRITERS VARCHAR(40),
   PARTECHWRITERSSUMMARY VARCHAR(1000),
   PARQAREPS VARCHAR(40),
   PARQASUMMARY VARCHAR(1000),
   PAROPERPERSONNEL VARCHAR(40),
   PAROPERSUMMARY VARCHAR(1000),
   FOREIGN KEY(formobjid) REFERENCES harForm ON DELETE CASCADE);
 
COMMIT;
spool off;
EXIT
