/* 
 * AlterTables.sql
 */ 
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

DEFINE HARVESTINDEXTSNAME = &1

ALTER TABLE HARFILEEXTENSION 
ADD( CONSTRAINT harFileExtension_PK 
PRIMARY KEY (REPOSITOBJID, FILEEXTENSION)
USING INDEX TABLESPACE &HARVESTINDEXTSNAME);

-- Make the changes to the tables as needed

ALTER TABLE harApprove 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128));

ALTER TABLE harApproveHist MODIFY (Action VARCHAR (128));
--
-- Remove duplicates before creating primary constraint
--
DELETE
  FROM harapprovehist
 WHERE ROWID NOT IN (SELECT MIN (ROWID)
                       FROM harapprovehist
                      GROUP BY envobjid,
                               stateobjid,
                               packageobjid,
                               usrobjid,
                               execdtime,
                               action);

ALTER TABLE HARAPPROVEHIST 
 ADD CONSTRAINT HARAPPROVEHIST_PK 
 PRIMARY KEY (ENVOBJID, STATEOBJID, PACKAGEOBJID, USROBJID, EXECDTIME, ACTION)
    USING INDEX
    TABLESPACE &HARVESTINDEXTSNAME;

ALTER TABLE harCheckOutProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, 
ProcessName CHAR(128), StateObjId NOT NULL);

ALTER TABLE harConMrgProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, 
ProcessName CHAR(128), StateObjId NOT NULL) 
ADD (MergeRule CHAR(1) DEFAULT 'A' NOT NULL);

ALTER TABLE harCrPkgProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128), 
        DefaultPkgFormName CHAR(128), InitialStateId DEFAULT 0 NOT NULL);

ALTER TABLE harCrsEnvMrgProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128), StateObjId NOT NULL) 
ADD (MergeRule CHAR(1) DEFAULT 'A' NOT NULL);

ALTER TABLE harCrsEnvMrgProc MODIFY placement NULL;
UPDATE harCrsEnvMrgProc
   SET placement = NULL;
ALTER TABLE harCrsEnvMrgProc MODIFY placement CHAR(1) ;
UPDATE harCrsEnvMrgProc
   SET placement = 'A';
ALTER TABLE harCrsEnvMrgProc MODIFY placement NOT NULL;

ALTER TABLE harDelVersProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, 
ProcessName CHAR(128), StateObjId NOT NULL);

ALTER TABLE harDemoteProc MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128)) 
ADD (EnforceBind CHAR(1) DEFAULT 'N' NOT NULL,
     CHECKDEPENDENCIES CHAR(1) DEFAULT 'N' NOT NULL);

ALTER TABLE harFormHistory 
MODIFY (Action VARCHAR2(128));

ALTER TABLE harFormType 
MODIFY (FormTableName CHAR(32), FormTypeName VARCHAR(128));

ALTER TABLE harFormTypeDefs 
MODIFY (ColumnName CHAR(32), ColumnType CHAR(8));

ALTER TABLE harFormTypeDefs ADD(label VARCHAR2(128) NULL);

ALTER TABLE harIntMrgProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128), 
        StateObjId NOT NULL) 
ADD ( MERGEWAY          NUMBER  DEFAULT 0 NOT NULL);

ALTER TABLE harLinkedProcess 
MODIFY (ProcessName CHAR(128), ProcessType CHAR(32));

ALTER TABLE harListDiffProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, 
ProcessName CHAR(128), StateObjId NOT NULL);

ALTER TABLE harListVersProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, 
ProcessName CHAR(128), StateObjId NOT NULL);

ALTER TABLE harMovePkgProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128));
/*
 * Models dump did not have harMr_pk constraint. SBCM does.
 */
WHENEVER SQLERROR CONTINUE
ALTER TABLE harMR 
MODIFY (FormObjId NOT NULL) 
ADD (CONSTRAINT harMr_pk PRIMARY KEY (FormObjId)
     USING INDEX TABLESPACE &HARVESTINDEXTSNAME);
WHENEVER SQLERROR EXIT FAILURE

ALTER TABLE harNotify 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128), 
OutputTarget CHAR(8), OnErrorAction CHAR(8));

ALTER TABLE harNotify ADD(SUBJECT VARCHAR2(1000) NULL);

ALTER TABLE harPackage 
MODIFY (ModifiedTime NOT NULL, 
        ModifierId NOT NULL, 
        PackageName VARCHAR(128), 
        Status CHAR(32),
        StateObjId DEFAULT 0 NOT NULL,
        ViewObjId DEFAULT -1 NOT NULL
        );
        
ALTER TABLE harPackage 
ADD (Priority NUMBER DEFAULT 0 NOT NULL, 
     AssigneeId NUMBER NULL, 
     StateEntryTime DATE DEFAULT SYSDATE NOT NULL,
     CLIENTNAME VARCHAR2(128) NULL,
     SERVERNAME VARCHAR2(128) NULL);

ALTER TABLE harPkgHistory 
MODIFY (StateName VARCHAR(128), EnvironmentName VARCHAR(128), Action VARCHAR(128));

ALTER TABLE harPmStatus MODIFY (PMStatusName CHAR(128));

ALTER TABLE harPromoteProc MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128)) ADD (
       CHECKDEPENDENCIES    CHAR(1) DEFAULT 'N' NOT NULL,
       FROMSTATEID          NUMBER  DEFAULT 0 NOT NULL,
       ENFORCEBIND          CHAR(1) DEFAULT 'N' NOT NULL);

ALTER TABLE harRemItemProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128), StateObjId NOT NULL);

ALTER TABLE harSnapViewProc 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128), StateObjId NOT NULL);

ALTER TABLE harState 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, 
StateName CHAR(128), LocationX DEFAULT 0 NOT NULL, LocationY DEFAULT 0 NOT NULL,
PMStatusIndex DEFAULT 0 NOT NULL);

ALTER TABLE harTableInfo 
ADD(CASESENSLOGIN CHAR(1) DEFAULT 'Y' NOT NULL,
    Databaseid    INTEGER DEFAULT 0 NOT NULL,
    AUTHENTICATEUSER CHAR(1) DEFAULT 'Y' NOT NULL);

ALTER TABLE harUDP 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, ProcessName CHAR(128), OutputTarget CHAR(8), OnErrorAction CHAR(8), UDPType CHAR(8));

ALTER TABLE harUserGroup 
MODIFY (ModifiedTime NOT NULL, ModifierId NOT NULL, UserGroupName CHAR(128));








