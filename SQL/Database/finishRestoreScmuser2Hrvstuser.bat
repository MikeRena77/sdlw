@echo off

REM pause Database restoration CA SCM r12

REM
REM
REM
REM This script is used to restore a CA SCM database.
REM The CA SCM database must have already been exported to a dump file.

REM
REM Inform user to apply latest Harvest PATCH and prompt to confirm before continuing
REM

echo .
echo You must apply the latest CA SCM patch before running conversion.
echo The latest patches can be obtained at http://esupport.ca.com
echo Please note that the order in which these are applied is important.
echo The latest CA SCM product patch must be applied AFTER installing Conversion.
echo .
echo Do you want to continue with recovery?
echo .
echo Type CTRL+C and then Y to STOP or,
echo .
pause
echo .

REM --------------------------------------------------------------------------------------------------------------
REM ------------------------------->>>>>> Set the following variables <<<<<<--------------------------------------
REM --------------------------------------------------------------------------------------------------------------

echo REM --- Edit the following variables to suit recovery environment ---

set HAR_NAME=harvest
set HAR_PASS=harvest
set DBA_NAME=SYSTEM
set DBA_PASS=harvest
set DUMPED_FILE=scmuserexp.dmp
set DUMPED_USER=scmuser
set DataSrc=HARVEST


echo REM --- Define the names of the CA SCM Tablespaces --------
REM --- Do not change the default names of the CA SCM tablespaces.
set HARVESTMETATSNAME=HARVESTMETA
set HARVESTBLOBTSNAME=HARVESTBLOB
set HARVESTINDEXTSNAME=HARVESTINDEX

echo REM --- Define the names of the CA SCM Tablespaces Filenames for Oracle--------
set HARVESTMETAFILE=c:\harvestTables\SCMMETAFILE.ora
set HARVESTBLOBFILE=c:\harvestTables\SCMBLOBFILE.ora
set HARVESTINDEXFILE=c:\harvestTables\SCMINDEXFILE.ora

echo REM --- Define the size of the CA SCM Tablespaces in MB --------
set HARVESTMETAFILESIZE=75
set HARVESTBLOBFILESIZE=2000
set HARVESTINDEXFILESIZE=75


echo REM Tablespaces where user will be given unlimited quota
set temp_tbs=TEMP
set rb_tbs=UNDOTBS1

echo REM Storage parameters
set BlobInitExtent=2000
set BlobNextExtent=2000
set BlobIndxInitExtent=175
set BlobIndxNextExtent=175

REM --------------------------------------------------------------------------------------------------------------
REM --------------------------------->>>>>> End of variables settings <<<<<<--------------------------------------
REM --------------------------------------------------------------------------------------------------------------


echo *** Run crtblspc.sql to create table spaces (Will fail if already created)
sqlplus %DBA_NAME%/%DBA_PASS% @crtblspc.sql %HARVESTMETATSNAME% %HARVESTBLOBTSNAME% %HARVESTINDEXTSNAME% %HARVESTMETAFILE% %HARVESTBLOBFILE% %HARVESTINDEXFILE% %HARVESTMETAFILESIZE% %HARVESTBLOBFILESIZE% %HARVESTINDEXFILESIZE% crtblspc.log

pause

echo Set default MAXEXTENTS to UNLIMITED
sqlplus %DBA_NAME%/%DBA_PASS% @Altblspc.sql %HARVESTMETATSNAME% %HARVESTBLOBTSNAME% %HARVESTINDEXTSNAME% Altblspc.log

pause

echo Drop CA SCM user if it exists
sqlplus %DBA_NAME%/%DBA_PASS% @DropUser.sql %HAR_NAME% DropUser.log

pause

echo Create CA SCM user with quotas in CA SCM tablespaces
sqlplus %DBA_NAME%/%DBA_PASS% @creatusr.sql %HAR_NAME% %HAR_PASS% %HARVESTMETATSNAME% %HARVESTBLOBTSNAME% %HARVESTINDEXTSNAME% %temp_tbs% %rb_tbs% creatusr.log
if errorlevel 1 goto END

pause

echo Import old dump
rem imp %HAR_NAME%/%HAR_PASS% FROMUSER=%DUMPED_USER% TOUSER=%HAR_NAME% GRANTS=Y COMMIT=Y INDEXES=N file=%DUMPED_FILE% log=import.log
imp %HAR_NAME%/%HAR_PASS% FROMUSER=%DUMPED_USER% TOUSER=%HAR_NAME% GRANTS=Y COMMIT=Y INDEXES=N file=%DUMPED_FILE% log=import.log
if errorlevel 1 goto END


pause (finishRestoreScmuser.bat) succeeded. To complete conversion, edit and execute FinalCln.bat.
exit
:END
pause (finishRestoreScmuser.bat) failed. See SCM documentation for help on troubleshooting.

