rem @echo off
rem *************************************************************************
rem NAME        : $Workfile:   setmakldotnetmak.bat  $
rem               $Revision:   1.2  $  
rem               $Date:   14 Apr 2005 13:59:08  $
rem 
rem DESCRIPTION : Call vcvars32.bat then call maklocaldotnet.  Only intended to be
rem               called by setmaldotnet.bat.
rem 
rem TARGET:       DOS in separate session
rem 
rem MODIFICATION/REV HISTORY :
rem
rem $Log:   P:/vcs/cm/setmakldotnetmak.batv  $
REM  
REM     Rev 1.2   14 Apr 2005 13:59:08   LJanosek
REM  Added comment describing the unregistration of COMDevice dll.
REM  
REM     Rev 1.1   28 Feb 2005 10:25:28   GraceP
REM  modified to explicitly copy *.dll and *.exe to the misc directory.
REM  
REM     Rev 1.0   16 Dec 2004 10:38:36   SMcBrayer
REM  Initial revision.
rem *************************************************************************/

rem setup .NET environment
call "%VS71COMNTOOLS%vsvars32.bat"
call setupbld %2 %3 %4
cd wayne.net
del waynedotnet.out
del waynecommon\*.dll /s

rem cleanup .NET Compact Framework references
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\Win32Wrapper.dll
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\cmn*.dll
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\da*.dll
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\br*.dll
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\fc*.dll

rem invoke maklocaldotnet to build .NET solutions 
call rexx maklocaldotnet %1 %3
echo %errorlevel% >setmakldotnet.rc
xcopy setmakldotnet.rc ..\ /y/r

rem - unregister the registration done at the time of build, since the DLL gets moved to target\bin and 
rem - registered there. This only undoes any registrations in releases prior to base 15.00.c. This
rem - DLL is no longer part of the nucleus build process, hence this will have no effect after 15.00.b.
c:\windows\microsoft.net\framework\v1.1.4322\regasm.exe /silent /codebase /unregister waynecommon\DeviceManager\DeviceManagerSolution\COMfcDevice\bin\COMDevice.dll

xcopy waynecommon\bin\*.dll ..\misc\*.dll /r/y
xcopy waynecommon\bin\*.exe ..\misc\*.exe /r/y

rem cleanup .NET Compact Framework references
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\Win32Wrapper.dll
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\cmn*.dll
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\da*.dll
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\br*.dll
del "C:\Program Files\Microsoft Visual Studio .NET 2003\CompactFrameworkSDK\v1.0.5000\Windows CE\fc*.dll

exit