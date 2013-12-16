start fciv -add Batch -r -bp %CD% -xml batchFilesDB.xml
fciv -add cm -r -bp %CD% -xml cmFilesDB.xml
fciv -add perlWorkspace -r -bp %CD% -xml perlFilesDB.xml
fciv -add research -r -bp %CD% -xml researchFilesDB.xml
fciv -add TeamBuildTypes -r -bp %CD% -xml teamFilesDB.xml
fciv -add tfsWorking -r -bp %CD% -xml tfsFilesDB.xml
