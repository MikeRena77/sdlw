
cd workspace\Batch
fciv -add %CD% -r -exc batchFilesDB.xml -wp -xml batchFilesDB.xml
cd ..\cm
fciv -add %CD% -r -exc cmFilesDB.xml -wp -xml cmFilesDB.xml
cd ..\perlWorkspace
fciv -add %CD% -r -exc perlFilesDB.xml -wp -xml perlFilesDB.xml
cd ..\TeamBuildTypes
fciv -add %CD% -r -exc teamFilesDB.xml -wp -xml teamFilesDB.xml
cd ..\tfsWorking
fciv -add %CD% -r -exc tfsFilesDB.xml -wp -xml tfsFilesDB.xml