spool c:\report\harUsersReport.out
SELECT count("TESCOCM"."HARUSER"."USROBJID")
    FROM "TESCOCM"."HARUSER";
spool off
exit