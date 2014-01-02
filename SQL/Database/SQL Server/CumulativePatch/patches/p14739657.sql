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
/* Patch Star 14739657 Portal & CPCM: Rename UEMPEGDATA.UEMPEG_version.UEMPEG_VERSION column */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

EXEC sp_rename 'UEMPEGDATA.UEMPEG_version', 'UEMPEG_VERSIONx','COLUMN';
GO

EXEC sp_rename 'UEMPEGDATA.UEMPEG_VERSIONx', 'UEMPEG_VERSION','COLUMN';
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14739657, getdate(), 1, 4, 'Patch Star 14739657 Portal & CPCM: Rename UEMPEGDATA.UEMPEG_version.UEMPEG_VERSION column ' )
GO

COMMIT TRANSACTION 
GO


