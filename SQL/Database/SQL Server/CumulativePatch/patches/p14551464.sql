SET LOCK_TIMEOUT 300000
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 14551464 DASHBOARD NEEDS PERM GRANT		                                */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

IF LEFT(CAST(SERVERPROPERTY('productversion') as VARCHAR),1) = '8'
	EXEC sp_executesql N'USE master; GRANT EXECUTE ON xp_varbintohexstr to public'
ELSE
	EXEC sp_executesql N'USE master; GRANT EXECUTE ON fn_varbintohexstr to public'

GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
  values ( 14551464, getdate(), 1, 4, 'Star 14551464 DASHBOARD NEEDS PERM GRANT' )
GO

COMMIT 
GO


