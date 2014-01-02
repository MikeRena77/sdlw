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
/* Patch Star 14573732 AI: Removal of Primary Key Constraint for "olorgname" in table   */
/*                         ud_orgdef_list                                               */
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

-- Code that should be executed to remove exisitng Primary Key constraint

IF EXISTS(select name From dbo.sysobjects where name like 'ud_orgdef_list_pk') 
	ALTER TABLE [dbo].[ud_orgdef_list] DROP CONSTRAINT [ud_orgdef_list_pk]
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14573732, getdate(), 1, 4, 'Patch Star 14573732 AI: Removal of Primary Key Constraint for "olorgname" in table ud_orgdef_list' )
GO

COMMIT TRANSACTION 
GO
