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
/* Star 14606116 WF:RM TWO CLUSTERED INDEXES						*/
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from actors with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

ALTER TABLE [dbo].[actors] DROP
       CONSTRAINT [$actor_u000041c600000000]
GO
ALTER TABLE [dbo].[actors] WITH NOCHECK ADD
       CONSTRAINT [$actor_u000041c600000000] PRIMARY KEY NONCLUSTERED
       (
               [productid],
               [actor]
       )  ON [PRIMARY]
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14606116, getdate(), 1, 4, 'Star 14606116 WF:RM TWO CLUSTERED INDEXES' )
GO

COMMIT TRANSACTION 
GO


