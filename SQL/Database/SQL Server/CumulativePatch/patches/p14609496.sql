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
/* star 14609496 MISSING UNIQUE INDEX			                                */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
Select top 1 1 from dbo.tng_jasmine_menu_object with (tablockx)
GO

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'baseidx_tng_jasmine_menu_object')
	drop index tng_jasmine_menu_object.baseidx_tng_jasmine_menu_object
go

create UNIQUE CLUSTERED INDEX baseidx_tng_jasmine_menu_object on dbo.tng_jasmine_menu_object(menu_name,name)
go

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14609496, getdate(), 1, 4, 'Patch Star 14609496 MISSING UNIQUE INDEX' )
GO

COMMIT TRANSACTION 
GO
