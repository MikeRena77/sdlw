@echo off
rem  ------------------------------------------------------------------------------------------------------------
rem - Header: startupExplorer.bat, v2.0, 1/22/2009 mha                                                              
rem - This batch script kicks off my desired Explorer windows on startup after logon
rem -   After launching 8 Explorer windows, it then launches a Telnet session
rem -   The Telnet session automatically echos back to a log => %LOG
rem -
rem - Usage: startupExplorer.bat
rem -     no parameters are passed in because it launches automatically at session startup
rem -
rem - Written 12-4-2008
rem -     by Michael Andrews (MHA)
rem -     for AAFES HQ
rem - Version    Date       by   Change Description
rem -   1.0      12/4/2008  MHA  Startup batch file used to launch windows I use in daily work
rem -   2.0      1/22/2009  MHA  Changed up the launching of Telnet to generate a unique log for each session
rem -   3.0      2/20/2009  MHA  Added another step before the telnet session to launch Clarity
rem -   3.1      8/05/2009  MHA  Added new line for opening my communications folder
rem -   3.2     10/26/2009  MHA  Commented out the launch of the ftp explorer window
rem -   3.3     10/25/2013  MHA  Completely revamped for the GE, Wayne Energy environment
rem -   3.4     11/18/2013  MHA  Added a new drive mapping for the new file share currently being set up
rem -   3.5     11/26/2013  MHA  Made setBuilder.bat a part of the initialization routine
rem -   3.6     12/04/2013  MHA  Changed log file variable for disambiguation
rem  ------------------------------------------------------------------------------------------------------------
rem  
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set ELOG="C:\Users\502256043\Documents\working\logs\startup%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log"

echo TODAY > %ELOG%
date /t  >> %ELOG%
time /t  >> %ELOG%
title startupExplorer.bat
rem sleep 30

call clearHistory.bat

call setBuilder.bat

if exist u:\ net use u: /delete
net use u: "\\genpitfi01.og.ge.com\Wayne_aus1\groups\Software Development\WDSWDEVL" /persistent:no
rem net use u: "\\tnwp010166.genpitfi01.og.ge.com\Wayne_aus1\groups\Systems Engineering" /persistent:no
rem if exist p:\ net use p: /delete
rem net use p: "\\GENPITFI01.og.ge.com\Wayne_aus1\groups\Software Development\WDSWDEVL" /persistent:no

if exist x:\ net use x: /delete
net use x: \\wdswdevl\ntnuc /persistent:no

if exist y:\ net use y: /delete
net use y: \\tnwp011355.genpitfi01.og.ge.com\TFSBuild_Source /persistent:no

if exist z:\ net use z: /delete
net use z: \\tnwp011355.genpitfi01.og.ge.com\TFS_BuildOutPuts /persistent:no

rem Computer
start EXPLORER.EXE /E, ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}

start EXPLORER.EXE /e, \bin\Batch

rem My Libraries
start EXPLORER.EXE /e, ::{031E4825-7B94-4dc3-B131-E946B44C8DD5}

rem My Documents
start EXPLORER.EXE /N, ::{450D8FBA-AD25-11D0-98A8-0800361B1103}

start EXPLORER.EXE /n, u:\

REM start EXPLORER.EXE /n, y:\

REM start EXPLORER.EXE /n, z:\

title Window available for reuse

cd %USERPROFILE%
cd  >> %ELOG%
echo StartUp Finished >> %ELOG%
date /t  >> %ELOG%
time /t  >> %ELOG%
rem exit

