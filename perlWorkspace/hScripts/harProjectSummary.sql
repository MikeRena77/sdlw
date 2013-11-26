SET NEWPAGE 0
SET SPACE 0
SET LINESIZE 132
SET PAGESIZE 0
SET ECHO OFF
SET FEEDBACK ON
SET HEADING ON
SET MARKUP HTML ON
SET ESCAPE \
SPOOL log/harProjectSummary.html
PROMPT [************************************************]
PROMPT [This is the SQL we will run****************************]
PROMPT [************************************************]
set ECHO ON
SELECT  environmentname, envisactive, creationtime, modifiedtime
FROM    harenvironment
WHERE   harenvironment.environmentname IS LIKE '%HR%'
ORDER BY harenvironment.environmentname;
SET ECHO OFF
PROMPT [************************************************]
PROMPT [The report can be found under the log directory************]
PROMPT [***in a file named itemAccessCount.html*******************]
PROMPT [************************************************]
spool off
exit