@echo off
rem ***************************************************************************************
rem *Header: hexiSwap.bat, v1.0, 10/22/2008 mha                                                                           *
rem * Batch script used to convert hexadecimal values in an output file to their ASCII representations
rem *
rem * This script takes an input of a file generated from a DOS >reg export ... command
rem *        and converts the hexadecimal to ASCII to provide the actual PATH value, etc
rem *
rem * Usage: hexiSwap.bat regExportOutputFile
rem *     where:
rem *         regExportOutputFile = the product of a DOS >reg export command
rem *
rem * Original coding 10-22-2008
rem *    by Michael Andrews (MHA)
rem *    for AAFES HQ
rem *
rem * Version     Date        by    Change Description
rem *   1.0       10/22/2008  MHA   Initially written to convert hexadecimal to ASCII
rem *
rem ***************************************************************************************
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=\hScripts\logs\hexiSwap%date:~4,2%_%date:~7,2%_%date:~10,4%_%hour%_%minute%.log

rem This is the start of the sed commands that will process the hexToAscii conversion
sed -i "s/\\\r//g" %1 >> %LOG%
sed -i "s/00\r/\r\n/g" %1 >> %LOG%
sed -i "s/\r/\r\n/g" %1 >> %LOG%
sed -i "s/,/, /g" %1 >> %LOG%
sed -i "s/hex(2):/hex(2): /g" %1 >> %LOG%
sed -i "s/ 00,//g" %1 >> %LOG%
sed -i "s/ 30,/0/g" %1 >> %LOG%
sed -i "s/ 31,/1/g" %1 >> %LOG%
sed -i "s/ 32,/2/g" %1 >> %LOG%
sed -i "s/ 33,/3/g" %1 >> %LOG%
sed -i "s/ 34,/4/g" %1 >> %LOG%
sed -i "s/ 35,/5/g" %1 >> %LOG%
sed -i "s/ 36,/6/g" %1 >> %LOG%
sed -i "s/ 37,/7/g" %1 >> %LOG%
sed -i "s/ 38,/8/g" %1 >> %LOG%
sed -i "s/ 39,/9/g" %1 >> %LOG%
sed -i "s/ 41,/A/g" %1 >> %LOG%
sed -i "s/ 42,/B/g" %1 >> %LOG%
sed -i "s/ 43,/C/g" %1 >> %LOG%
sed -i "s/ 44,/D/g" %1 >> %LOG%
sed -i "s/ 45,/E/g" %1 >> %LOG%
sed -i "s/ 46,/F/g" %1 >> %LOG%
sed -i "s/ 47,/G/g" %1 >> %LOG%
sed -i "s/ 48,/H/g" %1 >> %LOG%
sed -i "s/ 49,/I/g" %1 >> %LOG%
sed -i "s/ 4a,/J/g" %1 >> %LOG%
sed -i "s/ 4b,/K/g" %1 >> %LOG%
sed -i "s/ 4c,/L/g" %1 >> %LOG%
sed -i "s/ 4d,/M/g" %1 >> %LOG%
sed -i "s/ 4e,/N/g" %1 >> %LOG%
sed -i "s/ 4f,/O/g" %1 >> %LOG%
sed -i "s/ 50,/P/g" %1 >> %LOG%
sed -i "s/ 51,/Q/g" %1 >> %LOG%
sed -i "s/ 52,/R/g" %1 >> %LOG%
sed -i "s/ 53,/S/g" %1 >> %LOG%
sed -i "s/ 54,/T/g" %1 >> %LOG%
sed -i "s/ 55,/U/g" %1 >> %LOG%
sed -i "s/ 56,/V/g" %1 >> %LOG%
sed -i "s/ 57,/W/g" %1 >> %LOG%
sed -i "s/ 58,/X/g" %1 >> %LOG%
sed -i "s/ 59,/Y/g" %1 >> %LOG%
sed -i "s/ 5a,/Z/g" %1 >> %LOG%
sed -i "s/ 5b,/[/g" %1 >> %LOG%
sed -i "s/ 5c,/\\/g" %1 >> %LOG%
sed -i "s/ 5d,/]/g" %1 >> %LOG%
sed -i "s/ 5e,/^/g" %1 >> %LOG%
sed -i "s/ 5f,/_/g" %1 >> %LOG%
sed -i "s/ 60,/'/g" %1 >> %LOG%
sed -i "s/ 61,/a/g" %1 >> %LOG%
sed -i "s/ 62,/b/g" %1 >> %LOG%
sed -i "s/ 63,/c/g" %1 >> %LOG%
sed -i "s/ 64,/d/g" %1 >> %LOG%
sed -i "s/ 65,/e/g" %1 >> %LOG%
sed -i "s/ 66,/f/g" %1 >> %LOG%
sed -i "s/ 67,/g/g" %1 >> %LOG%
sed -i "s/ 68,/h/g" %1 >> %LOG%
sed -i "s/ 69,/i/g" %1 >> %LOG%
sed -i "s/ 6a,/j/g" %1 >> %LOG%
sed -i "s/ 6b,/k/g" %1 >> %LOG%
sed -i "s/ 6c,/l/g" %1 >> %LOG%
sed -i "s/ 6d,/m/g" %1 >> %LOG%
sed -i "s/ 6e,/n/g" %1 >> %LOG%
sed -i "s/ 6f,/o/g" %1 >> %LOG%
sed -i "s/ 70,/p/g" %1 >> %LOG%
sed -i "s/ 71,/q/g" %1 >> %LOG%
sed -i "s/ 72,/r/g" %1 >> %LOG%
sed -i "s/ 73,/s/g" %1 >> %LOG%
sed -i "s/ 74,/t/g" %1 >> %LOG%
sed -i "s/ 75,/u/g" %1 >> %LOG%
sed -i "s/ 76,/v/g" %1 >> %LOG%
sed -i "s/ 77,/w/g" %1 >> %LOG%
sed -i "s/ 78,/x/g" %1 >> %LOG%
sed -i "s/ 79,/y/g" %1 >> %LOG%
sed -i "s/ 7a,/z/g" %1 >> %LOG%
sed -i "s/ 20,/ /g" %1 >> %LOG%
sed -i "s/ 25,/%%/g" %1 >> %LOG%
sed -i "s/ 2d,/-/g" %1 >> %LOG%
sed -i "s/ 2e,/./g" %1 >> %LOG%
sed -i "s/ 2f,/\//g" %1 >> %LOG%
sed -i "s/ 3a,/:/g" %1 >> %LOG%
sed -i "s/ 3b,/;/g" %1 >> %LOG%
sed -i "s/ 32,//g" %1 >> %LOG%
sed -i "s/ 7b,/{/g" %1 >> %LOG%
sed -i "s/ 7c,/|/g" %1 >> %LOG%
sed -i "s/ 7d,/}/g" %1 >> %LOG%
sed -i "s/ 7e,/~/g" %1 >> %LOG%
sed -i "s/ 7f,/DEL/g" %1 >> %LOG%
sed -i "s/  //g" %1 >> %LOG%