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
/* Star 14843483 DSM: Alter rule rule_i_new_so_sw_category for ca_category_def */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ********************** 10437 begin  ******************* */

/**
 ***********************************************
 ***********************************************
  bug fix : inserting multiple categories
  Sample : UPM does a query like 

	INSERT INTO ca_category_def 
	(category_uuid, ...) 
	SELECT t.category_uuid, .. 
	FROM #ca_category_def t 
	WHERE t.category_uuid NOT IN ( SELECT category_uuid FROM ca_category_def ) ;


 ***********************************************
 ***********************************************
 */

/*
 **********************************************
 rule for insert of Class software category
*/
alter  trigger rule_i_new_so_sw_category
	on ca_category_def
	after insert 
as
begin
	  declare @_obj_uuid   binary(16);
    declare @_clsid      integer;
    declare @_uri        nvarchar(255);

    select @_clsid = 1009;

    declare curCatIns cursor for
    	select category_uuid, creation_user from inserted;

    open curCatIns;
    fetch curCatIns into @_obj_uuid, @_uri; -- get first 
    while @@fetch_status = 0
    begin
		execute  proc_i_new_so_object @_obj_uuid, @_clsid, @_uri;
		fetch curCatIns into @_obj_uuid, @_uri; -- get next 

     end; -- while
     close curCatIns;
     deallocate curCatIns;


end;
go

/* ********************** 10437 end  ******************* */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14843483, getdate(), 1, 4, 'Star 14843483 Star 14843483 DSM: Alter rule rule_i_new_so_sw_category for ca_category_def' )
GO

COMMIT TRANSACTION 
GO

