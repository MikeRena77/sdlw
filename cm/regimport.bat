@echo off
reg import %1
if [%2]==[] goto end
cd /d e:\TFS_BuildOutPuts
icacls %2 /grant genpitfi01\502194519:F

rmdir /s /q E:\TFS_BuildOutPuts\FD0800_Dev_20131206.1
rmdir /s /q E:\TFS_BuildOutPuts\FD0800_Dev_20131206.1_Nucleus

net use u: "\\genpitfi01.og.ge.com\Wayne_aus1\groups\Software_Development\WDSWDEVL" /persistent:no
rmdir /s /q "U:\NTBase\Build\Test\N247_$(BuildNumber)"
:end
