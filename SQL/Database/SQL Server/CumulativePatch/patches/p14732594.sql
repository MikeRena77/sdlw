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

/* lock objects... */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harudp with (tablockx)
GO
 
Select top 1 1 from haruserdata with (tablockx)
GO
 
Select top 1 1 from harlinkedprocess with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/****************************************************************************/
/*                                                                          */
/* Patch Star 14732594 new columns for haruserdata                          */
/*                                                                          */
/****************************************************************************/

ALTER TABLE [dbo].[haruserdata] ADD SWLogin CHAR(1) DEFAULT 'N' NOT NULL;
GO
ALTER TABLE [dbo].[haruserdata] ADD AccountDisabled CHAR(1) DEFAULT 'N' NOT NULL;
GO
ALTER TABLE [dbo].[haruserdata] ADD AccountLocked CHAR(1) DEFAULT 'N' NOT NULL;
GO

/****************************************************************************/
/*                                                                          */
/*  register patch                                                          */
/*                                                                          */
/****************************************************************************/
insert into mdb_patch values ( 14732594, getdate(), null, 1, 4, null, 'Star 14732594 new columns for haruserdata' )
GO

COMMIT TRANSACTION
GO
