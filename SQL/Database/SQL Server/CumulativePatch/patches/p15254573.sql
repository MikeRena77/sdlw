SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
BEGIN TRANSACTION 
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 15254573 : TNGAMO: add trigger to improve performance 				*/ 
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO

Select top 1 1 from ca_object_ace with (tablockx)
GO

Select top 1 1 from ca_group_ace with (tablockx)
GO
 
Select top 1 1 from ca_group_def with (tablockx)
GO

Select top 1 1 from ca_class_ace with (tablockx)
GO
 
Select top 1 1 from usd_swfold with (tablockx)
GO
 
Select top 1 1 from csm_object with (tablockx)
GO
 
 
/* Start of locks for dependent tables */

Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

alter trigger rule_u_so_updated_object_ace
	 on ca_object_ace
	 after update
as 
begin
  
   declare 	@_level 	integer;
   declare 	@_object_uuid	binary(16);
   declare 	@_sp_uuid	binary(16);
   declare 	@_level_before	integer;
   declare 	@_object_type 	integer;
/*	
   select @_level 		=  (select security_level from inserted);
   select @_object_uuid	= (select object_def_uuid from deleted);
   select @_sp_uuid	= (select security_profile_uuid from deleted);
   select @_level_before	= (select security_level from  deleted);
   select @_object_type 	= (select object_type from deleted);	
--    execute  proc_u_so_updated_object_ace @_level, @_object_uuid, @_sp_uuid, @_level_before, @_object_type;

*/
	IF ( (SELECT trigger_nestlevel( object_ID('rule_u_so_updated_object_ace') ) ) < 2 )
	begin

		declare c_oace_upd cursor local
		for select i.security_level, i.object_def_uuid, d.security_profile_uuid, d.security_level, d.object_type
		from inserted as i, deleted as d 
		where i.security_profile_uuid = d.security_profile_uuid 
						and i.object_def_uuid = d.object_def_uuid ;/* itrac 12093*/
	--					and i.object_type = d.object_type;
	 
	   
		open c_oace_upd
		fetch from c_oace_upd into @_level, @_object_uuid, @_sp_uuid, @_level_before,@_object_type --get first row
		
		while @@fetch_status = 0
		begin
	   
		execute  proc_u_so_updated_object_ace @_level, @_object_uuid, @_sp_uuid, @_level_before, @_object_type;
			fetch from c_oace_upd into @_level, @_object_uuid, @_sp_uuid, @_level_before,@_object_type  --get next row
		
		end
		close c_oace_upd;
		deallocate c_oace_upd;
	end

end
go





/*
 ************************************************
 trigger for updating a group ace
*/
ALTER trigger [dbo].[rule_u_so_updated_group_ace]
 on [dbo].[ca_group_ace]
 after update
as
begin
	if update(ace)
	begin
		declare @_group_uuid binary(16);
		declare @_sp_uuid binary(16);
		declare @_group_ace integer;
		declare @_group_enable_inheritance integer;
		declare @_group_old_ace integer;
		declare @_group_old_enable_inheritance integer;

		set nocount on;

		DECLARE mycur cursor local
			FOR select inserted.group_def_uuid, inserted.security_profile_uuid, inserted.ace,
					inserted.enable_inheritance, deleted.ace, deleted.enable_inheritance from deleted, inserted
					where inserted.group_def_uuid = deleted.group_def_uuid
						  and inserted.security_profile_uuid = deleted.security_profile_uuid /* itrac 12093*/

		OPEN mycur
		FETCH NEXT FROM mycur INTO @_group_uuid, @_sp_uuid, @_group_ace, @_group_enable_inheritance, @_group_old_ace, @_group_old_enable_inheritance
		WHILE @@FETCH_STATUS = 0
		BEGIN

			execute  proc_u_so_updated_group_ace @_group_uuid, @_sp_uuid, @_group_ace, @_group_enable_inheritance, @_group_old_ace, @_group_old_enable_inheritance
			FETCH NEXT FROM mycur INTO @_group_uuid, @_sp_uuid, @_group_ace, @_group_enable_inheritance, @_group_old_ace, @_group_old_enable_inheritance

		END

		CLOSE mycur
		DEALLOCATE mycur
	end
