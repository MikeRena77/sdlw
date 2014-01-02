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
/* Star 14608268 DSM : MSSQL Update to trigger r_d_links_category_def                   */
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

/* ************************************** 9575 begin ****************** */

drop trigger  r_d_links_category_def
go
drop procedure p_d_link_category_def
go
create trigger  r_d_links_category_def
	 on ca_category_def
	 instead of delete
as
  
begin
    
		delete ca_category_member from ca_category_member cm, deleted d WHERE  cm.category_uuid = d.category_uuid ;		
		delete ca_category_def from ca_category_def  cf, deleted d where cf.category_uuid= d.category_uuid ;
		
end;
go

/* ************************************** 9575 end ****************** */



/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14608268, getdate(), 1, 4, 'Star 14608268 DSM : MSSQL Update to trigger r_d_links_category_def' )
GO

COMMIT TRANSACTION 
GO


