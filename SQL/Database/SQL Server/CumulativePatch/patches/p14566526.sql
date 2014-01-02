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
/* Star 14566526 UAPM : MSSQL MODIFY 2 EXISTING TRIGGERS                                */
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

drop trigger t_u_ca_discovered_hw
GO

CREATE TRIGGER t_u_ca_discovered_hw ON ca_discovered_hardware 
FOR UPDATE AS

/*  Only run if host_name has been updated. */

if update (host_name)
    begin
    
        declare @dis_hw_uuid binary(16)
        declare @new_host_name nvarchar(255)
        declare @old_host_name nvarchar(255)

        declare change_list cursor for
          select inserted.dis_hw_uuid, inserted.host_name, deleted.host_name from inserted, deleted
           where inserted.discovery_changes_switch = 0 and inserted.dis_hw_uuid = deleted.dis_hw_uuid
   
        open change_list

        fetch next from change_list into @dis_hw_uuid, @new_host_name, @old_host_name

        while @@fetch_status = 0
            begin

               /*  Only process if the host_name value has changed to something different. */

	       if @new_host_name <> @old_host_name
                   begin

                       /* Set the discovery_changes_switch 'on'. */

                       update ca_discovered_hardware
	                  set discovery_changes_switch = 1
                        where dis_hw_uuid = @dis_hw_uuid
                   end

                fetch next from change_list into @dis_hw_uuid, @new_host_name, @old_host_name
        
            end
	
        close change_list

        deallocate change_list

    end
GO

drop trigger t_u_inv_generalinventory_item
GO

CREATE TRIGGER t_u_inv_generalinventory_item ON inv_generalinventory_item
FOR UPDATE AS

/* Only execute if item_value_text or item_value_double has been updated. */

if update (item_value_text) or update (item_value_double)
    begin
    
        declare @object_uuid binary(16)
	declare @discovery_changes_switch smallint
    
        declare change_list cursor for
          select object_uuid from inserted
           where (item_parent_name_id = 2  and item_name_id = 7 and item_value_double <> item_previous_value_double)
              or (item_parent_name_id = 5  and item_name_id = 17 and item_value_text <> item_previous_value_text)
              or (item_parent_name_id = 31 and item_name_id = 132 and item_value_double <> item_previous_value_double)
       
        open change_list
    
        fetch next from change_list into @object_uuid
    
        while @@fetch_status = 0
            begin
            
                /*  Check whether the discovery_changes_switch for the associated  */
	        /*  ca_discovered_hardware record is already set 'on'.             */
	        /*  If not, then update it.                                        */ 
	
                select @discovery_changes_switch = 
			(SELECT discovery_changes_switch
			   FROM ca_discovered_hardware
	                  WHERE dis_hw_uuid = @object_uuid)
	                  
	        if @discovery_changes_switch = 0
                    update ca_discovered_hardware
    	               set discovery_changes_switch = 1
                     where dis_hw_uuid = @object_uuid
    
                fetch next from change_list into @object_uuid
            
            end
    	
            close change_list
    
            deallocate change_list
    
    end

go





/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14566526, getdate(), 1, 4, 'Star 14566526 UAPM : MSSQL MODIFY 2 EXISTING TRIGGERS ' )
GO

COMMIT TRANSACTION 
GO


