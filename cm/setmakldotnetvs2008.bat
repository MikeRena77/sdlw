rem @echo off
rem *************************************************************************
rem NAME        : $Workfile:   setmakldotnet.bat  $
rem               $Revision:   1.0  $  
rem               $Date:   16 Dec 2004 10:38:16  $
rem 
rem DESCRIPTION : Call vcvars32.bat then call maklocaldotnet.  Only intended to be
rem               called by basebld and applbld scripts.
rem 
rem TARGET:       DOS 
rem 
rem MODIFICATION/REV HISTORY :
rem
rem $Log:   P:/vcs/cm/setmakldotnet.batv  $
REM  
REM     Rev 1.0   16 Dec 2004 10:38:16   SMcBrayer
REM  Initial revision.
rem *************************************************************************/

if "%1"==""       goto help
if "%1"=="-h"     goto help
if "%1"=="-H"     goto help
if "%1"=="help"   goto help
if "%1"=="HELP"   goto help

rem  start .NET build is separate DOS session
start "Build .NET Solutions" /WAIT /I setmakldotnetmakvs2008.bat %1 %2 %3 %4

goto end

:help
echo  ********** SetupBld and Invoke MakLocalDotNET**********************
echo  *                                                                 *
echo  *  Helper script for applbld.cmd and basebld.cmd                  *
echo  *     NOT intended for command-line use                           *
echo  *                                                                 *
echo  *Syntax: setmakldotnet target nbase_root [nappl_root] [build_type]*
echo  *                                                                 *
echo  *  Where build_type is:                                           *
echo  *     SM_PRODUCTION - production SmartHeap (the default)          *
echo  *     SM_DEBUG      - memory debug SmartHeap                      *
echo  *     SYMBOLS       - no SmartHeap, but with debug                *
echo  *                                                                 *
echo  *******************************************************************

:end
