echo If you provide pause as a parameter when running this batch
echo You will get the pause prompt between each set of checksums run
rem copy NUL batchFilesDB.xml
if exist batchFilesDB.xml del /f /q batchFilesDB.xml
fciv -add Batch -r -bp %CD% -xml batchFilesDB.xml
rem copy NUL cmFilesDB.xml
%1
if exist cmFilesDB.xml del /f /q cmFilesDB.xml
fciv -add cm -r -bp %CD% -xml cmFilesDB.xml
rem copy NUL perlFilesDB.xml
%1
if exist perlFilesDB.xml del /f /q perlFilesDB.xml
fciv -add perlWorkspace -r -bp %CD% -xml perlFilesDB.xml
rem copy NUL researchFilesDB.xml
%1
if exist researchFilesDB.xml del /f /q researchFilesDB.xml
fciv -add research -r -bp %CD% -xml researchFilesDB.xml
rem copy NUL scriptsFilesDB.xml
%1
if exist scriptsFilesDB.xml del /f /q scriptsFilesDB.xml
fciv -add Scripts -r -bp %CD% -xml scriptsFilesDB.xml
rem copy NUL teamFilesDB.xml
%1
if exist teamFilesDB.xml del /f /q teamFilesDB.xml
fciv -add TeamBuildTypes -r -bp %CD% -xml teamFilesDB.xml
rem copy NUL tfsFilesDB.xml
%1
if exist tfsFilesDB.xml del /f /q tfsFilesDB.xml
fciv -add tfsWorking -r -bp %CD% -xml tfsFilesDB.xml
rem copy NUL vbFilesDB.xml
%1
if exist vbFilesDB.xml del /f /q vbFilesDB.xml
fciv -add vb -r -bp %CD% -xml vbFilesDB.xml
echo If you are doing a pause on each checksum DB, you're finished and
echo next is the exit
%1
exit
