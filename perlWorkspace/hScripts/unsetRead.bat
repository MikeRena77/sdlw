@echo off
rem ***************************************************************************************
rem *Header: unsetRead.bat, v1.0, 2/22/2008 mha                                                                                             *
rem * This batch script is called to unset Read-Only attributes against a directory
rem *   specified in the calling script and assigned against variable %RODIR%
rem * Required in situations like automated builds where previous Harvest action
rem *   set all files to Read-Only
rem * Root directory for this script operation  => h3_beta
rem *
rem * Usage: unsetRead.bat target web appsSpecifier
rem *     where:
rem *         target=the specific  target folder/website
rem *         web = the specific web under \Inetpub
rem *         appsSpecifier = the specific apps root level directory (e.g. HarvestApps, H3)
rem *
rem *
rem * Written 2-15-2008
rem *    by Michael Andrews (MHA)
rem *    for AAFES HQ
rem * Version    Date       by   Change Description
rem *   1.1      2/22/2008  MHA  Elaborated on comments
rem *   1.2      2/25/2008  MHA  Further comments to spell out usage better
rem *   1.3      3/03/2008  MHA  Added process markers to tag beginning and end 
rem *   1.4      3/17/2008  MHA  Expanded with new web parameter to allow additional targeting
rem *   1.5      6/17/2008  MHA  Required mod to accomodate HarvestApps projects
rem *
rem ***************************************************************************************

rem * Set up variables to generate unique Log file name
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\unsetRead_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

date /t >> %LOG% && time /t >> %LOG%
echo(-----BEGIN UNSET REPORT--------------------------------) >> %LOG%

rem * Set up variable to receive Read-Only directory name passed from calling script
rem * Test for a third parameter
rem * A third parameter means that the top-level directory is not \inetpub
set RODIR=c:\%3
if %RODIR% EQU c:\ goto IPUB
set RODIR=C:\%3\%2\%1
goto OP

rem * If there was no third parameter passed in, then top-level directory is \inetpub
:IPUB
set RODIR=c:\inetpub\%2\%1

:OP
rem * Set Read-Only attribute off
attrib -r %RODIR%\*.* /s >> %LOG%
echo(-----END UNSET REPORT----------------------------------) >> %LOG%
date /t >> %LOG% && time /t >> %LOG%
