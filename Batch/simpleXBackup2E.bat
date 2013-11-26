rem An alternative for using the archive bit (/m) in copying files
rem at some point in the future I may want to switch to /d instead of /m
rem /d only copies the source over the destination where source is newer
rem also discovered the /h allows for copying hidden and system files

for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG="C:\Users\502256043\Documents\working\logs\update_%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.notes"

cd /d e:\Documents
cd /d c:\Users\502256043\Documents
dir /a:d /b  >> %LOG%
cd
IF NOT [%1]==[] pause
xcopy *.* e: /m /s /e /c /f /r /y >> %LOG%

cd /d e:\Downloads
cd /d c:\Users\502256043\Downloads
cd
IF NOT [%1]==[] pause
xcopy *.* e: /m /s /e /c /f /r /y >> %LOG%

cd /d e:\workspace
cd /d c:\Users\502256043\workspace
cd
IF NOT [%1]==[] pause
xcopy *.* e: /m /h /s /e /c /f /r /y >> %LOG%

