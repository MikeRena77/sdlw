@echo off
rem ***************************************************************************************
rem *Header: webCheck.bat, v1.0, 4/2/2008 07:30 mha                                                                           *
rem * Batch script used to run the FP check and publish commands on the test site
rem *        http://bane-h3-webSpecifier.aafes.com//hrReports
rem *        on BANE
rem *
rem * This script expects to find all necessary files already in-place
rem *        It should be run after its respective Harvest Check Out process
rem *        has been successfully completed.
rem *
rem * Usage: webCheck.bat web webPath
rem *     where:
rem *         web = the specific web under \Inetpub\webPath and
rem *         webPath = a specific web under \Inetpub
rem *
rem * Original coding 4-2-2008; ported for PRODSWA 4/15/2008
rem *    by Michael Andrews (MHA)
rem *    for AAFES HQ
rem *
rem * Version     Date        by    Change Description
rem *   1.0       4/02/2008   MHA   Initially written to handle generic webs on HARDEV3
rem *   1.1       4/10/2008   MHA   Fixed the problems with assigning port # where variable "substring" handling wasn't working
rem *   1.2       4/15/2008   MHA   Ported script to PRODSWA for testing build web sites on HARDEV2
rem *   1.3       5/22/2008   MHA   Added handling for h3_qa (QA) and h3 (GOLD) servers
rem *
rem ***************************************************************************************

rem * Call to the batch script that handles setting Read-Only attributes off before FP command-line
call c:\hScripts\unsetRead.bat %1 %2

IF %2 EQU h3_alpha GOTO H3_ALPHA
IF %2 EQU h3_beta GOTO H3_BETA
IF %2 EQU h3_qa GOTO H3_QA
IF %2 EQU h3 GOTO H3

:H3_ALPHA
set FPSEADM=http://bane-h3-alpha.aafes.com/_vti_bin/_vti_adm/fpadmdll.dll
set PORT=/LM/W3SVC/587179803
echo %FPSEADM% >test
echo %PORT% >>test
goto START

:H3_BETA
set FPSEADM=http://bane-h3-beta.aafes.com/_vti_bin/_vti_adm/fpadmdll.dll
set PORT=/LM/W3SVC/1931390814
echo %FPSEADM% >test
echo %PORT% >>test
goto START

:H3_QA
set FPSEADM=http://bane-h3-qa.aafes.com/_vti_bin/_vti_adm/fpadmdll.dll
set PORT=/LM/W3SVC/1091813327
echo %FPSEADM% >test
echo %PORT% >>test
goto START

:H3
set FPSEADM=http://galactus-h3-gold.aafes.com/_vti_bin/_vti_adm/fpadmdll.dll
set PORT=/LM/W3SVC/1492830429
echo %FPSEADM% >test
echo %PORT% >>test
goto START

rem * Set up variables to generate unique Log file name
:START
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\genericWebCheck_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.rtf

rem * Modify PATH variable to include location for the <owsadm.exe> command file
set PATH=%PATH%;C:\Program Files\Common Files\Microsoft Shared\web server extensions\50\bin

rem # Launching the individual FP Server commands from the command-line
owsadm.exe -o create -targetserver %FPSEADM% -w "%1" -p %PORT% -sp publish >> %LOG%
owsadm.exe -o recalc -targetserver %FPSEADM% -w "%1" -p %PORT% >> %LOG%
owsadm.exe -o check -targetserver %FPSEADM% -w "%1" -p %PORT% >> %LOG%

rem # Launching a FP Server check for the root level of the web server
owsadm.exe -o check -targetserver %FPSEADM% -w "/" -p %PORT% >> %LOG%

:END
exit
:EOF