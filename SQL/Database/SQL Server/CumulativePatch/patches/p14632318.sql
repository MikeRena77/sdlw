SET LOCK_TIMEOUT 300000
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 14632318 ADD INDEX AND COLUMN (INGRES)						*/
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ca_install_package with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
alter table ca_install_package
add lang_code nchar(5) COLLATE !!sensitive;
GO

alter table ca_install_package
add constraint [$ca_re_r000005b711111111] foreign key (lang_code) 
references ca_language  (lang_code) ;
GO

create index xak9ca_install_package
on ca_install_package (ipkg_name);
GO


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14632318, getdate(), 1, 4, 'Star 14632318 ADD INDEX AND COLUMN (INGRES)' )
GO

COMMIT 
GO


