SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
--
--  Add users, logins and roles
---
---sp_adduser infopump,,InfoPumpAdmin
-- go

---if exists (select loginname from master.dbo.syslogins where loginname = 'infopump')
--	exec sp_droplogin 'infopump'		
--go	
--exec sp_addlogin infopump,infopump,mdb 
--go

IF EXISTS (SELECT * FROM dbo.sysusers WHERE name = N'infopump_user' AND issqlrole = 1)
begin
	IF EXISTS (SELECT * FROM dbo.sysusers WHERE name = N'infopump')
		exec sp_droprolemember 'infopump_user', 'infopump'
	exec sp_droprole infopump_user 
end

IF EXISTS (SELECT * FROM dbo.sysusers WHERE name = N'infopump_admin' AND issqlrole = 1)
begin
	IF EXISTS (SELECT * FROM dbo.sysusers WHERE name = N'infopump')
		exec sp_droprolemember 'infopump_admin', 'infopump'
	exec sp_droprole infopump_admin 
end

IF NOT EXISTS (SELECT * FROM dbo.sysusers WHERE name = N'InfoPumpUsers' AND issqlrole = 1)
	exec sp_addrole InfoPumpUsers 
	
IF NOT  EXISTS (SELECT * FROM dbo.sysusers WHERE name = N'InfoPumpAdmin' AND issqlrole = 1)
	exec sp_addrole InfoPumpAdmin
go
	
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION 
GO

/****************************************************************************************/
/*                                                                                      */
/* Patch Star 14694926 ADT: Initialize a MS SQL Server IDB for ADT Version 2.2          */
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ddcolumn with (tablockx)
GO
 
Select top 1 1 from ddtable with (tablockx)
GO
 
Select top 1 1 from ddtablemodify with (tablockx)
GO
 
Select top 1 1 from error with (tablockx)
GO
 
Select top 1 1 from requestprovider with (tablockx)
GO
 
Select top 1 1 from requestqueue with (tablockx)
GO
 
Select top 1 1 from simplerequest with (tablockx)
GO
 
Select top 1 1 from lookoutcontrol with (tablockx)
GO
 
Select top 1 1 from permissions with (tablockx)
GO
 
Select top 1 1 from rdbms_provider with (tablockx)
GO
 
Select top 1 1 from scriptmessagelog with (tablockx)
GO
 
Select top 1 1 from db_application with (tablockx)
GO
 
Select top 1 1 from db_field with (tablockx)
GO
 
Select top 1 1 from db_infoblob with (tablockx)
GO
 
Select top 1 1 from db_layout with (tablockx)
GO
 
Select top 1 1 from db_psafile with (tablockx)
GO
 
Select top 1 1 from db_parameter with (tablockx)
GO
 
Select top 1 1 from db_programinstance with (tablockx)
GO
 
Select top 1 1 from db_program with (tablockx)
GO
 
Select top 1 1 from db_programtype with (tablockx)
GO
 
Select top 1 1 from db_programtypemisc with (tablockx)
GO
 
Select top 1 1 from db_seqcolumn with (tablockx)
GO
 
Select top 1 1 from db_seqtable with (tablockx)
GO
 
Select top 1 1 from db_servertype with (tablockx)
GO
 
Select top 1 1 from db_startable with (tablockx)
GO
 
Select top 1 1 from db_table with (tablockx)
GO
 
Select top 1 1 from db_wkf with (tablockx)
GO
 
Select top 1 1 from db_wkfconnection with (tablockx)
GO
 
Select top 1 1 from db_opsegment with (tablockx)
GO
 
Select top 1 1 from db_op with (tablockx)
GO
 
Select top 1 1 from db_indexcol with (tablockx)
GO
 
Select top 1 1 from db_index with (tablockx)
GO
 
Select top 1 1 from db_gatorstar with (tablockx)
GO
 
Select top 1 1 from db_gator with (tablockx)
GO
 
Select top 1 1 from db_star with (tablockx)
GO
 
Select top 1 1 from db_column with (tablockx)
GO
 
Select top 1 1 from db_datatype with (tablockx)
GO
 
Select top 1 1 from db_object with (tablockx)
GO
 
Select top 1 1 from ipprovider with (tablockx)
GO
 
Select top 1 1 from execution with (tablockx)
GO
 
Select top 1 1 from iprequest with (tablockx)
GO
 
Select top 1 1 from ipobject with (tablockx)
GO
 
Select top 1 1 from codefragment with (tablockx)
GO
 
Select top 1 1 from globalvariable with (tablockx)
GO
 
Select top 1 1 from ipuser with (tablockx)
GO
 
Select top 1 1 from lookoutidcontrol with (tablockx)
GO
 
Select top 1 1 from lookoutserver with (tablockx)
GO
 
Select top 1 1 from providerversion with (tablockx)
GO
 
Select top 1 1 from systemparameter with (tablockx)
GO
 
Select top 1 1 from iprequestcode with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

