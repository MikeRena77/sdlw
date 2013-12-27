@echo off
rem  ------------------------------------------------------------------------------------------------------------
rem - Header: loc.bat, v1.0, 12/27/2013 mha                                                              
rem - This batch reads a file and counts lines
rem -   
rem
rem -
rem - Usage: loc.bat filename
rem -        the file to be read is passed in 
rem -
rem - Written 12-27-2013
rem -     by Michael Andrews (MHA)
rem -     
rem - Version    Date       by   Change Description
rem -   1.0      12/27/2013  MHA  Read a file and count lines
rem -                            
rem  ------------------------------------------------------------------------------------------------------------
rem  
SET /a counter=0 
set /a LineCount=0

for /F %%I in ('type %1 2^>nul') do ( 
rem  echo %I
  set /a LineCount+=1
  set /a counter+=1 
 )

:continue
echo LineCount is: %LineCount%

