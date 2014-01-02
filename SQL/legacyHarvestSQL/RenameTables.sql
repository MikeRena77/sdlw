/*
 * RenameTables.sql
 *
 * Rename all of the tables that have to be redone or dropped
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

RENAME harAllChildrenPath TO OLDharAllChildrenPath;
RENAME harAllEnvirs TO OLDharAllEnvirs;
RENAME harAllUsers TO OLDharAllUsers;
RENAME harAssocForm TO OLDharAssocForm;
RENAME harCheckinProc TO OLDharCheckinProc;
RENAME harCheckout TO OLDharCheckout;
RENAME harEnvironment TO OLDharEnvironment;
RENAME harEnvRepository TO OLDharEnvRepository;
RENAME harEnvUserList TO OLDharEnvUserList;
RENAME harForm TO OLDharForm;
RENAME harFullItemPath TO OLDharFullItemPath;
RENAME harHarvest TO OLDharHarvest;
RENAME harItem TO OLDharItem;
RENAME harItemPath TO OLDharItemPath;
RENAME harLatestVersion1 TO OLDharLatestVersion1;
RENAME harMergedVersion TO OLDharMergedVersion;
RENAME harMiscTable TO OLDharMiscTable;
RENAME harMViewItemPath TO OLDharMViewItemPath;
RENAME harObjIdGen TO OLDharObjIdGen;
RENAME harPackageGroup TO OLDharPackageGroup;
RENAME harPathFullName TO OLDharPathFullName;
RENAME harProjectAttr TO OLDharProjectAttr;
RENAME harRepository TO OLDharRepository;
RENAME harRepView TO OLDharRepView;
RENAME harRepViewPath TO OLDharRepViewPath;
RENAME harRepViewVersion TO OLDharRepViewVersion;
RENAME harStateProcess TO OLDharStateProcess;
RENAME harUser TO OLDharUser;
RENAME harVersion TO OLDharVersion;
RENAME harVersionInView TO OLDharVersionInView;
RENAME harView TO OLDharView;
RENAME harViewsOfRep TO OLDharViewsOfRep;
RENAME harViewVersion TO OLDharViewVersion;
