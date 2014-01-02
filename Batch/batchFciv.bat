echo If you provide pause as a parameter when running this batch
echo You will get the pause prompt between each set of checksums run
del fciv.err
if exist batchFilesDB.xml del /f /q batchFilesDB.xml
copy NULx.xml batchFilesDB.xml
date /t >>fciv.err && time /t >>fciv.err
fciv -add Batch -r -bp %CD% -xml batchFilesDB.xml

%1
if exist cmFilesDB.xml del /f /q cmFilesDB.xml
copy NULx.xml cmFilesDB.xml
time /t >>fciv.err
fciv -add cm -r -bp %CD% -xml cmFilesDB.xml

%1
if exist perlFilesDB.xml del /f /q perlFilesDB.xml
copy NULx.xml perlFilesDB.xml
time /t >>fciv.err
fciv -add perlWorkspace -r -bp %CD% -xml perlFilesDB.xml

%1
if exist researchFilesDB.xml del /f /q researchFilesDB.xml
copy NULx.xml researchFilesDB.xml
time /t >>fciv.err
fciv -add research -r -bp %CD% -xml researchFilesDB.xml

%1
if exist scriptsFilesDB.xml del /f /q scriptsFilesDB.xml
copy NULx.xml scriptsFilesDB.xml
time /t >>fciv.err
fciv -add Scripts -r -bp %CD% -xml scriptsFilesDB.xml

%1
if exist SQLFilesDB.xml del /f /q SQLFilesDB.xml
copy NULx.xml SQLFilesDB.xml
time /t >>fciv.err
fciv -add SQL -r -bp %CD% -xml SQLFilesDB.xml

%1
if exist teamFilesDB.xml del /f /q teamFilesDB.xml
copy NULx.xml teamFilesDB.xml
time /t >>fciv.err
fciv -add TeamBuildTypes -r -bp %CD% -xml teamFilesDB.xml

%1
if exist tfsFilesDB.xml del /f /q tfsFilesDB.xml
copy NULx.xml tfsFilesDB.xml
time /t >>fciv.err
fciv -add tfsWorking -r -bp %CD% -xml tfsFilesDB.xml

%1
if exist vbFilesDB.xml del /f /q vbFilesDB.xml
copy NULx.xml vbFilesDB.xml
time /t >>fciv.err
fciv -add vb -r -bp %CD% -xml vbFilesDB.xml

echo If you are doing a pause on each checksum DB, you're finished and
echo next is the exit
%1
date /t >>fciv.err && time /t >>fciv.err
exit
