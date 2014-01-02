/*
 *   UpdateFileExt.sql
 *
 *   Modify Repository Text File Extensions
 *      according to version data text file settings
 */
WHENEVER SQLERROR exit failure
spool &1

DEFINE HARVESTINDEXTSNAME = &2

/*
 *  Create temporary indices
 *  Ignore errors in case indices already exist.
 */
WHENEVER SQLERROR continue

CREATE INDEX harConvVerData_Item_Idx
ON harVersionData (itemobjid, textfile)  
TABLESPACE &HARVESTINDEXTSNAME;

CREATE UNIQUE INDEX harConvItems_Rep_Idx 
ON harItems (repositobjid, itemobjid )
TABLESPACE &HARVESTINDEXTSNAME;

WHENEVER SQLERROR exit failure
/*
 * Create view: Extensions of files marked as text
 */
CREATE OR REPLACE VIEW harconvtextview (repositobjid, ext)
AS
   SELECT UNIQUE i.repositobjid,
   UPPER (SUBSTR (i.itemname, INSTR (i.itemname, '.', -1) + 1)) ext
     FROM haritems i, harversiondata d
    WHERE i.itemtype = 1
      AND INSTR (i.itemname, '.', -1) > 0
      AND d.itemobjid = i.itemobjid
      AND d.textfile = 1;
/*
 * Create view: Extensions of files marked as binary
 */
CREATE OR REPLACE VIEW harconvbextview (repositobjid, ext)
AS
   SELECT UNIQUE i.repositobjid,
   UPPER (SUBSTR (i.itemname, INSTR (i.itemname, '.', -1) + 1)) ext
     FROM haritems i, harversiondata d
    WHERE i.itemtype = 1
      AND INSTR (i.itemname, '.', -1) > 0
      AND d.itemobjid = i.itemobjid
      AND d.textfile = 0;
/*
 * Report extensions marked as both text and binary.
 * No action for these.
 */
set linesize 1000
column Repository format a44
column ext heading 'Extensions identified as both text and binary'
column ext format a64

SELECT r.repositname AS Repository,
       t.ext  
FROM harrepository r, harconvtextview t, harconvbextview b
 WHERE t.repositobjid = b.repositobjid
   AND t.ext = b.ext
   AND t.repositobjid = r.repositobjid;
/*
 * Report extensions marked binary only
 */
column fileextension heading "Extensions identified as binary only" 
column fileextension format a64

SELECT r.repositname AS Repository,
       f.fileextension 
FROM harrepository r, harfileextension f 
WHERE r.repositobjid = f.repositobjid
   AND EXISTS (SELECT b.repositobjid, b.ext
                 FROM harconvbextview b
                WHERE b.repositobjid = f.repositobjid
                  AND b.ext = RTRIM( f.fileextension))
   AND NOT EXISTS (SELECT t.repositobjid, t.ext
                     FROM harconvtextview t
                    WHERE t.repositobjid = f.repositobjid
                      AND t.ext = RTRIM( f.fileextension));
/*
 * Report extensions marked text only
 */
column ext heading "Extensions identified as text only"
column ext format a64

SELECT r.repositname AS Repository,
       t.ext   
FROM harrepository r, harconvtextview t
 WHERE t.repositobjid = r.repositobjid
   AND NOT EXISTS (SELECT b.repositobjid
                     FROM harconvbextview b
                    WHERE b.repositobjid = t.repositobjid
                      AND b.ext = t.ext)
   AND NOT EXISTS (SELECT f.repositobjid                     
                   FROM harfileextension f
                    WHERE f.repositobjid = t.repositobjid
                      AND RTRIM( f.fileextension) = t.ext);

PAUSE Press [return] to modify repository text file extensions.
/*
 * Remove extensions marked binary only
 */
DELETE harfileextension f
 WHERE EXISTS (SELECT b.repositobjid, b.ext
                 FROM harconvbextview b
                WHERE b.repositobjid = f.repositobjid
                  AND b.ext = RTRIM( f.fileextension))
   AND NOT EXISTS (SELECT t.repositobjid, t.ext
                     FROM harconvtextview t
                    WHERE t.repositobjid = f.repositobjid
                      AND t.ext = RTRIM( f.fileextension));
/*
 * Add extensions marked text only
 */
INSERT INTO harfileextension
            (repositobjid, fileextension)
   SELECT t.repositobjid, t.ext
     FROM harconvtextview t
    WHERE (NOT EXISTS (SELECT b.repositobjid
                        FROM harconvbextview b
                       WHERE b.repositobjid = t.repositobjid
                         AND b.ext = t.ext))
      AND (NOT EXISTS (SELECT f.repositobjid
                        FROM harfileextension f
                       WHERE f.repositobjid = t.repositobjid
                         AND RTRIM( f.fileextension) = t.ext));
/*
 * Drop temporary indices
 */
DROP INDEX harConvVerData_Item_Idx;
DROP INDEX harConvItems_Rep_Idx;

PAUSE Press [return] to commit changes.
COMMIT;

PROMPT UpdateFileExt.sql ran successfully.

SPOOL off
EXIT






