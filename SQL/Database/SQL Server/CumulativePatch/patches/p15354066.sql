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
/* Star 15354066 : TNGAMO: 11861: add indexes to optimize replication			*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */

 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

create index ca_asset_source_idx_04
on ca_asset_source(logical_asset_uuid,exclude_registration)
GO

create index ca_asset_source_idx_03
on ca_asset_source(source_location_uuid)
GO

create index ca_logical_asset_idx_03
on ca_logical_asset(asset_uuid,exclude_registration)
GO

create index ca_logical_asset_property_idx_03
on ca_logical_asset_property(logical_asset_uuid,exclude_registration)
GO


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15354066, getdate(), 1, 4, 'Star 15354066 : TNGAMO: 11861: add indexes to optimize replication' )
GO

COMMIT TRANSACTION 
GO

