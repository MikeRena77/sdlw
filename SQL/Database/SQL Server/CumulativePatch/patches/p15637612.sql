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
/* Star 15637612 UDBM SQL Station add indexes						*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from dbh_sql_ora with (tablockx)
GO
 
Select top 1 1 from dbh_sql_udb with (tablockx)
GO
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

CREATE  INDEX [dbh_sql_ora_inst_snapts_idx] ON [dbo].[dbh_sql_ora]([var1], [var2], [snapshot_timestamp]) ON [PRIMARY]
GO

CREATE  INDEX [dbh_sql_udb_inst_snapts_idx] ON [dbo].[dbh_sql_udb]([var1], [snapshot_timestamp]) ON [PRIMARY]
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15637612, getdate(), 1, 4, 'Star 15637612 UDBM SQL Station add indexes' )
GO

COMMIT TRANSACTION 
GO

