SET LOCK_TIMEOUT 300000
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 14568542 HARVEST PK MISSING						                                */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harassocpkg with (tablockx)
GO
 
Select top 1 1 from harseqtable with (tablockx)
GO
 
Select top 1 1 from haruserdata with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
ALTER TABLE HARASSOCPKG ADD CONSTRAINT HARASSOCPKG_PK PRIMARY KEY
	( FORMOBJID   , ASSOCPKGID );
GO

ALTER TABLE HARSEQTABLE ADD CONSTRAINT HARSEQTABLE_PK PRIMARY KEY
	( CTR );
GO

ALTER TABLE HARUSERDATA ADD CONSTRAINT HARUSERDATA_PK PRIMARY KEY
	( USROBJID );
GO


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14568542, getdate(), 1, 4, 'Star 14568542 HARVEST PK MISSING' )
GO

COMMIT 
GO


