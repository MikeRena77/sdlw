-- copyglobalext.sql - Tom Cameron
-- script for Harvest 5.x to copy the Global file extensions to a specific repository
-- Instructions:
-- run using sqlplus as the owner of the Harvest tables, providing the repository name as an argument:
-- sqlplus harvest5/harvest @copyglobalext 'Rep Name'

WHENEVER SQLERROR EXIT FAILURE
set verify on
set feedback on

DECLARE
   rname  harrepository.repositname%TYPE := '&1';
   repid  harfileextension.repositobjid%TYPE;
BEGIN
   SELECT repositobjid
     INTO repid
     FROM harrepository
    WHERE repositname = rname;
   INSERT INTO harfileextension
     select repid, G.fileextension
     from harfileextension G
     where G.repositobjid = 0
       and G.fileextension not in (select M.fileextension from harfileextension M where M.repositobjid = repid);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20000, 'Repository not found');
END;
/
commit;

