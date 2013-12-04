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
rem -   1.1      12/04/2013  MHA  Changed log file variable for disambiguation with additional notifications
rem  ------------------------------------------------------------------------------------------------------------
rem  
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set HLOG="C:\Users\502256043\Documents\working\logs\clearHistory%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log"

echo TODAY > %HLOG%
date /t  >> %HLOG%
time /t  >> %HLOG%
title clearHistory.bat >> %HLOG%
echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo "START! Reminder: when this batch is run embedded inside another job..."
echo "...this clearHistory.bat will attempt to delete files under temp directories..."
echo "...some will return access errors because not all temp files can be deleted."
del /s /q /f "C:\Users\502256043\AppData\Local\Temp" >> %HLOG%
dir "C:\Users\502256043\AppData\Local\Temp" >> %HLOG%

del /s /q /f /a:h "C:\Users\502256043\AppData\Local\Microsoft\Windows\History" >> %HLOG%
dir "C:\Users\502256043\AppData\Local\Microsoft\Windows\History" >> %HLOG%

del /s /q /f /a:h "C:\Users\502256043\AppData\Local\Microsoft\Windows\Temporary Internet Files" >> %HLOG%
dir "C:\Users\502256043\AppData\Local\Microsoft\Windows\Temporary Internet Files" >> %HLOG%
echo "If any errors were encountered since this job's START, they belong to clearHistory.bat"
echo "Ending clearHistory.bat"
echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
