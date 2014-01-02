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
/* Star 14697138 HARVEST STATE DATA UPDATE						*/
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harstate with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
update harstate set locationx=147, locationy=800 where stateobjid = 1
GO

update harstate set locationx=416, locationy=356 where stateobjid = 50
GO

update harstate set locationx=347, locationy=117 where stateobjid = 54
GO 

update harstate set locationx=550, locationy=483 where stateobjid = 176
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14697138, getdate(), 1, 4, 'Star 14697138 HARVEST STATE DATA UPDATE' )
GO

COMMIT TRANSACTION 
GO


