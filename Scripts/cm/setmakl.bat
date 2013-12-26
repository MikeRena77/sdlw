@echo off
rem *************************************************************************
rem NAME        : $Workfile:   setmakl.bat  $
rem               $Revision:   1.1  $  
rem               $Date:   May 18 1998 11:02:50  $
rem 
rem DESCRIPTION : Call setupbld then call maklocal.  Only intended to be
rem               called by basebld and applbld scripts.  Solves the problem
rem               of needing to call a build-specific version of setvdisk
rem               before the build has been extracted from pvcs.
rem 
rem TARGET:       DOS (but can be run from OS/2 session)
rem 
rem MODIFICATION/REV HISTORY :
rem $Log:   P:/vcs/cm/setmakl.batv  $
REM  
REM     Rev 1.1   May 18 1998 11:02:50   DavidC
REM  code review change - added help gotos in case someone invokes by hand
REM  
REM     Rev 1.0   May 11 1998 17:54:12   DavidC
REM  Initial revision.
rem *************************************************************************/

if "%1"==""       goto help
if "%1"=="-h"     goto help
if "%1"=="-H"     goto help
if "%1"=="help"   goto help
if "%1"=="HELP"   goto help

rem %1      - maklocal's target
rem %2 - %4 - setupbld's arguments

call setupbld %2 %3 %4
call rexx maklocal %1
echo %errorlevel% >setmakl.rc
goto end

:help
echo  ********** SetupBld and Invoke MakLocal ***************************
echo  *                                                                 *
echo  *  Helper script for applbld.cmd and basebld.cmd                  *
echo  *     NOT intended for command-line use                           *
echo  *                                                                 *
echo  *  Syntax: setmakl target nbase_root [nappl_root] [build_type]    *
echo  *                                                                 *
echo  *  Where build_type is:                                           *
echo  *     SM_PRODUCTION - production SmartHeap (the default)          *
echo  *     SM_DEBUG      - memory debug SmartHeap                      *
echo  *     SYMBOLS       - no SmartHeap, but with debug                *
echo  *                                                                 *
echo  *******************************************************************

:end
