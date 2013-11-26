@echo off
rem  ------------------------------------------------------------------------------------------------------------
rem - Header: reader.bat, v1.0, 11/13/2013 mha                                                              
rem - This batch reads a file RELEASE.NUM to the first space and stores the input as LabelNumber
rem -   
rem
rem -
rem - Usage: reader.bat
rem -     no parameters are passed in because it launches automatically at session startup
rem -
rem - Written 11-13-2013
rem -     by Michael Andrews (MHA)
rem -     
rem - Version    Date       by   Change Description
rem -   1.0      11/13/2013  MHA  Read a file to the first space and save the read character
rem -                             as the environment variable LabelNumber
rem  ------------------------------------------------------------------------------------------------------------
rem  
SET /a counter=0 
for /f %%a in ('type RELEASE.NUM 2^>nul') do ( 
  if %counter% GTR 1 goto continue 
  set LabelNumber=%%a
  set /a counter+=1 
 )

:continue
rem echo LabelNumber is: %LabelNumber%

