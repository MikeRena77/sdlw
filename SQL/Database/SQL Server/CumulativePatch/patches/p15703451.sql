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
/* Star 15703451 UPM/DSM bug fix							*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from upm_baseline_sw with (tablockx)
GO
 
Select top 1 1 from upm_deployment with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
/* End of lines added to convert to online lock */
 

/* upm_baseline_sw.distribution_uuid -- NEW COLUMN */
alter table upm_baseline_sw
    add distribution_uuid binary(16) null;
go

/* upm_deployment.distribution_uuid -- NEW COLUMN */
alter table upm_deployment
    add distribution_uuid binary(16) null;
go


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15703451, getdate(), 1, 4, 'Star 15703451 UPM DSM bug fix' )
GO

COMMIT TRANSACTION 
GO

