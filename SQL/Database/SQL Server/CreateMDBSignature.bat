@ECHO OFF

REM Name: CreateMDBSignature.bat 
REM
REM Description: 
REM		returns 1 if the signature is created, otherwise returns 0
REM 
REM Syntax:
REM
REM 	CreateMDBSignature [-DBMS_INSTANCE=xxxx] [-MDB_NAME=xxxx] [-debug] [-?]
REM
REM History:
REM	29-nov-2005 mulwi01
REM	    Created.
REM

SETLOCAL

set DBMS_INSTANCE=
set MDB_NAME=mdb


REM
REM Parse the command line parameters
REM

:PARSE_ARGS

IF "%~1"==""   GOTO NO_MORE_ARGS
IF "%~1"=="-?" GOTO USAGE


IF NOT "%~1"=="-DBMS_INSTANCE" GOTO NEXT_ARG1
SHIFT
if "%~1"=="local" goto DBMS_INSTANCE_LOCAL
set DBMS_INSTANCE=-S %~1
:DBMS_INSTANCE_LOCAL
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG1
IF NOT "%~1"=="-MDB_NAME" GOTO NEXT_ARG2
SHIFT
set MDB_NAME=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG2
IF /i NOT "%~1"=="-debug" GOTO INVALID_ARG
set DEBUGECHO=@ECHO ON
%DEBUGECHO%
SHIFT
GOTO PARSE_ARGS

:INVALID_ARG
echo %date% %time% Usage: Invalid argument "%~1"
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

set ERR_MESSAGE=cannot find osql or sqlcmd. Check that SQLServer has been installed and in the PATH
GOTO DONE_ERROR
:OSQL_FOUND

IF (%SIGFILE%) == () set SIGFILE="%MDB_NAME%_signature.txt"


REM
REM create the signature... 
REM

echo %date% %time% Creating the %MDB_NAME% signature in %SIGFILE% 

echo MdbName=%MDB_NAME%							>  %SIGFILE%
echo DbmsType=SQLServer							>> %SIGFILE%





REM
REM add the current date... 
REM

IF EXIST mdbsig.txt del mdbsig.txt
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -h-1 -s. -E -b -Q "select 'SignatureDate='+cast(getdate() as varchar)" > mdbsig.txt
findstr /B /L /C:"SignatureDate=" mdbsig.txt 
if %ERRORLEVEL% EQU 0 GOTO FOUND_SIGDATE
type mdbsig.txt 
del mdbsig.txt > nul
set ERR_MESSAGE=CreateMDBSignature: error on mdb.SignatureDate
GOTO DONE_ERROR

:FOUND_SIGDATE
findstr /B /L /C:"SignatureDate=" mdbsig.txt >> %SIGFILE%
del mdbsig.txt > nul



REM
REM add the majorversion... 
REM

IF EXIST mdbsig.txt del mdbsig.txt
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -h-1 -s. -E -b -Q "select 'MdbMajorVersion='+cast(mdbMajorVersion as varchar(5)) from mdb" > mdbsig.txt
findstr /B /L /C:"MdbMajorVersion=" mdbsig.txt 
if %ERRORLEVEL% EQU 0 GOTO FOUND_MAJOR
type mdbsig.txt 
del mdbsig.txt > nul
set ERR_MESSAGE=CreateMDBSignature: error on mdb.mdbMajorVersion
GOTO DONE_ERROR

:FOUND_MAJOR
findstr /B /L /C:"MdbMajorVersion=" mdbsig.txt >> %SIGFILE%
del mdbsig.txt > nul



REM
REM add the minorversion... 
REM

IF EXIST mdbsig.txt del mdbsig.txt
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -h-1 -s. -E -b -Q "select 'MdbMinorVersion='+cast(mdbMinorVersion as varchar(5)) from mdb" > mdbsig.txt
findstr /B /L /C:"MdbMinorVersion=" mdbsig.txt 
if %ERRORLEVEL% EQU 0 GOTO FOUND_MINOR
type mdbsig.txt 
del mdbsig.txt > nul
set ERR_MESSAGE=CreateMDBSignature: error on mdb.mdbMinorVersion
GOTO DONE_ERROR

