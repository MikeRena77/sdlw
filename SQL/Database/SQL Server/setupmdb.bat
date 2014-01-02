@Echo off

REM Name: setupmdb.bat 
REM
REM Description: 
REM		creates the mdb on SQLServer
REM 
REM Syntax:
REM
REM 	setupmdb [-DBMS_TYPE={ingres},{mssql},{oracle}] [-DBMS_INSTANCE=xxxx] [-MDB_NAME=xxxx] [-MDB_SOURCE_DIR=<dir>] [-MDB_TARGET_DIR=<dir>] [-MDB_PATCH_DIR=<dir>] [-MDB_EXIT_SCRIPT=<yes or no>] [-debug] [-?]
REM
REM History:
REM		7-sep-2005	mulwi01		added header, options, source/target directories, error messages
REM		8-sep-2005	mulwi01		replace user ddl files with inline ddl for password and version
REM	   12-sep-2005	mulwi01		add error if mdb already exists
REM	   12-sep-2005	mulwi01		Star 14336013 DSM: SQLSERVER ALLOW NESTED TR
REM	   16-sep-2005	mulwi01		log build 030a
REM	   16-sep-2005	mulwi01		log build 030b
REM	   20-sep-2005	mulwi01		log build 030c
REM	   26-sep-2005	mulwi01		log build 030d
REM	   26-sep-2005	mulwi01		Star 14404124 MDB STATUS LOG FILE ERROR
REM	   26-sep-2005	mulwi01		Star 14404387 MDB N/W INSTALL FAILED
REM	   26-sep-2005	mulwi01		Star 14402287 MDB N/W INSTALLATION FAILURE
REM	   27-sep-2005	mulwi01		Star 14404359 MDB INSTALLER THROWS ERR MESG
REM	   29-sep-2005	mulwi01		use recovery full option
REM	    3-oct-2005	mulwi01		log build 030e
REM 	4-oct-2005  hopst01 	Star 14404124 MDB STATUS LOG FILE ERROR, add use of sqlcmd for sql server 2005
REM	   10-oct-2005  mulwi01 	make MDB_ADMIN_PSWD optional and default to mdbadmin 
REM	   13-oct-2005	mulwi01		log build 030f
REM	   18-oct-2005	mulwi01		automatically install the latest patch (if present)
REM	    2-nov-2005	mulwi01		log build 030g
REM	    2-nov-2005	mulwi01		remove mdbadmin database user
REM	    3-nov-2005	mulwi01		fix bad server return code
REM	    7-nov-2005	mulwi01		more return codes; exitscript option (14471684); delete mdb on error; errmsg file
REM	    8-nov-2005	mulwi01		Star 14484939 AUTOPATCH INSTALLATION FAILS
REM	   18-nov-2005	mulwi01		log build 030h
REM	   28-nov-2005	mulwi01		check previous mdb version
REM	   29-nov-2005	mulwi01		log the return code; generate signature
REM	   29-nov-2005	mulwi01		log build 030i
REM	   30-nov-2005	mulwi01		log build 030j
REM	   30-nov-2005	mulwi01		Remove RECOVERY=FULL option as per ISL recommendation 
REM	   30-nov-2005	mulwi01		run the cumulative patch on an existing mdb
REM

setlocal

rem
rem Version and build for log
rem
set MDB_VERSION=1.0.4 (030j)


REM set DEBUGECHO=@ECHO on
set DEBUGECHO=@ECHO off
%DEBUGECHO%

for /f "delims=," %%a in ('chdir') do set CURDIR=%%a

REM
REM Set the default parameters
REM
set DBMS_TYPE=mssql
set DBMS_INSTANCE=
set DBMS_INSTANCE_PATCH=
set MDB_NAME=mdb
set MDB_SOURCE_DIR=%CURDIR%
set MDB_TARGET_DIR=%CURDIR%
set MDB_PATCH_DIR=
set MDB_RC=2
set ERR_MESSAGE=
set LOGFILE=
set EXIT_SCRIPT=/B



REM
REM Parse the command line parameters
REM

:PARSE_ARGS

IF "%~1"==""   GOTO NO_MORE_ARGS
IF "%~1"=="-?" GOTO USAGE

