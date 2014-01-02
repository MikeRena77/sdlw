SET LOCK_TIMEOUT 300000
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 14604332 ADD ADDITIONAL GRANT FOR AMSGR						*/
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
GRANT  SELECT  ON [dbo].[inv_default_item]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_default_tree]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_externaldevice_item]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_externaldevice_tree]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_generalinventory_item]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_generalinventory_tree]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_object_tree_id]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_performance_item]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_performance_tree]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_reconcile_item]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_reconcile_tree]  TO [amsgroup]
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14604332, getdate(), 1, 4, 'Star 14604332 ADD ADDITIONAL GRANT FOR AMSGR' )
GO

COMMIT 
GO


