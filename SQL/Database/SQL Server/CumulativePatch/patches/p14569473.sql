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
/* Star 14569473 CPCM:MISSING PERMISSIONS		                                */
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[UEPERSISTANTSTATEINFORMATIONDATA]  TO [portaldba_group]
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14569473, getdate(), 1, 4, 'Star 14569473 CPCM:MISSING PERMISSIONS' )
GO

COMMIT TRANSACTION 
GO


