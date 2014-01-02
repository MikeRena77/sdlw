SET LOCK_TIMEOUT 300000
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

/****************************************************************************************/
/*                                                                                      */
/* Patch Star 14590854 ADD GROUP AND GRANTS FOR AMS					*/
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
GRANT  SELECT  ON [dbo].[arg_action]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[arg_actiondf]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[arg_actionlk]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[ca_asset_subschema]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[ca_n_tier]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[ca_settings]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_root_map]  TO [amsgroup]
GO
GRANT  SELECT  ON [dbo].[inv_table_map]  TO [amsgroup]
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14590854, getdate(), 1, 4, 'Patch Star 14590854 ADD GROUP AND GRANTS FOR AMS' )
GO

COMMIT 
GO


