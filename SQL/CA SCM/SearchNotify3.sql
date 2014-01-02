SET NEWPAGE 0
SET SPACE 0
SET LINESIZE 132
SET PAGESIZE 0
SET ECHO OFF
SET FEEDBACK ON
SET HEADING ON
SET MARKUP HTML ON
SET ESCAPE \
SPOOL logs/SearchNotify.html
PROMPT [************************************************]
PROMPT [This is the SQL we will run****************************]
PROMPT [************************************************]
SET ECHO ON
select  haruser.realname "USER NAME", 
        harlinkedprocess.processname "PROCESS NAME" 
from    haruser, harlinkedprocess, harnotifylist
where   haruser.usrobjid           =   harnotifylist.usrobjid and
        harlinkedprocess.PARENTPROCOBJID = harnotifylist.PARENTPROCOBJID
order by haruser.realname;
SET ECHO OFF
PROMPT [************************************************]
PROMPT [The report can be found under the logs directory************]
PROMPT [***in a file named SearchNotify.html*******************]
PROMPT [************************************************]
spool off
exit