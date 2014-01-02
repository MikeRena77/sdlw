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

/*****************************************************************************/
/*                                                                           */
/* Star 14607142 updating ACK fails         				     */
/*                                                                           */
/*****************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('tng_tu_managedobject')
)
BEGIN
   PRINT 'Dropping old version of tng_tu_managedobject'
   DROP trigger tng_tu_managedobject
END
GO

create trigger tng_tu_managedobject on tng_managedobject for update as
declare @uuid_bin UUID       
declare @uuid int
declare @class_id int
declare @status_no int
declare @cur_time datetime
declare @severity int
declare @propagate_status char(1)
declare @acknowledge tinyint
declare @timestamp datetime
declare @IsInsertChangeHistory int
declare @prop_sev int
declare @sev int
declare @weighted_sev int
declare @Max_Sev int
declare @DeltaGMT int
declare @GMTDate datetime
set nocount on
  
  if not exists (select * from deleted )
    return
    
  if( update(severity) or update(status_no))
    if( ( 1 in (select acknowledge from deleted)) and ( 1 in (select acknowledge from inserted)))
	begin
	  select 80001	
	  raiserror 80001 'Update severity or status_no failed Since one of acknowledges is on(1). '
	  rollback transaction
	  return
	end
  
  if( update(class_name) or update(uuid))
  begin
    select 80002	
	raiserror 80002 'Do not allow to update class name or uuid of an object, the transaction failed. '
	rollback transaction
	return
  end

  select @timestamp=getdate(),  @IsInsertChangeHistory = 0
  /*5/2/96*/
if( update( date_modify) )
  update tng_managedobject set date_modify=@timestamp
	  from inserted i, deleted d, tng_managedobject m     
  	  where m.uuid=i.uuid and i.uuid=d.uuid and
                i.date_modify <> d.date_modify and i.date_modify = NULL /*10/31/96*/

else 
 update tng_managedobject set date_modify=@timestamp
	  from inserted i, tng_managedobject m     
  	  where m.uuid=i.uuid
                
if( update( propagated_sev) )
Begin
	
	  insert into tng_prop_status_history( class_name,  record_uuid,  status_no,  severity,   timestamp,user_name)
    			                 select  i.class_name,       i.uuid,i.propagated_status_no, i.propagated_sev, @timestamp,HOST_NAME()
							     from  inserted i	
	select @prop_sev = severity from inserted
	  
	  if( not update(severity))
		select @sev = m.severity from tng_managedobject m, inserted i
			where m.uuid = i.uuid
	  else		
		select @sev = severity from inserted
	
	
		
end 
/* 2/13/96 update whatever except uuid,class_name,status_no and severity, we log in tng_change_history...   	*/
  if ( update(label)          or update(address)          or update(name)             or update(address_type) or 
       update(interface_type) or update(acknowledge)      or update(propagate_status) or update(hidden)       or 
       update(posted)         or update(ip_address_hex)   or update(mac_address)      or update(subnet_mask)  or 
	   update(alarmset_name)  or update(autoarrange_type) or /*or update(date_ins)         or update(date_modify) */
	   update(DSM_Server)     or update(admin_status)     or update(DSM_Address)      or update(weight) or
	   update(override_imagelarge) or
       update(override_imagelarge) or
       update(override_imagesmall) or
       update(override_imagedecal) or
       update(override_imagetintbool) or
       update(override_model)      or
       update(background_image)
  	 )
  begin
    insert into tng_change_history ( operation, class_name,  object_id1, portnum1,  portnum2, timestamp )
                           select  	    'u',    class_name,  uuid, 		 0,  	     0    , @timestamp
				           from deleted

	select @IsInsertChangeHistory = 1

	/* Added for the weight_severity changes*/
	/* if weight changes  weight_sev changes*/
		if( not update(severity) or not update(status_no))
		 begin
			select @weighted_sev = (m.severity* i.weight) from tng_managedobject m, inserted i 
				where m.uuid = i.uuid
				and m.class_name = i.class_name
			
			select @sev = m.severity from tng_managedobject m, inserted i where m.uuid=i.uuid
		 end

		else
		 begin
			select @weighted_sev = (i.severity* i.weight) from inserted i 

			select @sev = i.severity from inserted i 


		end

		select @prop_sev = m.propagated_sev from tng_managedobject m, inserted i where m.uuid = i.uuid

		if (@sev > @prop_sev)
			select @Max_Sev = @sev
		else
			select @Max_Sev = @prop_sev


  end


  if( update(status_no) or update(severity) or update(alarmset_name))
  begin
    /*insert 1st update Info(deleted) in tng_status_history */
