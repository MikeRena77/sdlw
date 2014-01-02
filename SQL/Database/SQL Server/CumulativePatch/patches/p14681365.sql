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
/* Star 14681365 HARVEST PKG AND USER IND						*/
/*                                                                                      */
/****************************************************************************************/
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harpackagestatus with (tablockx)
GO
 
Select top 1 1 from haruser with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
drop index HARPACKAGESTATUS.harpackagestatus_s_idx
GO

CREATE INDEX HARPACKAGESTATUS_S_IDX ON HARPACKAGESTATUS (
            SERVERNAME, packageobjid)
GO

drop index haruser.haruser_ind
GO

create unique index haruser_ind on haruser (
            username, usrobjid,realname,passwdattrs)
GO


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14681365, getdate(), 1, 4, 'Star 14681365 HARVEST PKG AND USER IND' )
GO

COMMIT TRANSACTION 
GO

