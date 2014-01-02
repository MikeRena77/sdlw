
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
/* Star 15450466 : TNGAMO: 11914: performance index 					*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */


/*
 ************************************************
 trigger for updating a area ace
 - either area_ace of a group object
 - security level ( reverting)
*/
ALTER trigger [dbo].[rule_u_so_updated_group_area]
 on [dbo].[ols_area_ace]
 after update
as
begin

	if update(area_ace)
	begin
		

		declare @_inherit_ace integer;
		declare @_group_uuid  binary(16);
		declare @_member_uuid binary(16);

		declare @_group_area_ace_new integer;
		declare @_member_area_ace 	 integer;
		declare @_group_area_ace_old integer;

		declare @_object_level integer;
		declare @_object_type  integer;
		declare @_temp_ace     integer;


		set nocount on;
		DECLARE gcur_aace CURSOR LOCAL
			FOR select inserted.object_def_uuid, inserted.area_ace, g.security_group,
						 deleted.area_ace from deleted, inserted, ca_group_def g
				where deleted.object_def_uuid = inserted.object_def_uuid
					and g.group_uuid = inserted.object_def_uuid -- only valid for group updates

		OPEN gcur_aace
		FETCH NEXT FROM gcur_aace INTO @_group_uuid, @_group_area_ace_new, @_inherit_ace, @_group_area_ace_old
		WHILE @@FETCH_STATUS = 0
		BEGIN

				-- check if it's a security group

				if(@_inherit_ace = 1)
				begin
					-- it is a security group

					-- for update area_ace for all members of the group
					declare cur_gace cursor LOCAL
						for select gm.member_uuid, oa.area_ace, oa.security_level, oa.object_type
						from ca_group_member gm, ols_area_ace ga, ols_area_ace oa
						where ga.object_def_uuid = @_group_uuid
							AND ga.object_def_uuid = gm.group_uuid
							and oa.object_def_uuid = gm.member_uuid;

					open cur_gace
					fetch cur_gace into  @_member_uuid, @_member_area_ace, @_object_level, @_object_type;
					while @@fetch_status = 0
					begin
						-- Calculate a new ace from the new parent
						if (@_object_level != 2)-- not object level
						begin

							--select @_temp_ace = (@_group_area_ace_old & ~(@_member_area_ace)  ) | @_group_area_ace_new;

							--if(@_temp_ace <> @_member_area_ace  )
							--begin
							--	update ols_area_ace
							--		set area_ace = @_temp_ace,
							--			security_level = 1    -- now group level
							--		where object_def_uuid = @_member_uuid

		   					--execute  proc_u_so_area_revert @_level, @_object_uuid, @_level_before/* 3 !!! */, @_object_type;
							if(@_group_area_ace_new <> @_member_area_ace  )
							begin
		   						execute  proc_u_so_area_revert 3, @_member_uuid, 2 /* object_level temp */, @_object_type;
									
							end;


						end;

					fetch cur_gace into  @_member_uuid, @_member_area_ace, @_object_level, @_object_type;
				end;	-- end while
				close cur_gace;
				deallocate cur_gace;

		end
		FETCH NEXT FROM gcur_aace INTO @_group_uuid, @_group_area_ace_new, @_inherit_ace, @_group_area_ace_old ;

		END -- while end
		CLOSE gcur_aace
		DEALLOCATE gcur_aace

	end;


   if update(security_level)
   begin
	IF ( (SELECT trigger_nestlevel( object_ID('rule_u_so_updated_group_area') ) ) < 2 )
	begin
		declare 	@_level 		integer;
		declare 	@_object_uuid	binary(16);
		declare 	@_level_before	integer;

		declare c_aace_upd cursor LOCAL for 
		select i.security_level, i.object_def_uuid, d.security_level, d.object_type
		from inserted as i, deleted as d where
						i.object_def_uuid = d.object_def_uuid ;
						--	and i.object_type = d.object_type;


		open c_aace_upd
		fetch from c_aace_upd into @_level, @_object_uuid, @_level_before,@_object_type --get first row

		while @@fetch_status = 0
		begin

		   execute  proc_u_so_area_revert @_level, @_object_uuid, @_level_before, @_object_type;
		   fetch from c_aace_upd into @_level, @_object_uuid,  @_level_before,@_object_type  --get next row

		end
		close c_aace_upd;
		deallocate c_aace_upd;
	end
   end;


end;

GO



/*
 **********************************************
 * trigger for deleting a group member
 * 
 * this trigger is now used for updates too.
 */

drop trigger rule_d_so_removed_group_member
go
create trigger rule_du_so_removed_group_member
	on ca_group_member
	after delete,update 
as
begin 
	declare @_object_uuid binary(16);
   
	declare cur_del cursor
	for select member_uuid
		from  deleted;
		
	open cur_del;
	fetch cur_del into @_object_uuid;     -- get first 
	while @@fetch_status = 0
	begin
	   execute  proc_d_so_removed_group_member @_object_uuid;
	   fetch cur_del into @_object_uuid;     -- get next
	end; -- while
	
	close cur_del;
	deallocate cur_del;

end;	
go

/*****************************************************************************/
/*                                                                           */
/* Register patch                                                     	     */
/*                                                                           */
/*****************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15649403, getdate(), 1, 4, 'Star 15649403 : XMGR:PERMISSIONS NOT INHERITED' )
GO

commit
