@echo off
SET /a counter=0 
for /f %%a in ('type RELEASE.NUM 2^>nul') do ( 
  if %counter% GTR 1 goto continue 
  set LabelNumber=%%a
  set /a counter+=1 
 )

:continue
rem echo LabelNumber is: %LabelNumber%

