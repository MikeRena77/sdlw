SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION 
GO

/****************************************************************************************/
/*                                                                                      */
/* Patch Star 14571426 USD: CLARITY AND HARVEST INTEGRATION CHANGES                      */
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
/* Comment this out as usp_projex doesn't exist yet Select top 1 1 from usp_projex with (tablockx)
GO */
 
Select top 1 1 from chg with (tablockx)
GO
 
Select top 1 1 from ca_resource_family with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
/****** New Service Desk reference table ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[usp_projex]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[usp_projex] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[del] [int] NOT NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[clarity_name] [nvarchar] (128) COLLATE !!insensitive NULL ,
	[clarity_id] [nvarchar] (128) COLLATE !!insensitive NULL ,
	[clarity_info] [nvarchar] (512) COLLATE !!insensitive NULL ,
	[endevor_name] [nvarchar] (128) COLLATE !!insensitive NULL ,
	[endevor_server] [nvarchar] (128) COLLATE !!insensitive NULL ,
	[endevor_info] [nvarchar] (512) COLLATE !!insensitive NULL ,
	[entwb_name] [nvarchar] (128) COLLATE !!insensitive NULL ,
	[entwb_server] [nvarchar] (128) COLLATE !!insensitive NULL ,
	[entwb_info] [nvarchar] (512) COLLATE !!insensitive NULL ,
	[harvest_name] [nvarchar] (128) COLLATE !!insensitive NULL ,
	[harvest_server] [nvarchar] (128) COLLATE !!insensitive NULL ,
	[harvest_info] [nvarchar] (512) COLLATE !!insensitive NULL ,
	[organization_uuid] [binary] (16) NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL 
) ON [PRIMARY]
END

GO

ALTER TABLE [dbo].[usp_projex] WITH NOCHECK ADD 
	CONSTRAINT [XPKusp_projex] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [usp_projex_x0] ON [dbo].[usp_projex]([ext_asset]) ON [PRIMARY]
GO


GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[usp_projex]  TO [service_desk_admin_group]
GO

GRANT  SELECT  ON [dbo].[usp_projex]  TO [service_desk_ro_group]
GO


/****** New Service Desk column in chg table ******/
ALTER TABLE [dbo].[chg] ADD [project] [binary] (16) NULL
GO

 CREATE  INDEX [chg_x15] ON [dbo].[chg]([project], [active_flag]) ON [PRIMARY]
GO

/****** New Service Desk entry in ca_resource_family ******/
INSERT INTO ca_resource_family ( id,  inactive,  name,  table_extension_name,  creation_user,  creation_date,  last_update_user,  last_update_date,  version_number,  description,  exclude_registration,  delete_time,  include_reconciliation )
SELECT DISTINCT 
 605,  0,  'Projects',  'projex',  null,  null,  null,  null,  0,  'Project family',  1,  null,  0 
  FROM ca_resource_family
 WHERE NOT EXISTS (SELECT 1 FROM ca_resource_family WHERE id = 605)
go





/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14571426, getdate(), 1, 4, 'Star 14571426 USD: CLARITY AND HARVEST INTEGRATION CHANGES' )
GO

COMMIT TRANSACTION 
GO


