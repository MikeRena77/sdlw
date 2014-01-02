SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
SET XACT_ABORT OFF
GO
BEGIN TRANSACTION 
GO

/****************************************************************************/
/*                                                                          */
/* Star 14823018 request changes for mq tables                  	    */
/*                                                                          */
/****************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

declare @sql nvarchar(4000)

set @sql = N'alter table wtMqChannelInst drop column mqsport'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'alter table wtMqChannelInst add MqChannelInstType varchar(12) NOT NULL default ""'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'alter table wtMqMgrInst drop column mqsport'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'alter table wtMqMgrInst add MqsRemote int NOT NULL default 2'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'alter table wtMqMgrInst add MqsPlatform varchar(12) NOT NULL default "UNKNOWN"'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'alter table wtMqMgrInst add MqsCmdLevel varchar(5) NOT NULL default "520"'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'alter table wtMqMgrInst add MqsListenPort varchar(5) NOT NULL default "1414"'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqChannelInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT DELETE ON dbo.wtMqChannelInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT UPDATE ON dbo.wtMqChannelInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT INSERT ON dbo.wtMqChannelInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqChannelInst TO wvuser'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqChannelInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT DELETE ON dbo.wtMqChannelInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT UPDATE ON dbo.wtMqChannelInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT INSERT ON dbo.wtMqChannelInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqChannelInst TO wvuser'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqChannelInst TO uniuser '
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wvMqChannelInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wvMqChannelInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wvMqChannelInst TO wvuser'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wvMqChannelInst TO uniuser'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT DELETE ON dbo.wtMqMgrInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT UPDATE ON dbo.wtMqMgrInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT INSERT ON dbo.wtMqMgrInst TO wvadmin '
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO wvuser'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT DELETE ON dbo.wtMqMgrInst TO uniadmin '
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT UPDATE ON dbo.wtMqMgrInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT INSERT ON dbo.wtMqMgrInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO wvuser '
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO uniuser'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO wvadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO uniadmin'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO wvuser'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'GRANT SELECT ON dbo.wtMqMgrInst TO uniuser'
execute sp_executesql @sql
GO

/*****************************************************************************/
/*                                                                           */
/* Register patch                                                      	     */
/*                                                                           */
/*****************************************************************************/

insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14823018, getdate(), 1, 4, 'Star 14823018 request changes for mq tables' );

commit transaction
GO

