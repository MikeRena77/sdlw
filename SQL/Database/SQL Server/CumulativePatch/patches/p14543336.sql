SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 14543336 DSM: MSSQL SERVICE DESK INTEG                                          */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from am_external_device_def with (tablockx)
GO
 
Select top 1 1 from ca_discovered_hardware_network with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

/********************** 9278 begin ****************** */


alter table am_external_device_def alter column [map_macaddress] [nvarchar] (255) collate !!insensitive  NULL
go
alter table ca_discovered_hardware_network
	drop constraint XPKca_discovered_hardware_network
go
alter table ca_discovered_hardware_network alter column mac_address nvarchar(64) collate !!insensitive NOT NULL
go

ALTER TABLE [dbo].[ca_discovered_hardware_network] WITH NOCHECK ADD 
	CONSTRAINT [XPKca_discovered_hardware_network] PRIMARY KEY  CLUSTERED 
	(
		[dis_hw_uuid],
		[mac_address],
		[dns_name]
	)  ON [PRIMARY] 
GO


/********************** 9278 end ****************** */

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14543336, getdate(), 1, 4, 'Star 14543336 DSM: MSSQL SERVICE DESK INTEG ' )
GO

COMMIT TRANSACTION 
GO


