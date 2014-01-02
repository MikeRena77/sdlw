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
/* Star 15047531 Portal r12 changes							*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from cmsacl10046data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10046data with (tablockx)
GO
 
Select top 1 1 from cmsurldata with (tablockx)
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
 
DROP TABLE [dbo].[CMSACL10046DATA]
GO
DROP TABLE [dbo].[CMSROLLBK10046DATA]
GO
DROP TABLE [dbo].[CMSURLDATA]
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15047531, getdate(), 1, 4, 'Star 15047531 Portal r12 changes' )
GO

COMMIT TRANSACTION 
GO

