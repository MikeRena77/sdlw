@echo off
rem ***************************************************************************************
rem *  Filename:  runXPSjob.bat
rem *  Batch script used to check out specific files to a newly generated folder
rem *   - bearing the name of the package to which the version(s) belong
rem * 
rem *  Check out occurs on the VENOM server under the \XPS directory
rem *  The command line is runXPSjob.bat $user
rem *  Variable passed in:  user = the username in Harvest
rem * 
rem *  Written 2-02-2009
rem *    by Michael Andrews
rem *    for AAFES HQ
rem *  Version    Date       by   Change Description
rem *    1.0      2/2/2009  MHA  Script written to coordinate between Harvest and Endevor
rem *    1.1      2/3/2009  MHA  Modification to put "email" handling in and then subsequently moved to X-hsyncUDP_createFolderWithPkgName.pl
rem *
rem ***************************************************************************************

set PATH=%PATH%;C:\Program Files\UnxUtils\bin;C:\Program Files\UnxUtils\usr\local\wbin
set LOG=
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\runXPSjob_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

date /t > %LOG% && time /t >> %LOG%
echo(-----BEGIN %LOG% REPORT--------------------------------) >> %LOG%
cd \XPS >> %LOG%
rem *      set USER=%1
rem *      echo %USER% >> %LOG%
rem *      echo sed "s/myname/%USER%/g" \hscripts\userEmail.sql.sav >> %LOG%
rem *      sed "s/myname/%USER%/g" \hscripts\userEmail.sql.sav > userEmail.sql
rem *      type userEmail.sql >> %LOG%
rem *      sed "s/myname/\"%USER%\"/g" \hscripts\userEmail.sql.sav >> %LOG%

rem *      echo 'hsql -b PRODSWA -f userEmail.sql -nh -o email' >> %LOG%
rem *      hsql -b PRODSWA -f userEmail.sql -nh -eh "%HARVESTHOME%\hsync.dfo" -o email

attrib -r *.* /s /d

XPSjob.bat >> %LOG%

echo(-------END %LOG% REPORT--------------------------------) >> %LOG%