@echo off
rem *************************************************************************
rem NAME        : $Workfile:   dailybuildtimer.bat  $
rem               $Revision:   1.2  $  
rem               $Date:   05 Aug 2002 09:45:06  $
rem 
rem DESCRIPTION : This script is run on the build PC and starts the dailybuild
rem               script every 24 hours.
rem
rem               The script is an infinite loop with a 24 hour sleep command.
rem
rem               The script initially sleeps 8 hours. Just in case
rem
rem NOTE: This script was originally written in perl and originally always
rem       started the daily build script at 1am.  For some reason REXX would
rem       intermittently fail when a perl sript started a perl script that
rem       started a rexx script.  The .BAT file seems to working okay.
rem 
rem MODIFICATION/REV HISTORY :
rem $Log:   P:/vcs/cm/dailybuildtimer.batv  $
REM  
REM     Rev 1.2   05 Aug 2002 09:45:06   CraigL
REM  Changes for new server.
REM  
REM     Rev 1.1   Jul 12 1999 14:35:24   BMaster
REM  removed "pause" that was there only for debugging
REM  
REM     Rev 1.0   Jul 09 1999 12:17:46   brettl
REM  Initial revision.
REM  
rem *************************************************************************/

if "%1"==""       goto help
if "%1"=="-h"     goto help
if "%1"=="-H"     goto help



set /a SLEEP_SECONDS=%1% * 3600
echo %SLEEP_SECONDS%

time /t
net use /d p:
net use p: \\wdswdevl\ntnuc

echo sleeping %1% hours
sleep %SLEEP_SECONDS%

:start
time /t
net use /d p:
net use p: \\wdswdevl\ntnuc
kill rxapi.exe
start perl p:\cm\dailybuild.pl REBUILD
time /t
echo sleeping 1 day
sleep 86400
goto :start


:help

echo Tool: dailybuildtimer.bat
echo Usage: dailybuildtimer.bat [initial delay in hours]
echo 
echo Example: dailybuildtimer 10
echo This example waits 10 hours before starting the daily build script
echo
echo This tool starts the daily build script after the specified time and
echo then every 24 hours.