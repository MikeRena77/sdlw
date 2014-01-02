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
/* Star 14657498 PATCH 14569492 ON MSSQL 2000		                                */
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
EXEC sp_rename 'UEAVIDATA.UENAME_of_SUBJECT', 'UENAME_OF_SUBJECT_NEWNAME', 'COLUMN';
GO

EXEC sp_rename 'UEAVIDATA.UENAME_OF_SUBJECT_NEWNAME', 'UENAME_OF_SUBJECT';
GO


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14657498, getdate(), 1, 4, 'Star 14657498 PATCH 14569492 ON MSSQL 2000' )
GO

COMMIT TRANSACTION 
GO


