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
/* Patch Star 14507108 HARVEST: USD Integration changes                                 */
/*                                                                                      */
/****************************************************************************************/
BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harusdplatforminfo with (tablockx)
GO
 
Select top 1 1 from harusdpackageinfo with (tablockx)
GO
 
Select top 1 1 from harformattachment with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

CREATE INDEX HARUSDPLATFORMINFO_FRM_IND ON HARUSDPLATFORMINFO
(
    FORMOBJID
)
GO

CREATE INDEX HARUSDPACKAGEINFO_FRM_IND ON HARUSDPACKAGEINFO
(
    FORMOBJID
)
GO



CREATE INDEX HARFORMATTACHMENT_IND
	ON dbo.HARFORMATTACHMENT(FORMOBJID)
GO

CREATE UNIQUE INDEX HARFORMATTACHMENT_IND2
	ON dbo.HARFORMATTACHMENT(ATTACHMENTNAME, FORMOBJID)
GO






/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14507108, getdate(), 1, 4, 'Patch Star 14507108 HARVEST: USD Integration changes  ' )
GO

COMMIT TRANSACTION 
GO


