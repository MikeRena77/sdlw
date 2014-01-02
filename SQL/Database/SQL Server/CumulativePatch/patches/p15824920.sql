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
/* star 15824920 UNIQUE INDEXES MISSING                               */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from chgcat with (tablockx)
GO
 
Select top 1 1 from chgstat with (tablockx)
GO
 
Select top 1 1 from act_type with (tablockx)
GO
 
Select top 1 1 from cr_stat with (tablockx)
GO
 
Select top 1 1 from crt with (tablockx)
GO
 
Select top 1 1 from isscat with (tablockx)
GO
 
Select top 1 1 from issstat with (tablockx)
GO
 
Select top 1 1 from srv_desc with (tablockx)
GO
 
Select top 1 1 from tskstat with (tablockx)
GO
 
Select top 1 1 from tskty with (tablockx)
GO
 
Select top 1 1 from prptpl with (tablockx)
GO
 
Select top 1 1 from tspan with (tablockx)
GO
 
Select top 1 1 from tz with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
/* End of lines added to convert to online lock */

 
/* create missing unique indexes */
 
CREATE UNIQUE INDEX [chgcat_x3] ON [dbo].[chgcat]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [chgstat_x2] ON [dbo].[chgstat]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [act_type_x2] ON [dbo].[act_type]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [cr_stat_x2] ON [dbo].[cr_stat]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [crt_x1] ON [dbo].[crt]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [isscat_x3] ON [dbo].[isscat]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [issstat_x2] ON [dbo].[issstat]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [srv_desc_x2] ON [dbo].[srv_desc]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [tskstat_x2] ON [dbo].[tskstat]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [tskty_x2] ON [dbo].[tskty]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [tspan_x1] ON [dbo].[tspan]([code]) ON [PRIMARY]
GO

CREATE UNIQUE INDEX [tz_x1] ON [dbo].[tz]([code]) ON [PRIMARY]	 
GO


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15824920, getdate(), 1, 4, 'Patch Star 15824920 UNIQUE INDEXES MISSING' )
GO

COMMIT TRANSACTION 
GO

