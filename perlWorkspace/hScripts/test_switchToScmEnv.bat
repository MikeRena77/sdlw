rem @echo off
rem  ------------------------------------------------------------------------------------------------------------
rem - Header: scmEnv.bat, v1.0, 8/14/2008 mha                                                                      
rem - This batch script makes direct changes to the registry of Hardev1 in order to allow
rem -   switching between Harvest Change Manager r7.1 and Software Change Manager r12
rem - This file applies the environment setting for SCM
rem -
rem - Usage: scmEnv.bat
rem -     where:
rem -         both this batch file and its corresponding .reg file exist in the same directory
rem -
rem - Written 8-14-2008
rem -     by Michael Andrews (MHA)
rem -     for AAFES HQ
rem - Version    Date       by   Change Description
rem -   1.0      8/14/2008  MHA  Switch to Environment settings for Software Change Manager
rem  ------------------------------------------------------------------------------------------------------------
rem  
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=\hScripts\logs\scmEnv%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log

touch %LOG%

reg import scmEnv.reg >> %LOG%
echo "LINE 23" >> %LOG%
type %LOG%
pause

set DT="\Documents and Settings\All Users\Desktop"
echo %DT% >> %LOG%
echo "LINE 29" >> %LOG%
type %LOG%
pause

cd %DT%
cd >> %LOG%
echo "LINE 35" >> %LOG%
type %LOG%
pause

set harFlag=%DT%\Harvest.flag
set scmFlag=%DT%\SCM.flag
set lagFlag=%DT%\nowSetForLAG.flag

echo "LINE 43" >> %LOG%
type %LOG%
pause

if exist %scmFlag% del %scmFlag%
if exist %harFlag% del %harFlag%
if exist %lagFlag% del %lagFlag%

echo "LINE 51" >> %LOG%
type %LOG%
pause

touch %scmFlag% >>%LOG%
echo "LINE 56" >> %LOG%
type %LOG%
pause

echo rebooting at %DATE% %TIME% >> %LOG%
shutdown /r /f /c "Reboot for flipping to SCM r12 Environment" >> %LOG%