IF NOT "%~1"=="-DBMS_TYPE" GOTO NEXT_ARG1
SHIFT
set DBMS_TYPE=%~1
IF NOT "%DBMS_TYPE%"=="mssql" GOTO USAGE
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG1
IF NOT "%~1"=="-DBMS_INSTANCE" GOTO NEXT_ARG2
SHIFT
if "%~1"=="local" goto DBMS_INSTANCE_LOCAL
set DBMS_INSTANCE=-S %~1
set DBMS_INSTANCE_PATCH=-DBMS_INSTANCE=%~1
:DBMS_INSTANCE_LOCAL
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG2
IF NOT "%~1"=="-MDB_NAME" GOTO NEXT_ARG3
SHIFT
set MDB_NAME=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG3
IF NOT "%~1"=="-MDB_SOURCE_DIR" GOTO NEXT_ARG4
SHIFT
set MDB_SOURCE_DIR=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG4
IF NOT "%~1"=="-MDB_TARGET_DIR" GOTO NEXT_ARG5
SHIFT
set MDB_TARGET_DIR=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG5
IF NOT "%~1"=="-MDB_PATCH_DIR" GOTO NEXT_ARG6
SHIFT
set MDB_PATCH_DIR=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG6
IF NOT "%~1"=="-MDB_EXIT_SCRIPT" GOTO NEXT_ARG7
SHIFT
IF NOT "%~1"=="yes" GOTO CHECK_NO
set EXIT_SCRIPT=/B
SHIFT
GOTO PARSE_ARGS
:CHECK_NO
IF NOT "%~1"=="no" GOTO XSCRIPT_ERR
set EXIT_SCRIPT=
SHIFT
GOTO PARSE_ARGS
:XSCRIPT_ERR
echo %date% %time% Invalid -MDB_EXIT_SCRIPT argument "%~1", expected yes or no
set ERR_MESSAGE=Invalid -MDB_EXIT_SCRIPT argument "%~1", expected yes or no
GOTO USAGE

:NEXT_ARG7
IF NOT "%~1"=="-debug" GOTO INVALID_ARG
set DEBUGECHO=@ECHO ON
%DEBUGECHO%
SHIFT
GOTO PARSE_ARGS

:INVALID_ARG
echo %date% %time% Usage: Invalid argument "%~1"
set ERR_MESSAGE=Invalid setupmdb argument "%~1"
GOTO USAGE

:NO_MORE_ARGS


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

set MDB_RC=10
set ERR_MESSAGE=cannot find osql or sqlcmd. Check that SQLServer has been installed and in the PATH
GOTO DONE_EXIT
:OSQL_FOUND



IF EXIST "%MDB_SOURCE_DIR%" GOTO SOURCE_DIR_EXIST
set MDB_RC=20
set ERR_MESSAGE="%MDB_SOURCE_DIR%" does not exist
GOTO DONE_EXIT
:SOURCE_DIR_EXIST


REM
REM Create the mdb directory and copy the install image
REM

IF EXIST "%MDB_TARGET_DIR%" GOTO TARGET_DIR_EXIST
mkdir "%MDB_TARGET_DIR%" 
echo %date% %time% Install created the mdb directory as "%MDB_TARGET_DIR%" 
:TARGET_DIR_EXIST

IF EXIST "%MDB_TARGET_DIR%\ddl" GOTO TARGET_DDL_DIR_EXIST
mkdir "%MDB_TARGET_DIR%\ddl" 
echo %date% %time% Install created the mdb directory as "%MDB_TARGET_DIR%\ddl" 
:TARGET_DDL_DIR_EXIST



IF "%MDB_TARGET_DIR%"=="%MDB_SOURCE_DIR%" GOTO SAME_DIRS

echo %date% %time% Copying "%MDB_SOURCE_DIR%" to "%MDB_TARGET_DIR%"	
copy "%MDB_SOURCE_DIR%" "%MDB_TARGET_DIR%"							
if %ERRORLEVEL% EQU 0 GOTO COPY_MDB
set MDB_RC=30
set ERR_MESSAGE=Failed to copy files from "%MDB_SOURCE_DIR%" to "%MDB_TARGET_DIR%" (errorlevel=%ERRORLEVEL%)
GOTO DONE_EXIT
:COPY_MDB

