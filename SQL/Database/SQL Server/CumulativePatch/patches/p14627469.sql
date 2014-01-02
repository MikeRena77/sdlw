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
/* Star 14627469 CPCM:MIXED CASE COLUMN NAMES						*/
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
EXEC sp_rename 'UEROLLBK10123DATA.UEMPEG_version', 'UEMPEG_VERSION_NEWNAME', 'COLUMN';
GO
EXEC sp_rename 'UEROLLBK10123DATA.UEMPEG_VERSION_NEWNAME', 'UEMPEG_VERSION';
GO

EXEC sp_rename 'UEMPEGDATA.UEMPEG_version', 'UEMPEG_VERSION_NEWNAME', 'COLUMN';
GO
EXEC sp_rename 'UEMPEGDATA.UEMPEG_VERSION_NEWNAME', 'UEMPEG_VERSION';
GO

EXEC sp_rename 'UEROLLBK10109DATA.UENAME_of_SUBJECT', 'UENAME_OF_SUBJECT_NEWNAME', 'COLUMN';
GO
EXEC sp_rename 'UEROLLBK10109DATA.UENAME_OF_SUBJECT_NEWNAME', 'UENAME_OF_SUBJECT';
GO


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14627469, getdate(), 1, 4, 'Star 14627469 CPCM:MIXED CASE COLUMN NAMES' )
GO

COMMIT TRANSACTION 
GO