end
go





/****** Object:  Trigger dbo.rule_u_so_updated_group    Script Date: 12/1/2005 11:51:50 PM ******/



/*
 ************************************
 trigger for updating a group definition
 and the column security_group  was changed
  update of (security_group)
 */
alter trigger [dbo].[rule_u_so_updated_group]
       on [dbo].[ca_group_def]
          after update
as
begin
	declare @ugrp_uuid binary(16);
	declare @old_grpinheritance integer;
    declare @new_grpinheritance integer;
	
	DECLARE cur_u_so_updated_group cursor local
		FOR select deleted.group_uuid, deleted.security_group, inserted.security_group from deleted, inserted
			where inserted.group_uuid = deleted.group_uuid /* itrac 12093*/

	OPEN cur_u_so_updated_group
	FETCH NEXT FROM cur_u_so_updated_group INTO @ugrp_uuid, @old_grpinheritance, @new_grpinheritance;	
	WHILE @@FETCH_STATUS = 0
	BEGIN

		execute  proc_u_so_updated_group	@ugrp_uuid, @old_grpinheritance, @new_grpinheritance;	
		FETCH NEXT FROM cur_u_so_updated_group INTO @ugrp_uuid, @old_grpinheritance, @new_grpinheritance;	

	END

	CLOSE cur_u_so_updated_group
	DEALLOCATE cur_u_so_updated_group

end;
GO

/****** Object:  Trigger dbo.rule_u_so_class_ace    Script Date: 12/1/2005 11:50:56 PM ******/



/************************************************/
/*  trigger if class ace is updated */

ALTER trigger [dbo].[rule_u_so_class_ace]
 on [dbo].[ca_class_ace]
 after update
as                                        
begin                                  

   declare @new_ace 	integer;
   declare @new_access		integer;
   declare @old_ace 		integer;
   declare @sp_uuid 		binary(16);
   declare @class_uuid		binary(16);

/*
   select @new_ace 	= (select ace from inserted);                             
   select @new_access	= (select access from inserted);                        
   select @old_ace 	= (select ace from deleted);                              
   select @sp_uuid 	= (select security_profile_uuid from inserted);           
   select @class_uuid	= (select class_def_uuid from inserted);                
                                                                      
   execute  proc_u_so_class_ace @new_ace, @new_access, @old_ace , @sp_uuid , @class_uuid;
*/


-- Create a class ACE for this class
    declare c_ins cursor local
   	for select i.ace, i.access, i.security_profile_uuid, i.class_def_uuid, d.ace
    from inserted as i, deleted as d 
	where i.security_profile_uuid = d.security_profile_uuid and i.class_def_uuid = d.class_def_uuid ;
 								/* itrac 12093*/
 
   
    open c_ins
    fetch from c_ins into @new_ace, @new_access, @sp_uuid, @class_uuid, @old_ace --get first row
    
    while @@fetch_status = 0
    begin
   
      execute  proc_u_so_class_ace @new_ace, @new_access, @old_ace , @sp_uuid , @class_uuid;
      fetch from c_ins into @new_ace, @new_access, @sp_uuid, @class_uuid, @old_ace --get next row
    
    end
    close c_ins;
    deallocate c_ins;

end;
GO

alter trigger rule_upd_so_usd_group_sec_grp
on usd_swfold
after update
as
begin
	declare @_obj_uuid binary(16);
	declare @_type integer;
	declare @_old_security_group integer;
	declare @_new_security_group integer;

	DECLARE mycur CURSOR LOCAL
	FOR select deleted.objectid, deleted.type, deleted.security_group, inserted.security_group
	from inserted, deleted
	where inserted.objectid= deleted.objectid /* itrac 12093*/

	OPEN mycur
	FETCH NEXT FROM mycur INTO @_obj_uuid, @_type, @_old_security_group,
	@_new_security_group
	WHILE @@FETCH_STATUS = 0
		BEGIN

			execute proc_upd_so_usd_group_sec_grp @_obj_uuid, @_type,
			@_old_security_group, @_new_security_group;
			FETCH NEXT FROM mycur INTO @_obj_uuid, @_type, @_old_security_group,
			@_new_security_group

		END

		CLOSE mycur
		DEALLOCATE mycur

	end;

