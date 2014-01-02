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
/* Patch Star 14793104 UPM, DSM,eVM: Alter ca_install_package.ipkg.name to case insensitive */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ca_install_package with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

drop index ca_install_package.xak9ca_install_package;
go

alter table ca_install_package
   alter column ipkg_name nvarchar(255) COLLATE !!insensitive NULL;
go

create index xak9ca_install_package
on ca_install_package (ipkg_name);
go

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14793104, getdate(), 1, 4, 'Patch Star 14793104 UPM, DSM,eVM: Alter ca_install_package.ipkg.name to case insensitive ' )
GO

COMMIT TRANSACTION 
GO


