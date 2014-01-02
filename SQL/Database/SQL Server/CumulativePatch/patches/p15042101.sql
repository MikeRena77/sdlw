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
/* Star 15042101 INCORRECT UNIQUE INDEX 4 LINKS				*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harlinkedprocess with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
/* End of lines added to convert to online lock */

drop index HARLINKEDPROCESS.HARLINKEDPROCESS_IND
GO

CREATE UNIQUE INDEX HARLINKEDPROCESS_IND
	            ON HARLINKEDPROCESS
	            (PARENTPROCOBJID,
	            PROCESSNAME,
	            PROCESSPRELINK)
GO


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15042101, getdate(), 1, 4, 'Star 15042101 INCORRECT UNIQUE INDEX 4 LINKS' )
GO

COMMIT TRANSACTION 
GO
