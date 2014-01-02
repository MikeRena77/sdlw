-- SPOOL &1 
/*
 * Replace invalid creator/modifier in all tables
 */ 
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
--
-- If there is no user with object ID 1, then create one
--
WHENEVER SQLERROR CONTINUE
INSERT INTO harAllUsers
( usrobjid, username, loggedin, ENCRYPTPSSWD, CREATIONTIME, CREATORID, 
  MODIFIEDTIME, MODIFIERID)
VALUES ( 1, 'Conversion', 'N', 'FgtNrhy', SYSDATE, 
         1, SYSDATE, 1);
 
WHENEVER SQLERROR EXIT FAILURE
START FixMissingUserRefs harApprove 1
START FixMissingUserRefs harCheckInProc 1
START FixMissingUserRefs harCheckOutProc 1
START FixMissingUserRefs harConMrgProc 1
START FixMissingUserRefs harCrPkgProc 1
START FixMissingUserRefs harCrsEnvMrgProc 1
START FixMissingUserRefs harDelVersProc 1
START FixMissingUserRefs harDemoteProc 1
START FixMissingUserRefs harEnvironment 1
START FixMissingUserRefs harForm 1
START FixMissingUserRefs harIntMrgProc 1
START FixMissingUserRefs harItems 1
START FixMissingUserRefs harListDiffProc 1
START FixMissingUserRefs harListVersProc 1
START FixMissingUserRefs harMovePkgProc 1
START FixMissingUserRefs harNotify 1
START FixMissingUserRefs harPackage 1
START FixMissingUserRefs harPackageGroup 1
START FixMissingUserRefs harPromoteProc 1
START FixMissingUserRefs harRemItemProc 1
START FixMissingUserRefs harRenameItemProc 1
START FixMissingUserRefs harRepository 1
START FixMissingUserRefs harSnapViewProc 1
START FixMissingUserRefs harState 1
START FixMissingUserRefs harUdp 1
START FixMissingUserRefs harUser 1
START FixMissingUserRefs harUserGroup 1
START FixMissingUserRefs harVersions 1
START FixMissingUserRefs harView 1

-- commit;

-- spool off

-- EXIT

