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
set BKUP=\hScripts\conf\G9LHQH1EnvBkup.config
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=\hScripts\logs\g9lhqh1Env%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log
set PROJECT="AAFES Administrative Support"
set VIEWPATH=\SCMAdmin\conf"
set CLIENTPATH="c:\hScripts\conf"

reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /s > %BKUP%
rem hci Hardev3EnvBkup.config -b HARDEV1 -en %PROJECT% -st HarvestAdmin -vp %VIEWPATH% -p "Hardev3EnvironmentConfiguration" -uk -op p -cp %CLIENTPATH% -pn "Engineering Build CheckIn" -eh "%CA_SCM_HOME%\hsync.dfo" -oa "%LOG% -wts
type %BKUP% > %LOG%
