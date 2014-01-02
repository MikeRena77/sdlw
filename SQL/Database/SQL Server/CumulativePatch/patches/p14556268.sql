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
/* Star 14556268 DSM : MSSQL Changes to table ca_group_ace                              */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ca_group_ace with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

/* ********************** 9234 begin ******************* */
/* object_type must be set, when ca_group_ace is updated */
/* update ca_group_ace  in case of a group and  security */
/*		level is set  									 */

alter table ca_group_ace 
	add  [security_level] [int] not null default 0 ;
go

/*
 ****************************************
 rule if a new group_ace was inserted
 trigger checks for consistence of object_type
 all object_type attributes in one group must have
 the same value
*/


create trigger r_i_inserted_group_ace
       on ca_group_ace
       after insert 
as
begin
    SET NOCOUNT ON;  

	declare	@_group_def_uuid binary(16);		/* new.group_def_uuid */
	declare	@_object_type integer;			/* new.object_type */
	declare	@_count integer;			    /* number of groups */
  
	declare rule_i_g_ace cursor for
		select  group_def_uuid, object_type
		from inserted;

	-- get first inserted group ace
	open rule_i_g_ace;
	fetch from rule_i_g_ace into @_group_def_uuid, @_object_type
	while @@fetch_status = 0
	begin
		set @_count = ( select count(*) from ca_group_ace 
						where group_def_uuid=@_group_def_uuid and object_type!=@_object_type )

		if ( @_count > 0 )
		begin
			raiserror ('Error 9015: insert of group_ace denied, group with different object type exists', 16,1);
			return
		end

		-- fetch next
		fetch from rule_i_g_ace into @_group_def_uuid, @_object_type
	
	end;  -- end of loop over inserted group aces
	close rule_i_g_ace;
	deallocate rule_i_g_ace;

end;

GO




/*
 ***********************************************
 procedure start if a neew security profile
 was created
 addes a class ace for the new security profile
*/

drop procedure proc_i_new_so_security_profile
go
create procedure proc_i_new_so_security_profile
	@_obj_uuid binary(16), 	/* new.security_profile_uuid */
	@_type integer,
	@_default_ace integer    /* new.default_ace */
	
as
begin
    SET NOCOUNT ON;  

    /* -- Give this new object an ACL. Copy it from its class */
    declare @_sp_uuid binary(16);
    declare @_ace integer;
    declare @_access integer;

    declare acl cursor for
    select security_profile_uuid, ace, access
    from ca_class_ace
    where class_def_uuid = (select class_def_uuid from ca_security_class_def where class_id = 2)
    
    open acl
    fetch from acl into @_sp_uuid, @_ace, @_access --get first ace
    
    while @@fetch_status = 0
    begin
        insert into ca_object_ace (object_def_uuid, security_profile_uuid, ace, access, security_level, object_type)
    	values (@_obj_uuid, @_sp_uuid, @_ace, @_access, 0, 2)

    	fetch from acl into @_sp_uuid, @_ace, @_access -- get next ace     
    end   
    close acl
    deallocate acl
	
	

	/* -- Now, as this new object is a security profile we must add its ace to each acl. */
	/* -- 1 means everyone */
	/* insert into log (des) values('bodbod test 2'); */
	select @_access=1

	if( @_default_ace = 0)
    	begin
		select @_access=0
    	end
	if( @_type = 1 )
   	begin
		select @_access = 1
    	end

	insert into ca_class_ace (class_def_uuid, security_profile_uuid, ace, access)
		select            cd.class_def_uuid,     @_obj_uuid, @_default_ace, @_access
		from ca_security_class_def cd

	insert into ca_object_ace(object_def_uuid, security_profile_uuid, ace, access, security_level, object_type )
		select distinct o.object_def_uuid, @_obj_uuid, @_default_ace, @_access, 0, o.object_type
		from ca_object_ace o

	
	insert into ca_group_ace(group_def_uuid, security_profile_uuid, ace, access, enable_inheritance, object_type )
		select distinct g.group_def_uuid, @_obj_uuid, @_default_ace, @_access, g.enable_inheritance, g.object_type
		from ca_group_ace g

end
go


GRANT  EXECUTE  ON [dbo].[proc_i_new_so_security_profile]  TO [ca_itrm_group]
GO


/************************************************/
 /*  update secured object class class ace*/

drop procedure proc_u_so_class_ace
go

create procedure proc_u_so_class_ace
    @new_ace int,
    @new_access int,
    @old_ace int,
    @sp_uuid binary(16),
    @class_uuid binary(16)
  
as
begin
   declare @object_type int;

  SET NOCOUNT ON;  

  if(@new_ace <> @old_ace)
  begin
	select @object_type = (select class_id  from ca_security_class_def where class_def_uuid = @class_uuid);

    update ca_object_ace
                    set
                    ace = @new_ace,
                    access  = @new_access
                    where  security_profile_uuid = @sp_uuid and object_type = @object_type and security_level = 0;
          
    -- update ca_group_ace  in case of a group and  security level is set 
    -- to class level security                
    update ca_group_ace 
		set 
		ace=@new_ace,
		access  = @new_access 
		where object_type = @object_type 	
			and security_profile_uuid = @sp_uuid
			and security_level = 0;
	                    
                    
  end;

end
go

GRANT  EXECUTE  ON [dbo].[proc_u_so_class_ace]  TO [ca_itrm_group]
GO

/* ********************** 9234 end ******************* */

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14556268, getdate(), 1, 4, 'Star 14556268 DSM : MSSQL Changes to table ca_group_ace' )
GO

COMMIT TRANSACTION 
GO


