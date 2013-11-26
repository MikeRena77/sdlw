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
rem  ------------------------------------------------------------------------------------------------------------
rem  
@echo off
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG="C:\Documents and Settings\andrewsmic\My Documents\working\logs\telnet%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log"

touch %LOG%

cd %DT%
call tnProd.bat

call tnDev.bat

rem DEVRMSDB is now reporting that telnet login is not allowed for cascm - 23 Dec 2009
rem call tnrmsdb.bat

title WindowTwo available for reuse
cd %USERPROFILE%
rem exit