:FOUND_MINOR
findstr /B /L /C:"MdbMinorVersion=" mdbsig.txt >> %SIGFILE%
del mdbsig.txt > nul



REM
REM add the build... 
REM

IF EXIST mdbsig.txt del mdbsig.txt
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -h-1 -s. -E -b -Q "select 'BuildNumber='+cast(buildNumber as varchar(5)) from mdb" > mdbsig.txt
findstr /B /L /C:"BuildNumber=" mdbsig.txt 
if %ERRORLEVEL% EQU 0 GOTO FOUND_BUILD
type mdbsig.txt 
del mdbsig.txt > nul
set ERR_MESSAGE=CreateMDBSignature: error on mdb.buildNumber
GOTO DONE_ERROR

:FOUND_BUILD
findstr /B /L /C:"BuildNumber=" mdbsig.txt >> %SIGFILE%
del mdbsig.txt > nul




REM
REM add the release date... 
REM

IF EXIST mdbsig.txt del mdbsig.txt
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -h-1 -s. -E -b -Q "select 'ReleaseDate='+cast(releaseDate as varchar) from mdb" > mdbsig.txt
findstr /B /L /C:"ReleaseDate=" mdbsig.txt 
if %ERRORLEVEL% EQU 0 GOTO FOUND_RDATE
type mdbsig.txt 
del mdbsig.txt > nul
set ERR_MESSAGE=CreateMDBSignature: error on mdb.ReleaseDate
GOTO DONE_ERROR

:FOUND_RDATE
findstr /B /L /C:"ReleaseDate=" mdbsig.txt >> %SIGFILE%
del mdbsig.txt > nul




REM
REM add the install date... 
REM

IF EXIST mdbsig.txt del mdbsig.txt
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -h-1 -s. -E -b -Q "select 'InstallDate='+cast(installDate as varchar) from mdb" > mdbsig.txt
findstr /B /L /C:"InstallDate=" mdbsig.txt 
if %ERRORLEVEL% EQU 0 GOTO FOUND_IDATE
type mdbsig.txt 
del mdbsig.txt > nul
rem allow null date
GOTO END_IDATE

:FOUND_IDATE
findstr /B /L /C:"InstallDate=" mdbsig.txt >> %SIGFILE%
del mdbsig.txt > nul
:END_IDATE



REM
REM add the patches... 
REM

IF EXIST mdbsig.txt del mdbsig.txt
%SQL_CMD% %DBMS_INSTANCE% -d %MDB_NAME% -h-1 -s. -E -b -Q "select 'Patch='+cast(patchnumber as varchar(10))+',\"'+cast(installdate as varchar)+'\",\"'+cast(description as varchar)+'\"' from mdb_patch" > mdbsig.txt
findstr /B /L /C:"Patch=" mdbsig.txt 
if %ERRORLEVEL% EQU 0 GOTO FOUND_PATCH
type mdbsig.txt 
del mdbsig.txt > nul
rem allow no patches
GOTO DONE

:FOUND_PATCH
findstr /B /L /C:"Patch=" mdbsig.txt >> %SIGFILE%
del mdbsig.txt > nul


GOTO DONE


:USAGE
echo Usage:
echo Usage: CreateMDBSignature [-DBMS_INSTANCE=xxxx] [-MDB_NAME=xxxx] [-debug] [-?]
echo Usage:	  DBMS_INSTANCE  server name or local
echo Usage:   MDB_NAME       database name
echo Usage:   -debug		 Run with "echo on"
echo Usage:   -?			 Prints this message
echo Usage:
ENDLOCAL
exit /B 1

:DONE
ENDLOCAL
exit /B 0

:DONE_ERROR
IF EXIST "%SIGFILE%" del "%SIGFILE%"
echo %date% %time% %ERR_MESSAGE%
ENDLOCAL
exit /B 1
