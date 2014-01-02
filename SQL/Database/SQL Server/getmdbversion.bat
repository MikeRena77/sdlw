@ECHO OFF

REM Name: getmdbversion.bat 
REM
REM Description: 
REM	get the mdb version.
REM 
REM Syntax:
REM
REM 	getmdbversion [-DBMS_TYPE={ingres},{mssql},{oracle}] [-DBMS_INSTANCE=xxxx] [-II_MDB_ADMIN=xxxx] [-II_MDB_NAME=xxxx] [-II_MDB_VERSION_TYPE=<major>|<minor>|<build>|<full>|<unicode>] [-debug] [-?]
REM
REM History:
REM	21-dec-2004 (mulwi01)
REM	    Created.
REM	 9-feb-2005 (mulwi01)
REM	    don't lock db; add more versions
REM	14-feb-2005 (mulwi01)
REM	    add more versions
REM	15-feb-2005 (mulwi01)
REM	    set major/minor version info
REM	13-may-2005 (mulwi01)
REM	    update for 1.03
REM	16-may-2005 (mulwi01)
REM	    add full
REM	17-may-2005 (mulwi01)
REM	    add unicode
REM	21-jun-2005 (mulwi01)
REM	    support for SQLServer
REM	 7-jul-2005 (mulwi01)
REM	    use lower case identifiers for SQLServer
REM	29-jul-2005 (mulwi01)
REM	    update for 1.04
REM	 8-aug-2005 (mulwi01)
REM	    add more builds
REM	27-sep-2005 (mulwi01)
REM	    Star 14404741 GETMDBVERSION RETURNS ERR MSG
REM	10-oct-2005 (mulwi01)
REM	    Star 14404741 GETMDBVERSION RETURNS ERR MSG (usage update)
REM

SETLOCAL

set II_MDB_ADMIN=mdbadmin
set II_MDB_NAME=mdb
set II_MDB_VERSION_TYPE=build
set DBMS_TYPE=ingres
set DBMS_INSTANCE=


REM
REM Parse the command line parameters
REM

:PARSE_ARGS

IF "%~1"==""   GOTO NO_MORE_ARGS
IF "%~1"=="-?" GOTO USAGE

IF NOT "%~1"=="-II_MDB_ADMIN" GOTO NEXT_ARG1
SHIFT
set II_MDB_ADMIN=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG1
IF NOT "%~1"=="-II_MDB_NAME" GOTO NEXT_ARG2
SHIFT
set II_MDB_NAME=%~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG2
IF NOT "%~1"=="-II_MDB_VERSION_TYPE" GOTO NEXT_ARG3
SHIFT
set II_MDB_VERSION_TYPE=%~1
SHIFT
IF "%II_MDB_VERSION_TYPE%"=="major" GOTO PARSE_ARGS
IF "%II_MDB_VERSION_TYPE%"=="minor" GOTO PARSE_ARGS
IF "%II_MDB_VERSION_TYPE%"=="build" GOTO PARSE_ARGS
IF "%II_MDB_VERSION_TYPE%"=="full" GOTO PARSE_ARGS
IF "%II_MDB_VERSION_TYPE%"=="unicode" GOTO PARSE_ARGS
GOTO INVALID_ARG

:NEXT_ARG3
IF NOT "%~1"=="-DBMS_TYPE" GOTO NEXT_ARG4
SHIFT
set DBMS_TYPE=%~1
SHIFT
IF "%DBMS_TYPE%"=="ingres"	GOTO PARSE_ARGS
IF "%DBMS_TYPE%"=="mssql"	GOTO PARSE_ARGS
GOTO INVALID_ARG

:NEXT_ARG4
IF NOT "%~1"=="-DBMS_INSTANCE" GOTO NEXT_ARG5
SHIFT
set DBMS_INSTANCE=-S %~1
SHIFT
GOTO PARSE_ARGS

:NEXT_ARG5
IF /i NOT "%~1"=="-debug" GOTO INVALID_ARG
set DEBUGECHO=@ECHO ON
%DEBUGECHO%
SHIFT
GOTO PARSE_ARGS

:INVALID_ARG
echo %date% %time% Usage: Invalid argument "%~1"
GOTO USAGE

:NO_MORE_ARGS

IF "%II_MDB_VERSION_TYPE%"=="unicode" GOTO CHECK_UNICODE


