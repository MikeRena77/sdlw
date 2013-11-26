rem ***************************************************************************************
rem * Batch script used to setup for the FP check and publish commands on the test site
rem *        http://bane/h3-beta/hrReports
rem *        on BANE
rem *
rem * Written 2-21-2008
rem *    by Michael Andrews
rem *    for AAFES HQ
rem *     version 1.1
rem *     - Modified to generate unique log file name on every run
rem ***************************************************************************************

rem * Set up variables to generate unique Log file name
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=c:\hScripts\logs\cleaningHrReportsBeta_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log

rem * Apply time stamp internally to file
date /t >> %LOG%
time /t >> %LOG%

rem * Set Read-Only attribute on for Harvest Check-Out
attrib.exe +r c:\inetpub\h3_beta\hrReports\*.* /s >> %LOG%

rem * Clean up any previous Studio-generated SCC files
del /F /S /Q /A:H \inetpub\h3_beta\hrReports\*.scc >> %LOG%