drop table DDColumn;
go
drop table DDTable;
go
drop table DDTableModify;
go
drop table Error;
go
drop table RequestProvider;
go
drop table RequestQueue;
go
drop table SimpleRequest;
go
drop table LookOutControl;
go
drop table Permissions;
go
drop table RDBMS_Provider;
go
drop table ScriptMessageLog;
go
drop table db_Application;
go
drop table db_Field;
go
drop table db_InfoBlob;
go
drop table db_Layout;
go
drop table db_PSAFile;
go
drop table db_Parameter;
go
drop table db_ProgramInstance;
go
drop table db_Program;
go
drop table db_ProgramType;
go
drop table db_ProgramTypeMisc;
go
drop table db_SeqColumn;
go
drop table db_SeqTable;
go
drop table db_ServerType;
go
drop table db_StarTable;
go
drop table db_Table;
go
drop table db_WKF;
go
drop table db_WKFConnection;
go
drop table db_OpSegment;
go
drop table db_Op;
go
drop table db_IndexCol;
go
drop table db_Index;
go
drop table db_GatorStar;
go
drop table db_Gator;
go
drop table db_Star;
go
drop table db_Column;
go
drop table db_DataType;
go
IF EXISTS (SELECT * FROM dbo.sysconstraints WHERE id = OBJECT_ID(N'[dbo].[db_Object]') and status &3=3 )
	ALTER TABLE [dbo].[db_object] DROP CONSTRAINT [$db_ob_r0000334300000000];
go
drop table db_Object;
go
drop table ipProvider;
go
drop table Execution;
go
drop table ipRequest;
go
drop table ipObject;
go
drop table CodeFragment;
go
drop table GlobalVariable;
go
drop table IPUser;
go
drop table LookoutIdControl;
go
drop table LookoutServer;
go
drop table ProviderVersion;
go
drop table SystemParameter;
go
drop table ipRequestCode;
go
-- -*- sql -*-
--
-- DDL to initialize a MS SQL Server IDB for ADT Version 2.2

