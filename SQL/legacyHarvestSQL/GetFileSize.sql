--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
SPOOL &1

SET document ON
set feedback on
set timing off
set verify off
SET heading ON
 
SELECT SUM( TO_NUMBER( VERSIONFILESIZE, '999999999999999999999999') ) AS 
total_file_size 
FROM harVersion
WHERE VERSIONFILESIZE IS NOT NULL AND VERSIONFILESIZE <> ' ';

spool off

EXIT