IF "%DBMS_TYPE%"=="ingres"	GOTO INGRES_VER
IF "%DBMS_TYPE%"=="mssql"	GOTO MSSQL_VER
GOTO USAGE


:MSSQL_VER
SET VERSION=unknown
IF "%II_MDB_VERSION_TYPE%"=="major"	GOTO GET_MAJOR
IF "%II_MDB_VERSION_TYPE%"=="minor"	GOTO GET_MINOR
IF "%II_MDB_VERSION_TYPE%"=="build"	GOTO GET_BUILD
IF "%II_MDB_VERSION_TYPE%"=="full"	GOTO GET_FULL
GOTO USAGE

:GET_MAJOR
for /F "TOKENS=1 EOL=( delims=. " %%A IN ('osql %DBMS_INSTANCE% -d %II_MDB_NAME% -h-1 -s. -n -E -Q"select mdbmajorversion from mdb"') DO SET VERSION=%%A
echo %VERSION%
GOTO DONE

:GET_MINOR
for /F "TOKENS=1 EOL=( delims=. " %%A IN ('osql %DBMS_INSTANCE% -d %II_MDB_NAME% -h-1 -s. -n -E -Q"select mdbminorversion from mdb"') DO SET VERSION=%%A
echo %VERSION%
GOTO DONE

:GET_BUILD
for /F "TOKENS=1 EOL=( delims=. " %%A IN ('osql %DBMS_INSTANCE% -d %II_MDB_NAME% -h-1 -s. -n -E -Q"select buildnumber from mdb"') DO SET VERSION=%%A
echo %VERSION%
GOTO DONE

:GET_FULL
for /F "TOKENS=1,2,3 EOL=( delims=. " %%A IN ('osql %DBMS_INSTANCE% -d %II_MDB_NAME% -h-1 -s. -n -E -Q"select mdbmajorversion, mdbminorversion, buildnumber from mdb"') DO SET VERSION=%%A.%%B.%%C
echo %VERSION%
GOTO DONE



:INGRES_VER

IF "%II_SYSTEM%" == "" GOTO II_SYSTEM_ERROR
IF EXIST "%II_SYSTEM%" GOTO II_SYSTEM_EXISTS
echo Error: II_SYSTEM directory "%II_SYSTEM%" does not exist
GOTO USAGE
:II_SYSTEM_ERROR
echo Error: II_SYSTEM is not defined
GOTO USAGE
:II_SYSTEM_EXISTS

REM
REM Obtain the mdb version 
REM
IF EXIST mdbversion.txt del mdbversion.txt
IF EXIST mdbversion.tmp del mdbversion.tmp
echo \script mdbversion.txt				>  mdbversion.tmp
echo select buildnumber from tau_mdb\g	>> mdbversion.tmp
sql -u%II_MDB_ADMIN% -i44 -v  %II_MDB_NAME% < mdbversion.tmp > nul
IF EXIST mdbversion.tmp del mdbversion.tmp
IF NOT EXIST mdbversion.txt GOTO DB_UNKNOWN
IF EXIST junk.out del junk.out
findstr /B /L /C:" " mdbversion.txt > junk.out
if %ERRORLEVEL% EQU 0 GOTO DB_EXIST
del mdbversion.txt > nul

GOTO DONE

:DB_EXIST
del mdbversion.txt > nul

:DB017
findstr /B /L /C:"  17" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB018
set II_MDB_BUILD=17
GOTO VERSION_1_01

:DB018
findstr /B /L /C:"  18" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB019
set II_MDB_BUILD=18
GOTO VERSION_1_02

:DB019
findstr /B /L /C:"  19" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB020
set II_MDB_BUILD=19
GOTO VERSION_1_02

:DB020
findstr /B /L /C:"  20" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB021
set II_MDB_BUILD=20
GOTO VERSION_1_02

:DB021
findstr /B /L /C:"  21" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB022
set II_MDB_BUILD=21
GOTO VERSION_1_02

:DB022
findstr /B /L /C:"  22" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB023
set II_MDB_BUILD=22
GOTO VERSION_1_02

:DB023
findstr /B /L /C:"  23" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB024
set II_MDB_BUILD=23
GOTO VERSION_1_02

