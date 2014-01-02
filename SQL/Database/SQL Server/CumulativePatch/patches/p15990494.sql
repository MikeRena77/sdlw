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
/* Star 15990494 BSO Process Manager: BAM component changes				*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
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

grant select on ActivitiesLateCompView to [aionadmin_group];
GO

grant select on ActivitiesLateIncompView to [aionadmin_group];
GO

grant select on ActivitiesAvgOverdueView to [aionadmin_group];
GO

grant select on ActivitiesTimeToDueDate to [aionadmin_group];
GO

grant select on ActorBottleneckView to [aionadmin_group];
GO

grant select on ActorThroughputView to [aionadmin_group];
GO

 
/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15990494, getdate(), 1, 4, ' Star 15990494 BSO Process Manager: BAM component changes' )
GO

COMMIT TRANSACTION 
GO

