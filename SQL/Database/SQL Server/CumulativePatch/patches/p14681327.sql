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
/* Star 14681327 NEEDS TO ADD UNIQUE INDICES						*/
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from isscat with (tablockx)
GO
 
Select top 1 1 from prob_ctg with (tablockx)
GO
 
Select top 1 1 from chgcat with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
CREATE  UNIQUE  INDEX [isscat_x2] ON [dbo].[isscat]([sym], [owning_contract]) ON [PRIMARY]
GO

CREATE  UNIQUE  INDEX [prob_ctg_x2] ON [dbo].[prob_ctg]([sym], [owning_contract]) ON [PRIMARY]
GO

CREATE  UNIQUE  INDEX [chgcat_x2] ON [dbo].[chgcat]([sym], [owning_contract]) ON [PRIMARY]
GO


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14681327, getdate(), 1, 4, 'Star 14681327 NEEDS TO ADD UNIQUE INDICES' )
GO

COMMIT TRANSACTION 
GO


