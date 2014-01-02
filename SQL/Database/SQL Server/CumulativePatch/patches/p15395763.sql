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
/* Star 15395763 : CMDB : multiple data sourcing					*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */

select top 1 1 from ci_hardware_server with (tablockx)
Go

select top 1 1 from ci_app_ext with (tablockx)
GO

select top 1 1 from ci_hardware_storage with (tablockx)
GO

select top 1 1 from ci_network_nic with (tablockx)
GO

select top 1 1 from ci_network_controller with (tablockx)
GO

select top 1 1 from ci_service with (tablockx)
GO

Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

/******************************************/
/* CREATE ci_mdr_provider TABLE           */
/******************************************/
 
CREATE TABLE [dbo].[ci_mdr_provider] (
      [id] [int] NOT NULL,
      [del] [int] NOT NULL,
      [description] [nvarchar] (255) COLLATE !!insensitive NULL,
      [hostname] [nvarchar] (255) COLLATE !!insensitive NULL,
      [mdr_class] [nvarchar] (50) COLLATE !!insensitive NULL,
      [mdr_name] [nvarchar] (50) COLLATE !!insensitive NOT NULL,
      [name] [nvarchar] (16) COLLATE !!insensitive NOT NULL,
      [owner] [binary] (16) NULL,
      [password] [nvarchar] (255) COLLATE !!insensitive NULL,
      [encryptiontype] [nvarchar] (12) COLLATE !!insensitive NULL,
      [encryptedpassword] [nvarchar] (255) COLLATE !!insensitive NULL,
      [path] [nvarchar] (255) COLLATE !!insensitive NULL,
      [parameters] [nvarchar] (255) COLLATE !!insensitive NULL,
      [port] [int] NULL,
      [launchurl] [nvarchar] (255) COLLATE !!insensitive NULL,
      [last_mod_dt] [int] NULL,
      [last_mod_by] [binary] (16) NULL,
      [userid] [nvarchar] (100) COLLATE !!insensitive NULL,
      [persid] [nvarchar] (30) COLLATE !!insensitive NULL
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ci_mdr_provider_X0] ON [dbo].[ci_mdr_provider] 
([mdr_name] ASC) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ci_mdr_provider_X1] ON [dbo].[ci_mdr_provider] 
([mdr_class] ASC) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [ci_mdr_provider_X2] ON [dbo].[ci_mdr_provider] 
([id] ASC) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ci_mdr_provider] ADD PRIMARY KEY NONCLUSTERED 
([id] ASC) ON [PRIMARY]
GO

 
/********************************/
/* CREATE IDMAP TABLE           */
/********************************/

CREATE TABLE [dbo].[ci_mdr_idmap] (
            [id] [int] NOT NULL,
            [federated_asset_id] [nvarchar](255) COLLATE !!insensitive NULL,
            [mdr_provider_id] [int] NOT NULL,
            [cmdb_asset_id] [binary](16) NULL,
            [last_mod_dt] [int] NULL,
            [last_mod_by] [binary](16) NULL,
            [del] [int] NOT NULL,
            [persid] [nvarchar](30) COLLATE !!insensitive NULL
) ON [PRIMARY]
GO 


CREATE NONCLUSTERED INDEX [ci_mdr_idmap_X0] ON [dbo].[ci_mdr_idmap] 
([mdr_provider_id] ASC) ON [PRIMARY]
GO 

CREATE NONCLUSTERED INDEX [ci_mdr_idmap_X1] ON [dbo].[ci_mdr_idmap] 
([federated_asset_id] ASC) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ci_mdr_idmap_X2] ON [dbo].[ci_mdr_idmap] 
([cmdb_asset_id] ASC) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ci_mdr_idmap] ADD PRIMARY KEY NONCLUSTERED 
([id] ASC) ON [PRIMARY]
GO


/* Authorize access to new tables */

GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[ci_mdr_provider] to [cmdb_admin], [service_desk_admin_group],[public]
GRANT SELECT                         ON [dbo].[ci_mdr_provider] to [service_desk_ro_group]

GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[ci_mdr_idmap] to [cmdb_admin], [service_desk_admin_group],[public]
GRANT SELECT                         ON [dbo].[ci_mdr_idmap] to [service_desk_ro_group]


/* lengthen fields in existing tables */

ALTER TABLE ci_hardware_server    ALTER COLUMN proc_type               nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN cd_rom_type             nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN server_type             nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN disk_type               nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN net_card                nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN monitor                 nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN printer                 nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN technology              nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN type_net_conn           nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN role                    nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN supervision_mode        nvarchar(255) ;
ALTER TABLE ci_hardware_server    ALTER COLUMN net_card                nvarchar(255) ;
GO 
 
ALTER TABLE ci_app_ext            ALTER COLUMN environment             nvarchar(255) ;
ALTER TABLE ci_app_ext            ALTER COLUMN version                 nvarchar(255) ;
ALTER TABLE ci_app_ext            ALTER COLUMN server                  nvarchar(255) ;
ALTER TABLE ci_app_ext            ALTER COLUMN install_dir             nvarchar(255) ;
ALTER TABLE ci_app_ext            ALTER COLUMN main_process            nvarchar(255) ;
ALTER TABLE ci_app_ext            ALTER COLUMN highavail_appl_resources nvarchar(255) ;
ALTER TABLE ci_app_ext            ALTER COLUMN support_type            nvarchar(255) ;
GO 

ALTER TABLE ci_hardware_storage   ALTER COLUMN disk_type               nvarchar(255) ;
ALTER TABLE ci_hardware_storage   ALTER COLUMN media_type              nvarchar(255) ;
GO

ALTER TABLE ci_network_nic        ALTER COLUMN type_net_conn           nvarchar(255) ;
GO

ALTER TABLE ci_network_controller ALTER COLUMN type_net_conn           nvarchar(255) ;
GO

ALTER TABLE ci_service             ALTER COLUMN version                nvarchar(255) ;
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15395763, getdate(), 1, 4, 'Star 15395763 : CMDB : multiple data sourcing' )
GO

COMMIT TRANSACTION 
GO

