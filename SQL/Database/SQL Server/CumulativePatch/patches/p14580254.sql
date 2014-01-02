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
/* Patch Star 14580254 Autosys: Modify stored procedure ujo_send_event                  */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

if exists (select * from sysobjects where name = 'ujo_send_event' and type = 'P')
begin
	drop procedure ujo_send_event
end
go

create proc ujo_send_event
    @eoid       varchar(12),
    @joid       int,
    @job_name   varchar(64),
    @box_name   varchar(64),
    @AUTOSERV   varchar(30),
    @priority   int,
    @event      int,
    @status     int,
    @alarm      int,
    @event_time_gmt int,
    @exit_code  int,
    @machine    varchar(80),
    @pid        int,
    @jc_pid     int,
    @run_num    int,
    @ntry       int,
    @text       varchar(255),
    @que_priority   int    

AS
declare @counter varchar(7)
declare @evt_num int
declare @l_instance varchar(4)
declare @l_event_time_gmt int
declare @l_gmt_offset int
declare @job_type char(1)
declare @count int

declare @charpos int
declare @nod_name varchar(65)
declare @nod_ckpt varchar(16)
declare @nod_boot varchar(16)

/* STAR 11631087 */
if (@event = 101 AND
    (@status = 1 OR @status = 4 OR @status = 5 OR @status = 6 OR @status = 10))
begin
    select @priority = 10
end

select @l_instance = str_val from ujo_alamode where type = 'AUTOSERV'
update  ujo_next_oid set @evt_num = oid= (select oid+1 from ujo_next_oid where field = 'evt_num') where field = 'evt_num'


if ( @l_instance != @AUTOSERV OR (@event = 101 AND (@status = 1 OR @status = 3 OR @status = 4 OR @status = 5 OR @status = 6 OR @status = 10)) )
begin
    select @l_event_time_gmt = datediff( ss,'01/01/1970', getdate() )
    select @l_gmt_offset = int_val from ujo_alamode where type = 'gmt_offset'
    select @l_event_time_gmt =  @l_event_time_gmt + @l_gmt_offset
    if ((substring(@eoid, 4, 1) = 'y') AND (@event = 101 AND (@status = 1 OR @status = 4 OR @status = 5 OR @status = 6 OR @status = 10)))
        select @l_event_time_gmt = @l_event_time_gmt + 1
        /* Issue 12303214 - sinpr01 */
        if ( @status = 10)
        begin
            select @l_event_time_gmt = @l_event_time_gmt + 2
        end
end
else
begin
    select @l_event_time_gmt = @event_time_gmt
end

/* Update the asbnode table if necessary */
if (substring(@eoid, 4, 1) = 'y')
begin
    select @charpos = charindex('$$UJM_NODE$$', @text)
    if (@charpos != 0)
    begin
        select @nod_name = substring(@text, @charpos + 12, 65)
        select @nod_name = upper(@nod_name)
        select @nod_ckpt = substring(@text, @charpos + 77, 16)
        select @nod_boot = substring(@text, @charpos + 93, 16)

        if (select TOP 1 1 from ujo_asbnode where nod_name=@nod_name) = 1
        begin
            update ujo_asbnode set nod_ckpt=@nod_ckpt, nod_boot=@nod_boot
                where nod_name=@nod_name
        end
        else
        begin            
            insert into ujo_asbnode (nod_name, nod_ckpt, nod_boot)
                values (@nod_name, @nod_ckpt, @nod_boot)
        end
    end
end

/* Added for issue number 9344983 - Xia Lin */
if (@event = 12345)
begin
   select @event = 101

   if (@status = 1 OR @status = 3 OR @status = 4 OR @status = 5 OR @status = 6 OR @status = 8)
   begin
      select @l_event_time_gmt = @event_time_gmt
   end
end

/* Ended for issue number 9344983 - Xia Lin */
if exists(select eoid from ujo_event where eoid = @eoid) or exists(select eoid from ujo_proc_event where eoid = @eoid)
begin
    if exists ( select eoid from ujo_event where eoid = @eoid and
        (job_name = @job_name AND event = @event AND status = @status
        AND ntry = @ntry ))
       or exists ( select eoid from ujo_proc_event where eoid = @eoid and
        (job_name = @job_name AND event = @event AND status = @status
        AND ntry = @ntry ))
    /* Issue 10725507/2 -sinpr01 don't compare event_time_gmt */
    begin
        /* Really is the same event */
        print 'This Event was already here'
        return 1
    end

    select @counter = counter from ujo_last_Eoid_counter

    insert ujo_event2
    ( eoid,stamp,joid,job_name,box_name,AUTOSERV,
    priority,event,status,alarm,
    event_time_gmt,exit_code,
    machine,pid, jc_pid, run_num, ntry, text, que_priority,
    evt_num, que_status, que_status_stamp,
    counter
    )
    values  ( @eoid, getdate(),@joid,@job_name,@box_name,@AUTOSERV,
    @priority,@event, @status, 
    @alarm, @l_event_time_gmt, @exit_code, 
    @machine, @pid, @jc_pid, @run_num, @ntry, @text, @que_priority,
    @evt_num, 0, getdate(),
    @counter )

    print 'Detected duplicate event.'
    return -1       /* -1 => SE_DUP_EVENT */
end
/* get a run_num (Needed for autorep reports sendevents & missing heartbeat) */
    /* IF this causes blocks, we'll think about it
    */

if @run_num = 0 and @joid != 0
begin
    select  @run_num = run_num 
    from    ujo_job_status 
    where   joid = @joid

    if @run_num is NULL
    begin
        select @run_num = 0
    end
end



/* PUT this INTO the event table */

insert  ujo_event
    ( eoid,stamp,joid,job_name,box_name,AUTOSERV,
    priority,event,status,alarm,
    event_time_gmt,exit_code,
    machine,pid, jc_pid, run_num, ntry, text, que_priority,
    evt_num, que_status, que_status_stamp )
values  ( @eoid, getdate(),@joid,@job_name,@box_name,@AUTOSERV,
    @priority,@event, @status, 
    @alarm, @l_event_time_gmt, @exit_code, 
    @machine, @pid, @jc_pid, @run_num, @ntry, @text, @que_priority,
    @evt_num, 0, getdate() )    
  

if @@rowcount = 1
begin
    if ( @event = 106 )  /* ALARM! - stub out alarm table */
    begin
        insert  ujo_alarm
            ( eoid,alarm,alarm_time,job_name,joid,
              state,state_time,evt_num, event_comment,
              len, response )
        values  ( @eoid,@alarm,@l_event_time_gmt,@job_name,@joid,
              43, @l_event_time_gmt, 0, @text, /*43=OPEN*/
              1, ' ' )
    end    
    return 1
end
return 2

go


grant execute on ujo_send_event to ujoadmin
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14580254, getdate(), 1, 4, 'Patch Star 14580254 Autosys: Modify stored procedure ujo_send_event' )
GO

COMMIT TRANSACTION 
GO
