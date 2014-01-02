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
/* Star 15273404 DSM: 11720: ols group area permission					*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

/*
 *****************************************************
 procedure for calcuating the area permission 

	@param	@object_uuid uuid of the objects to be updated
	@param	@_object_type	object type
	
	@return	 NULL in case it is not a member of a group 
		    otherwise area permission based on the memberships
 */

create function [dbo].ols_fn_getGroupAreaPerm(
			@object_uuid	binary(16),	   /* old.object_def_uuid */
			@_object_type 	integer		   /* old.object_type */

)
returns integer			-- area permission
as
begin
	
	declare @gcnt integer;

	
	set @gcnt = 0;
	select @gcnt = ( select count(*) cnt from ca_group_member m, ca_group_def g
							where m.member_uuid = @object_uuid
							and m.group_uuid = g.group_uuid
							and g.security_group = 1);
	if( @gcnt > 0 )
	begin
		-- the object is a member of a group, we need to calculate the area_ace
		declare @object_ace integer;
		declare @parent_ace integer;
			
		set @parent_ace = 0;	-- set default value
		set @object_ace = 0;	-- set default value

		declare parent_ace_list cursor local for
		select area_ace
		from ols_area_ace
		where object_def_uuid in
		(select g.group_uuid from ca_group_member m , ca_group_def g
		where m.member_uuid = @object_uuid
				and m.group_uuid = g.group_uuid
				and g.security_group = 1)

		
		open parent_ace_list
		fetch from parent_ace_list into @parent_ace --get first ace
		while @@fetch_status = 0
		begin
			
			select @object_ace = (@object_ace | @parent_ace)
			
			fetch from parent_ace_list into @parent_ace  --get next ace
		end
		close parent_ace_list
		deallocate parent_ace_list
		return @object_ace;		
		
	end;
	
	-- the object is NOT member of a group
	return NULL;
	
end
GO


grant execute on ols_fn_getGroupAreaPerm to ca_itrm_group
go
grant execute on ols_fn_getGroupAreaPerm to ca_itrm_group_ams
go



/*
 ********************************************
 procedure runs if a new member was created
 in the ca_group_member table

 parameters
	@ngmem_uuid		uuid of the new group member
	@nggroup_uuid	uuid of the assigned group


  post-condition
	if it is not and inheritance group then nothing was done

	if it is inheritance group  then the object_ace was
	calculated based on the object_ace of the parent group

	In case  the security_level of the member object_ace
	is set to class level,
	then the member object_ace is set to the parent group ace

	else the security_level of the object_ace is set to group level
	In this case the new member object_ace is ORed with the parent group
	ace

 */
alter  procedure  proc_i_new_so_group_member
	@ngmem_uuid binary(16),
	@nggroup_uuid binary(16)

as

  declare @_inherit_ace integer;
  declare @_sp_uuid  binary(16);
  declare @_object_level  integer;
  declare @_object_ace  integer;
  declare @_parent_ace  integer;

  declare @_temp_ace  integer;
  declare @_parent_access  integer;

begin

	set nocount on;
	-- check if it's a security group
	select @_inherit_ace = (select g.security_group
								from ca_group_def g
								where g.group_uuid = @nggroup_uuid);

	if(@_inherit_ace = 1)
	begin
		-- it is a security group
		 declare cur_sp cursor
			for select o.security_profile_uuid, o.security_level, o.ace, g.ace, g.access
			from ca_object_ace o, ca_group_ace g
			where g.group_def_uuid = @nggroup_uuid AND
				o.object_def_uuid = @ngmem_uuid  AND
				o.security_profile_uuid = g.security_profile_uuid
		 open cur_sp
		 fetch cur_sp into @_sp_uuid, @_object_level, @_object_ace, @_parent_ace, @_parent_access;
		 while @@fetch_status = 0
		 begin
			-- Calculate a new ace from the new parent
			if (@_object_level = 0)-- class
			begin
				update ca_object_ace
					set ace = @_parent_ace, access = @_parent_access, security_level = 1
					where object_def_uuid = @ngmem_uuid AND security_profile_uuid = @_sp_uuid;
				 end
			else if (@_object_level = 1) -- group
			begin
				select @_temp_ace = (@_object_ace | @_parent_ace);

				if(@_temp_ace <> @_object_ace  )
				begin
					update ca_object_ace
						set ace = @_temp_ace, access = @_parent_access, security_level = 1
						where object_def_uuid = @ngmem_uuid AND security_profile_uuid = @_sp_uuid;
				end;
			end;

			fetch cur_sp into @_sp_uuid, @_object_level, @_object_ace, @_parent_ace, @_parent_access;
		  end;	-- end while
		  close cur_sp;
		  deallocate cur_sp;


		-- re-caclulate the area ace now
		-- update area ace of the group member
		declare @_level_before integer;
		select @_level_before = (select security_level from ols_area_ace where object_def_uuid = @ngmem_uuid) ;

		declare @_object_type integer;
		select @_object_type = (select object_type from ols_area_ace where object_def_uuid = @ngmem_uuid) ;

        -- set the area permission to group level in case it is not object level
		if  (@_level_before != 2)
        begin
			declare @grp_area_ace int;
			select @grp_area_ace = (select dbo.ols_fn_getGroupAreaPerm(@ngmem_uuid, @_object_type));
			if( @grp_area_ace is not NULL)
    			update ols_area_ace set area_ace = @grp_area_ace,
						security_level = 1			-- set to group level now 
					where object_def_uuid = @ngmem_uuid
						and object_type = @_object_type;
        end;

   end;
