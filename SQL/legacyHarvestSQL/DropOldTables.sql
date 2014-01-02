--
-- Drop old tables after conversion is complete
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
-- SPOOL &1
-- Commit every change in order to avoid huge rollback segments
SET autocommit ON
set feedback on
set timing off
set verify off

DROP TABLE OLDharAllChildrenPath;
DROP TABLE OLDharAllEnvirs;
DROP TABLE OLDharAllUsers;
DROP TABLE OLDharAssocForm;
DROP TABLE OLDharCheckinProc;
DROP TABLE OLDharCheckout;
DROP TABLE OLDharEnvironment;
DROP TABLE OLDharEnvRepository;         
DROP TABLE OLDharEnvUserList;
DROP TABLE OLDharForm CASCADE CONSTRAINTS;
DROP TABLE OLDharFullItemPath;
DROP TABLE OLDharHarvest;
DROP TABLE OLDharItem;
DROP TABLE OLDharItemPath;
DROP TABLE OLDharLatestVersion1;
DROP TABLE OLDharMergedVersion;
DROP TABLE OLDharMiscTable;
DROP TABLE OLDharMViewItemPath;
DROP TABLE OLDharObjIdGen;
DROP TABLE OLDharPackageGroup;
DROP TABLE OLDharPathFullName;
DROP TABLE OLDharProjectAttr;
DROP TABLE OLDharRepository;
DROP TABLE OLDharRepView;
DROP TABLE OLDharRepViewPath;
DROP TABLE OLDharRepViewVersion;
DROP TABLE OLDharStateProcess;
DROP TABLE OLDharUser;
DROP TABLE OLDharVersion;
DROP TABLE OLDharVersionInView;
DROP TABLE OLDharView;
DROP TABLE OLDharViewsOfRep;
DROP TABLE OLDharViewVersion;

@dropTmp.sql

-- spool off
-- EXIT
