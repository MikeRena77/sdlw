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
/* Star 15147582 HARREPOSITORY_IND MOD					*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harrepository with (tablockx)
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


DROP INDEX HARREPOSITORY.HARREPOSITORY_IND
GO

alter table harrepository alter column repositname varchar(128)
GO

CREATE UNIQUE INDEX HARREPOSITORY_IND ON HARREPOSITORY
(REPOSITNAME)
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15147582, getdate(), 1, 4, 'Star 15147582 HARREPOSITORY_IND MOD' )
GO

COMMIT TRANSACTION 
GO
