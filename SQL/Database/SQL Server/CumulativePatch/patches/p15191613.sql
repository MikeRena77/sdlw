
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
/* Star 15191613 DSM: OLS area procedures						*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

Select top 1 1 from mdb_patch with (tablockx)
GO

/* ************************** 11466 10858 11494 begin **************/



/**
 ******************************************************
 * set/reset area  bit
 * used to manage the area permission in case an area was added, deleted
 */


alter procedure ols_sp_area_changed (
	@action		int,		-- 0 area was deleted, 1 area was created	
	@area_id	int		-- area uuid
)
as 
begin
	
	declare @aBit int;
	
	
	if ( @area_id > 31 )
	begin
			raiserror ('Error 9019: Area_id in ols_area_def greater than 31.', 16, 1);
			return;
	end;

	if ( @area_id = 31 )
		set @aBit	= 0x80000000;
	else
		-- < 31
		select @aBit = (power(2,@area_id));


	if (@action = 0)
	begin
 
		/* area is deleted */
		update ca_settings 
			set 	set_val_lng = (set_val_lng | @aBit )
			where 	set_id = 900;

		-- area was deleted - unlink the area
		-- level 4 will be updated, when ca_settings is changed
		update ols_area_ace set area_ace = (area_ace & ~(@aBit))
			where security_level = 0;
		update ols_area_ace set area_ace = (area_ace | @aBit)
			where security_level = 1 or security_level = 2;
		update ca_security_profile set area_ace = (area_ace & ~(@aBit))
			where buildin_profile = 0; -- not build in profile
	end;
/*
	else
	begin 
		-- area was set
		declare @g_area_ace int;

		select @g_area_ace = (select set_val_lng from ca_settings where set_id = 900);
		if(  @g_area_ace is null )
			return;
		if ( (@g_area_ace & @aBit) != 0 )
		begin
			-- bit is set in global settings
			--update ols_area_ace set area_ace= area_ace | @aBit;
			-- update ca_security_profile set area_ace= area_ace | @aBit;
		end
		else
			-- bit is not set in global settings
			begin 
				
			update ols_area_ace set area_ace = (area_ace & ~(@aBit));
			update ca_security_profile set area_ace = (area_ace & ~(@aBit));
			end
		
	end;
*/
end
go

grant execute on [dbo].ols_sp_area_changed to ca_itrm_group
go
grant execute on [dbo].ols_sp_area_changed to ca_itrm_group_ams
go



/*
 *********************************************************
 *********************************************************
 * Procedures and rules to manage security profiles
 *********************************************************
 *********************************************************
 */
/*
 *****************************************************
 procedure for updating the security_level of a area definition
 as well as the area permission in case of reverting 
	The security API sets the Security_level = 3 to signal that 
	we need to reverting the area permissiosn as follow:

	if obejct is member of a securiyt group
		--> revert to sec level 1  :: group level

	if( object i not member of a group but creation user is known)
		--> revert to sec level = 0 :: creation user level

	others
		--> revert to default value


	Note: reverting is onyl needed if
	current security level = 3		
			previous securiyt level = 2 ( object level)


	@param 			@_level curent securoty level (should be 3)

	@param			@object_uuid uuid of the objects to be updated

	@object_uuid	@_level_before	old securiyt level

	@param	@_object_type	object type
 */

alter procedure [dbo].proc_u_so_area_revert(
			@_level 		integer,		  /* new.security_level */
			@object_uuid	binary(16),	   /* old.object_def_uuid */
			@_level_before	integer,		  /* old.security_level */
			@_object_type 	integer		   /* old.object_type */

)
as
begin
	
	declare @gcnt integer;

	set nocount on;
	if ( @_level = 3 -- reverting
		and @_level_before = 2 ) -- object level before. Set to group ace
	begin

		  set @gcnt = 0;
		  select @gcnt = ( select count(*) from ca_group_member m , ca_group_def g
							  where m.member_uuid = @object_uuid
							  and  m.group_uuid = g.group_uuid
							  and g.security_group  = 1 );
		  if( @gcnt > 0 )
		  begin
			-- the object is a member of a group, then we need to recalculate the area_ace
			-- revert to group level

			declare @_object_class_uuid binary(16);
			declare @object_ace integer;
			declare @object_access integer;
			declare @object_level integer;
			declare @parent_ace integer;
			declare @parent_access integer;
			declare @ace_found integer;

			set @parent_ace = 0;	-- set default value
			set @object_ace = 0;	-- set default value

			declare parent_ace_list cursor for
			select area_ace
			from ols_area_ace
			where object_def_uuid in
			(select g.group_uuid from ca_group_member m , ca_group_def g
			where m.member_uuid = @object_uuid
					and m.group_uuid = g.group_uuid
					and g.security_group = 1)

			select @object_level = 0 -- set security level
			open parent_ace_list
			fetch from parent_ace_list into @parent_ace --get first ace
			while @@fetch_status = 0
			begin
				select @ace_found = 1  -- ace calculated
				if @object_level = 0 -- still class level
					begin
						select @object_ace = @parent_ace
					end
				else if @object_level = 1
					begin
						select @object_ace = (@object_ace | @parent_ace)
					end

				select @object_level = 1 -- set security level = group level

				fetch from parent_ace_list into @parent_ace  --get next ace
			end
			close parent_ace_list
			deallocate parent_ace_list


			update ols_area_ace set area_ace = @object_ace, security_level = @object_level
			  where object_def_uuid = @object_uuid;
		  end
		  else
		  begin
			-- the object is NOT member of a group
			-- we need to revert to creation user level / OR global level
			declare @uri nvarchar(255);
			
			select @uri = (	select creation_user from ols_area_ace 
				where object_def_uuid =  @object_uuid)
			-- in case of null then  we will get the gloabl settings
			execute ols_sp_setAreaCodeByUser @uri, @object_uuid, @_object_type;
		   end;
	end;


end

go

grant execute on [dbo].proc_u_so_area_revert to ca_itrm_group
go
grant execute on [dbo].proc_u_so_area_revert to ca_itrm_group_ams
go



/* ************************** 11466 10858 11494 end **************/

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15191613, getdate(), 1, 4, 'Star 15191613 DSM: OLS area procedures' )
GO

COMMIT TRANSACTION 
GO

