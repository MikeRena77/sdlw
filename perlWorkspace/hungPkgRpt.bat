if exist hungPackageReportSummary.htm del /f /q hungPackageReportSummary.htm
if not exist prodswaPkgHungReport.sql echo "The required SQL script is missing" && exit
sqlplus hrvstuser/har2vest@HARVEST2_PRODDBS1 @prodswaPkgHungReport.sql
copy hungPackageReportSummary.htm logs\hungPackageReportSummary_%date:~10,4%-%date:~4,2%-%date:~7,2%.htm