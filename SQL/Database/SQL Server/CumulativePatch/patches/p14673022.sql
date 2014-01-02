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
/* Patch Star 14673022 Autosys: Modify stored procedure ujo_chase_state STARTING event  */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* Issue 14560053 Date 24th Feb'06 */
if exists (select * from sysobjects where name = 'ujo_chase_state' and type = 'P')
begin
	drop procedure ujo_chase_state
end
go
create proc ujo_chase_state

	@starting_delay_time int

AS

declare @nstart  int

select @nstart = max( nstart ) from ujo_chase
if (@nstart IS NULL)
begin
	set @nstart = 0
end

set @nstart = @nstart+1

/* Rolling slots */
if @nstart > 50
begin
	set @nstart = 1
	delete ujo_chase 	/* Issue 12216151 - sinpr01 */
end

/* Clean it out */

delete ujo_chase where nstart = @nstart



/* Put in the ones that were in the event and are waiting */

/* RUNNING */
/* Issue 12216151 - sinpr01 add eoid */

    insert into ujo_chase
    	(nstart, joid, eoid, job_name, job_type, status, run_machine, pid, jc_pid )
    
    select	@nstart, j.joid, e.eoid, j.job_name, j.job_type, status, e.machine, pid, jc_pid
    from	ujo_event e, ujo_job j
    where	e.joid = j.joid and job_type in ('c', 'f')
    and	que_status = 0
    and	status = 1


/* Put in the current status */

insert into ujo_chase 
	(nstart, joid, job_name, job_type, status, run_machine, pid, jc_pid )

select	@nstart, j.joid, j.job_name, j.job_type, 
	status, run_machine, pid, jc_pid

from	ujo_job j, ujo_job_status s
where	j.joid = s.joid
and	status = 1
and	job_type in ('c','f')
and	j.joid not in
	( select joid from ujo_chase where nstart = @nstart )

/* STARTING */
insert ujo_chase 
	(nstart, joid, job_name, job_type, status, run_machine, pid, jc_pid )

select	@nstart, j.joid, j.job_name, j.job_type, 
	status, run_machine, pid, jc_pid

from	ujo_job j, ujo_job_status s
where	j.joid = s.joid
and	status = 3 
and	status_time < @starting_delay_time
and	job_type in ('c','f')
and	j.joid not in
       	( select joid from ujo_event where status = 3 and event_time_gmt < @starting_delay_time )
and	j.joid not in
	( select joid from ujo_chase where nstart = @nstart )



/* Now blow off the 1's that are waiting in the event and finished */


    
delete from ujo_chase    
where joid in 
     (SELECT r.joid 
      FROM ujo_chase r, ujo_event e
      WHERE r.joid = e.joid
      and	que_status = 0 /* Means its waiting to be processed */
      and	e.status in ( 4,5,6,10 ) /* Success, Failure, Terminated, Restart */
      and	nstart = @nstart) 


/* Remove the rows in the chase table that are for Z/Team machines. */
delete from ujo_chase where run_machine in
(select distinct j.run_machine from ujo_job_status j, ujo_machine m where
j.run_machine = m.name and m.type in ('z', 't'))

/* Issue 12184156 - sinpr01 */
/* Remove the rows in the chase table that have blank machine names */
delete from ujo_chase where run_machine='' and nstart=@nstart

/* pass back which chase number it is... IF = 0 there's nothing ! */
if ( select top 1 1 from ujo_chase where nstart = @nstart ) > 0
begin
	select @nstart
end
else
begin
	select @nstart = 0
end

select @nstart as nstart
return -999 /*SUCCESS*/

go


grant execute on ujo_chase_state to ujoadmin
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14673022, getdate(), 1, 4, 'Patch Star 14673022 Autosys: Modify stored procedure ujo_chase_state STARTING event' )
GO

COMMIT TRANSACTION 
GO