--
-- Create IDB objects
--
exec sp_addtype ACCESS_TYPE, int
go
exec sp_addtype BOOLEAN_FLAG, tinyint
go
exec sp_addtype CALCULATION_TYPE, tinyint
go
exec sp_addtype CAPABILITIES_MASK, int
go
exec sp_addtype COMPILE_STATUS_TYPE, tinyint
go
exec sp_addtype DATABASE_TYPE, smallint
go
exec sp_addtype DATETIME_TYPE, datetime
go
exec sp_addtype DAY_TYPE, tinyint
go
exec sp_addtype DES_GLOBVALUE_TYPE, 'binary (248)'
go
exec sp_addtype DES_PASSWORD_TYPE, 'binary (32)'
go
exec sp_addtype DES_TEXT_TYPE, image
go
exec sp_addtype DOW_TYPE, tinyint
go
exec sp_addtype ERRORMSG_TYPE, 'varchar (255)'
go
exec sp_addtype HANDLER_KEYS_TYPE, image
go
exec sp_addtype HOUR_TYPE, tinyint
go
exec sp_addtype IDENTIFIER_TYPE, int
go
exec sp_addtype LONG_NAME_TYPE, 'varchar (128)'
go
exec sp_addtype MESSAGE_TYPE, 'varchar (255)'
go
exec sp_addtype MINUTE_TYPE, tinyint
go
exec sp_addtype MONTH_TYPE, tinyint
go
exec sp_addtype NAME_TYPE, 'varchar (32)'
go
exec sp_addtype NOTE_TYPE, 'varchar (255)'
go
exec sp_addtype OBJECT_TYPE, tinyint
go
exec sp_addtype PARAMETER_VALUE_TYPE, 'varchar (255)'
go
exec sp_addtype PASSWORD_TYPE, 'varchar (32)'
go
exec sp_addtype PERMISSION_MASK, int
go
exec sp_addtype PROVIDER_TYPE, smallint
go
exec sp_addtype PROV_KEYS_TYPE, image
go
exec sp_addtype QUERY_TYPE, 'varchar (255)'
go
exec sp_addtype USER_TYPE, tinyint
go
-- user table
CREATE TABLE IPUser (UserId IDENTIFIER_TYPE NOT NULL,UserName VARCHAR(32) NOT NULL,UserType USER_TYPE NOT NULL,UserGroupId IDENTIFIER_TYPE NULL,LastLoginTime DATETIME_TYPE NULL,Capabilities CAPABILITIES_MASK NULL,UserNote VARCHAR(255) NULL,CONSTRAINT pk_IPUser PRIMARY KEY(UserId))
go
-- Object
CREATE TABLE ipObject (ObjectId IDENTIFIER_TYPE NOT NULL,UserId IDENTIFIER_TYPE NOT NULL,ObjectName VARCHAR(32) NOT NULL,ObjectType OBJECT_TYPE NOT NULL,ObjectNote VARCHAR(255) NULL,ObjectFolderId IDENTIFIER_TYPE NOT NULL,ObjectCreatedTime DATETIME_TYPE NOT NULL,ObjectLastModifyTime DATETIME_TYPE NOT NULL,ObjectModifierId IDENTIFIER_TYPE NOT NULL,ObjectModifierInstance int NOT NULL,CONSTRAINT pk_Object PRIMARY KEY(ObjectId))
go
-- code fragment
CREATE TABLE CodeFragment (FragmentId IDENTIFIER_TYPE NOT NULL,FragmentCode DES_TEXT_TYPE NULL,CONSTRAINT pk_CodeFragment PRIMARY KEY(FragmentId))
go
-- Request
CREATE TABLE ipRequest (RequestId IDENTIFIER_TYPE NOT NULL,CalcServerId IDENTIFIER_TYPE NULL,RequestScript DES_TEXT_TYPE NULL,CompileStatus COMPILE_STATUS_TYPE NOT NULL,LastUpdateTime DATETIME_TYPE NULL,CalcType CALCULATION_TYPE NOT NULL,CalcMinute MINUTE_TYPE NULL,CalcHour HOUR_TYPE NULL,CalcDOW DOW_TYPE NULL,CalcDay DAY_TYPE NULL,CalcMonth MONTH_TYPE NULL,CalcCount smallint NULL,CalcStartTime DATETIME_TYPE NULL,CalcEndTime DATETIME_TYPE NULL,CONSTRAINT pk_Request PRIMARY KEY (RequestId))
go
-- LookOutServer
CREATE TABLE LookOutServer (ServerId IDENTIFIER_TYPE NOT NULL,ServerName VARCHAR(32) NOT NULL,ServerInstalled BOOLEAN_FLAG NOT NULL,ServerNote VARCHAR(255) NULL,ServerLicenseInfo varchar (255) NOT NULL,CONSTRAINT pk_LookOutServer PRIMARY KEY(ServerId))
go
-- Execution
CREATE TABLE Execution (RequestId IDENTIFIER_TYPE NOT NULL, ExecutionId IDENTIFIER_TYPE NOT NULL,ServerId IDENTIFIER_TYPE NULL,UserId IDENTIFIER_TYPE NOT NULL,ExecutionStartTime DATETIME_TYPE NOT NULL,ExecutionEndTime DATETIME_TYPE NULL,CONSTRAINT pk_Execution PRIMARY KEY(ExecutionId))
go
-- DDTable
CREATE TABLE DDTable (DDTableId IDENTIFIER_TYPE NOT NULL,RequestId IDENTIFIER_TYPE NULL,ExecutionId IDENTIFIER_TYPE NULL,DDUserId IDENTIFIER_TYPE NOT NULL,DDProviderId IDENTIFIER_TYPE NOT NULL,DDDatabaseName VARCHAR(128) NULL,DDTableName VARCHAR(128) NOT NULL,DDTableNote VARCHAR(255) NULL,DDTableCreateTime DATETIME_TYPE NOT NULL,CONSTRAINT pk_DDTable PRIMARY KEY(DDTableId))
go
-- DDColumn
CREATE TABLE DDColumn (DDTableId IDENTIFIER_TYPE NOT NULL,DDColumnName VARCHAR(32) NOT NULL,DDColumnType VARCHAR(32) NOT NULL,DDColumnNote VARCHAR(255) NULL,CONSTRAINT pk_DDColumn PRIMARY KEY(DDTableId,DDColumnName))
go
CREATE TABLE DDTableModify (RequestId IDENTIFIER_TYPE NOT NULL,ExecutionId IDENTIFIER_TYPE NOT NULL,DDTableProviderId IDENTIFIER_TYPE NOT NULL,DDTableModifyTime DATETIME_TYPE NOT NULL,DDTableDatabaseName VARCHAR(128) NULL,DDTableModifyName VARCHAR(128) NOT NULL,DDTableUserId IDENTIFIER_TYPE NOT NULL,DDNumRowsInserted int NULL,DDNumRowsUpdated int NULL) 
go
-- was unique
CREATE INDEX XPKDDTableModify ON DDTableModify (ExecutionId,DDTableProviderId,DDTableModifyName) 
go
CREATE TABLE Error (RequestId IDENTIFIER_TYPE NOT NULL,ExecutionId IDENTIFIER_TYPE NOT NULL,ErrorOrder int NOT NULL,ErrorCode int NOT NULL,ErrorMessage VARCHAR(255) NOT NULL,ErrorSeverity int NOT NULL,ErrorTime DATETIME_TYPE NOT NULL,CONSTRAINT pk_Error PRIMARY KEY(RequestId, ExecutionId, ErrorOrder)) 
go
CREATE TABLE GlobalVariable (VariableId IDENTIFIER_TYPE NOT NULL,VariableAccess ACCESS_TYPE NULL,VariableValue DES_GLOBVALUE_TYPE NULL,CONSTRAINT pk_GlobalVariable PRIMARY KEY(VariableId)) 
go
CREATE TABLE LookOutControl (ControlEntryId IDENTIFIER_TYPE NOT NULL,ServerId IDENTIFIER_TYPE NULL,StartupTime DATETIME_TYPE NOT NULL,ShutdownTime DATETIME_TYPE NULL,SchedulerPulse DATETIME_TYPE NULL,CONSTRAINT pk_LookOutControl PRIMARY KEY(ControlEntryId)) 
go
CREATE TABLE LookOutIdControl (LookOutVersion varchar (80) NOT NULL,IdLock IDENTIFIER_TYPE NOT NULL,LockTime DATETIME_TYPE NULL,NextObjectId IDENTIFIER_TYPE NOT NULL,NextGroupId IDENTIFIER_TYPE NOT NULL,NextExecutionId IDENTIFIER_TYPE NOT NULL,NextDDTableId IDENTIFIER_TYPE NOT NULL,NextControlId IDENTIFIER_TYPE NOT NULL,NextServerId IDENTIFIER_TYPE NOT NULL,HandlerKeys HANDLER_KEYS_TYPE NULL,CONSTRAINT pk_LookOutIdControl PRIMARY KEY(LookOutVersion)) 
go
CREATE TABLE Permissions (ObjectId IDENTIFIER_TYPE NOT NULL,GranteeId IDENTIFIER_TYPE NOT NULL,PermissionMask PERMISSION_MASK NOT NULL,CONSTRAINT pk_Permissions PRIMARY KEY (ObjectId, GranteeId)) 
go
CREATE TABLE ipProvider (ProviderId IDENTIFIER_TYPE NOT NULL,DeviceId IDENTIFIER_TYPE NULL,ProviderType PROVIDER_TYPE NOT NULL,OneConnPerReq BOOLEAN_FLAG NULL,OneReqAtATime BOOLEAN_FLAG NULL,CONSTRAINT pk_Provider PRIMARY KEY(ProviderId))
go
CREATE TABLE ProviderVersion (ProviderType PROVIDER_TYPE NOT NULL,ProviderSubtype PROVIDER_TYPE NOT NULL,ServerId IDENTIFIER_TYPE NOT NULL,ProviderName VARCHAR(32) NOT NULL,ProviderVersion VARCHAR(32) NOT NULL,ProviderModuleName VARCHAR(32) NOT NULL,MinRunVersion int NOT NULL,ProviderKeys PROV_KEYS_TYPE NULL,CONSTRAINT pk_ProviderVersion PRIMARY KEY(ProviderType,ProviderSubtype,ServerId))
go
CREATE TABLE RDBMS_Provider (ProviderId IDENTIFIER_TYPE NOT NULL,LoginName VARCHAR(32) NULL,LoginPassword DES_PASSWORD_TYPE NULL,ServerName VARCHAR(128) NULL,DatabaseName VARCHAR(128) NULL, DatabaseType DATABASE_TYPE NOT NULL,Other VARCHAR(128) NULL,CONSTRAINT pk_RDBMS_Provider PRIMARY KEY(ProviderId))
go
CREATE TABLE ipRequestCode (RequestId IDENTIFIER_TYPE NOT NULL,CompiledScript DES_TEXT_TYPE NULL,CONSTRAINT pk_ipRequestCode PRIMARY KEY(RequestId))
go
CREATE TABLE RequestProvider (ProviderId IDENTIFIER_TYPE NOT NULL,RequestId IDENTIFIER_TYPE NOT NULL,CONSTRAINT pk_RequestProvider PRIMARY KEY(ProviderId, RequestId))
go
CREATE TABLE RequestQueue (RequestId IDENTIFIER_TYPE NOT NULL,ServerId IDENTIFIER_TYPE NOT NULL,NextExecutionTime DATETIME_TYPE NOT NULL,UserId IDENTIFIER_TYPE NOT NULL,Reschedule BOOLEAN_FLAG NOT NULL,LockTime DATETIME_TYPE NULL,CONSTRAINT pk_RequestQueue PRIMARY KEY(RequestId))
go
CREATE TABLE ScriptMessageLog (RequestId IDENTIFIER_TYPE NOT NULL,ExecutionId IDENTIFIER_TYPE NOT NULL,MessageOrder int NOT NULL,MessageTime DATETIME_TYPE NOT NULL,MessageText VARCHAR(255) NULL,CONSTRAINT pk_ScriptMessageLog PRIMARY KEY(RequestId,ExecutionId,MessageOrder))
go
CREATE TABLE SimpleRequest (RequestId IDENTIFIER_TYPE NOT NULL,SourceProviderId IDENTIFIER_TYPE NOT NULL,SourceServerName VARCHAR(128) NULL,SourceDatabaseName VARCHAR(128) NULL,SourceLoginName VARCHAR(32) NULL,SourceLoginPassword DES_PASSWORD_TYPE NULL,SourceOther VARCHAR(128) NULL,DestProviderId IDENTIFIER_TYPE NOT NULL,DestServerName VARCHAR(128) NULL,DestDatabaseName VARCHAR(128) NULL,DestLoginName VARCHAR(32) NULL,DestLoginPassword DES_PASSWORD_TYPE NULL,DestOther VARCHAR(128) NULL,DestTableName VARCHAR(128) NULL,DestTableOverwrite BOOLEAN_FLAG NOT NULL,BulkTransfer BOOLEAN_FLAG NULL,DeleteString VARCHAR(255) NULL,CONSTRAINT pk_SimpleRequest PRIMARY KEY(RequestId))
go
CREATE TABLE SystemParameter (ParameterName VARCHAR(32) NOT NULL,ParameterValue VARCHAR(255) NULL,ParameterType tinyint NOT NULL,ServerId IDENTIFIER_TYPE NOT NULL,CONSTRAINT pk_SystemParameter PRIMARY KEY(ServerId, ParameterName))
go
-- add it triggers for deleting FKey Refs
CREATE TRIGGER dbdel_DDTable ON DDTable FOR DELETE AS BEGIN DELETE FROM DDColumn FROM deleted WHERE DDColumn.DDTableId = deleted.DDTableId END
go
CREATE TRIGGER dbdel_Object ON ipObject FOR DELETE AS BEGIN DELETE FROM Permissions FROM deleted WHERE Permissions.ObjectId = deleted.ObjectId DELETE FROM ipRequest FROM deleted WHERE ipRequest.RequestId = deleted.ObjectId DELETE FROM ipProvider FROM deleted WHERE ipProvider.ProviderId = deleted.ObjectId DELETE FROM RDBMS_Provider FROM deleted WHERE RDBMS_Provider.ProviderId = deleted.ObjectId END
go
CREATE TRIGGER dbdel_Request ON ipRequest FOR DELETE AS BEGIN DELETE FROM Execution FROM deleted WHERE Execution.RequestId = deleted.RequestId DELETE FROM RequestProvider FROM deleted WHERE RequestProvider.RequestId = deleted.RequestId DELETE FROM RequestQueue FROM deleted WHERE RequestQueue.RequestId = deleted.RequestId DELETE FROM SimpleRequest FROM deleted WHERE SimpleRequest.RequestId = deleted.RequestId END
go
CREATE TRIGGER dbdel_Execution ON Execution FOR DELETE AS BEGIN DELETE FROM DDTable FROM deleted WHERE DDTable.ExecutionId = deleted.ExecutionId DELETE FROM DDTableModify FROM deleted WHERE DDTableModify.ExecutionId = deleted.ExecutionId DELETE FROM Error FROM deleted WHERE Error.ExecutionId = deleted.ExecutionId DELETE FROM ScriptMessageLog FROM deleted WHERE ScriptMessageLog.ExecutionId = deleted.ExecutionId END
go
CREATE TRIGGER dbdel_LookOutServer ON LookOutServer FOR DELETE AS BEGIN DELETE FROM Execution FROM deleted WHERE Execution.ServerId = deleted.ServerId DELETE FROM LookOutControl FROM deleted WHERE LookOutControl.ServerId = deleted.ServerId END
go
CREATE TRIGGER dbdel_Provider ON ipProvider FOR DELETE AS BEGIN DELETE FROM RequestProvider FROM deleted WHERE RequestProvider.ProviderId = deleted.ProviderId END
go
CREATE TRIGGER dbdel_IPUser ON IPUser FOR DELETE AS BEGIN DELETE FROM ipObject FROM deleted WHERE ipObject.UserId = deleted.UserId END
go
GRANT SELECT, INSERT, UPDATE, DELETE ON CodeFragment TO InfoPumpUsers
go
GRANT SELECT, DELETE ON DDColumn TO InfoPumpUsers
go
GRANT SELECT,DELETE ON DDColumn TO public
go
GRANT SELECT, DELETE ON DDTable TO InfoPumpUsers
go
GRANT SELECT ON DDTable TO public
go
GRANT SELECT, DELETE ON DDTableModify TO InfoPumpUsers
go
GRANT SELECT ON DDTableModify TO public
go
GRANT SELECT, DELETE ON Error TO InfoPumpUsers
go
GRANT SELECT, DELETE ON Execution TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON GlobalVariable TO InfoPumpUsers
go
GRANT SELECT ON LookOutControl TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON LookOutIdControl TO InfoPumpUsers
go
GRANT SELECT ON LookOutServer TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ipObject TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON Permissions TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ipProvider TO InfoPumpUsers
go
GRANT SELECT ON ProviderVersion TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON RDBMS_Provider TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ipRequest TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON RequestProvider TO  InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON RequestQueue TO InfoPumpUsers
go
GRANT SELECT, DELETE ON ScriptMessageLog TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON SimpleRequest TO InfoPumpUsers
go
GRANT SELECT, UPDATE ON SystemParameter TO InfoPumpUsers
go
GRANT SELECT, UPDATE ON IPUser TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ipRequestCode TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON CodeFragment TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON DDColumn TO InfoPumpAdmin  
go
GRANT SELECT, INSERT, UPDATE, DELETE ON DDTable TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON DDTableModify TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON Error TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON Execution TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON GlobalVariable TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON LookOutControl TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON LookOutIdControl TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON LookOutServer TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ipObject TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON Permissions TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ipProvider TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ProviderVersion TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON RDBMS_Provider TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ipRequest TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ipRequestCode TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON RequestProvider TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON RequestQueue TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON ScriptMessageLog TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON SimpleRequest TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON SystemParameter TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON IPUser TO InfoPumpAdmin
go
-- populate the beginning tables with some information 
INSERT INTO IPUser (UserId, UserName, UserType, UserGroupId, LastLoginTime, Capabilities,UserNote) VALUES (1,'InfoPumpUsersGroup', 0,0, NULL,0, 'Default Group for InfoPump Users')
go
INSERT INTO IPUser (UserId, UserName, UserType, UserGroupId, LastLoginTime, Capabilities,UserNote) VALUES (3, 'infopump', 1, 1, NULL, 0xFFFFFFFF, 'InfoPump Administrator')
go
INSERT INTO ipObject (ObjectId, UserId, ObjectName, ObjectType, ObjectNote, ObjectFolderId, ObjectCreatedTime, ObjectLastModifyTime, ObjectModifierId, ObjectModifierInstance) VALUES (0,3,'MainFolder',1,'The Root Folder',0,GETDATE(),GETDATE(),0,0)
go
INSERT INTO LookOutIdControl (LookOutVersion, IdLock, LockTime, NextObjectId, NextGroupId, NextExecutionId, NextDDTableId, NextControlId, NextServerId, HandlerKeys) VALUES ('INFOPUMP IDB V03.00.00',0,NULL,1,4,1,1,1,1,NULL)
go
CREATE TABLE db_Object (dbrep_IID INT NOT NULL PRIMARY KEY ,dbrep_ParentIID INT NOT NULL,dbrep_Name VARCHAR(255) NOT NULL,dbrep_Status SMALLINT NOT NULL,dbrep_Version INT NOT NULL,dbrep_ObjectType TINYINT NOT NULL,dbrep_Description VARCHAR(255),CONSTRAINT db_ObjectUnique UNIQUE(dbrep_ParentIID, dbrep_Name, dbrep_ObjectType, dbrep_Status, dbrep_Version) )
go
-- binary blobs assoc with object in db_Object that hold additional info
CREATE TABLE db_InfoBlob (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_Blob IMAGE )
go
-- server type is the highest object in the DBMS / data heirarchy
CREATE TABLE db_ServerType (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_dbmsName VARCHAR(255),dbrep_dbmsVersion VARCHAR(255),dbrep_accessMethod SMALLINT,dbrep_levelsSupported SMALLINT,dbrep_type SMALLINT,dbrep_dbmsMajorVersion SMALLINT )
go
-- datatypes are associated with a server type
CREATE TABLE db_DataType (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_BaseTypeIID INT,dbrep_length INT,dbrep_precision INT,dbrep_scale INT )
go
-- metadata concerning tables in DBMS
 CREATE TABLE db_Table (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_TableType SMALLINT,dbrep_starRole INT )