copy "%MDB_SOURCE_DIR%\ddl" "%MDB_TARGET_DIR%\ddl"							
if %ERRORLEVEL% EQU 0 GOTO COPY_MDB_DDL
set MDB_RC=40
set ERR_MESSAGE=Failed to copy files from "%MDB_SOURCE_DIR%\ddl" to "%MDB_TARGET_DIR%\ddl" (errorlevel=%ERRORLEVEL%)
GOTO DONE_EXIT
:COPY_MDB_DDL


:SAME_DIRS


rem
rem Check for a cumulative patch
rem

rem
rem Any patch directory?
rem
IF (%MDB_PATCH_DIR%) == () GOTO NO_PATCH_DIR
IF NOT EXIST "%MDB_PATCH_DIR%" GOTO NO_PATCH_DIR
mkdir "%MDB_TARGET_DIR%\CumulativePatch" 
echo %date% %time% Install created the mdb directory as "%MDB_TARGET_DIR%\CumulativePatch" 
mkdir "%MDB_TARGET_DIR%\CumulativePatch\patches" 
echo %date% %time% Install created the mdb directory as "%MDB_TARGET_DIR%\CumulativePatch\patches" 

copy "%MDB_PATCH_DIR%" "%MDB_TARGET_DIR%\CumulativePatch"							
if %ERRORLEVEL% EQU 0 GOTO PD_COPY_CUM_PATCH
set MDB_RC=50
set ERR_MESSAGE=Failed to copy files from "%MDB_PATCH_DIR%" to "%MDB_TARGET_DIR%\CumulativePatch" (errorlevel=%ERRORLEVEL%)
GOTO DONE_EXIT
:PD_COPY_CUM_PATCH

IF NOT EXIST "%MDB_PATCH_DIR%\patches" GOTO PD_END_CUMULATIVE_PATCH
copy "%MDB_PATCH_DIR%\patches" "%MDB_TARGET_DIR%\CumulativePatch\patches"							
if %ERRORLEVEL% EQU 0 GOTO PD_END_CUMULATIVE_PATCH
set MDB_RC=60
set ERR_MESSAGE=Failed to copy files from "%MDB_PATCH_DIR%\patches" to "%MDB_TARGET_DIR%\CumulativePatch\patches" (errorlevel=%ERRORLEVEL%)
GOTO DONE_EXIT
:PD_END_CUMULATIVE_PATCH

GOTO END_CUMULATIVE_PATCH

:NO_PATCH_DIR


rem
rem Any CumulativePatch directory?
rem
IF NOT EXIST "%MDB_SOURCE_DIR%\CumulativePatch" GOTO END_CUMULATIVE_PATCH
mkdir "%MDB_TARGET_DIR%\CumulativePatch" 
echo %date% %time% Install created the mdb directory as "%MDB_TARGET_DIR%\CumulativePatch" 
mkdir "%MDB_TARGET_DIR%\CumulativePatch\patches" 
echo %date% %time% Install created the mdb directory as "%MDB_TARGET_DIR%\CumulativePatch\patches" 

copy "%MDB_SOURCE_DIR%\CumulativePatch" "%MDB_TARGET_DIR%\CumulativePatch"							
if %ERRORLEVEL% EQU 0 GOTO COPY_CUM_PATCH
set MDB_RC=70
set ERR_MESSAGE=Failed to copy files from "%MDB_SOURCE_DIR%\CumulativePatch" to "%MDB_TARGET_DIR%\CumulativePatch" (errorlevel=%ERRORLEVEL%)
GOTO DONE_EXIT
:COPY_CUM_PATCH

IF NOT EXIST "%MDB_SOURCE_DIR%\CumulativePatch\patches" GOTO END_CUMULATIVE_PATCH
copy "%MDB_SOURCE_DIR%\CumulativePatch\patches" "%MDB_TARGET_DIR%\CumulativePatch\patches"							
if %ERRORLEVEL% EQU 0 GOTO END_CUMULATIVE_PATCH
set MDB_RC=80
set ERR_MESSAGE=Failed to copy files from "%MDB_SOURCE_DIR%\CumulativePatch\patches" to "%MDB_TARGET_DIR%\CumulativePatch\patches" (errorlevel=%ERRORLEVEL%)
GOTO DONE_EXIT
:END_CUMULATIVE_PATCH