/* 03/20/96 ignore the 1st status of an updated object 
	insert into tng_status_history( class_name,  record_uuid, status_no, severity, timestamp)
    			            select 	d.class_name, d.uuid,   d.status_no, d.severity, @timestamp
							from  deleted d		
							where 	(d.uuid not in (select record_uuid from tng_status_history))  
*/
								   /*2/14/96	and	d.status_no=s.status_no */
	if(update(severity))
	begin
		select @weighted_sev = (i.severity* m.weight) from tng_managedobject m, inserted i 
				where m.uuid = i.uuid
				and m.class_name = i.class_name

			select @sev = i.severity from inserted i

		select @prop_sev = m.propagated_sev from tng_managedobject m, inserted i where m.uuid = i.uuid 

		if (@sev > @prop_sev)
			select @Max_Sev = @sev
		else
			select @Max_Sev = @prop_sev
	END

	if(not update(severity)) 
	begin/*05/28/96 if user not update severity, we enforce alarmset rule defined in alarmset_entry */						        
	  /*also insert current Info but their alarmset_name and status_no are not defined in tng_alarmset_entry */
	  insert into tng_status_history( class_name,  record_uuid, status_no, severity, timestamp,user_name)
    			            select 	i.class_name, i.uuid,   i.status_no, i.severity, @timestamp,HOST_NAME()
							from  inserted i	
							where not exists (select * from tng_alarmset_entry a
										where a.alarmset_name=i.alarmset_name and
											a.status_no=i.status_no)



      /*also insert current Info which alarmset_name and status_no are defined in tng_alarmset_entry */
	  insert into tng_status_history( class_name,  record_uuid, status_no, severity, timestamp,user_name)
    			            select 	i.class_name, i.uuid,   i.status_no, a.severity, @timestamp,HOST_NAME()
							from  inserted i	 , tng_alarmset_entry a
							where i.status_no=a.status_no	and i.alarmset_name=a.alarmset_name
    
	end
	else /*05/28/96 if user update severity, we accept the severity value from user*/
	begin
	  insert into tng_status_history( class_name,  record_uuid, status_no, severity, timestamp,user_name)
    			            select 	i.class_name, i.uuid,   i.status_no, i.severity, @timestamp,HOST_NAME()
							from  inserted i
	end

    /*since status_no updated, we update severity and propagate_status to keep consistency*/
	if( (update(status_no) or update(alarmset_name)) and (not update(severity)) )
	begin
	  if(not update(propagate_status))
	  begin
	
		select @sev = a.severity from tng_alarmset_entry a, inserted i where i.alarmset_name=a.alarmset_name and
  	  		a.status_no=i.status_no

		select @prop_sev = m.propagated_sev from tng_managedobject m, inserted i where m.uuid = i.uuid
		
		if (@sev= NULL )
			select @sev = 0
		if (@sev > @prop_sev)
			select @Max_Sev = @sev
		else
			select @Max_Sev = @prop_sev
		 		
        update tng_managedobject set severity=a.severity, weighted_severity = (m.weight *a.severity),
					Max_Sev = @Max_Sev /*, propagate_status=a.propagate_status , date_modify=@timestamp,*/
	    from inserted i, tng_alarmset_entry a, tng_managedobject m     
  	    where m.uuid=i.uuid and i.alarmset_name=a.alarmset_name and
  	  		a.status_no=i.status_no	/*6/06/96and  i.severity <>a.severity*/


	  	if( @IsInsertChangeHistory = 0 and
		  	exists ( select * from inserted i, tng_alarmset_entry a 
			        where i.alarmset_name=a.alarmset_name and
  	  					  a.status_no=i.status_no  and
						  i.propagate_status<>a.propagate_status
				  )
		  )	/*02/26/97*/
		  insert into tng_change_history ( operation, class_name,  object_id1, portnum1,  portnum2, timestamp,user_name )
                           select  	    'u',    class_name,  uuid, 		 0,  	     0    , @timestamp,HOST_NAME()
				           from deleted

		
		
	  end
	  else 
	     Begin
			
		select @sev = a.severity from tng_alarmset_entry a, inserted i where i.alarmset_name=a.alarmset_name and
  	  		a.status_no=i.status_no

		select @prop_sev = m.propagated_sev from tng_managedobject m, inserted i where m.uuid = i.uuid

		if (@sev = NULL)
			select @sev = 0
		if (@sev > @prop_sev)
			select @Max_Sev = @sev
		else
			select @Max_Sev = @prop_sev

		 /*05/28/96 don't use trigger to enforce propagate_status in alarmset_entry if user updates propagate_status*/ 
		update tng_managedobject set severity=a.severity,weighted_severity = (m.weight *a.severity),
					Max_Sev = @Max_Sev /*, date_modify=@timestamp*/
	    from inserted i, tng_alarmset_entry a, tng_managedobject m     
  	    where m.uuid=i.uuid and i.alarmset_name=a.alarmset_name and
  	  		a.status_no=i.status_no	 and  i.severity <>a.severity

	     end
	end

end	



/* This is only used for updating the weighted severity and Max_Sev*/
if @weighted_sev > 0 
Begin
update tng_managedobject 
	Set weighted_severity = @weighted_sev,
		Max_Sev =@Max_Sev
from tng_managedobject m, inserted i
where m.uuid = i.uuid
End 


  /* 7/27/99 if acknowledge set to 1, turn off propagate_status */
  if (update(acknowledge) and ( 1 in (select acknowledge from inserted)))
  BEGIN
	update tng_managedobject set propagate_status = 0 from inserted i, tng_managedobject m 
	   where m.uuid = i.uuid and m.propagate_status <> 0 and m.acknowledge = 1

    insert into tng_change_history ( operation, class_name,  object_id1, portnum1,  portnum2, timestamp,user_name )
	   select  	    'u',    m.class_name,  m.uuid, 		 0,  	     0    , @timestamp,HOST_NAME()
	   from tng_managedobject m, inserted i
	   where m.uuid = i.uuid and m.propagate_status <> 0 and m.acknowledge = 1
  END



 return

GO
/*****************************************************************************/
/*                                                                           */
/* Register patch                                                            */
/*                                                                           */
/*****************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14607142, getdate(), 1, 4, 'Star 14607142 updating ACK fails')
GO

COMMIT TRANSACTION 
GO