GO



alter trigger rule_upd_so_csm_object
on csm_object
after update
as
begin
	declare @_old_uuid binary(16);
	declare @_new_uuid binary(16);
	declare @_new_csm_class_id integer;
	declare @_old_cms_class_id integer;
	declare @_user nvarchar(255);

	DECLARE mycur CURSOR LOCAL
	FOR select deleted.uuid, inserted.uuid, inserted.class, deleted.class, inserted.creation_user
	from inserted, deleted
	where inserted.id= deleted.id /* itrac 12093*/

	OPEN mycur
	FETCH NEXT FROM mycur INTO @_old_uuid, @_new_uuid, @_new_csm_class_id,
	@_old_cms_class_id, @_user;
	WHILE @@FETCH_STATUS = 0
		BEGIN

			execute proc_upd_so_csm_object @_old_uuid, @_new_uuid, @_new_csm_class_id,
			@_old_cms_class_id, @_user;
			FETCH NEXT FROM mycur INTO @_old_uuid, @_new_uuid, @_new_csm_class_id,
			@_old_cms_class_id, @_user;

		END

		CLOSE mycur
		DEALLOCATE mycur

	end;

GO



alter trigger r_u_dis_user_uri_check
on ca_discovered_user
after update
as
declare @_olduri nvarchar(255);
declare @_newuri nvarchar(255);
declare @_dom_uuid binary(16);

begin
if update(uri)
	BEGIN
		DECLARE mycur CURSOR LOCAL
		FOR select deleted.uri, inserted.uri, deleted.domain_uuid 
		from deleted, inserted
		where deleted.user_uuid=inserted.user_uuid /* itrac 12093*/
				and deleted.domain_uuid=inserted.domain_uuid /* itrac 12093*/

		OPEN mycur
		FETCH NEXT FROM mycur INTO @_olduri,@_newuri,@_dom_uuid;
		WHILE @@FETCH_STATUS = 0
			BEGIN

				execute p_iu_dis_user_uri_check @_olduri,@_newuri,@_dom_uuid;
				FETCH NEXT FROM mycur INTO @_olduri,@_newuri,@_dom_uuid;

			END

			CLOSE mycur
			DEALLOCATE mycur

		end
end

GO




alter trigger r_u_dis_hw_host_uuid
on ca_discovered_hardware
after update
as
declare @_olduuid char(36);
declare @_newuuid char(36);
declare @_dom_uuid binary(16);

begin

	if update(host_uuid)
		begin

			DECLARE cur_r_u_dis_hw_host_uuid CURSOR LOCAL
			FOR select deleted.host_uuid, inserted.host_uuid, deleted.domain_uuid 
			from deleted, inserted
			where deleted.dis_hw_uuid= inserted.dis_hw_uuid	/* itrac 12093*/
					and deleted.domain_uuid= inserted.domain_uuid	/* itrac 12093*/

			OPEN cur_r_u_dis_hw_host_uuid
			FETCH NEXT FROM cur_r_u_dis_hw_host_uuid INTO @_olduuid, @_newuuid, @_dom_uuid;
			WHILE @@FETCH_STATUS = 0
				BEGIN

					execute p_iu_dis_hw_host_uuid @_olduuid, @_newuuid, @_dom_uuid;
					FETCH NEXT FROM cur_r_u_dis_hw_host_uuid INTO @_olduuid, @_newuuid, @_dom_uuid;

				END

				CLOSE cur_r_u_dis_hw_host_uuid
				DEALLOCATE cur_r_u_dis_hw_host_uuid

			end
end

GO


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15254573, getdate(), 1, 4, 'Star 15254573 : TNGAMO: add trigger to improve performance' )
GO

COMMIT TRANSACTION 
GO

