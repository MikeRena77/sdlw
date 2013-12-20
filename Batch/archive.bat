@echo off
echo Did you remember to provide the zip file name: %1
pause

echo This is going to archive the files into your zip %1 
echo     by moving files in this directory %CD%
zip -Rmq -b "%CD%" %1 *.*