REM
REM Set the install log file
REM
set LOGFILE="%MDB_TARGET_DIR%\install_%MDB_NAME%.log"

echo %date% %time% setupmdb mdb log file in %LOGFILE%
echo . >> %LOGFILE% 2>&1
echo . >> %LOGFILE% 2>&1
echo . >> %LOGFILE% 2>&1
echo %date% %time% ====================================================================== >> %LOGFILE% 2>&1
echo %date% %time% ============================= %MDB_VERSION% =========================== >> %LOGFILE% 2>&1
echo %date% %time% ====================================================================== >> %LOGFILE% 2>&1
echo %date% %time% setupmdb mdb log file in %LOGFILE% >> %LOGFILE% 2>&1



chdir /D "%MDB_TARGET_DIR%" >> %LOGFILE% 2>&1


REM
REM check if mdb already exists
REM
echo %date% %time% Checking if %MDB_NAME% already exists...
echo %date% %time% Checking if %MDB_NAME% already exists... >>%LOGFILE% 2>&1
echo %date% %time%>> %LOGFILE%
echo %date% %time% %SQL_CMD% %DBMS_INSTANCE% -d master -E -e -b -Q "exit(SELECT count(*)+100000 FROM master..sysdatabases WHERE name = '%MDB_NAME%')"    >>%LOGFILE% 2>&1
%SQL_CMD% %DBMS_INSTANCE% -d master -E -e -b -Q "exit(SELECT count(*)+100000 FROM master..sysdatabases WHERE name = '%MDB_NAME%')"    >>%LOGFILE% 2>&1
set RC=%ERRORLEVEL%
IF %RC% EQU 100000 GOTO MDB_NOT_FOUND
IF %RC% EQU 100001 GOTO MDB_EXISTS
set MDB_RC=100
set ERR_MESSAGE=SQL command error, ERRORLEVEL=%RC%, see logfile for details
GOTO DONE_EXIT


:MDB_EXISTS
REM
REM check the existing mdb version
REM
echo %date% %time% Checking the existing %MDB_NAME% version...
echo %date% %time% Checking the existing %MDB_NAME% version... >>%LOGFILE% 2>&1
echo %date% %time%>> %LOGFILE%
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -E -e -b -Q "exit(select (mdbmajorversion * 100) + mdbminorversion from mdb)"    >>%LOGFILE% 2>&1
set RC=%ERRORLEVEL%
IF %RC% EQU 1 GOTO MDB_VER_ERROR
IF %RC% EQU 104 GOTO MDB_104_EXISTS

set MDB_RC=200
set ERR_MESSAGE=Database %MDB_NAME% contains version %RC% but there is no upgrade available.
GOTO DONE_EXIT

:MDB_VER_ERROR
set MDB_RC=101
set ERR_MESSAGE=SQL command error checking version, ERRORLEVEL=%RC%, see logfile for details
GOTO DONE_EXIT

:MDB_104_EXISTS
set MDB_RC=0
set ERR_MESSAGE=Database %MDB_NAME% already contains version %RC%
echo %date% %time% %ERR_MESSAGE% 
echo %date% %time% %ERR_MESSAGE% >> %LOGFILE% 2>&1
GOTO APPLY_PATCH



:MDB_NOT_FOUND
REM
REM no existing mdb, create it
REM
if exist mdb_mssql.sql del mdb_mssql.sql
copy .\DDL\mdb_mssql.sql .\


IF %SQL_CMD% EQU sqlcmd (
	%SQL_CMD% %DBMS_INSTANCE% -h-1 -s. -E -b /Q  "select convert(varchar(30), serverproperty('COLLATION'))" > collation.txt
) ELSE (
	%SQL_CMD% %DBMS_INSTANCE% -h-1 -s. -n -E -b /Q  "select convert(varchar(30), serverproperty('COLLATION'))" > collation.txt
)
IF %ERRORLEVEL% EQU 0 GOTO DB_COLLATION
set MDB_RC=300
set ERR_MESSAGE=Failed to determine the collation (errorlevel=%ERRORLEVEL%)
GOTO DONE_EXIT
:DB_COLLATION

echo %date% %time% Creating %MDB_NAME%...
echo %date% %time% >> %LOGFILE% 2>&1
echo %date% %time% Creating %MDB_NAME%... >>%LOGFILE% 2>&1

