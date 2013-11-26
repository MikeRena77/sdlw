rem Batch file for recurring task to keep system drive defragmented
rem Schedule this as a recurring daily or periodic task
rem The defrag operation screen output will be captured in a log under a logs directory
rem The log name is generated in such a way as to identify the date and time of the defrag operation
rem Author:                                     Michael Andrews
rem Date deployed to HARDEV3:  21 Mar 08
rem Usage:                                       at the prompt>defrag
rem                or as a task, just identify the file

for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=logs\%date:~4,2%_%date:~7,2%_%date:~10,4%.log

defrag c: -f -v > %LOG%