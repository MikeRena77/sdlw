/*
 * CreateSequence.sql
 *
 * Create sequences for object IDs
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
-- spool &1

SET autocommit ON
SET document ON
set feedback on
set timing off
set verify off

START CreateSeqMaster.sql harBranchSeq harBranch branchobjid harBranch
START CreateSeqMaster.sql harEnvironmentSeq harEnvironment envobjid harEnvironment
START CreateSeqMaster.sql harFormSeq harForm formobjid harForm
START CreateSeqMaster.sql harItemsSeq harItems itemobjid harItems
START CreateSeqMaster.sql harPackageSeq harPackage packageobjid harPackage
START CreateSeqMaster.sql harPackageGroupSeq harPackageGroup pkggrpobjid harPackageGroup

-- Processes are a special case
START CreateSeqProc.sql  

START CreateSeqMaster.sql harRepositorySeq harRepository repositobjid harRepository
START CreateSeqMaster.sql harStateSeq harState stateobjid harState
START CreateSeqMaster.sql harUserSeq harAllUsers usrobjid harUser
START CreateSeqMaster.sql harUserGroupSeq harUserGroup usrgrpobjid harUserGroup
START CreateSeqMaster.sql harVersionDataSeq harVersionData versiondataobjid harVersionData
START CreateSeqMaster.sql harVersionsSeq harVersions versionobjid harVersions
START CreateSeqMaster.sql harViewSeq harView viewobjid harView

-- spool off

-- EXIT
