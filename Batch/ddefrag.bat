rem Batch file for recurring task to keep system drive defragmented
rem Schedule this as a recurring daily or periodic task
rem The defrag operation screen output will be captured in a log under a logs directory
rem The log name is generated in such a way as to identify the date and time of the defrag operation
rem Date:	This has been around for a while but I'm adding clarification
rem Author:     Michael Andrews
rem 
rem Usage:      at the prompt>ddefrag
rem             or as a task, just identify the file

for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=logs\%date:~4,2%_%date:~7,2%_%date:~10,4%.log

defrag c: -f -v > %LOG%