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
/* Patch Star 14761153 WF: Add reservedby column to Simpleevent / new wf_ids table    	*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from simpleevent with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */
 
alter table simpleevent add reservedby nvarchar(32) null;
go

create table wf_ids (
	id		bigint		not null 	default 0,
	category	nvarchar(32)	not null	default ' ',
	productid	binary(16)	not null
);
go

alter table wf_ids add primary key (productid ASC,category ASC);
go

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[wf_ids]  TO [service_desk_admin_group]
GO

GRANT  SELECT  ON [dbo].[wf_ids]  TO [service_desk_ro_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[wf_ids]  TO [usmgroup]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[wf_ids]  TO [workflow_admin_group]
GO

GRANT  SELECT  ON [dbo].[wf_ids]  TO [workflow_ro_group]
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14761153, getdate(), 1, 4, 'Patch Star 14761153 WF: Add reservedby column to Simpleevent / new wf_ids table' )
GO

COMMIT TRANSACTION 
GO

