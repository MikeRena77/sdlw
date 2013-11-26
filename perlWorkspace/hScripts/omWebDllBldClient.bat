@echo off
rem ***************************************************************************************
rem *  Filename:  omWebDllBldClient.bat
rem *  Batch script used to perform an OpenMake build of the beta web site DLL for
rem *         http://HARDEV3/h3-beta/hrReports
rem * 
rem *  Build accomplished on HARDEV3 OpenMake Remote Build Server
rem *  The command line is omWebDllBld.bat workflow [package]
rem *  Variables passed in:  wflow = Meister workflow
rem *  The wflow variable is passed in from the Harvest UDP
rem *    and specifies the Meister Workflow to execute
rem *  The command line is omWebDllBldClient.bat wflow ["package"]
rem *  Variables passed in:
rem *    wflow       = the desired OpenMake workflow
rem *    ["package"] = the work package
rem * 
rem *  Written 7-26-2008
rem *    by Michael Andrews
rem *    for AAFES HQ
rem *  Version    Date       by   Change Description
rem *    1.0      7/26/2008  MHA  Script written for the production  build of AAFES.HR.Functions.DLL  with Meister
rem *
rem ***************************************************************************************

rem * This script was written to implement a Meister/OpenMake Remote Build 
rem *    This build supports developers by generating the new DLL on the Beta server
rem *    but the target is not checked out of or back in to Harvest

set wflow=%1
SHIFT
echo "Creating the LOG now"
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\omWebDllBldClient_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log
echo "Writing out the time date stamp now"
date /t > %LOG% && time /t >> %LOG%
echo(-----BEGIN %WFLOW% BUILD REPORT--------------------------------) >> %LOG%
rem * If there are more than one package, loop for them all
echo "Processing packages now"
@ECHO OFF
:Loop
IF "%1"=="" GOTO Continue
echo %1 >> %LOG%
echo %1 >> c:\hScripts\pkg
SHIFT
GOTO Loop
:Continue

rem FOR %%A IN (%*) DO (
rem echo %%A >> %LOG%
rem echo %%A >> c:\hScripts\pkg
rem )

echo "Launching the OM Workflow now"
rem *  Run the OpenMake build
java -cp "c:\Program Files\openmake\client\bin\omcmdline.jar" com.openmake.cmdline.Main -BUILD %wflow% >> %LOG%

echo(-----END %WFLOW% BUILD REPORT----------------------------------) >> %LOG%
date /t >> %LOG% && time /t >> %LOG%
echo "Final time date stamp now"
