@echo off
rem  ------------------------------------------------------------------------------------------------------------
rem - Header: wipe.bat, v0.1, 11/21/2013 mha                                                              
rem - This batch script accepts a file name as parameter
rem -   It deletes the file %1 and recreates it as a zero length file
rem -   in effect wiping it
rem -
rem - Usage: wipe.bat
rem -     a file name must be passed as parameter on launch
rem -
rem - Written 11-21-2013
rem -     by Michael Andrews (MHA)
rem -     
rem - Version    Date        by   Change Description
rem -   0.1      11/21/2013  MHA  Wipe utility that deletes and recreates a file
rem
rem  ------------------------------------------------------------------------------------------------------------
rem  
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG="C:\Users\502256043\Documents\working\logs\wipe%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log"
set BACKUPDIR="C:\Users\502256043\Documents\working\backup"

echo TODAY > %LOG%
date /t  >> %LOG%
time /t  >> %LOG%

call setbuilder.bat >> %LOG%

if exist %1 goto checktouch >> %LOG%
goto error

:checktouch
if exist t del t >> %LOG%
touch t >> %LOG%
IF NOT EXIST t GOTO error >> %LOG%
del t

:wipeaction
copy /v /y %1 %BACKUPDIR% >> %LOG%
del /f /q %1 >> %LOG%
touch %1 >> %LOG%
goto end

:error
echo "Either you forgot to submit the file name or else the touch command is not in your PATH"

:end
echo FINISHED >> %LOG%
date /t  >> %LOG%
time /t  >> %LOG%

