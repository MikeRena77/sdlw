@Echo off

REM
REM Name: PatchMDB.bat 
REM
REM Description:	Patch an MDB instance in SQLServer
REM 
REM Syntax:
REM
REM 	PatchMDB [-DBMS_INSTANCE=xxxx] [-MDB_NAME=xxxx] -MDB_PATCH=xxxx [-MDB_TARGET_DIR=<dir>] [-debug] [-?]
REM
REM History:
REM	17-oct-2005 mulwi01
REM	    Created
REM	29-nov-2005	mulwi01		generate signature
REM	19-jan-2005	ricle02		Star 14599933 PATCH COLLATION HANDLING
REM	11-mar-2006	mulwi01		Star 14712269 OSQL USAGE - DASH VALUE
REM     18-aug-2006     rigka01         Star 15148450, MDB21, Add more logging 
REM     4-dec-2006      todjo06         Star 15277870 Authentication change
REM     12-mar-2007     todjo06         Star 15215592 Using full path (UNC)
REM     12-mar-2007     todjo06         Star 15546020 Return 0 on reapply
REM     26-Apr-2007     todjo06         Star 15914385 DBPORT parameter
REM     27-Apr-2007     todjo06         Star 15918155 Signature problem
REM


REM
REM Start localization of environment variables in a batch file
REM
SETLOCAL

echo %date% %time% Started PatchMDB
set PATCHMDB_COMMAND=%~f0 %*
REM 15215592 - use full path of PatchMDB to find other
REM   batch files and executables.
set PATCHMDB_PATH=%~dp0%
set PATCHMDB_VERSION=15
echo %date% %time% PatchMDB version: %PATCHMDB_VERSION%
echo %date% %time% PatchMDB command: %PATCHMDB_COMMAND%


REM set DEBUGECHO=@ECHO on
set DEBUGECHO=@ECHO off
%DEBUGECHO%

for /f "delims=," %%a in ('chdir') do set CURDIR=%%a

REM
REM Set the default parameters
REM
set MDB_ADMIN=mdbadmin
set MDB_NAME=mdb
set DBMS_INSTANCE=
set MDB_TARGET_DIR=%PATCHMDB_PATH%
set AUTHENTICATION_TYPE=WIN
set DBUSER=
set DBPASSWORD=
set AUTH_STRING=
set INSTANCE_ARG=
set DBPORT=
set HASPORT=0
set HASINSTANCE=0

set MDB_RC=2
set ERR_MESSAGE=Patch MDB error

REM
REM Parse the command line parameters
REM

:PARSE_ARGS

IF "%~1"==""   GOTO NO_MORE_ARGS
IF "%~1"=="-?" GOTO USAGE

IF NOT "%~1"=="-DBMS_INSTANCE" GOTO NEXT_ARG1
SHIFT
if "%~1"=="local" goto DBMS_INSTANCE_LOCAL
set HASINSTANCE=1
set INSTANCE_ARG=%~1
set DBMS_INSTANCE=-S "%~1"
set DBMS_INSTANCE_PATCH=-DBMS_INSTANCE="%~1"
:DBMS_INSTANCE_LOCAL
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG1
IF NOT "%~1"=="-MDB_PATCH" GOTO NEXT_ARG2
SHIFT
set MDB_PATCH=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG2
IF NOT "%~1"=="-MDB_NAME" GOTO NEXT_ARG3
SHIFT
set MDB_NAME=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG3
IF NOT "%~1"=="-MDB_TARGET_DIR" GOTO NEXT_ARG4
SHIFT
set MDB_TARGET_DIR=%~1
IF EXIST "%MDB_TARGET_DIR%" GOTO TARGET_DIR_EXIST
echo %date% %time% Error: MDB_TARGET_DIR does not exist: "%MDB_TARGET_DIR%" 
GOTO USAGE
:TARGET_DIR_EXIST
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG4

