SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO


/****************************************************************************************/
/*                                                                                      */
/* Star 14537257 CPCM:COLUMN NAME MIXED CASE						*/
/*                                                                                      */
/****************************************************************************************/
BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

EXEC sp_rename 'UEROLLBK10131DATA.UETEMPLATE_name', 'UETEMPLATE_NAME_NEWNAME', 'COLUMN';
GO

EXEC sp_rename 'UEROLLBK10131DATA.UETEMPLATE_NAME_NEWNAME', 'UETEMPLATE_NAME';
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14537257, getdate(), 1, 4, 'Star 14537257 CPCM:COLUMN NAME MIXED CASE' )
GO

COMMIT TRANSACTION 
GO


