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

/*****************************************************************************/
/*                                                                           */
/* Star 15089641 index revision needed	 		                     */
/*                                                                           */
/*****************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from haritems with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

drop index HARITEMS.haritems_itemnameupper
go
create index HARITERMS_ITEMNAMEUPPPER ON dbo.HARITEMS
(
  ITEMNAMEUPPER,
  PARENTOBJID,
  ITEMOBJID,
  ITEMNAME,
  REPOSITOBJID)
GO
 
/*****************************************************************************/
/*                                                                           */
/* Register patch                                                      	     */
/*                                                                           */
/*****************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15089641, getdate(), 1, 4, 'Star 15089641 index revision needed' )
GO

COMMIT TRANSACTION 
GO
