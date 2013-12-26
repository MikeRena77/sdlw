del /s /f /q *FilesDB.xml
rem copy NUL batchFilesDB.xml
if exist batchFilesDB.xml del /f /q batchFilesDB.xml
fciv -add Batch -r -bp %CD% -xml batchFilesDB.xml
rem copy NUL cmFilesDB.xml
if exist cmFilesDB.xml del /f /q cmFilesDB.xml
fciv -add cm -r -bp %CD% -xml cmFilesDB.xml
rem copy NUL perlFilesDB.xml
if exist perlFilesDB.xml del /f /q perlFilesDB.xml
fciv -add perlWorkspace -r -bp %CD% -xml perlFilesDB.xml
rem copy NUL researchFilesDB.xml
if exist researchFilesDB.xml del /f /q researchFilesDB.xml
fciv -add research -r -bp %CD% -xml researchFilesDB.xml
rem copy NUL scriptsFilesDB.xml
if exist scriptsFilesDB.xml del /f /q scriptsFilesDB.xml
fciv -add Scripts -r -bp %CD% -xml scriptsFilesDB.xml
rem copy NUL teamFilesDB.xml
if exist teamFilesDB.xml del /f /q teamFilesDB.xml
fciv -add TeamBuildTypes -r -bp %CD% -xml teamFilesDB.xml
rem copy NUL tfsFilesDB.xml
if exist tfsFilesDB.xml del /f /q tfsFilesDB.xml
fciv -add tfsWorking -r -bp %CD% -xml tfsFilesDB.xml
rem copy NUL vbFilesDB.xml
if exist vbFilesDB.xml del /f /q vbFilesDB.xml
fciv -add vb -r -bp %CD% -xml vbFilesDB.xml
exit
