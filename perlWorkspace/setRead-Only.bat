set target=""
set webPath=
set scripDir=
set extens=

rem set target=%2\%1 && echo "%target%"
rem pause
rem set webPath=%2 && echo %webPath%
rem pause
set scripDir=C:\hScripts\logs && echo %scripDir%
pause
set extens=asax,aspx,config,cs,csproj,dll,licx,resx,webinfo,rpx,tmp,dll,rdf,gif,cab,asp,doc,htm,xml,disco,map,wsdl,pdb && echo %extens%
pause
rem * Set up variables to generate unique Log file name
set LOG=
pause
for /f "tokens=1,2,3 delims=: " %%a in ("%time%") do set hour=%%a&set minute=%%b&set second=%%c
set LOG=%scripDir%\setRead-OnlyBat_%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%_%minute%_%second:~0,2%.log
pause
for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 delims=, " %%a in ("%extens%") do "attrib -r %2\%1\*.%%a /s"
pause
FOR /R %2\%1 %%G IN (*.htm) DO attrib -r %%G