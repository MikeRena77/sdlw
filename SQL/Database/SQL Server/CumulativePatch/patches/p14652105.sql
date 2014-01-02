SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 14652105 DSM:MSSQL REPLICATION PERFORMA                                         */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ca_replication_history with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* *************** 9942 begin ***************************** */
																		
CREATE  INDEX [ca_replication_history_idx1] 
	ON [dbo].[ca_replication_history](
		[table_name],[primary_uuid], [lng1]) 
	ON [PRIMARY]
GO

/* *************** 9942 begin ***************************** */

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14652105, getdate(), 1, 4, 'Star 14652105 DSM:MSSQL REPLICATION PERFORMA ' )
GO

COMMIT TRANSACTION 
GO

