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

/*****************************************************************************/
/*                                                                           */
/* Star 14906843 HARPKGHISTORY ACTION change				     */
/*                                                                           */
/*****************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 

Select top 1 1 from harpkghistory with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */
 
UPDATE dbo.harpkghistory set ACTION='Created' WHERE ACTION='CREATED'
GO

/*****************************************************************************/
/*                                                                           */
/* Register patch                                                            */
/*                                                                           */
/*****************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14906843, getdate(), 1, 4, 'Star 14906843 HARPKGHISTORY ACTION change')
GO

COMMIT TRANSACTION 
GO

