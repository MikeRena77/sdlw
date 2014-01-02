echo off

REM ###################################################################
REM 
REM Specify the following information for your site. 
REM      
REM      HAR_NAME     - the Oracle user that owns the AllFusion Harvest CM tables.
REM      HAR_PASS     - the Oracle user's password.
REM	 PERCENT      - Percentage of rows to estimate.
REM	 CASCADE      - Gather statistics on the indexes as well. 
REM
REM	 note: SORT_AREA_SIZE affects generation performance.
REM            For more information, see ALTER SESSION SET SORT_AREA_SIZE
REM            in your Oracle documentation.  
REM ###################################################################

set HAR_NAME=HARVEST
set HAR_PASS=HARVEST
set PERCENT=100
set CASCADE=TRUE


ECHO -----------------------------------------------------------------------     
ECHO ORAMaint.bat is running Oracle DBMS_STATS package to update Statistics.
ECHO This may take a while. Please wait...
ECHO -----------------------------------------------------------------------     


REM *** OPTIMIZE ORACLE DATABASE SCHEMA
sqlplus %HAR_NAME%/%HAR_PASS% @optimize.sql %HAR_NAME% %PERCENT% %CASCADE% optimize.log

echo DB Optimization is Complete


