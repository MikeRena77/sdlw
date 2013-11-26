@echo off
rem ***************************************************************************************
rem *Header: hrReportsWebCheck.bat, v1.0, 2/22/2008 mha                                                                           *
rem * Batch script used to run the FP check and publish commands on the test site
rem *        http://bane:8080/hrReports
rem *        on BANE
rem *
rem * This script expects to find all necessary files already in-place
rem *        It should be run after its respective Harvest Check Out process
rem *        has been successfully completed.
rem *
rem * Usage: hrReportsWebCheck.bat web
rem *     where:
rem *         web = the specific web under \Inetpub
rem *
rem * Written 2-21-2008
rem *    by Michael Andrews (MHA)
rem *    for AAFES HQ
rem *
rem *	Version   Date       by    Change Description
rem *	1.1       2/25/2008  MHA   Modified comments
rem *   1.2       4/30/2008  MHA   Modified to point to BANE-ALPHA web
rem *
rem ***************************************************************************************

rem * Call to the batch script that handles setting Read-Only attributes off before FP command-line
call c:\hScripts\unsetRead.bat hrReports %1

rem * Modify PATH variable to include location for the <owsadm.exe> command file
set PATH=%PATH%;C:\Program Files\Common Files\Microsoft Shared\web server extensions\50\bin

rem * Set up variables to generate unique Log file name
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\hrReportsWebCheck_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

rem * Run the FP command-line utilities to "CHECK" and "INSTALL/PUBLISH" the <hrReports> web site
owsadm.exe -o check -targetserver "http://bane-h3-alpha.aafes.com/_vti_bin/_vti_adm/fpadmdll.dll" -p 80 -w "/hrReports" >> %LOG%

owsadm -o install -targetserver "http://bane-h3-alpha.aafes.com/_vti_bin/_vti_adm/fpadmdll.dll" -p 80 -w "/hrReports" -sp publish >> %LOG%

owsadm.exe -o check -targetserver "http://bane-h3-alpha.aafes.com/_vti_bin/_vti_adm/fpadmdll.dll" -p 80 -w "/hrReports" >> %LOG%

owsadm.exe -targetserver "http://bane-h3-alpha.aafes.com/_vti_bin/_vti_adm/fpadmdll.dll" -o check -p 80 -w "/" >> %LOG%
