@echo off
rem ***************************************************************************************
rem *Header: myHRReportsLinkChecker.bat, v1.0, 2/22/2008 mha                                                                           *
rem * Batch script used to run the FP check and publish commands on the test site
rem *        http://web/hrReports
rem *        on HARDEV3
rem *
rem * This script expects to find all necessary files already in-place
rem *        It should be run after its respective Harvest Check Out process
rem *        has been successfully completed.
rem *
rem * Usage: myHRReportsLinkChecker.bat web
rem *     where:
rem *         web = the specific web under \Inetpub
rem *
rem * Written 3-27-2008
rem *    by Michael Andrews (MHA)
rem *    for AAFES HQ
rem *
rem * Version     Date       by    Change Description
rem *   1.0       3/27/2008  MHA   Created batch file to call the new Python LinkChecker
rem *
rem ***************************************************************************************

rem * Modify PATH variable to include location for the <owsadm.exe> command file
set PATH=%PATH%;C:\Program Files\Common Files\Microsoft Shared\web server extensions\50\bin;c:\Python25;c:\python25\scripts

rem * Set up variables to generate unique Log file name
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\HRReportsLinkCheck_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

IF %1 EQU h3_alpha GOTO ALPHA

IF %1 EQU h3_beta GOTO BETA

:ALPHA
rem * Run linkchecker.bat to run checks of all links
linkchecker.bat -o text http://hardev3:8098/hrReports/ > %LOG%

GOTO END

:BETA
rem * Run linechecker.bat to run checks of all links
linkchecker -v -o text http://hardev3:8080/hrReports/ > %LOG%

set LOG=

:END
:EOF