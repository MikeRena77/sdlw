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
/* Star 16029018  UAPM: new tables arg_job and arg_job_task				*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
Select top 1 1 from sysobjects with (tablockx)
GO

Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_arg_job_task_arg_job]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[arg_job_task] DROP CONSTRAINT FK_arg_job_task_arg_job
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[arg_job]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[arg_job]
GO

CREATE TABLE [dbo].[arg_job] (
	[job_id] [int] NOT NULL ,
	[definition] [image] NULL ,
	[owner] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[object_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[object_type] [int] NOT NULL ,
	[action] [int] NULL ,
	[status] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[status_message] [nvarchar] (2000) COLLATE !!insensitive NULL ,
	[server_name] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[job_type] [int] NULL ,
	[process_id] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[category] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[creation_user] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[creation_date] [int] NULL ,
	[last_update_user] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[last_update_date] [int] NULL ,
	[version_number] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[arg_job] WITH NOCHECK ADD 
	CONSTRAINT [PK_arg_job] PRIMARY KEY  CLUSTERED 
	(
		[job_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[arg_job] ADD 
	CONSTRAINT [DF_arg_job_version_number] DEFAULT (0) FOR [version_number]
GO

 CREATE  INDEX [arg_job_idx_01] ON [dbo].[arg_job]([category]) ON [PRIMARY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[arg_job_task]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[arg_job_task]
GO

CREATE TABLE [dbo].[arg_job_task] (
	[job_id] [int] NOT NULL ,
	[object_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[object_type] [int] NULL ,
	[status] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[status_message] [nvarchar] (2000) COLLATE !!insensitive NULL ,
	[creation_date] [int] NULL ,
	[creation_user] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[last_update_date] [int] NULL ,
	[last_update_user] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[version_number] [int] NOT NULL ,
	[job_task_id] [int] NOT NULL ,
	[server_name] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[job_type] [int] NULL ,
	[process_id] [nvarchar] (255) COLLATE !!insensitive NULL ,
	[category] [nvarchar] (255) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[arg_job_task] WITH NOCHECK ADD 
	CONSTRAINT [PK_arg_job_task] PRIMARY KEY  CLUSTERED 
	(
		[job_id],
		[job_task_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[arg_job_task] ADD 
	CONSTRAINT [DF_arg_job_task_version_number] DEFAULT (0) FOR [version_number]
GO

ALTER TABLE [dbo].[arg_job_task] ADD 
	CONSTRAINT [arg_job_task_fk01] FOREIGN KEY 
	(
		[job_id]
	) REFERENCES [dbo].[arg_job] (
		[job_id]
	)
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 16029018, getdate(), 1, 4, 'Star 16029018  UAPM: new tables arg_job and arg_job_task' )
GO

COMMIT TRANSACTION 
GO

