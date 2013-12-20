@echo off
echo This command is only good for older Windows systems where 
echo     the command file ntbackup still exists
echo Are you sure you want to attempt this command sequence?
echo ntbackup backup systemstate /J "Backup Job 1" /F "C:\compare\2s5jy51\backup_%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%-%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%.bkf"
pause
ntbackup backup systemstate /J "Backup Job 1" /F "C:\compare\2s5jy51\backup_%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%-%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%.bkf"