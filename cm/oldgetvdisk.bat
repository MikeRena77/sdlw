@echo off
rem /* begin extraction */
rem /*************************************************************************
rem *
rem * NAME         :  $Workfile:   getvdisk.bat  $
rem *                 $Revision:   1.3  $  $Date:   11 Sep 2008 14:32:36  $
rem *                 $Logfile:   P:/vcs/cm/getvdisk.batv  $
rem *
rem *
rem * DESCRIPTION  :     Creates copy of necessary build files locally.
rem *                    Will get setvdisk.bat from the specified base's
rem *                    pvcs.  Will then run setvdisk which will delete any
rem *                    vdisk that exists and re-get.  The base version
rem *                    e.g. 146, 170, 160 is required.
rem *
rem * TARGET:            XP
rem *
rem * MODIFICATION/REV HISTORY :
rem * $Log:   P:/vcs/cm/getvdisk.batv  $
REM  
REM     Rev 1.3   11 Sep 2008 14:32:36   DGindler
REM  Added support for base 191
REM  
REM     Rev 1.2   18 Jun 2008 15:08:04   BMaster
REM  added base 19.5
REM  
REM     Rev 1.1   23 Apr 2008 12:32:48   GraceP
REM  modified base190 to use next190 label
REM  
REM     Rev 1.0   11 Feb 2008 11:52:02   NNixon
REM  Initial revision.
rem  
rem  2/11/08 added base174
rem  1/18/08 added base1351
rem  8/17/07 added base162
rem  6/21/07 added base173
rem  5/30/07 added base172
rem  5/08/07 added base190
rem  1/12/07 added base171
rem  1/9/07 added base161
rem  Initial revision.
rem *
rem *************************************************************************/
rem /* end extraction */
if "%1" == "-h" goto help:
if "%1" == "/h" goto help:
if "%1" == "help" goto help:
if "%1" == "HELP" goto help:
if "%1" == "?" goto help:
if "%1" == "/?" goto help:

rem set up paths
rem environmental variable VDISK must be set with the path before running setvdisk
if "%VDISK%" == "" goto help:

if "%1" == "" goto help:
if "%1" == "196" goto base196:
if "%1" == "200" goto base200:
if "%1" == "195" goto base195:
if "%1" == "191" goto base191:
if "%1" == "190" goto base190:
if "%1" == "174" goto base174:
if "%1" == "173" goto base173:
if "%1" == "172" goto base172:
if "%1" == "171" goto base171:
if "%1" == "170" goto base170:
if "%1" == "1705" goto base1705:
if "%1" == "160" goto base160:
if "%1" == "162" goto base162:
if "%1" == "161" goto base161:
if "%1" == "140" goto base140:
if "%1" == "146" goto base146:
if "%1" == "1461" goto base1461:
if "%1" == "147" goto base147:
if "%1" == "148" goto base148:
if "%1" == "130" goto base130:
if "%1" == "135" goto base135:
if "%1" == "1351" goto base135:

goto help:

:base170
echo get the setvdisk for base170 from pvcs.
get -vNEXT170 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base1705
echo get the setvdisk for base1705 from pvcs.
get -vNEXT1705 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base190
echo get the setvdisk for base190 from pvcs.
get -vNEXT190 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base191
echo get the setvdisk for base191 ( 190 ) from pvcs.
get -vNEXT190 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base195
echo get the setvdisk for base196 from pvcs.
get -vNEXT195 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base196
echo get the setvdisk for base196 from pvcs.
get -vNEXT196 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:


:base200
echo get the setvdisk for base200 from pvcs.
get -vNEXT -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base174
echo get the setvdisk for base174 from pvcs.
get -vNEXT174 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base173
echo get the setvdisk for base173 from pvcs.
get -vNEXT173 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base172
echo get the setvdisk for base172 from pvcs.
get -vNEXT172 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base171
echo get the setvdisk for base171 from pvcs.
get -vNEXT171 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base162
echo get the setvdisk for base162 from pvcs.
get -vNEXT162 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base161
echo get the setvdisk for base161 from pvcs.
get -vNEXT161 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base160
echo get the setvdisk for base160 from pvcs.
get -vNEXT160 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base140
echo get the setvdisk for base140 from pvcs.
get -vNEXT140 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base146
echo get the setvdisk for base146 from pvcs.
get -vNEXT146 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base1461
echo get the setvdisk for base1461 from pvcs.
get -vNEXT1461 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base147
echo get the setvdisk for base147 from pvcs.
get -vNEXT147 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base148
echo get the setvdisk for base148 from pvcs.
get -vNEXT148 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base130
echo get the setvdisk for base130 from pvcs.
get -vNEXT130 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:

:base135
echo get the setvdisk for base135 from pvcs.
get -vNEXT135 -w -y q:\vcs\bin\setvdisk.bat 
goto copyit:


:copyit
del d:\setvdisk.bat
cd d:\
copy q:\vcs\bin\setvdisk.bat
CALL d:\setvdisk.bat CLEAN
goto end:

:help
echo  ****** GetVDISK BUILD environment under XP *********
echo  *                                                     *
echo  *       Syntax: getvdisk 170                          *
echo  *                                                     *
echo  *        170 is an example of the base vdisk you want *
echo  *                                                     *
echo  *        170, 160, 148, 147, 146, 1461, 140, 135, 130 *
echo  *        171, 172, 173, 190, 191, 195, 200            *
echo  *        are presently supported                      *
echo  *                                                     *
echo  *        [env. var. VDISK must be set first]          *
echo  *        [ex.  set VDISK=d:\vdisk]                    *
echo  *        [min. of 200M needed on vdrive]              *
echo  *                                                     *
echo  *******************************************************

:end
