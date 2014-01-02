REM echo off

REM ###################################################################
REM 
REM Specify the following information for your site. 
REM      
REM      HAR_NAME     - the Oracle user that owns AllFusion Harvest.
REM      HAR_PASS     - the Oracle user's password.
REM      DBA_NAME     - Oracle DBA name	
REM      DBA_PASS     - Oracle DBA password
REM      harvest_meta - Tablespace for Harvest metadata 
REM      harvest_blob - Tablespace for Harvest Blobs
REM      harvest_index - Tablespace for Harvest indexes
REM      harvest_metafile - Database File for Harvest metadata 
REM      harvest_blobfile - Database File for Harvest Blobs
REM      harvest_index - Database File for Harvest indexes
REM
REM ###################################################################

set HAR_NAME=test
set HAR_PASS=test
set DBA_NAME=system
set DBA_PASS=harvest
set DUMPED_FILE=Models_Oracle.txt
set DUMPED_USER=system
set REMOTE=

set harvest_meta=HARVESTMETA
set harvest_blob=HARVESTBLOB
set harvest_index=HARVESTINDEX

REM *** Initialize & read-in 3 files for harvest table spaces (.ora)
set harvest_metafile=HarvestMeta.ora
set harvest_blobfile=HarvestBlob.ora
set harvest_indexfile=HarvestIndex.ora

REM *** Delete exisiting Harvest user
sqlplus %DBA_NAME%/%DBA_PASS%%REMOTE% @DropUser.sql %HAR_NAME% DropUser.log

REM *** Run crtblspc.sql to create table spaces (Will fail if already created)
sqlplus %DBA_NAME%/%DBA_PASS%%REMOTE% @crtblspc.sql %harvest_meta% %harvest_blob% %harvest_index% %harvest_metafile% %harvest_blobfile% %harvest_indexfile% 50 50 50 crtblspc.log

REM *** Run creatusr.sql to create / set users (modified version of setuser.sql) 
sqlplus %DBA_NAME%/%DBA_PASS%%REMOTE% @creatusr.sql %HAR_NAME% %HAR_PASS% %harvest_meta% %harvest_blob% %harvest_index% TEMP RBS creatusr.log

REM *** Import the meta data
sqlplus %HAR_NAME%/%HAR_PASS%%REMOTE% @%DUMPED_FILE% import.log %harvest_meta% %harvest_blob% %harvest_index%



echo DB import is complete

pause


