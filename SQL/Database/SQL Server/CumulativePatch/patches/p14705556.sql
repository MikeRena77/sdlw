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
/* Patch Star 14705556 NSM: Create trigger tng_ti_inclusion on tng_inclusion            */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */
 
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'tng_ti_inclusion' AND type = 'TR')
	DROP TRIGGER [dbo].[tng_ti_inclusion]
GO	
	
create trigger tng_ti_inclusion on tng_inclusion FOR INSERT AS
set nocount on
declare @uuid UUID

  if not exists ( select * from inserted )
    return

/* 7/29/96
   insert into tng_change_history ( operation, class_name, object_id1, portnum1,  portnum2, timestamp, user_name )
                         select  	   'i', 'Inclusion',  uuid, 		0,  	   0  , getdate(),HOST_NAME()
						 from inserted
*/

  select @uuid=uuid from inserted
  
  if(@uuid is not null)
  begin
    insert into tng_change_history ( operation, class_name, object_id1, portnum1,  portnum2, timestamp,user_name )
				            values (       'i', 'Inclusion',  @uuid, 		0,  	   0  , getdate(),HOST_NAME() )
  end
  
  return
GO


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14705556, getdate(), 1, 4, 'Patch Star 14705556 NSM: Create trigger tng_ti_inclusion on tng_inclusion ' )
GO

COMMIT TRANSACTION 
GO


