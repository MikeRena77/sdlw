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
/* Star 15860702 HARPACKAGEGROUP PKGGRPNAME						*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harpackagegroup with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
/* End of lines added to convert to online lock */

DROP INDEX HARPACKAGEGROUP.HARPKGGRP_IND
GO

ALTER TABLE HARPACKAGEGROUP 
ALTER COLUMN PKGGRPNAME VARCHAR(128) COLLATE !!sensitive NOT NULL
GO

CREATE UNIQUE INDEX HARPKGGRP_IND ON HARPACKAGEGROUP
(
    ENVOBJID
  , PKGGRPNAME
)
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15860702, getdate(), 1, 4, 'Star 15860702 HARPACKAGEGROUP PKGGRPNAME' )
GO

COMMIT TRANSACTION 
GO
