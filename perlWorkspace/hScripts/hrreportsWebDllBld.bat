@echo off
rem ***************************************************************************************
rem *  Filename:  hrReportsWebDllBld.bat
rem *  Batch script used to perform an OpenMake build of the web site DLL for
rem *         http://machine/h3-beta/hrReports
rem *         on MACHINE
rem * 
rem *  Build accomplished on HARDEV3 OpenMake Remote Build Server
rem *  The command line is hrReportsWebDllBld.bat package
rem *  Variables passed in:  package
rem *  PACKAGE variable saved out to temp file PKG for passing to later scripts
rem * 
rem *  Written 2-27-2008
rem *     by Michael Andrews
rem *     for AAFES HQ
rem *  Version    Date       by   Change Description
rem *    1.0      2/27/2008  MHA  Script written to build HRREPORTS.DLL  with OpenMake
rem *    1.1      2/28/2008  MHA  Script modified for handling build completely from OpenMake
rem *    1.2      2/28/2008  MHA  Echo out to the PKG file had to be more specifically named
rem ***************************************************************************************

rem * This script has been totally rewritten to implement using Perl scripts in the OpenMake workflow
rem * instead of batch files.  
rem * Additionally, the OpenMake workflow has taken over the entire process because the interaction
rem * between OpenMake and Harvest was faulty.  If OpenMake only controlled the build itself and Harvest
rem * handled all check outs and check ins for the built DLL, the timing was faulty on the Harvest Check In
rem * after the OpenMake step of the process.  Harvest attempted a Check In of the DLL before OpenMake had
rem * actually done the build to create a new version of the DLL.  Now the OpenMake workflow controls all aspects
rem * of the update process.

set package=%1

set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\hrReportsWebDllBld_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

date /t > %LOG% && time /t >> %LOG%
echo(-----BEGIN BUILD REPORT--------------------------------)

echo %package% >> %LOG%
echo %package% > \hScripts\pkg

attrib +r \hScripts\pkg

rem *  Run the OpenMake build
java -cp "c:\Program Files\openmake\client\bin\omcmdline.jar" com.openmake.cmdline.Main -BUILD "HRREPORTS DLL BUILD"

echo(-----END BUILD REPORT----------------------------------)
date /t >> %LOG% && time /t >> %LOG%
