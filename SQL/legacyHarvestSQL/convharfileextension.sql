/*
 * convharfileextension.sql
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
PROMPT
PROMPT Please enter extension generation option 0, 1, or 2
PROMPT  0 : Only list current cross-platform extensions
PROMPT  1 : Generate a global extension list
PROMPT  2 : Generate a list of extensions in each repository
ACCEPT extoption NUMBER FORMAT '9' PROMPT 'Extension option> '

spool convharfileextension.log
-- DEFINE extoption = &1

WHENEVER SQLERROR Continue
DROP TABLE ConvHarFileExtension;

WHENEVER SQLERROR EXIT FAILURE
CREATE TABLE ConvHarFileExtension (repositobjid number NOT NULL, 
                                   repositname char(44) NOT NULL, 
                                   fileextension char(64) NOT NULL, 
                                   NOTE char(32) NULL);

INSERT INTO convharfileextension
            (repositobjid, repositname, fileextension, note)
   SELECT DISTINCT DECODE (&extoption, 1, 0, r.repositobjid),
                   DECODE (&extoption, 1, '<Global Repository>', r.repositname),
                   e.fileextension, '<Cross-Platform Text>'
     FROM harfileextension e, harrepository r
    WHERE e.repositobjid = r.repositobjid;

-- insert the list of all the file extensions we can find, per repository
INSERT INTO convharfileextension
            (repositobjid, repositname, fileextension)
   SELECT DISTINCT r.repositobjid, RTRIM( r.repositname),
                   DECODE (
                      INSTR (i.itemname, '.', -1, 1),
                      0, '<NONE>',
                      LENGTH(i.itemname), '<NONE>', 
                      UPPER (
                         SUBSTR (i.itemname, INSTR (i.itemname, '.', -1, 1) + 1)
                      )
                   )
     FROM harrepository r, haritem i
    WHERE &extoption = 2
      AND i.repositobjid = r.repositobjid
   MINUS
   SELECT repositobjid, RTRIM(repositname), RTRIM(fileextension)
     FROM convharfileextension;

-- insert the list of all the file extensions we can find, globally for the global list
INSERT INTO convharfileextension
            (repositobjid, repositname, fileextension)
   SELECT DISTINCT 0, '<Global Repository>',
                   DECODE (
                      INSTR (i.itemname, '.', -1, 1),
                      0, '<NONE>', 
                      LENGTH(i.itemname), '<NONE>', 
                      UPPER (
                         SUBSTR (i.itemname, INSTR (i.itemname, '.', -1, 1) + 1)
                      )
                   )
     FROM haritem i
    WHERE &extoption = 1
   MINUS
   SELECT repositobjid, RTRIM(repositname), RTRIM(fileextension)
     FROM convharfileextension;

SPOOL off;

-- generate a text data file that will be edited and reloaded
SET pagesize 0
SET trimspool on
SET termout off
SET heading off
SET headsep off
SET recsep off
SET verify off
SET feedback off
COLUMN repositname noprint
COLUMN fileextension noprint
SPOOL convharfileextension.dat
SELECT repositname, fileextension,
       repositobjid || CHR (9) || RTRIM (repositname) || CHR (9) ||
          RTRIM (fileextension) ||
          CHR (9) ||
          note
  FROM convharfileextension
 ORDER BY 1, 2;
SPOOL off;

-- Do not commit changes - user needs to edit list first.
ROLLBACK;

EXIT;