set TMPSQL=create_sql_%MDB_NAME%.sql
if exist %TMPSQL% del %TMPSQL%
echo create database %MDB_NAME%						>> %TMPSQL%
"%MDB_TARGET_DIR%\LoadMDBUtil" -mdb %TMPSQL% collation.txt
echo go												>> %TMPSQL%
echo use %MDB_NAME%									>> %TMPSQL%
echo go												>> %TMPSQL%

echo ALTER DATABASE %MDB_NAME%						>> %TMPSQL%
echo    SET RECURSIVE_TRIGGERS ON					>> %TMPSQL%
echo go												>> %TMPSQL%

echo sp_configure 'show advanced option', '1'		>> %TMPSQL%
echo go												>> %TMPSQL%
echo RECONFIGURE									>> %TMPSQL%
echo go												>> %TMPSQL%
echo sp_configure									>> %TMPSQL%
echo go												>> %TMPSQL%
IF %SQL_CMD% EQU sqlcmd (
	echo exit												>> %TMPSQL%
)	

echo %date% %time%>> %LOGFILE%
echo %date% %time% %SQL_CMD% %DBMS_INSTANCE% -d master -E -e -b [%TMPSQL%]   >>%LOGFILE% 2>&1
%SQL_CMD% %DBMS_INSTANCE% -d master -E -e -b <%TMPSQL%   >>%LOGFILE% 2>&1
IF %ERRORLEVEL% EQU 0 GOTO DB_CREATED
set MDB_RC=400
set ERR_MESSAGE=Failed to create the database (errorlevel=%ERRORLEVEL%)
if exist %TMPSQL% del %TMPSQL%
GOTO DONE_EXIT
:DB_CREATED
if exist %TMPSQL% del %TMPSQL%



echo %date% %time% Loading DDL...
echo %date% %time%>> %LOGFILE%
echo %date% %time%>> %LOGFILE%
echo %date% %time% Loading DDL... >>%LOGFILE%

"%MDB_TARGET_DIR%\LoadMDBUtil" -collation mdb_mssql.sql collation.txt
if exist collation.txt del collation.txt

IF %SQL_CMD% EQU sqlcmd (
	echo exit												>> mdb_mssql.sql
)	

echo %date% %time% %SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -E -e -b [mdb_mssql.sql]   >>%LOGFILE% 2>&1
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -E -e -b <mdb_mssql.sql   >>%LOGFILE% 2>&1
IF %ERRORLEVEL% EQU 0 GOTO DB_LOADED
set MDB_RC=500
set ERR_MESSAGE=Failed to load the database (errorlevel=%ERRORLEVEL%)
if exist mdbstatus.log del mdbstatus.log
echo %date% %time% Removing failed mdb... 
echo %date% %time% Removing failed mdb... >>%LOGFILE%
%SQL_CMD% %DBMS_INSTANCE% -d master -E -e -b -Q "drop database [%MDB_NAME%]" >>%LOGFILE% 2>&1
GOTO DONE_EXIT
:DB_LOADED

set ERR_MESSAGE=Database %MDB_NAME% created



:APPLY_PATCH
rem
rem Check for a cumulative patch
rem
IF NOT EXIST "%MDB_TARGET_DIR%\CumulativePatch" GOTO PATCH_DONE
IF NOT EXIST "%MDB_TARGET_DIR%\CumulativePatch\GetPatchNumber.bat" GOTO NO_PATCH_NUM
IF NOT EXIST "%MDB_TARGET_DIR%\CumulativePatch\PatchMDB.bat" GOTO NO_PATCH_MDB
rem
rem Apply cumulative patch
rem
echo %date% %time% Applying cumulative patch... 
echo %date% %time% Applying cumulative patch... >>%LOGFILE%
chdir /D "%MDB_TARGET_DIR%\CumulativePatch" >> %LOGFILE% 2>&1
call GetPatchNumber MDB_CUMULATIVE_PATCH	>>%LOGFILE% 2>&1
echo %date% %time% call PatchMDB %DBMS_INSTANCE_PATCH% -MDB_NAME=%MDB_NAME% -MDB_PATCH=%MDB_CUMULATIVE_PATCH% >>%LOGFILE% 2>&1
call PatchMDB %DBMS_INSTANCE_PATCH% -MDB_NAME=%MDB_NAME% -MDB_PATCH=%MDB_CUMULATIVE_PATCH%
IF %ERRORLEVEL% EQU 0 GOTO PATCH_OK
set MDB_RC=600
set ERR_MESSAGE=Failed to apply patch %MDB_CUMULATIVE_PATCH% on database %MDB_NAME% (errorlevel=%ERRORLEVEL%)
chdir /D "%MDB_TARGET_DIR%" >> %LOGFILE% 2>&1
if exist mdbstatus.log del mdbstatus.log
GOTO DONE_EXIT

