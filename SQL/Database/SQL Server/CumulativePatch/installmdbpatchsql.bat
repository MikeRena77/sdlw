REM
REM Name: InstallMDBPatchSQL.bat 
REM
REM Description:	Patch an MDB instance on SQLServer 
REM 
REM Syntax:
REM
REM 	InstallMDBPatchSQL [dbname] [patch file] [patch number]
REM
REM History:
REM	17-oct-2005 mulwi01
REM	    Created
REM	12-dec-2005	mulwi01		Star 14539001 CUMULATIVE PATCH INSTALL HANGS
REM	19-jan-2005	ricle02		Star 14599933 PATCH COLLATION HANDLING
REM	20-sep-2006	rigka01		Star 15251588 PATCH COLLATE MISMATCH BETWEEN SERVER AND DATABASE
REM	07-nov-2006	rigka01		Star 15377965 MDB 30 PATCH INSTALL ON SQL SERVER EXPRESS OR WHEN AUTO CLOSE IS ON FAILS PREMATURELY
REM 	17-nov-2006 	rigka01		Star 15441161 MDB 30 fails for SQL Server Express
REM     12-mar-2007     todjo06         Star 15215592 using UNC path 
REM     24-Apr-2007     todjo06         Star 15832202 and 15823162 adjustments
REM     

set PATCH_PATH=%~dp0%

IF NOT EXIST %LOGFILE% set LOGFILE=install_%1.log

REM Star 14599933
set MDB_PATCH_FILE=%2
set MDB_PATCH_TEMP=%MDB_PATCH_FILE%_tmp

set MDB_RC_FILE=mdbpatcherr.txt
IF EXIST "%MDB_RC_FILE%" GOTO DONE_SKIP_ERROR



REM
REM Check if the patch already exists
REM
echo %date% %time% Checking if the patch already exists 
echo %date% %time% Checking if the patch already exists >> %LOGFILE%
%SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d %1 -e -b -Q "exit(select count(*) from mdb_patch where patchnumber = %3)" >>%LOGFILE% 2>&1
IF %ERRORLEVEL% EQU 1 GOTO PATCH_EXISTS



echo %date% %time% Installing patch %3 in database %1  
echo %date% %time% Installing patch %3 in database %1  >> %LOGFILE%

REM Star 14599933
if "%4"=="setcollation" goto DO_SETCOLL
goto DO_PATCHMDB

:DO_SETCOLL
echo %date% %time% Getting collation from database
echo %date% %time% Getting collation from database  >> %LOGFILE%

REM 15823162 - use -h-1, not -h -1

IF %SQL_CMD% EQU sqlcmd (
REM 	echo %SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -h-1 -s. -b /Q  "Use %1; select convert(varchar(30), databasepropertyex('%1', 'collation'))" > collation.txt
	%SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -h-1 -s. -b /Q  "Use %1; select convert(varchar(30), databasepropertyex('%1', 'collation'))" > collation.txt
) ELSE (
REM 	echo %SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -h-1 -s. -n -b /Q  "Use %1; select convert(varchar(30), databasepropertyex('%1', 'collation'))" > collation.txt
	%SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -h-1 -s. -n -b /Q  "Use %1; select convert(varchar(30), databasepropertyex('%1', 'collation'))" > collation.txt
)
IF %ERRORLEVEL% EQU 0 GOTO DB_COLLATION
echo %date% %time% Failed to determine the collation (errorlevel=%ERRORLEVEL%)
echo %date% %time% Failed to determine the collation (errorlevel=%ERRORLEVEL%) >> %LOGFILE%
GOTO DONE_ERROR

:DB_COLLATION
if exist %MDB_PATCH_TEMP% del %MDB_PATCH_TEMP%
copy %MDB_PATCH_FILE% %MDB_PATCH_TEMP%
set MDB_PATCH_FILE=%MDB_PATCH_TEMP%

echo %date% %time% Collation.txt start >>%LOGFILE%
type collation.txt >> %LOGFILE% 
echo %date% %time% Collation.txt end >>%LOGFILE%

IF %SQL_CMD% EQU sqlcmd (
"%PATCH_PATH%\LoadMDBUtil" -collation %MDB_PATCH_FILE% collation.txt 2
) ELSE (
"%PATCH_PATH%\LoadMDBUtil" -collation %MDB_PATCH_FILE% collation.txt 1
)

if exist collation.txt del collation.txt

REM Do not use -b option otherwise some worldview patches might fail.

:DO_PATCHMDB
%SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d %1 -e -i %MDB_PATCH_FILE% >>%LOGFILE% 2>&1
if %ERRORLEVEL% EQU 0 GOTO DONE
echo %date% %time% ***Error installing patch %3 in database %1 
echo %date% %time% ***Error installing patch %3 in database %1 >> %LOGFILE%
GOTO DONE_ERROR


:PATCH_EXISTS
echo %date% %time% Warning patch %3 already exists in database %1 
echo %date% %time% Warning patch %3 already exists in database %1 >> %LOGFILE%
GOTO DONE

:DONE
if exist %MDB_PATCH_TEMP% del %MDB_PATCH_TEMP%
exit /B 0

:DONE_ERROR
IF NOT EXIST "%MDB_RC_FILE%" echo %date% %time% ***Error installing patch script %3 in database %1 >> "%MDB_RC_FILE%"
exit /B 1

:DONE_SKIP_ERROR
echo %date% %time% Patch %3 was not installed in database %1 because of a previous error >> %LOGFILE%
exit /B 1
