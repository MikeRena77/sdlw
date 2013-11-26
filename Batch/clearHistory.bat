@echo off
rem  ------------------------------------------------------------------------------------------------------------
rem - Header: startupExplorer.bat, v1.0, 10/25/2013 mha                                                              
rem - This batch script cleans the Temp, History and Temporary Internet Folders
rem -   
rem
rem -
rem - Usage: clearHistory.bat
rem -     no parameters are passed in because it launches automatically at session startup
rem -
rem - Written 10-25-2013
rem -     by Michael Andrews (MHA)
rem -     
rem - Version    Date       by   Change Description
rem -   1.0      10/25/2013  MHA  Clean Temp directories
rem  ------------------------------------------------------------------------------------------------------------
rem  
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG="C:\Users\502256043\Documents\working\logs\clearHistory%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log"

echo TODAY > %LOG%
date /t  >> %LOG%
time /t  >> %LOG%
title clearHistory.bat >> %LOG%
del /s /q /f "C:\Users\502256043\AppData\Local\Temp" >> %LOG%
dir "C:\Users\502256043\AppData\Local\Temp" >> %LOG%

del /s /q /f /a:h "C:\Users\502256043\AppData\Local\Microsoft\Windows\History" >> %LOG%
dir "C:\Users\502256043\AppData\Local\Microsoft\Windows\History" >> %LOG%

del /s /q /f /a:h "C:\Users\502256043\AppData\Local\Microsoft\Windows\Temporary Internet Files" >> %LOG%
dir "C:\Users\502256043\AppData\Local\Microsoft\Windows\Temporary Internet Files" >> %LOG%