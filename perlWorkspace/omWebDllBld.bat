@echo off
rem ***************************************************************************************
rem *  Filename:  omWebDllBld.bat
rem *  Batch script used to perform an OpenMake build of the beta web site DLL for
rem *         http://HARDEV3/h3-beta/hrReports
rem * 
rem *  Build accomplished on HARDEV3 OpenMake Remote Build Server
rem *  The command line is omWebDllBld.bat workflow
rem *  Variables passed in:  wflow = Meister workflow
rem *  The wflow variable is passed in from the Harvest UDP
rem *    and specifies the Meister Workflow to execute
rem * 
rem *  Written 3-24-2008
rem *    by Michael Andrews
rem *    for AAFES HQ
rem *  Version    Date       by   Change Description
rem *    1.0      3/24/2008  MHA  Script written to beta build HRREPORTS.DLL  with Meister
rem *    1.1      6/03/2008  MHA  Modified banners to reflect wflow name instead of just BETA
rem *
rem ***************************************************************************************

rem * This script was written to implement a Meister/OpenMake Remote Build 
rem *    This build supports developers by generating the new DLL on the Beta server
rem *    but the target is not checked out of or back in to Harvest

set wflow=%1

set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\omWebDllBld_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

date /t > %LOG% && time /t >> %LOG%
echo(-----BEGIN %WFLOW% BUILD REPORT--------------------------------) >> %LOG%

rem *  Run the OpenMake build
java -cp "c:\Program Files\openmake\client\bin\omcmdline.jar" com.openmake.cmdline.Main -BUILD %wflow% >> %LOG%

echo(-----END %WFLOW% BUILD REPORT----------------------------------) >> %LOG%
date /t >> %LOG% && time /t >> %LOG%