:DB024
findstr /B /L /C:"  24" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB025
set II_MDB_BUILD=24
GOTO VERSION_1_03

:DB025
findstr /B /L /C:"  25" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB026
set II_MDB_BUILD=25
GOTO VERSION_1_03

:DB026
findstr /B /L /C:"  26" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB027
set II_MDB_BUILD=26
GOTO VERSION_1_04

:DB027
findstr /B /L /C:"  27" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB028
set II_MDB_BUILD=27
GOTO VERSION_1_04

:DB028
findstr /B /L /C:"  28" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB029
set II_MDB_BUILD=28
GOTO VERSION_1_04

:DB029
findstr /B /L /C:"  29" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB030
set II_MDB_BUILD=29
GOTO VERSION_1_04

:DB030
findstr /B /L /C:"  30" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB_UNKNOWN
set II_MDB_BUILD=30
GOTO VERSION_1_04

:DB031
findstr /B /L /C:"  31" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB_UNKNOWN
set II_MDB_BUILD=31
GOTO VERSION_1_04

:DB032
findstr /B /L /C:"  32" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB_UNKNOWN
set II_MDB_BUILD=32
GOTO VERSION_1_04

:DB033
findstr /B /L /C:"  33" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB_UNKNOWN
set II_MDB_BUILD=33
GOTO VERSION_1_04

:DB034
findstr /B /L /C:"  34" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB_UNKNOWN
set II_MDB_BUILD=34
GOTO VERSION_1_04

:DB035
findstr /B /L /C:"  35" junk.out > nul
if %ERRORLEVEL% NEQ 0 GOTO DB_UNKNOWN
set II_MDB_BUILD=35
GOTO VERSION_1_04



:DB_UNKNOWN
set II_MDB_BUILD=unknown
set II_MDB_MAJORVERSION=unknown
set II_MDB_MINORVERSION=unknown
GOTO MDB_RETURN


:USAGE
echo Usage:
echo Usage: getmdbversion [-DBMS_TYPE={ingres},{mssql},{oracle}] [-DBMS_INSTANCE=xxxx] [-II_MDB_ADMIN=xxxx] [-II_MDB_NAME=xxxx] [-II_MDB_VERSION_TYPE={major},{minor},{build}] [-debug] [-?]
echo Usage: -II_MDB_ADMIN   (Ingres only)
echo Usage: -debug          Run with "echo on"
echo Usage: -?              Prints this message
echo Usage:
GOTO DONE

:VERSION_1_01
set II_MDB_MAJORVERSION=1
set II_MDB_MINORVERSION=1
GOTO MDB_RETURN

:VERSION_1_02
set II_MDB_MAJORVERSION=1
set II_MDB_MINORVERSION=2
GOTO MDB_RETURN

:VERSION_1_03
set II_MDB_MAJORVERSION=1
set II_MDB_MINORVERSION=3
GOTO MDB_RETURN

:VERSION_1_04
set II_MDB_MAJORVERSION=1
set II_MDB_MINORVERSION=4
GOTO MDB_RETURN

:MDB_RETURN
IF "%II_MDB_VERSION_TYPE%"=="major" echo %II_MDB_MAJORVERSION%
IF "%II_MDB_VERSION_TYPE%"=="minor" echo %II_MDB_MINORVERSION%
IF "%II_MDB_VERSION_TYPE%"=="build" echo %II_MDB_BUILD%
IF "%II_MDB_VERSION_TYPE%"=="full" echo %II_MDB_MAJORVERSION%.%II_MDB_MINORVERSION%.%II_MDB_BUILD%
GOTO DONE

:CHECK_UNICODE
REM
REM Check for NFD unicode normalization
REM
IF EXIST infodb.out del infodb.out
infodb %II_MDB_NAME% > infodb.out
findstr /L /C:"NFD" infodb.out > nul
if %ERRORLEVEL% EQU 0 GOTO UNICODE_NFD
findstr /L /C:"NFC" infodb.out > nul
if %ERRORLEVEL% EQU 0 GOTO UNICODE_NFC
echo unknown
GOTO DONE

:UNICODE_NFC
echo NFC
GOTO DONE

:UNICODE_NFD
echo NFD
GOTO DONE

:DONE
IF EXIST infodb.out del infodb.out
IF EXIST junk.out del junk.out
ENDLOCAL