IF /i NOT "%~1"=="-debug" GOTO NEXT_ARG5 
set DEBUGECHO=@ECHO 
%DEBUGECHO%
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG5
IF NOT "%~1"=="-DBUSER" GOTO NEXT_ARG6
SHIFT
set DBUSER=%~1
set AUTHENTICATION_TYPE=SQL
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG6
IF NOT "%~1"=="-DBPASSWORD" GOTO NEXT_ARG7
SHIFT
set DBPASSWORD=%~1
set AUTHENTICATION_TYPE=SQL
SHIFT
GOTO PARSE_ARGS

REM STAR 15914385 - allow port number as a separate parameter

:NEXT_ARG7
IF NOT "%~1"=="-DBPORT" GOTO INVALID_ARG
SHIFT
set HASPORT=1
set DBPORT=%~1
SHIFT
GOTO PARSE_ARGS

:INVALID_ARG
echo %date% %time% Usage: Invalid PatchMDB argument "%~1"
GOTO USAGE

:NO_MORE_ARGS

if NOT "%AUTHENTICATION_TYPE%"=="WIN" GOTO SQL_AUTH
set AUTH_STRING=-E
GOTO AUTH_DONE

:SQL_AUTH

IF "%DBUSER%"=="" GOTO AUTH_ERR
IF "%DBPASSWORD%"=="" GOTO AUTH_ERR

set AUTH_STRING=-U "%DBUSER%" -P "%DBPASSWORD%"
GOTO AUTH_DONE

:AUTH_ERR
echo %date% %time% missing argument to use sql server authentication.
goto USAGE

:AUTH_DONE

if (%HASPORT%) EQU (0) GOTO NO_PORT_NUM
if (%HASINSTANCE%) EQU (1) GOTO HAS_INSTANCE
set ERR_MESSAGE=Error: Port number must be accompanied by DBMS_INSTANCE designation
echo %date% %time% %ERR_MESSAGE%
GOTO USAGE

:HAS_INSTANCE
set DBMS_INSTANCE=-S "%INSTANCE_ARG%,%DBPORT%"
set DBMS_INSTANCE_PATCH=-DBMS_INSTANCE "%INSTANCE_ARG%,%DBPORT%"

:NO_PORT_NUM


IF NOT "%MDB_PATCH%" == "" GOTO MDBPATCH_FOUND
set ERR_MESSAGE=Missing MDB_PATCH argument
echo %date% %time% %ERR_MESSAGE%
GOTO USAGE
:MDBPATCH_FOUND



rem
rem check if SQLServer is available
rem
sqlcmd -? > nul 2>&1
IF %ERRORLEVEL% NEQ 9009 (
	set SQL_CMD=sqlcmd
	GOTO OSQL_FOUND
)
osql -? > nul 2>&1
IF %ERRORLEVEL% NEQ 9009 (
	set SQL_CMD=osql
	GOTO OSQL_FOUND
)
set ERR_MESSAGE=cannot find osql or sqlcmd. Check that SQLServer has been installed and in the PATH
echo %date% %time% %ERR_MESSAGE%
GOTO DONE_ERROR
:OSQL_FOUND

set PATCH_PREFIX=%PATCHMDB_PATH%patches\p
set PATCH_MANIFEST="%PATCH_PREFIX%%MDB_PATCH%.txt"
IF EXIST %PATCH_MANIFEST% GOTO MANI_EXISTS
set ERR_MESSAGE=Error: missing patch manifest %PATCH_MANIFEST%
echo %date% %time% %ERR_MESSAGE%
GOTO DONE_ERROR
:MANI_EXISTS




