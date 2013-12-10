@echo off
reg import %1
if [%2]==[] goto end
cd /d e:\TFS_BuildOutPuts
icacls %2 /grant genpitfi01\502194519:F
:end
