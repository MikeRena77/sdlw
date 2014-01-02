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
/* Star 14633394 DSM:MSSQL Trigger and Procedure change                                 */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from inv_table_map with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
/* ******************** 9853 begin ************************* */


/*
 ***********************************************
 update object usage list in ca_discovered hardware 
 	for each new object       : _action = 0
 or
 	for each deleted object   : _action = 1  
 in ca_server_component
*/
drop procedure p_integrity_component_reg
GO
create procedure p_integrity_component_reg
	 @_action	 integer,
	 @_server_uuid 	 binary(16),
	 @_comp_id integer
	
as
	declare @_dis_hw_uuid    	binary(16);
	declare @_user_uuid		binary(16);
	declare @_dis_hw_user_uuid 	binary(16);
	declare @_domain_uuid		binary(16);
	declare @_manager_uuid		binary(16);
	declare @_usage_list     	binary(32);
	declare @_leading_bytes  	binary varying(32);
	declare @_component_bit  	integer;
	declare @_end_byte	binary(1);
	declare @_indicator	binary(1);
	declare @_null_byte	binary(1);
	declare @_byte_nr	integer;
	declare @_i		integer;
	declare @_cc		char(30);
	declare @_agent_type 	integer;			-- agent type of an agent record 
	
	declare @_usage_leadbytes binary varying(32); 		-- leading bytes of the current usage list
	declare @_usage_byte  binary(1);			-- byte needs to be updated