REM
REM Set the patch log file
REM
IF (%LOGFILE%) == () set LOGFILE="%MDB_TARGET_DIR%\install_%MDB_NAME%.log"
echo . >> %LOGFILE% 2>&1
echo . >> %LOGFILE% 2>&1
echo . >> %LOGFILE% 2>&1
echo %date% %time% PatchMDB mdb log file for %MDB_PATCH% in %LOGFILE%
echo %date% %time% ====================================================================== >> %LOGFILE% 2>&1
echo %date% %time% PatchMDB mdb log file for %MDB_PATCH% in %LOGFILE% >> %LOGFILE% 2>&1

REM 
REM Log the full PatchMDB version command
REM
echo %date% %time% PatchMDB version: %PATCHMDB_VERSION% >> %LOGFILE% 2>&1
echo %date% %time% PatchMDB command: %PATCHMDB_COMMAND% >> %LOGFILE% 2>&1

chdir /D "%MDB_TARGET_DIR%" >> %LOGFILE% 2>&1

REM
REM check if mdb already exists
REM
echo %date% %time% Checking if %MDB_NAME% already exists...
echo %date% %time% Checking if %MDB_NAME% already exists... >>%LOGFILE% 2>&1
echo %date% %time%>> %LOGFILE%
echo %date% %time% %SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d master -e -b -Q "exit(SELECT count(*) FROM master..sysdatabases WHERE name = '%MDB_NAME%')"    >>%LOGFILE% 2>&1
%SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d master -e -b -Q "exit(SELECT count(*) FROM master..sysdatabases WHERE name = '%MDB_NAME%')"    >>%LOGFILE% 2>&1
IF %ERRORLEVEL% NEQ 0 GOTO MDB_FOUND
set ERR_MESSAGE=Error: database %MDB_NAME% does not exist
GOTO ERROR_MESSAGE
:MDB_FOUND




REM
REM Check that the mdb version matches the patch requirement
REM
echo %date% %time% Checking the mdb version
echo %date% %time% Checking the mdb version >> %LOGFILE% 2>&1

FOR /F "eol=- tokens=1,2 delims=, usebackq" %%i in (%PATCH_MANIFEST%) do IF %MDB_PATCH% EQU %%i set PATCH_BUILD=%%j

echo %SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d %MDB_NAME% -e -b -Q "exit(select buildnumber from mdb)"    >>%LOGFILE% 2>&1
%SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d %MDB_NAME% -e -b -Q "exit(select buildnumber from mdb)"    >>%LOGFILE% 2>&1
set MDB_BUILD=%ERRORLEVEL%

if (%MDB_BUILD%) == (%PATCH_BUILD%) GOTO BUILD_EXIST
set ERR_MESSAGE=Error: database %MDB_NAME% contains build %MDB_BUILD% but patch requires build %PATCH_BUILD%
GOTO ERROR_MESSAGE
:BUILD_EXIST




REM
REM Check if the patch already exists
REM
echo %date% %time% Checking if the patch already exists 
echo %date% %time% Checking if the patch already exists >> %LOGFILE%
echo %SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d %MDB_NAME% -e -b -Q "exit(select count(*) from mdb_patch where patchnumber = %MDB_PATCH%)" >>%LOGFILE% 2>&1
%SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d %MDB_NAME% -e -b -Q "exit(select count(*) from mdb_patch where patchnumber = %MDB_PATCH%)" >>%LOGFILE% 2>&1
IF %ERRORLEVEL% EQU 0 GOTO PATCH_NOT_EXIST
set ERR_MESSAGE=Database %MDB_NAME% already contains patch %MDB_PATCH%
echo %date% %time% %ERR_MESSAGE%
echo %date% %time% %ERR_MESSAGE% >> %LOGFILE% 2>&1
GOTO DONE
:PATCH_NOT_EXIST




REM
REM Installing patch
REM
set MDB_RC_FILE=mdbpatcherr.txt
IF EXIST "%MDB_RC_FILE%" del "%MDB_RC_FILE%"
echo %date% %time% Installing the patch from the manifest...
echo %date% %time% Installing the patch from the manifest... >> %LOGFILE%
REM Star 14599933
FOR /F "eol=- tokens=1,2,3,4,5,6 delims=, usebackq" %%i in (%PATCH_MANIFEST%) do call "%PATCHMDB_PATH%\installmdbpatchsql" %MDB_NAME% "%PATCH_PREFIX%%%i.sql" %%i %%k



