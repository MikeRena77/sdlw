@echo off
rem /*************************************************************************
rem *
rem * NAME        :  $Workfile:   setODBCNucDBFile.bat  $
rem *                $Revision:   1.1  $  
rem *                $Date:   Aug 26 1999 10:46:44  $
rem *
rem * DESCRIPTION :  See help at bottom of file
rem *
rem * MODIFICATION/REV HISTORY :
rem * $Log:   P:/vcs/cm/setODBCNucDBFile.batv  $
REM  
REM     Rev 1.1   Aug 26 1999 10:46:44   brettl
REM  changed param from applname to applrootdir
REM  this is compatible with the build scripts
REM  
REM     Rev 1.0   Aug 26 1999 09:32:18   brettl
REM  Initial revision.
REM *
REM * 
rem *************************************************************************/

if "%1"=="" goto :help
if "%1"=="-h" goto :help
if "%1"=="-H" goto :help


REM change the single backslash to a double backslash, like regedit needs

set ApplDir=%1%
set ApplDir=%ApplDir:\=\\%


REM create the temporary .reg file with the appropriate application dir

echo REGEDIT4 > tmpsetODBCNucDBFile.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI\Nucleus] >> tmpsetODBCNucDBFile.reg
echo "DatabaseFile"="%ApplDir%\\target\\database\\nucleus.db" >> tmpsetODBCNucDBFile.reg


REM apply the change to the registry

regedit.exe /s tmpsetODBCNucDBFile.reg


REM delete the temporary reg file

del /f/q tmpsetODBCNucDBFile.reg


goto :end


:help
echo "setODBCNucDBFile.bat
echo "
echo "This command changes the filename associated with the Nucleus ODBC
echo "connection.  This is useful with you are switching, say, between
echo "starter and chevron.
echo "
echo "It is also used in the build scripts to avoid the need for a human to
echo "check and change the ODBC settings every time a different application
echo "is build on the build PC.
echo "
echo "usage: setODBCNucDBFile <application root>
echo "example: setODBCNucDBFile D:\NSTARTER
echo "
echo "NOTE: no checking is performed on the application, typos are happily
echo "      accepted
echo "
echo "ASSUMPTION: nucleus.db is located in the standard build directory
echo "            (<application root>\target\database\nucleus.db)

:end