begin
	--
 	--  assert pre-condition
	-- 
	if ( @_comp_id < 0 
		OR 
	     @_comp_id > 255)
	begin
		-- component id out of range
		raiserror('DSM Status: registering component with component id %d ', 10,1, @_comp_id ) with log;		
		return;
	end;
	
	--
	-- start update of the usage list 
	--
	select @_null_byte 	= 0x00;
	select @_indicator	= 0xFF;	 
	select @_byte_nr   	= @_comp_id/8;
	select @_end_byte  	= (power(2,7 - @_comp_id + @_byte_nr*8));
	/*_end_byte  	= byte( X'EE'); */
	select @_leading_bytes 	= 0x0000000000000000000000000000000000000000000000000000000000000000;

	select @_leading_bytes 	= convert (binary varying(32),substring(@_leading_bytes, 1,	 @_byte_nr));	
	set @_component_bit	= (@_leading_bytes + @_end_byte);	

	if(@_action = 0 or @_action = 1)
	begin	--
		-- a server component was (un)registered 
		--
		set @_dis_hw_uuid = (select dis_hw_uuid
					from ca_server
					where server_uuid = @_server_uuid
			             );

		-- read the current usage list
		
		set @_usage_list = (select usage_list from ca_discovered_hardware where  dis_hw_uuid = @_dis_hw_uuid);
		if( @_usage_list is NULL) 
			set @_usage_list = 0x00000000000000000000000000000000000000000000;

		if(@_action = 0)
		begin /* register */
			/*message ' update usage list for registering server component ';*/
			set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
			set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
			set @_usage_byte = (@_usage_byte | @_component_bit);
			if (( convert(int,@_byte_nr)+1) = 32)
				set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
			else
				set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
		
		end
		else 
		begin   /* unregister */
			/*message 'update usage list for unregistering server component ';*/
			set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
			set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
			set @_usage_byte = (@_usage_byte ^ @_component_bit);
			if (( convert(int,@_byte_nr)+1) = 32)
				set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
			else
				set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
			
		end;
		
		update ca_discovered_hardware
			set usage_list = @_usage_list
			where dis_hw_uuid = @_dis_hw_uuid;
		

	end
	else
	if(@_action = 2 or @_action = 3)
	begin
		/* an agent component was (un)registered                      */
		/* in this case the _server_uuid is set to the object_uuid    */
		/* check the agent type first to see if the component is for  */
		/* a computer or user */
		select @_dis_hw_uuid = @_server_uuid;
		select @_agent_type = (select agent_type from ca_agent 
				where object_uuid = @_dis_hw_uuid);


		/* agent_type */
		if(@_agent_type = 1)
		begin
			/* computer */
			
			set @_usage_list = (select usage_list from ca_discovered_hardware where  dis_hw_uuid = @_dis_hw_uuid);
			if( @_usage_list is NULL) 
				set @_usage_list = 0x00000000000000000000000000000000000000000000;
			if (@_action = 2 )
			begin /* register */
				/*message ' update usage list for registering computer agent component ';*/
				set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
				set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
				set @_usage_byte = (@_usage_byte | @_component_bit);
				if (( convert(int,@_byte_nr)+1) = 32)
					set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
				else
					set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
			end
			else
			begin
				/* unregister */
				/*message ' update usage list for unregistering computer agent component ';*/
				set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
				set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
				set @_usage_byte = (@_usage_byte ^ @_component_bit);
				if (( convert(int,@_byte_nr)+1) = 32)
					set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
				else
					set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
				
	                	/* reset SD status if SD component is unregistered */
				if(@_comp_id = 40 OR @_comp_id=46)
				begin
				    update ca_agent set derived_status_sd = 0 where object_uuid=@_dis_hw_uuid;
				end;
				
			end;
			update ca_discovered_hardware
				set usage_list = @_usage_list
				where dis_hw_uuid = @_dis_hw_uuid;


		end	
		else
		begin
			if(@_agent_type = 2) 
			begin   /* user */
				select @_user_uuid = @_server_uuid;
				
				set @_usage_list = (select usage_list from ca_discovered_user where  user_uuid = @_user_uuid);
				if( @_usage_list is NULL) 
					set @_usage_list = 0x00000000000000000000000000000000000000000000;
	

				if (@_action = 2 )
				begin /* register */
					/*message ' update usage list for registering user agent component ';*/
					set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
					set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
					set @_usage_byte = (@_usage_byte | @_component_bit);
					if (( convert(int,@_byte_nr)+1) = 32)
						set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
					else
						set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
				end
				else
				begin
					/* unregister */
					/*message ' update usage list for unregistering user agent component ';*/
					set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
					set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
					set @_usage_byte = (@_usage_byte ^ @_component_bit);
					if (( convert(int,@_byte_nr)+1) = 32)
						set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
					else
						set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	

				end;
				update ca_discovered_user
					set usage_list = @_usage_list
					where user_uuid = @_user_uuid;


			end
			else
			begin
				if(@_agent_type = 4) 
				begin
					/* computeruser */		
					select @_dis_hw_user_uuid = @_server_uuid;
					set @_usage_list = (select usage_list from ca_link_dis_hw_user where  link_dis_hw_user_uuid = @_dis_hw_user_uuid);
					if( @_usage_list is NULL) 
						set @_usage_list = 0x00000000000000000000000000000000000000000000;
	

					if (@_action = 2 )
					begin /* register */
						/*message ' update usage list for registering computeruser agent component ';*/
						set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
						set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
						set @_usage_byte = (@_usage_byte | @_component_bit);
						if (( convert(int,@_byte_nr)+1) = 32)
							set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
						else
							set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
					end
					else
					begin
						/* unregister */
						/*message ' update usage list for unregistering computeruser agent component ';*/
						set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
						set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
						set @_usage_byte = (@_usage_byte ^ @_component_bit);
						if (( convert(int,@_byte_nr)+1) = 32)
							set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
						else
							set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
					end;
					update ca_link_dis_hw_user
						set usage_list = @_usage_list
						where link_dis_hw_user_uuid = @_dis_hw_user_uuid;

				end;
			end;
		end;
	end
    else

	if(@_action = 4 or @_action = 5)
	  begin
		/* manager component was (un)registered*/
		select @_manager_uuid = @_server_uuid;
		
		set @_domain_uuid = (select domain_uuid	from ca_manager where manager_uuid = @_manager_uuid);
		set @_usage_list = (select usage_list from ca_n_tier where domain_uuid = @_domain_uuid);
		if( @_usage_list is NULL) 
			set @_usage_list = 0x00000000000000000000000000000000000000000000;
		if(@_action = 4)
		begin /* register */
			/*message ' update usage list for registering manager component ';*/
			set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
			set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
			set @_usage_byte = (@_usage_byte | @_component_bit);
			if (( convert(int,@_byte_nr)+1) = 32)
				set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
			else
				set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
				

		end
		else /* unregister */
		begin
			/*message ' update usage list for unregistering manager component ';*/
			set @_usage_leadbytes = convert (binary varying(32),substring(@_usage_list, 1,	 @_byte_nr));	
			set @_usage_byte = SUBSTRING (@_usage_list, 	 convert(int,@_byte_nr)+1, 1);	
			set @_usage_byte = (@_usage_byte ^ @_component_bit);
			if (( convert(int,@_byte_nr)+1) = 32)
				set @_usage_list = @_usage_leadbytes + @_usage_byte ;		
			else
				set @_usage_list = @_usage_leadbytes + @_usage_byte +SUBSTRING(@_usage_list, convert(int,@_byte_nr)+2, LEN(@_usage_list)-convert(int,@_byte_nr));	
		end;

		update ca_n_tier
			set usage_list = @_usage_list
			where domain_uuid = @_domain_uuid;
	  end
	else
	  begin
		/* it must be an programmimg error : unknow action code */
		raiserror('Error 9009: internal error: illegal action code in DB procedure p_integrity_component_reg', 16,1 );		
	  end;
	
    
