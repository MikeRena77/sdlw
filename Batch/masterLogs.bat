title masterLogs.bat
sleep 15
cd \log
start /min devMorningLogs.bat
start /min morningLogs.bat

start EXPLORER.EXE /e,"C:\log\harvest"

echo Do you want to start Clarity or abort?
pause
call clarity.bat
title Window available for reuse
rem exit
