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
/* Star 15050800 TNGAMO: ca_discovered_user.uri cannot have the same uri                */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ************** 11255 insert into ca_discovered_user begin ************* */
/*
 ************************************
 * trigger: update discovered_user to
 * check uri
 */

alter trigger r_u_dis_user_uri_check
		on ca_discovered_user
		after update
as
  declare @_olduri nvarchar(255);
  declare @_newuri nvarchar(255);
  declare @_dom_uuid binary(16);


if update(uri)
BEGIN
	DECLARE mycur CURSOR
		FOR select deleted.uri, inserted.uri, deleted.domain_uuid from deleted, inserted

	OPEN mycur
	FETCH NEXT FROM mycur INTO @_olduri,@_newuri,@_dom_uuid;
	WHILE @@FETCH_STATUS = 0
	BEGIN

		execute  p_iu_dis_user_uri_check  @_olduri,@_newuri,@_dom_uuid;
		FETCH NEXT FROM mycur INTO @_olduri,@_newuri,@_dom_uuid;

	END

	CLOSE mycur
	DEALLOCATE mycur

end
go



/*
 ************************************
 * trigger: new discovered_user to
 * check uri
 */


drop trigger r_i_dis_user_uri_check
GO
drop trigger rule_i_new_so_user
GO
alter procedure p_integrity_version_number
	   @old_verno int,
	   @new_verno int
as
begin
	if(@old_verno >= @new_verno)
	begin
		raiserror('Error 9001: update error, new version number less than the old version number', 16, 1 );
		return 1;
	end;

	return 0;
end
go

/*
 ************************************
 * procedure to
 * check uri of a discovered_user object
 *
 * !!! this check can be used before insertion !!!
 */

create procedure  p_i_dis_user_uri_check
	@_olduri nvarchar(255),
	@_newuri nvarchar(255),
	@_dom_uuid binary(16)

as
   declare	@_nr 		int;
   declare @_enumber	int ;
   declare @_rcount		int;
begin

	 set nocount on;

	 /* uri null is allowed */
	 if ( @_newuri IS NULL )
	 begin
		  return 0;
	 end;

	 select @_nr = (select count(*) from ca_discovered_user
						   where uri = @_newuri and (user_type = 1 or user_type = 2) and domain_uuid = @_dom_uuid);


	if (@_nr > 0)
	begin
		 raiserror ('Error 9007: uri for discovered user not unique: ', 16,1);
		return 1;
	end;

	return 0;
end
go


GRANT  EXECUTE  ON [dbo].[p_i_dis_user_uri_check]  TO [ca_itrm_group]
go
GRANT  EXECUTE  ON [dbo].[p_i_dis_user_uri_check]  TO [ca_itrm_group_ams]
go

/*
 *******************************************
  trigger if a new user was created
*/
create trigger r_i_new_user
 on ca_discovered_user
 instead of insert
as
begin
  declare @obj_uuid binary(16);
  declare @_olduri nvarchar(255);

  declare @_newuri nvarchar(255);
  declare @_dom_uuid binary(16);
  declare @return integer;

  set nocount on;

  select @_olduri= null;
  select @_newuri= (select uri from inserted);
  select @_dom_uuid = (select domain_uuid from inserted);


  -- check of right uri
  execute @return = p_i_dis_user_uri_check @_olduri, @_newuri, @_dom_uuid;
  if (	@return = 0 )
  begin


	  -- insert into ca_discovered_user
	  insert into ca_discovered_user(user_uuid, label, user_name, domain_uuid, creation_user, creation_date,
				last_update_user, last_update_date, version_number, uri, user_type, usage_list, directory_url)
		select user_uuid, label, user_name, domain_uuid, creation_user, creation_date,
				last_update_user, last_update_date, version_number, uri, user_type, usage_list, directory_url
		from inserted;

	  -- do so updates on ca_object_ace
	  select @obj_uuid = (select user_uuid from inserted);
	  execute  proc_i_new_so_user @obj_uuid;
  end;

end;
go

/* ************** 11255 insert into ca_discovered_user end   ************* */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15050800, getdate(), 1, 4, 'Star 15050800 TNGAMO: ca_discovered_user.uri cannot have the same uri' )
GO

COMMIT TRANSACTION 
GO

