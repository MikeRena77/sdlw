@echo off
IF [%1]==[] GOTO missingparam
set TEST=%1
set TESTTILDE=%~1
echo %TEST%
echo %TESTTILDE%
IF DEFINED TEST GOTO END
:missingparam
set JRE_HOME=
set JRE_HOME=C:\bin\Java\jdk1.7.0_45\jre
set PATH=
set PATH=c:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE;c:\Program Files\Microsoft Visual Studio 9.0\VC\BIN;c:\Program Files\Microsoft Visual Studio 9.0\Common7\Tools;c:\Windows\Microsoft.NET\Framework\v3.5;c:\Windows\Microsoft.NET\Framework\v2.0.50727;c:\Program Files\Microsoft Visual Studio 9.0\VC\VCPackages;C:\Program Files\\Microsoft SDKs\Windows\v6.0A\bin;C:\Program Files\CA\SC\CAWIN\;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\CA\SC\Csam\SockAdapter\bin;C:\Program Files\CA\DSM\bin;C:\Program Files\CA\SC\CBB\;C:\PROGRA~1\CA\SC\CAM\bin;c:\Program Files\Microsoft SQL Server\90\Tools\binn\;C:\bin\GNU\GnuPG;C:\Dwimperl\perl\bin;C:\Dwimperl\perl\site\bin;C:\Dwimperl\c\bin;C:\bin\Java\jdk1.7.0_45\jre\bin;C:\bin\Java\jdk1.7.0_45\bin;C:\Program Files\Git\cmd;c:\bin\Beyond Compare 3;c:\bin\batch;c:\bin\Console2;c:\bin\Notepad++;\\wdswdevl\ntnuc\pnutil
call vsvars32.bat
set PROMS_OROOT=c:\temp\proms_oroot
set RELEASE_TESTING=1
set TEST_AUTHOR=1
set VDISK=c:\VDISK
IF NOT EXIST e: subst e: c:\temp\e
:END

dir "\\GENPITFI01.og.ge.com\Wayne_aus1\groups"