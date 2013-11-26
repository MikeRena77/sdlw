@echo off
rem  ------------------------------------------------------------------------------------------------------------
rem - Header: allFusionEnv.bat, v1.0, 8/14/2008 mha                                                              
rem - This batch script makes direct changes to the registry of Hardev1 in order to allow
rem -   switching between Harvest Change Manager r7.1 and Software Change Manager r12
rem - This file applies the environment setting for Harvest
rem -
rem - Usage: allFusionEnv.bat
rem -     where:
rem -         both this batch file and its corresponding .reg file exist in the same directory
rem -
rem - Written 8-14-2008
rem -     by Michael Andrews (MHA)
rem -     for AAFES HQ
rem - Version    Date       by   Change Description
rem -   1.0      8/14/2008  MHA  Switch to Environment settings for AllFusion Harvest Change Manager
rem  ------------------------------------------------------------------------------------------------------------
rem  
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=\hScripts\logs\allFusionEnv%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log

touch %LOG%
reg import allFusionEnv.reg
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /s >> %LOG%

set DT="\Documents and Settings\All Users\Desktop"
echo %DT% >> %LOG%

cd /d %DT%
cd >> %LOG%

set harFlag=%DT%\Harvest.flag
set scmFlag=%DT%\SCM.flag
set lagFlag=%DT%\nowSetForLAG.flag

if exist %scmFlag% del %scmFlag%
if exist %harFlag% del %harFlag%
if exist %lagFlag% del %lagFlag%

touch %harFlag%

echo rebooting at %DATE% %TIME% >> %LOG%
shutdown /r /f /c "Reboot for flipping to AllFusion Harvest Change Manager r7.1 Environment" >> %LOG%