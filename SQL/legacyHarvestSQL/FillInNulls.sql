/*
 * FillInNulls.sql
 *
 * Fill in all NULL values that are going to be converted to NOT NULL
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

UPDATE harAllUsers SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harAllUsers SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harApprove SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harApprove SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harCheckInProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harCheckInProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harCheckOutProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harCheckOutProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harConMrgProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harConMrgProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harCrPkgProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harCrPkgProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harCrsEnvMrgProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harCrsEnvMrgProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harDelVersProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harDelVersProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harDemoteProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harDemoteProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harEnvironment SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harEnvironment SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harIntMrgProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harIntMrgProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harItem SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harItem SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harListDiffProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harListDiffProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harListVersProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harListVersProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harMovePkgProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harMovePkgProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harNotify SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harNotify SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harPackage SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harPackage SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harPackage SET stateobjid = 0 WHERE stateobjid IS NULL;
UPDATE harPackage SET viewobjid = -1 WHERE viewobjid IS NULL;
UPDATE harPackageGroup SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harPackageGroup SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harPromoteProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harPromoteProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harRemItemProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harRemItemProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harRepository SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harRepository SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harSnapViewProc SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harSnapViewProc SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harState SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harState SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harUDP SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harUDP SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harUDP SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harUDP SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harUser SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harUser SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harUserGroup SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harUserGroup SET ModifierId=CreatorId where ModifierId IS NULL;
UPDATE harView SET ModifiedTime=CreationTime where ModifiedTime IS NULL;
UPDATE harView SET ModifierId=CreatorId where ModifierId IS NULL;
