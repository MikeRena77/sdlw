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
/* Star 14626896 Service Desk: Increase sym column (prob_ctg, chgcat, isscat) to 128    */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from prob_ctg with (tablockx)
GO
 
Select top 1 1 from chgcat with (tablockx)
GO
 
Select top 1 1 from isscat with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

ALTER TABLE prob_ctg 
	ALTER COLUMN sym nvarchar(128) collate !!insensitive NOT NULL 
GO

ALTER TABLE chgcat 
	ALTER COLUMN sym nvarchar(128) collate !!insensitive NOT NULL 
GO

ALTER TABLE isscat 
	ALTER COLUMN sym nvarchar(128) collate !!insensitive NOT NULL 
GO





/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14626896, getdate(), 1, 4, 'Star 14626896 Service Desk: Increase sym column (prob_ctg, chgcat, isscat) to 128' )
GO

COMMIT TRANSACTION 
GO

