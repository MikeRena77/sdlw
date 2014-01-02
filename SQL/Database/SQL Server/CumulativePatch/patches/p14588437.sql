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

/*****************************************************************************************/
/*                                                                                       */
/* Patch Star 14588437 Autosys: New stored procedure ujo_move_event                      */
/*                              Modify stored procedure ujo_batch_get_event (raiseerror syntax)*/
/*****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

if exists (select * from sysobjects where name = 'ujo_move_event' and type = 'P')
begin
	drop procedure ujo_move_event
end
go

create proc ujo_move_event
	@eoid        varchar(12),
	@que_status  int
AS

declare @error_var     int, 
        @rowcount_var  int
        
	if( @eoid is null )
	begin
		raiserror ('Input parameter eoid cannot be null', 16, 1)
		return -1
   	end
   	else if( @que_status is null )
	begin
		raiserror ('Input parameter que_status cannot be null', 16, 1)
		return -1
   	end
   	
   	select @error_var = 0
	select @rowcount_var = 0
	
	update	ujo_event
	set	que_status = @que_status
		where eoid = @eoid

	SELECT @error_var = @@error, @rowcount_var = @@rowcount		
	
	if (@error_var != 0 )	
	begin
		raiserror ('procedure ujo_move_event failed during update with error:%d', 16, 1, @error_var)		
		return -1
	end    
	
	if (@rowcount_var !=1)
	begin		
		raiserror ('Invalid Event(%s)', 16, 1, @eoid)		
		return 0
	end
	
   	
   	select @error_var = 0
	select @rowcount_var = 0
	
	insert into ujo_proc_event (eoid, joid, job_name, box_name, AUTOSERV, priority, 
	                            event, status, alarm, event_time_gmt, exit_code, machine,
	                            pid, jc_pid, run_num, ntry, text, que_priority, stamp,
	                            evt_num, que_status, que_status_stamp)
	select *
	from ujo_event
	where eoid = @eoid
	
	SELECT @error_var = @@error, @rowcount_var = @@rowcount		
	
	if (@error_var != 0 )	
	begin
		raiserror ('procedure ujo_move_event failed inserting event into ujo_proc_event with error:%d', 16, 1, @error_var)
		return -1
	end    
	
	if (@rowcount_var = 1)
	begin
		delete from ujo_event where eoid = @eoid
	end
	
return 1

go

grant execute on ujo_move_event to ujoadmin
go

/* ujo_batch_get_event */
	
if exists (select * from sysobjects where name = 'ujo_batch_get_event' and type = 'P')
begin
        drop procedure ujo_batch_get_event
end
go

create proc ujo_batch_get_event
        @time0  int
AS

/* maximum number of events we wish to retrieve */

declare @time_stamp    datetime,
        @firstcount    int,
        @error_var     int, 
        @rowcount_var  int


/* Set our timestamp */
select @time_stamp = getdate()

begin tran
     
     /* update que_status flag and stamp */
     update ujo_event
        set que_status       = -1,
            que_status_stamp = @time_stamp
      where eoid in (select top 1024 eoid from ujo_event where event_time_gmt <= @time0
        and que_status = 0)

    -- Save the @@error and @@rowcount values in local 
    -- variables before they are cleared.
    SELECT @error_var = @@error, @firstcount = @@rowcount

    if (@error_var != 0 )
    begin
	raiserror ('procedure ujo_batch_get_event failed during first update', 16, 1)
	rollback tran
	return -1
    end	        
    /* If nothing was found during this clock tick, return */    
    if (@firstcount = 0)
    begin       
       rollback tran
       return 0
    end    


    /* retrieve the event 1024 */

    select TOP 1024 eoid, joid, priority, event, status, alarm, event_time_gmt,
	       exit_code, machine, pid, jc_pid, run_num, ntry, text,
	       stamp_diff=datediff(ss, stamp, @time_stamp), job_name,
	       box_name, que_priority, AUTOSERV, evt_num
    from ujo_event
    where event_time_gmt     <= @time0
	   and que_status         = -1
	   and que_status_stamp   = @time_stamp
    order by priority, event_time_gmt, evt_num

    -- Save the @@error and @@rowcount values in local 
    -- variables before they are cleared.
    SELECT @error_var = @@error, @rowcount_var = @@rowcount

    /* If nothing was found during this clock tick, return */
    if (@error_var != 0 )
    begin
	raiserror ('procedure ujo_batch_get_event failed during select', 16, 1)
	rollback tran
	return -1
    end    
     
    /* update que_status flag and stamp */
    update ujo_event
        set que_status       = -2
        where que_status_stamp = @time_stamp
        and event_time_gmt <= @time0
        and que_status = -1

    -- Save the @@error and @@rowcount values in local 
    -- variables before they are cleared.
    SELECT @error_var = @@error, @rowcount_var = @@rowcount
    
    if (@error_var != 0 )
    begin
	raiserror ('procedure ujo_batch_get_event failed during second update', 16, 1)
	rollback tran
	return -1
    end	  
        
    /* If nothing was found during this clock tick, return */    
    if (@firstcount != @rowcount_var)
    begin       
       raiserror ('procedure ujo_batch_get_event failed during second update. Data has been lost or modified', 16, 1)
       rollback tran
       return -1
    end    

commit tran 

return 1

go

grant execute on ujo_batch_get_event to ujoadmin
go	

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14588437, getdate(), 1, 4, 'Patch Star 14588437 Autosys: New stored procedure ujo_move_event / Modify stored procedure ujo_batch_get (raiseerror syntax)' )
GO

COMMIT TRANSACTION 
GO