end;
go

grant execute on p_integrity_component_reg to ca_itrm_group
GO

/* ******************** 9853 end ************************* */


/* ******************** 9768 begin ************************* */
/* this is needed to store the table owner of dynamic created tables */

alter table inv_table_map
add  tbl_owner nvarchar(128)  /* case-insensitive */ 
						collate		!!insensitive NULL
GO

/* ******************** 9768 end ************************* */

/* ******************** 9814 begin ************************* */
 
/****************************************
 * used to manage AM specify releated data
 */ 

drop trigger joborder_agent_delete
go
create trigger joborder_agent_delete
  on joborder 
  for delete

as
begin
    declare @domainid int,@unitid int ;
    
    DECLARE jobor_ag_del_cur CURSOR 
        FOR SELECT udomid,unitid 
            FROM deleted
            
    OPEN jobor_ag_del_cur 
    FETCH NEXT FROM jobor_ag_del_cur INTO @domainid,@unitid 
    WHILE @@FETCH_STATUS = 0 
    BEGIN 
        execute ca_agent_server_version_by_unit @domainid,@unitid 
        FETCH NEXT FROM jobor_ag_del_cur INTO @domainid,@unitid 
    END 
    CLOSE jobor_ag_del_cur 
    DEALLOCATE jobor_ag_del_cur 
  
      
end

GO


drop trigger ca_am_polilog_delete
go
create trigger ca_am_polilog_delete 
	on polilog 
	for delete
	
as
begin
    declare @object_uuid binary(16) ;
    
    DECLARE am_polilog_del_cur CURSOR 
        FOR SELECT object_uuid
            FROM deleted
            
    OPEN am_polilog_del_cur 
    FETCH NEXT FROM am_polilog_del_cur INTO @object_uuid
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        execute ca_am_update_agent_derived @object_uuid
        FETCH NEXT FROM am_polilog_del_cur INTO @object_uuid
    END 
    CLOSE am_polilog_del_cur
    DEALLOCATE am_polilog_del_cur 
    
      
end

GO

drop trigger linkbck_agent_delete
go
create trigger linkbck_agent_delete 
  on linkbck 
  for delete 

as
begin

    declare @object_uuid binary(16);

    DECLARE linkbck_agent_del_cur CURSOR 
    
    FOR SELECT object_uuid
            FROM deleted
        
    OPEN linkbck_agent_del_cur 
    FETCH NEXT FROM linkbck_agent_del_cur INTO @object_uuid
    WHILE @@FETCH_STATUS = 0 
    BEGIN 
        execute ca_agent_server_version_by_uuid @object_uuid;
       
        FETCH NEXT FROM linkbck_agent_del_cur INTO @object_uuid;
    END 
    CLOSE linkbck_agent_del_cur 
    DEALLOCATE linkbck_agent_del_cur 
      
end

GO





drop trigger linkmod_agent_delete
go
create trigger linkmod_agent_delete
   on linkmod 
   after delete 

   
as 
begin
    declare @object_uuid binary(16);

    DECLARE linkmod_ag_del_cur CURSOR 
    
    FOR SELECT object_uuid
            FROM deleted
        
    OPEN linkmod_ag_del_cur 
    FETCH NEXT FROM linkmod_ag_del_cur INTO @object_uuid
    WHILE @@FETCH_STATUS = 0 
    BEGIN 
        execute ca_agent_server_version_by_uuid @object_uuid;
       
        FETCH NEXT FROM linkmod_ag_del_cur INTO @object_uuid;
    END 
    CLOSE linkmod_ag_del_cur 
    DEALLOCATE linkmod_ag_del_cur 

end   

GO

drop trigger linkjob_agent_delete
go
create trigger linkjob_agent_delete 
    on linkjob for DELETE 
