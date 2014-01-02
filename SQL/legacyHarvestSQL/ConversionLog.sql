/*
 *  ConversionLog.sql
 *
 *  Create conversion log 
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
-- SPOOL &1
-- Commit every change in order to avoid huge rollback segments

DEFINE HARVESTINDEXTSNAME=&1

SET autocommit ON
SET document ON
set feedback on
set timing off
set verify off

CREATE TABLE harConversionLog
(
 TABLENAME  VARCHAR2(64) NOT NULL,
 LASTOBJID  NUMBER,
 PRIMARY KEY (TABLENAME) USING INDEX   
 TABLESPACE &HARVESTINDEXTSNAME
);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARALLCHILDRENPATH', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARALLUSERS', MAX (USROBJID)
     FROM HARALLUSERS;
     
INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARBRANCH', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARENVIRONMENT', MAX (envobjid)
     FROM HARENVIRONMENT;

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES ('HARENVIRONMENTACCESS', -2);
--
-- Not logging form subtype tables
--     
INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARFORM', MAX (FORMOBJID)
     FROM HARFORM;

INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARFORMTYPE', MAX (FORMTYPEOBJID)
     FROM HARFORMTYPE;
          
INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARHARVEST', -2);
          
INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARITEMACCESS', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARITEMRELATIONSHIP', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARITEMS', -2);
--
-- Not logging process subtype tables
--     
INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARLINKEDPROCESS', MAX (PROCESSOBJID)
     FROM HARLINKEDPROCESS;
     
INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARSTATEPROCESS', MAX (PROCESSOBJID)
     FROM HARSTATEPROCESS;
--
-- Not logging history and relationships
--    
INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARPACKAGE', MAX (PACKAGEOBJID)
     FROM HARPACKAGE;

INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARPACKAGEGROUP', MAX (PKGGRPOBJID)
     FROM HARPACKAGEGROUP;
          
INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARPATHFULLNAME', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARPMSTATUS', MAX (PMSTATUSINDEX)
     FROM HARPMSTATUS;
     
INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARREPINVIEW', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARREPOSITORY', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARREPOSITORYACCESS', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARSTATE', MAX (STATEOBJID)
     FROM HARSTATE;

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES ('HARSTATEPROCESSACCESS', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARUSER', MAX (USROBJID)
     FROM HARUSER;

INSERT INTO harConversionLog( tablename, lastobjid)
   SELECT 'HARUSERGROUP', MAX (USRGRPOBJID)
     FROM HARUSERGROUP;

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARVERSIONDATA', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARVERSIONDELTA', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARVERSIONINVIEW', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARVERSIONS', -2);

INSERT INTO harConversionLog( tablename, lastobjid)
VALUES( 'HARVIEW', -2);

UPDATE harConversionLog
SET LASTOBJID = 0
WHERE LASTOBJID IS NULL;

-- spool off

-- EXIT