go
-- metadata concerning flat file sources
CREATE TABLE db_SeqTable (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_aligned TINYINT,dbrep_ibmComp TINYINT,dbrep_endian SMALLINT,dbrep_mode SMALLINT,dbrep_floatFormat INTEGER,dbrep_codepage INTEGER,dbrep_location VARCHAR(127),dbrep_generatorPath VARCHAR(128) )
go
-- metadata about columns objects assoc with db_Table objects
CREATE TABLE db_Column (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_sequenceNum INT,dbrep_length INT,dbrep_precision INT,dbrep_scale INT,dbrep_isNullable TINYINT,dbrep_DatatypeIID INT NOT NULL )
go
-- metadata about fields from objects in the db_SeqTable 
CREATE TABLE db_SeqColumn (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_sync TINYINT,dbrep_syncType SMALLINT,dbrep_blankWhenZero TINYINT,dbrep_signIsSeparate TINYINT,dbrep_sign SMALLINT,dbrep_justified SMALLINT,dbrep_picture VARCHAR(128) )
go
-- metadata concerning layouts for COBOL records
CREATE TABLE db_Layout (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_normalizationLevel SMALLINT )
go
-- metadata about fields assoc with COBOL records
CREATE TABLE db_Field (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_sequenceNum INT,dbrep_GroupIID INT,dbrep_pictureClause VARCHAR(31), dbrep_usageClause VARCHAR(255),dbrep_syncType SMALLINT,dbrep_isGroup TINYINT,dbrep_isNested TINYINT,dbrep_type SMALLINT,dbrep_length INT,dbrep_precision INT,dbrep_scale INT,dbrep_blankWhenZero TINYINT,dbrep_justified SMALLINT,dbrep_isSigned TINYINT,dbrep_isSignSeparate TINYINT,dbrep_signType SMALLINT,dbrep_redefinesFieldName VARCHAR(255),dbrep_dependsOnFieldName VARCHAR(255),dbrep_occursMin SMALLINT,dbrep_occursMax SMALLINT )
go
-- metadata about indexes
CREATE TABLE db_Index (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_indexType SMALLINT,dbrep_ForeignTableIID INT )
go
-- metadata about index columns
CREATE TABLE db_IndexCol (dbrep_IndexIID INT NOT NULL,dbrep_ColumnIID INT NOT NULL,dbrep_sequenceNum INT )
go
-- metadata about star schema objects
CREATE TABLE db_Star (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_isFlat TINYINT,dbrep_isAggregated TINYINT )
go
-- metadata about tables used within star schemas
CREATE TABLE db_StarTable (dbrep_StarIID INT NOT NULL,dbrep_TableIID INT NOT NULL )
go
-- metadata about aggregations
CREATE TABLE db_Gator (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_sourceIID INT,dbrep_location VARCHAR(127) )
go
-- metadata about star schemas used in aggregations
CREATE TABLE db_GatorStar (dbrep_GatorIID INT NOT NULL,dbrep_StarIID INT NOT NULL )
go
-- applications are parent folders for programs
CREATE TABLE db_Application (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_workflowSpec VARCHAR(128),dbrep_location VARCHAR(128) )
go
-- programs are "graphical scripts" DecisionBase object equivalent to scripts
CREATE TABLE db_Program (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_executableName VARCHAR(127),dbrep_location VARCHAR(127),dbrep_lastExecution VARCHAR(127),dbrep_rowsInserted INT,dbrep_rowsDeleted INT,dbrep_rowsUpdated INT,dbrep_lastModified VARCHAR(30),dbrep_modifier VARCHAR(127) )
go
-- metadata about Reusable Transformations and LOOKUPS
CREATE TABLE db_Op (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_opType INT,dbrep_owner VARCHAR(128),dbrep_modifier VARCHAR(128),dbrep_functionName VARCHAR(128),dbrep_scriptName VARCHAR(128) )
go
-- segments are code fragments that are contained in db_Op object (RT's)
CREATE TABLE db_OpSegment (dbrep_IID INT NOT NULL,dbrep_opSegmentType SMALLINT,dbrep_isActive TINYINT,dbrep_isScriptFunction TINYINT,dbrep_scriptName VARCHAR(127),dbrep_functionName VARCHAR(128),dbrep_codePtr IMAGE )
go
-- parameters are data that is passed to db_Op objects (RTs)
CREATE TABLE db_Parameter (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_type VARCHAR(127),dbrep_kind SMALLINT,dbrep_sequenceNum INT )
go
-- workflow objects
CREATE TABLE db_WKF (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_version SMALLINT,dbrep_psafilepath VARCHAR(128),dbrep_pspfilepath VARCHAR(128),dbrep_psefilepath VARCHAR(128),dbrep_errhandlerwkfname VARCHAR(255),dbrep_lastStatus INT )
go
-- connections are the lines connecting program instances within workflow
CREATE TABLE db_WKFConnection (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_version SMALLINT,dbrep_connType SMALLINT,dbrep_SrcProgInstIID INT,dbrep_TgtProgInstIID INT )
go
-- these are instances of programs (executables) in a workflow
CREATE TABLE db_ProgramInstance (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_version SMALLINT,dbrep_left INT,dbrep_top INT,dbrep_right INT,dbrep_bottom INT,dbrep_proginsttype SMALLINT,dbrep_executableName VARCHAR(128),dbrep_location VARCHAR(128),dbrep_lastExecution VARCHAR(31),dbrep_userReturnCode INT,dbrep_ReturnCode INT,dbrep_RunStatus INT,dbrep_ProgramIID INT,dbrep_ProgramTypeIID INT,dbrep_MiscProgramTypeIID INT )
go
-- program types define "executables" so that workflow know how to execute them
CREATE TABLE db_ProgramType (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_version SMALLINT,dbrep_psaFilename VARCHAR(128),dbrep_pseFilename VARCHAR(128) )
go
-- additional information about a program type?
CREATE TABLE db_ProgramTypeMisc (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_version SMALLINT,dbrep_miscprogtype SMALLINT )
go
-- psa files are objects generated by workflow that hold program type info
CREATE TABLE db_PSAFile (dbrep_IID INT NOT NULL PRIMARY KEY,dbrep_version SMALLINT,dbrep_createTimestamp VARCHAR(31) )
go
--
-- create indexes on the IDB+ tables
--
CREATE INDEX idx_db_IndexCol ON db_IndexCol(dbrep_IndexIID)
go
CREATE INDEX idx_db_ObjParent ON db_Object(dbrep_ParentIID)
go
--
-- create triggers on the IDB+ tables to maintain referential integrity
--
-- if you delete an object - cascade the delete to dependent tables
CREATE TRIGGER del_db_Object ON db_Object FOR DELETE AS BEGIN DELETE FROM db_Application FROM deleted where db_Application.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Parameter FROM deleted  where db_Parameter.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Op FROM deleted where db_Op.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Program FROM deleted where db_Program.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Gator FROM deleted where db_Gator.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Star FROM deleted where db_Star.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Field FROM deleted  where db_Field.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Layout FROM deleted where db_Layout.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Index FROM deleted where db_Index.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Column FROM deleted where db_Column.dbrep_IID = deleted.dbrep_IID DELETE FROM db_Table FROM deleted where db_Table.dbrep_IID = deleted.dbrep_IID DELETE FROM db_DataType FROM deleted where db_DataType.dbrep_IID = deleted.dbrep_IID DELETE FROM db_ServerType FROM deleted where db_ServerType.dbrep_IID = deleted.dbrep_IID DELETE FROM db_InfoBlob FROM deleted where db_InfoBlob.dbrep_IID = deleted.dbrep_IID DELETE FROM db_WKF FROM deleted where db_WKF.dbrep_IID = deleted.dbrep_IID DELETE FROM db_WKFConnection FROM deleted where db_WKFConnection.dbrep_IID = deleted.dbrep_IID DELETE FROM db_ProgramInstance FROM deleted  where db_ProgramInstance.dbrep_IID = deleted.dbrep_IID DELETE FROM db_ProgramType FROM deleted where db_ProgramType.dbrep_IID = deleted.dbrep_IID DELETE FROM db_ProgramTypeMisc FROM deleted where db_ProgramTypeMisc.dbrep_IID = deleted.dbrep_IID DELETE FROM db_PSAFile FROM deleted where db_PSAFile.dbrep_IID = deleted.dbrep_IID END
go
-- if you delete an Op (RT, LOOKUP) delete the segments
CREATE TRIGGER del_db_Op ON db_Op FOR DELETE AS BEGIN DELETE FROM db_OpSegment FROM deleted where db_OpSegment.dbrep_IID = deleted.dbrep_IID END 
go
-- if you delete a table - delete the info in the star schema & flat file info
CREATE TRIGGER del_db_Table ON db_Table FOR DELETE AS BEGIN DELETE FROM db_SeqTable FROM deleted where db_SeqTable.dbrep_IID = deleted.dbrep_IID DELETE FROM db_StarTable FROM deleted where db_StarTable.dbrep_TableIID = deleted.dbrep_IID END
go
-- if you delete a column - delete the info from index & flat file as well
CREATE TRIGGER del_db_Column ON db_Column FOR DELETE AS BEGIN DELETE FROM db_SeqColumn FROM deleted where db_SeqColumn.dbrep_IID = deleted.dbrep_IID DELETE FROM db_IndexCol FROM deleted where db_IndexCol.dbrep_ColumnIID = deleted.dbrep_IID  END
go
-- if you delete and index - delete the columns as well
CREATE TRIGGER del_db_Index ON db_Index FOR DELETE AS BEGIN DELETE FROM db_IndexCol FROM deleted where db_IndexCol.dbrep_IndexIID = deleted.dbrep_IID END
go
-- if delete a star schema - delete  info about tables & aggregations in star
CREATE TRIGGER del_db_Star ON db_Star FOR DELETE AS BEGIN DELETE FROM db_StarTable FROM deleted where db_StarTable.dbrep_StarIID = deleted.dbrep_IID DELETE FROM db_GatorStar FROM deleted where db_GatorStar.dbrep_StarIID = deleted.dbrep_IID END
go
-- if you delete an aggregation - delete from star schemas too
CREATE TRIGGER del_db_Gator ON db_Gator FOR DELETE AS BEGIN DELETE FROM db_GatorStar FROM deleted where db_GatorStar.dbrep_GatorIID = deleted.dbrep_IID END
go
-- if you delete the datatype - delete any columns that used datatype
CREATE TRIGGER del_db_DataType ON db_DataType FOR DELETE AS BEGIN DELETE FROM db_Column FROM deleted where db_Column.dbrep_DatatypeIID = deleted.dbrep_IID END
go
-- if you delete a program, delete the program instances from the workflow
CREATE TRIGGER del_db_Program ON db_Program FOR DELETE AS BEGIN DELETE FROM db_ProgramInstance FROM deleted where db_ProgramInstance.dbrep_ProgramIID = deleted.dbrep_IID END
go
--
--  GRANT permissions on tables
--
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Object TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Object TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_InfoBlob TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_InfoBlob TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_ServerType TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_ServerType TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_DataType TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_DataType TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Table TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Table TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_SeqTable TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_SeqTable TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Column TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Column TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_SeqColumn TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_SeqColumn TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Layout TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Layout TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Field TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Field TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Index TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Index TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_IndexCol TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_IndexCol TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Star TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Star TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_StarTable TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_StarTable TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Gator TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Gator TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_GatorStar TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_GatorStar TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Application TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Application TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Program TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Program TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Op TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Op TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_OpSegment TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_OpSegment TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Parameter TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_Parameter TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_WKF TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_WKF TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_WKFConnection TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_WKFConnection TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_ProgramInstance TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_ProgramInstance TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_ProgramType TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_ProgramType TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_ProgramTypeMisc TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_ProgramTypeMisc TO InfoPumpAdmin
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_PSAFile TO InfoPumpUsers
go
GRANT SELECT, INSERT, UPDATE, DELETE ON db_PSAFile TO InfoPumpAdmin
go
--
--  INSERT some initial data for a "root" object
--
INSERT into db_Object ( dbrep_IID, dbrep_ParentIID, dbrep_Name, dbrep_Status, dbrep_Version, dbrep_ObjectType, dbrep_Description ) VALUES (1, 1, 'Root', -1, 0, 0, 'The Root')
/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14694926, getdate(), 1, 4, 'Patch Star 14694926 ADT: Initialize a MS SQL Server IDB for ADT Version 2.2' )
GO

COMMIT TRANSACTION 
GO
