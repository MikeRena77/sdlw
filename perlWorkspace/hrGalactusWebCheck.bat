@echo off
rem ***************************************************************************************
rem *Header: hrGalactusWebCheck.bat, v1.0, 10/09/2009 mha                                                                           *
rem * Batch script used to run the FP check and publish commands on the test site
rem *        http://galactus-serverSpecifier-webSpecifier.aafes.com//web
rem *        on GALACTUS but launched from HARDEV2
rem *
rem * Usage: hrGalactusWebCheck.bat web webPath a
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
rem *   1.0      10/09/2009   MHA   New script for automating the webcheck on GALACTUS launched from HARDEV2
rem *
rem ***************************************************************************************

rem * Call to the batch script that handles setting Read-Only attributes off before FP command-line
set WEB=%1
set WEBPATH=%2
rem * Set up variables to generate unique Log file name
:START
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\hrGalactusWebCheck_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log
echo %WEB% %WEBPATH%
echo -----BEGIN hrGalactusWebCheck REPORT------------------------------

rem We need to launch the process on Galactus  to run the web check for the web
echo (hexecp -b PRODSWA -prg "c:\hScripts\hrWebCheck.bat %WEB% %WEBPATH%" -m GALACTUS -syn -er "%CA_SCM_HOME%\galactus.dfo" -wts -oa %LOG%)
hexecp -b PRODSWA -prg "c:\hScripts\hrWebCheck.bat %WEB% %WEBPATH%" -m GALACTUS -syn -er "%CA_SCM_HOME%\galactus.dfo" -wts -oa %LOG%
echo -----END hrGalactusWebCheck REPORT--------------------------------
:END
exit
:EOF
