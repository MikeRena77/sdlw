--
--  Output Harvest version indicator
--
-- Harvest 4 has versionindicator = 40000
-- Harvest 5 has versionindicator = 50000
--
WHENEVER SQLERROR EXIT FAILURE

SET document off
SET feedback off
SET timing off
SET verify off
SET heading off
SET echo off
ttitle off
btitle off

spool &1

SELECT versionindicator
FROM harTableInfo;

spool off
exit
