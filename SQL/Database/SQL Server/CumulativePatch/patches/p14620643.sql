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

/******************************************************************************/
/*                                                                            */
/* Star 14620643 typo in DDL 						      */
/*                                                                            */
/******************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harseqtable with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */
 

UPDATE HARSEQTABLE SET OBJID = 	( SELECT MAX(BRANCHOBJID)  FROM HARBRANCH) WHERE CTR = 'HARBRANCHSEQ'; 
GO

/*****************************************************************************/
/*                                                                           */
/* Register patch                                                     	     */
/*                                                                           */
/*****************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14620643, getdate(), 1, 4, 'Star 14620643 typo in ddl' )
GO

COMMIT TRANSACTION 
GO
