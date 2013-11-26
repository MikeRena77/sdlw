@echo off
rem ***************************************************************************************
rem *Header: scManagementWebCheck.bat, v1.0, 2/22/2008 mha                                                                           *
rem * Batch script used to run the FP check and publish commands on the test site
rem *        http://web/scManagment
rem *        on HARDEV3
rem *
rem * This script expects to find all necessary files already in-place
rem *        It should be run after its respective Harvest Check Out process
rem *        has been successfully completed.
rem *
rem * Usage: scManagementWebCheck.bat web
rem *     where:
rem *         web = the specific web under \Inetpub
rem *
rem * Written 2-21-2008
rem *    by Michael Andrews (MHA)
rem *    for AAFES HQ
rem *
rem * Version     Date       by    Change Description
rem *   1.1       2/25/2008  MHA   Modified comments
rem *   1.1.1     2/26/2008  MHA   Modified to point to HARDEV3 web
rem *   1.1.2     3/17/2008  MHA   Expanded for new web parameter passed on to unsetRead.bat
rem *   1.2       3/19/2008  MHA   Expanded to include processing for either Alpha or Beta webs
rem *   1.3       3/27/2008  MHA   Added calls to new Python script/executable LinkChecker for each web
rem *
rem ***************************************************************************************

rem * Call to the batch script that handles setting Read-Only attributes off before FP command-line
call c:\hScripts\unsetRead.bat SCManagement %1

IF %1 EQU h3_alpha GOTO ALPHA

IF %1 EQU h3_beta GOTO BETA

IF %1 EQU wwwroot GOTO ROOT

:ALPHA
rem * Run linkchecker.bat to run checks of all links
perl c:\hScripts\mySCMLinkChecker.pl %1

rem * Set up variables to generate unique Log file name
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\SCManagementWebCheck_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

rem * Modify PATH variable to include location for the <owsadm.exe> command file
set PATH=%PATH%;C:\Program Files\Common Files\Microsoft Shared\web server extensions\50\bin

date /t > %LOG% && time /t >> %LOG%
echo (-----BEGIN SCM ALPHA WEB CHECK REPORT--------------------------------) >> %LOG%

rem * Run the FP command-line utilities to "CHECK" and "INSTALL/PUBLISH" the <hrReports> web site
owsadm.exe -o create -targetserver "http://hardev3:8098/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8098 -sp publish >> %LOG%

owsadm.exe -o recalc -targetserver "http://hardev3:8098/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8098 >> %LOG%

owsadm.exe -o check -targetserver "http://hardev3:8098/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8098 >> %LOG%

owsadm.exe -o check -targetserver "http://hardev3:8098/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8098 >> %LOG%

echo (-----END SCM ALPHA WEB CHECK REPORT----------------------------------) >> %LOG%
date /t >> %LOG% && time /t >> %LOG%

set LOG=

GOTO END

:BETA

rem * Run linkchecker.bat to run checks of all links
perl c:\hScripts\mySCMLinkChecker.pl %1

rem * Set up variables to generate unique Log file name
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\SCManagementWebCheck_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

rem * Modify PATH variable to include location for the <owsadm.exe> command file
set PATH=%PATH%;C:\Program Files\Common Files\Microsoft Shared\web server extensions\50\bin

date /t > %LOG% && time /t >> %LOG%
echo (-----BEGIN SCM BETA WEB CHECK REPORT--------------------------------) >> %LOG%

rem * Run the FP command-line utilities to "CHECK" and "INSTALL/PUBLISH" the <hrReports> web site
owsadm.exe -o create -targetserver "http://hardev3:8080/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8080 -sp publish >> %LOG%

owsadm.exe -o recalc -targetserver "http://hardev3:8080/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8080 >> %LOG%

owsadm.exe -o check -targetserver "http://hardev3:8080/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8080 >> %LOG%

owsadm.exe -o check -targetserver "http://hardev3:8080/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8080 >> %LOG%

echo (-----END SCM BETA WEB CHECK REPORT----------------------------------) >> %LOG%
date /t >> %LOG% && time /t >> %LOG%

set LOG=

GOTO END

:ROOT

rem * Run linkchecker.bat to run checks of all links
REM perl c:\hScripts\mySCMLinkChecker.pl %1

rem * Set up variables to generate unique Log file name
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\SCManagementWebCheck_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

rem * Modify PATH variable to include location for the <owsadm.exe> command file
set PATH=%PATH%;C:\Program Files\Common Files\Microsoft Shared\web server extensions\50\bin

date /t > %LOG% && time /t >> %LOG%
echo (-----BEGIN SCM ROOT WEB CHECK REPORT--------------------------------) >> %LOG%

rem * Run the FP command-line utilities to "CHECK" and "INSTALL/PUBLISH" the <hrReports> web site
owsadm.exe -o create -targetserver "http://hardev3:8088/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8088 -sp publish >> %LOG%

owsadm.exe -o recalc -targetserver "http://hardev3:8088/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8088 >> %LOG%

owsadm.exe -o check -targetserver "http://hardev3:8088/_vti_bin/_vti_adm/fpadmdll.dll" -w "/SCManagement" -p 8088 >> %LOG%

owsadm.exe -o check -targetserver "http://hardev3:8088/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8088 >> %LOG%

echo (-----END SCM ROOT WEB CHECK REPORT----------------------------------) >> %LOG%
date /t >> %LOG% && time /t >> %LOG%

set LOG=

:END
:EOF