end

GO




/*
 **********************************************
 * procedure starts if a group member was deleted
 */
alter procedure  [dbo].[proc_d_so_removed_group_member]
		@_object_uuid binary(16) /* old.member_uuid; */

as

  declare  @_sp_uuid 	binary(16);
  declare  @_object_class_uuid binary(16);
  declare  @_object_ace 	integer;
  declare  @_object_access 	integer;
  declare  @_object_level 	integer;
  declare  @_object_type	integer;
  declare  @_parent_ace 	integer;
  declare  @_parent_access 	integer;


begin

	set nocount on;

	declare cur_oace cursor
	for select security_profile_uuid, object_type
		from ca_object_ace
		where object_def_uuid = @_object_uuid AND security_level = 1

	open cur_oace;
	fetch cur_oace into @_sp_uuid, @_object_type;
	while @@fetch_status = 0
	begin

		select @_object_class_uuid = (select class_def_uuid
												from ca_security_class_def
												where class_id = @_object_type);

		-- start with class ace values
		select @_object_ace = (select ace from ca_class_ace
												where class_def_uuid = @_object_class_uuid and security_profile_uuid = @_sp_uuid);
		select @_object_access = (select  access from ca_class_ace
												where class_def_uuid = @_object_class_uuid and security_profile_uuid = @_sp_uuid);

		select @_object_level = 0;


		-- Calculate a new ace from all its parents that has inheritance enabled
		declare cur_gace cursor
		for select a.ace, a.access
			from ca_group_ace a, ca_group_member m
			where a.security_profile_uuid = @_sp_uuid and a.enable_inheritance = 1
				and a.group_def_uuid=  m.group_uuid and m.member_uuid = @_object_uuid

		open cur_gace;
		fetch cur_gace into @_parent_ace, @_parent_access --get first ace;
		while @@fetch_status = 0
		begin

			-- message 3 'proc_d_so_removed_group_member ca_group_ace';
			if ( @_object_level = 0 ) -- still class level

					select @_object_ace = @_parent_ace;
			else if (@_object_level = 1)

				select @_object_ace = (@_object_ace | @_parent_ace);


			select @_object_access = @_parent_access;
			select @_object_level = 1; -- set security level = group level
			if (@_parent_access = 0)

				break;

			fetch cur_gace into @_parent_ace, @_parent_access --get next ace;
		end; -- while
		close cur_gace;
		deallocate cur_gace;

		update ca_object_ace
			set ace = @_object_ace, access = @_object_access, security_level = @_object_level
			where object_def_uuid = @_object_uuid AND security_profile_uuid = @_sp_uuid;


		fetch cur_oace into @_sp_uuid, @_object_type; -- get next
	end; -- end while
	close cur_oace;
	deallocate cur_oace;


	-- update area ace of the group member
	select @_object_type = (select object_type from ols_area_ace where object_def_uuid = @_object_uuid) ;

    -- update the security level of the object to object level
	-- in case it is not
	declare @grp_area_ace int;
	select @grp_area_ace = (select dbo.ols_fn_getGroupAreaPerm(@_object_uuid, @_object_type));
	if( @grp_area_ace is NULL)
	begin
		-- object is not longer a member of any group
		-- set it o object level in case it is not 
    	update ols_area_ace set security_level = 2
					where object_def_uuid = @_object_uuid
						and object_type = @_object_type
						and security_level != 2;
	end
    else
    begin
    	update ols_area_ace set area_ace= @grp_area_ace
					where object_def_uuid = @_object_uuid
						and object_type = @_object_type
						and security_level = 1;
	end;


end;
GO



/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15273404, getdate(), 1, 4, 'Star 15273404 DSM: 11720: ols group area permission' )
GO

COMMIT TRANSACTION 
GO

