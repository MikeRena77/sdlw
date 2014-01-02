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
/* Star 15444683 : BABLD and DSM: combine 15423964 with partial 15441161		*/	
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


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15444683, getdate(), 1, 4, 'Star 15444683 : BABLD and DSM: combine 15423964 with partial 15441161' )
GO

COMMIT TRANSACTION 
GO

