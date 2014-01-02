spool c:\report\harVersionsReport.out
SELECT count("TESCOCM"."HARVERSIONS"."VERSIONOBJID")
    FROM "TESCOCM"."HARVERSIONS";
spool off
exit