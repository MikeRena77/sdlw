del /s /f /q *FilesDB.xml
rem copy NUL batchFilesDB.xml
fciv -add Batch -r -bp %CD% -xml batchFilesDB.xml
rem copy NUL cmFilesDB.xml
fciv -add cm -r -bp %CD% -xml cmFilesDB.xml
rem copy NUL perlFilesDB.xml
fciv -add perlWorkspace -r -bp %CD% -xml perlFilesDB.xml
rem copy NUL researchFilesDB.xml
fciv -add research -r -bp %CD% -xml researchFilesDB.xml
rem copy NUL scriptsFilesDB.xml
fciv -add Scripts -r -bp %CD% -xml scriptsFilesDB.xml
rem copy NUL teamFilesDB.xml
fciv -add TeamBuildTypes -r -bp %CD% -xml teamFilesDB.xml
rem copy NUL tfsFilesDB.xml
fciv -add tfsWorking -r -bp %CD% -xml tfsFilesDB.xml
rem copy NUL vbFilesDB.xml
fciv -add vb -r -bp %CD% -xml vbFilesDB.xml
exit
