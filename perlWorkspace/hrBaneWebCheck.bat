@echo off
rem ***************************************************************************************
rem *Header: hrBaneWebCheck.bat, v1.0, 10/05/2009 mha                                                                           *
rem * Batch script used to run the FP check and publish commands on the test site
rem *        http://bane-serverSpecifier-webSpecifier.aafes.com//web
rem *        on BANE but launched from HARDEV2
rem *
rem * Usage: hrBaneWebCheck.bat web webPath a
rem *     where:
rem *         web = the specific web under \Inetpub\webPath and
rem *         webPath = a specific web under \Inetpub
rem *         a => do a complete web check (all) of the entire webPath
rem *
rem * Original coding 10-05-2009
rem *    by Michael Andrews (MHA)
rem *    for AAFES HQ
rem *
rem * Version     Date        by    Change Description
rem *   1.0      10/05/2009   MHA   New script for automating the webcheck on BANE launched from HARDEV2
rem *   1.1      10/09/2009   MHA   Corrected the order of parameter passing in the call to hrWebCheck.bat
rem *
rem ***************************************************************************************

rem * Call to the batch script that handles setting Read-Only attributes off before FP command-line
set WEB=%1
set WEBPATH=%2
rem * Set up variables to generate unique Log file name
:START
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\hrBaneWebCheck_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log
echo %WEB% %WEBPATH%
echo -----BEGIN hrBaneWebCheck REPORT------------------------------

rem We need to launch the process on Bane  to run the web check for the web
echo (hexecp -b PRODSWA -prg "c:\hScripts\hrWebCheck.bat %WEB% %WEBPATH%" -m BANE -syn -er "%CA_SCM_HOME%\bane.dfo" -wts -oa %LOG%)
hexecp -b PRODSWA -prg "c:\hScripts\hrWebCheck.bat %WEB% %WEBPATH%" -m BANE -syn -er "%CA_SCM_HOME%\bane.dfo" -wts -oa %LOG%
echo -----END hrBaneWebCheck REPORT--------------------------------
:END
exit
:EOF
