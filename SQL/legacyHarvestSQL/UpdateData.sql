/*
 * UpdateData.sql
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR CONTINUE
--
-- Add counter to package names in existing Create Package process models
--
UPDATE harCrPkgProc
   SET DEFAULTPKGFORMNAME = 'MR-%N(''099999'')'
 WHERE DEFAULTPKGFORMNAME = 'MR-000001';

UPDATE harCrPkgProc
   SET DEFAULTPKGFORMNAME = 'Bug #-%N(''999'')'
 WHERE DEFAULTPKGFORMNAME = 'Bug #-';

UPDATE harCrPkgProc
   SET DEFAULTPKGFORMNAME = 'PAC-%N(''099999'')'
 WHERE DEFAULTPKGFORMNAME = 'PAC-000001';

UPDATE harCrPkgProc
   SET DEFAULTPKGFORMNAME = 'ESD-%N(''099999'')'
 WHERE DEFAULTPKGFORMNAME = 'ESD-000001';

UPDATE harCrPkgProc
   SET DEFAULTPKGFORMNAME = 'DT-%N(''099999'')'
 WHERE DEFAULTPKGFORMNAME = 'DT-000001';
--
-- Insert Global file extensions
--
/*
 * Text file extension lists are now generated before conversion
 *
INSERT INTO harFileExtension
     VALUES (0, 'TXT');
INSERT INTO harFileExtension
     VALUES (0, 'BAT');
INSERT INTO harFileExtension
     VALUES (0, 'HTM');
INSERT INTO harFileExtension
     VALUES (0, 'HTML');
INSERT INTO harFileExtension
     VALUES (0, 'SQL');
INSERT INTO harFileExtension
     VALUES (0, 'C');
INSERT INTO harFileExtension
     VALUES (0, 'CPP');
INSERT INTO harFileExtension
     VALUES (0, 'H');
INSERT INTO harFileExtension
     VALUES (0, 'CXX');
INSERT INTO harFileExtension
     VALUES (0, 'TLI');
INSERT INTO harFileExtension
     VALUES (0, 'TLH');
INSERT INTO harFileExtension
     VALUES (0, 'INL');
INSERT INTO harFileExtension
     VALUES (0, 'RC');
INSERT INTO harFileExtension
     VALUES (0, 'HTX');
INSERT INTO harFileExtension
     VALUES (0, 'HXX');
INSERT INTO harFileExtension
     VALUES (0, 'ASP');
INSERT INTO harFileExtension
     VALUES (0, 'ALX');
INSERT INTO harFileExtension
     VALUES (0, 'STM');
INSERT INTO harFileExtension
     VALUES (0, 'SHTML');
INSERT INTO harFileExtension
     VALUES (0, 'DSM');
INSERT INTO harFileExtension
     VALUES (0, 'HPP');
INSERT INTO harFileExtension
     VALUES (0, 'SH');
INSERT INTO harFileExtension
     VALUES (0, 'KSH');
INSERT INTO harFileExtension
     VALUES (0, 'CSH');
INSERT INTO harFileExtension
     VALUES (0, 'AWK');
INSERT INTO harFileExtension
     VALUES (0, 'MAKE');
INSERT INTO harFileExtension
     VALUES (0, 'MAK');
INSERT INTO harFileExtension
     VALUES (0, 'JAVA');
INSERT INTO harFileExtension
     VALUES (0, 'COBOL');
INSERT INTO harFileExtension
     VALUES (0, 'COB');
INSERT INTO harFileExtension
     VALUES (0, 'PERL');
INSERT INTO harFileExtension
     VALUES (0, 'BAS');
INSERT INTO harFileExtension
     VALUES (0, 'INI');
INSERT INTO harFileExtension
     VALUES (0, 'SHELL');
*/
WHENEVER SQLERROR EXIT FAILURE

UPDATE harFormTypeDefs
   SET columntype = 'number'
 WHERE UPPER (columntype) = 'INTEGER';

UPDATE harPromoteProc
SET fromstateid = stateobjid
WHERE fromstateid = 0;

--
-- Update MERGEDPKGSONLY column opposite 
--
UPDATE harPromoteProc
SET MERGEDPKGSONLY = 'T'
WHERE MERGEDPKGSONLY = 'Y';

UPDATE harPromoteProc
SET MERGEDPKGSONLY = 'Y'
WHERE MERGEDPKGSONLY = 'N';

UPDATE harPromoteProc
SET MERGEDPKGSONLY = 'N'
WHERE MERGEDPKGSONLY = 'T';

UPDATE harTableInfo
   SET VERSIONINDICATOR = 50000
 WHERE VERSIONINDICATOR = 40000;

--
-- Convert user groups
--
DELETE harUserGroup
 WHERE usrgrpobjid = 1;

INSERT INTO harUserGroup (
               USRGRPOBJID,
               USERGROUPNAME,
               CREATIONTIME,
               CREATORID,
               MODIFIEDTIME,
               MODIFIERID
            )
     VALUES (1, 'Administrator', SYSDATE, 1, SYSDATE, 1);
UPDATE harUsersInGroup
   SET usrgrpobjid = 1
 WHERE usrgrpobjid = 3;
UPDATE harApproveList
   SET usrgrpobjid = 1
 WHERE usrgrpobjid = 3;
UPDATE harNotifyList
   SET usrgrpobjid = 1
 WHERE usrgrpobjid = 3;
DELETE harUserGroup
 WHERE usrgrpobjid = 3;

UPDATE harusergroup
   SET usergroupname = 'Public'
 WHERE usrgrpobjid = 2;
--
-- Convert syntax for Windows list-type system variable workaround
--
UPDATE harUDP
SET programname = REPLACE(programname, '"[package]"', '["package"]')
WHERE programname LIKE '%"[package]"%';

UPDATE harUDP
SET programname = REPLACE(programname, '"[file]"', '["file"]')
WHERE programname LIKE '%"[file]"%';

UPDATE harUDP
SET programname = REPLACE(programname, '"[version]"', '["version"]')
WHERE programname LIKE '%"[version]"%';
--
--  Checkout path option values now start at 1
--
UPDATE harCheckoutProc
   SET pathoption = pathoption + 1
 WHERE pathoption < 3;