as 
BEGIN 
    declare @object_uuid binary(16);
    
    DECLARE linkjob_ag_del_cur CURSOR 
        FOR SELECT object_uuid
            FROM deleted 
        
        OPEN linkjob_ag_del_cur 
        FETCH NEXT FROM linkjob_ag_del_cur INTO @object_uuid
        WHILE @@FETCH_STATUS = 0 
        BEGIN 
            execute ca_agent_server_version_by_uuid @object_uuid;
        
            FETCH NEXT FROM linkjob_ag_del_cur INTO @object_uuid;
        END 
        CLOSE linkjob_ag_del_cur 
        DEALLOCATE linkjob_ag_del_cur 
END

GO


 
/****************************************
 * used to manage AM specify releated data
 */ 
drop procedure am_proc_delete_unit
go
create procedure am_proc_delete_unit
(
            @del_object_uuid binary(16),            /* Object uuid */
            @object_type int,            /* Object type 1=Computer,2=User,3=Engine,0=Group,etc */
	    @unit_id integer,
	    @domain_id integer
            )
as
begin

  delete from ca_discovered_software where asset_source_uuid = @del_object_uuid;
  delete from inv_generalinventory_item where object_uuid = @del_object_uuid;
  delete from inv_generalinventory_tree where object_uuid = @del_object_uuid;
  delete from inv_performance_item where object_uuid = @del_object_uuid;
  delete from inv_performance_tree where object_uuid = @del_object_uuid;
  delete from inv_root_map where object_uuid = @del_object_uuid;
	DELETE FROM BCKFILE WHERE object_uuid = @del_object_uuid;
	DELETE FROM FILEMGR WHERE object_uuid = @del_object_uuid;
	DELETE FROM STATJOB WHERE object_uuid = @del_object_uuid;
	DELETE FROM STATJOBM WHERE object_uuid = @del_object_uuid;
	DELETE FROM STATMOD WHERE object_uuid = @del_object_uuid;
	DELETE FROM STATMODM WHERE object_uuid = @del_object_uuid;
	DELETE FROM appuknow WHERE object_uuid = @del_object_uuid;
	DELETE FROM ca_query_result WHERE member_uuid=@del_object_uuid;
	DELETE FROM LOCKUNIT WHERE UNITID=@unit_id AND DOMAINID=@domain_id;
	DELETE FROM LINKJOB WHERE object_uuid = @del_object_uuid;
	DELETE FROM LINKMOD WHERE object_uuid = @del_object_uuid;
	DELETE FROM LINKBCK WHERE object_uuid = @del_object_uuid;
	DELETE FROM POLILOG WHERE object_uuid = @del_object_uuid;
	DELETE FROM JOBORDER WHERE UNITID=@unit_id AND UDOMID=@domain_id;
	DELETE FROM SNAPMAIN WHERE object_uuid = @del_object_uuid;
	DELETE FROM SNAPMEMO WHERE object_uuid = @del_object_uuid;
	DELETE FROM CONFMEMO WHERE UNITID=@unit_id AND DOMAINID=@domain_id;
	DELETE FROM inv_root_map WHERE object_uuid = @del_object_uuid;

 /* if unit_id and domain_id not null do other things */
end;

GO



GRANT  EXECUTE  ON [dbo].[am_proc_delete_unit]  TO [ca_itrm_group]
GO

drop trigger r_am_proc_delete_unit
go

create trigger   r_am_proc_delete_unit
	 on ca_agent
	 instead of delete
as
begin
    declare @object_uuid binary(16) ;
    declare @agent_type integer;
    declare @unit_id integer;
    declare @domain_id integer;
        
    DECLARE r_am_proc_delete_unit_cur CURSOR 
        FOR SELECT object_uuid, agent_type, unit_id, domain_id
            FROM deleted
      
    OPEN r_am_proc_delete_unit_cur 
    FETCH NEXT FROM r_am_proc_delete_unit_cur INTO @object_uuid, @agent_type, @unit_id, @domain_id
    WHILE @@FETCH_STATUS = 0 
    BEGIN

        execute ca_am_update_agent_derived @object_uuid
		execute am_proc_delete_unit @object_uuid, @agent_type, @unit_id, @domain_id
		delete from ca_agent where object_uuid=@object_uuid
        FETCH NEXT FROM r_am_proc_delete_unit_cur INTO @object_uuid, @agent_type, @unit_id, @domain_id
    END 
    CLOSE r_am_proc_delete_unit_cur 
    DEALLOCATE r_am_proc_delete_unit_cur 
    
    
end;
GO
/* ******************** 9814 end ************************* */


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14633394, getdate(), 1, 4, 'Star 14633394 DSM:MSSQL Trigger and Procedure change' )
GO

COMMIT TRANSACTION 
GO