REM
REM Check that the patch was installed
REM
%SQL_CMD% %AUTH_STRING% %DBMS_INSTANCE% -d %MDB_NAME% -e -b -Q "exit(select count(*) from mdb_patch where patchnumber = %MDB_PATCH%)" >>%LOGFILE% 2>&1
IF %ERRORLEVEL% NEQ 0 GOTO PATCH_OK
set ERR_MESSAGE=Error, Patch %MDB_PATCH% failed on database %MDB_NAME% 
GOTO ERROR_MESSAGE
:PATCH_OK



REM
REM Create the mdb signature for asset/patch management
REM

REM 15918155 - do not send DBUSER and DBPASSWORD to CreateMDBSignature if
REM  they are not being used

if "%AUTHENTICATION_TYPE%"=="WIN" GOTO CREATE_WIN_SIG

call CreateMDBSignature %DBMS_INSTANCE_PATCH% -MDB_NAME=%MDB_NAME% -DBUSER=%DBUSER% -DBPASSWORD=%DBPASSWORD%	>>%LOGFILE% 2>&1
GOTO COMPLETED

:CREATE_WIN_SIG

call CreateMDBSignature %DBMS_INSTANCE_PATCH% -MDB_NAME=%MDB_NAME% >>%LOGFILE% 2>&1
	

:COMPLETED
echo %date% %time% 
echo %date% %time% >> %LOGFILE%
echo %date% %time% Patch %MDB_PATCH% installed in database %MDB_NAME%
echo %date% %time% Patch %MDB_PATCH% installed in database %MDB_NAME% >> %LOGFILE%
echo %date% %time% 
echo %date% %time% >> %LOGFILE%
GOTO DONE




:USAGE
echo %date% %time% 
echo %date% %time% Usage: PatchMDB [-DBMS_INSTANCE=xxxx] [-MDB_NAME=xxxx] -MDB_PATCH=xxxx [-MDB_TARGET_DIR=dir] [-debug] [-?] [-DBUSER=xxxx] [-DBPASSWORD=xxxx] [-DBPORT=xxxx]
echo %date% %time%
echo %date% %time%      where: 
echo %date% %time%
echo %date% %time%        DBMS_INSTANCE     server name or local (optional with default local)
echo %date% %time%        MDB_NAME          database name        (optional with default mdb)
echo %date% %time%        MDB_PATCH         patch number         (required)
echo %date% %time%        MDB_TARGET_DIR    target mdb directory (optional with default current directory)
echo %date% %time%        -debug            echo output
echo %date% %time%        DBUSER            sql server user
echo %date% %time%        DBPASSWORD        password for sql server user
echo %date% %time%        DBPORT            port number of server to connect to
echo %date% %time%

endlocal
echo %date% %time% Usage error rc=99 
EXIT /B 99


:ERROR_MESSAGE
echo %date% %time% %ERR_MESSAGE%
echo %date% %time% %ERR_MESSAGE% >> %LOGFILE% 2>&1
echo %date% %time% Error rc=1 >> %LOGFILE% 2>&1
GOTO DONE_ERROR


:DONE_ERROR
echo %date% %time% Setting directory back to "%CURDIR%" 
chdir /D "%CURDIR%" 
echo %date% %time% Error rc=1 
endlocal
EXIT /B 1

:DONE
echo %date% %time% Setting directory back to "%CURDIR%" >> %LOGFILE% 2>&1
chdir /D "%CURDIR%" >> %LOGFILE% 2>&1
echo %date% %time% Successful rc=0 
echo %date% %time% Successful rc=0 >> %LOGFILE% 2>&1
endlocal
EXIT /B 0