:PATCH_OK
chdir /D "%MDB_TARGET_DIR%" >> %LOGFILE% 2>&1
GOTO PATCH_DONE

:NO_PATCH_NUM
echo %date% %time% Warning: cannot apply cumulative patch because "%MDB_TARGET_DIR%\CumulativePatch\GetPatchNumber.bat" is not found 
echo %date% %time% Warning: cannot apply cumulative patch because "%MDB_TARGET_DIR%\CumulativePatch\GetPatchNumber.bat" is not found >>%LOGFILE%
GOTO PATCH_DONE

:NO_PATCH_MDB
echo %date% %time% Warning: cannot apply cumulative patch because "%MDB_TARGET_DIR%\CumulativePatch\PatchMDB.bat" is not found 
echo %date% %time% Warning: cannot apply cumulative patch because "%MDB_TARGET_DIR%\CumulativePatch\PatchMDB.bat" is not found >>%LOGFILE%
GOTO PATCH_DONE

:PATCH_DONE
if exist mdbstatus.log del mdbstatus.log


REM
REM Create the mdb signature for asset/patch management
REM
call CreateMDBSignature %DBMS_INSTANCE_PATCH% -MDB_NAME=%MDB_NAME%	>>%LOGFILE% 2>&1



set MDB_RC=0

goto DONE_EXIT 



:usage
echo %date% %time%
echo %date% %time%    USAGE: [-DBMS_TYPE={ingres},{mssql},{oracle}] [-DBMS_INSTANCE=xxxx] [-MDB_NAME=xxxx] [-MDB_SOURCE_DIR=dir] [-MDB_TARGET_DIR=dir] [-MDB_PATCH_DIR=dir] [-MDB_EXIT_SCRIPT=yes or no] [-debug] [-?]
echo %date% %time%
echo %date% %time%      where: 
echo %date% %time%
echo %date% %time%        DBMS_TYPE         ingres, mssql,or oracle
echo %date% %time%        DBMS_INSTANCE     server name or local
echo %date% %time%        MDB_NAME          database name
echo %date% %time%        MDB_SOURCE_DIR    source mdb directory
echo %date% %time%        MDB_TARGET_DIR    target mdb directory
echo %date% %time%        MDB_PATCH_DIR     directory containing the cumulative patch
echo %date% %time%        MDB_EXIT_SCRIPT   yes to exit the script with /B or no (default is yes)
echo %date% %time%        -debug            echo output
echo %date% %time%
echo %date% %time%
echo %date% %time%
echo %date% %time%    Examples: 
echo %date% %time%
echo %date% %time%      Create mdb locally:      setupmdb -MDB_NAME=mdb
echo %date% %time%
	
set MDB_RC=99
set ERR_MESSAGE=Usage error rc=99
GOTO DONE_EXIT




:DONE_EXIT

echo %date% %time% %ERR_MESSAGE%

IF (%LOGFILE%) == () goto NO_LOG
echo %date% %time% %ERR_MESSAGE% >> %LOGFILE% 2>&1
echo %date% %time% %ERR_MESSAGE% > "%MDB_TARGET_DIR%\install_%MDB_NAME%_msg.log"
echo %date% %time% Setupmdb exit %EXIT_SCRIPT% return code=%MDB_RC% >> %LOGFILE% 2>&1
:NO_LOG

echo %date% %time% Setting directory to %CURDIR%
chdir /D %CURDIR%
echo %date% %time% Setupmdb exit %EXIT_SCRIPT% return code=%MDB_RC%

EXIT %EXIT_SCRIPT% %MDB_RC%
