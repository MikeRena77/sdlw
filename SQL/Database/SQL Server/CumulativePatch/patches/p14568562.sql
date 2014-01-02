SET LOCK_TIMEOUT 300000
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 14568562 HARVEST - 2 TABLES TO DELETE                                			*/
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harreceiveupdates with (tablockx)
GO
 
Select top 1 1 from harsendupdates with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
drop table harreceiveupdates
go
drop table harsendupdates
go

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14568562, getdate(), 1, 4, 'Star 14568562 HARVEST - 2 TABLES TO DELETE' )
GO

COMMIT 
GO


