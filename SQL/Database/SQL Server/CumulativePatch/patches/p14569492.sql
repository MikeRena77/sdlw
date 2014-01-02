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
/* Star 14569492 CPCM:COLUMN NAMED INCORRECTLY		                                */
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
-- Star 14657498 (ricle02)
-- Removed because of sp_rename under MSSQL 2000 is not case sensitive on column names
--
-- EXEC sp_rename 'UEAVIDATA.UENAME_of_SUBJECT', 'UENAME_OF_SUBJECT', 'COLUMN';
-- GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14569492, getdate(), 1, 4, 'Star 14569492 CPCM:COLUMN NAMED INCORRECTLY' )
GO

COMMIT TRANSACTION 
GO


