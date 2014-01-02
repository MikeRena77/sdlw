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
/* Patch Star 14930657 Autosys: Replace ujo_get_jobrow stored procedure - coding error in the join */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

if exists (select name from sysobjects where name = 'ujo_get_jobrow' and type = 'P')
begin
	drop procedure ujo_get_jobrow
end
go

Create proc ujo_get_jobrow
	@joid  int
AS

SELECT  
	j.joid, 
    j.job_name,
    j.job_type,
    j.owner,
    j.permission,
	j.box_joid,
	j.machine,
	j.n_retrys,
	j.date_conditions,
	j.days_of_week,
	j.run_calendar,
	j.exclude_calendar,
	j.start_times,
	j.start_mins,
	j.run_window,
	j.command,	 
    j.description, 
    j.term_run_time,
    j.box_terminator, 
    j.job_terminator,
    j.std_in_file,
    j.std_out_file,
    j.std_err_file,
	j.watch_file,
	j.watch_file_min_size,
	j.watch_interval,
    j.min_run_alarm, 
    j.max_run_alarm, 
    j.alarm_if_fail,
	j.chk_files,
	j.free_procs,
	j.profile,
	j.heartbeat_interval,
	j.auto_hold, 
	j.job_load,
	j.priority, 
	j.auto_delete, 
	j.numero,
	j.max_exit_success, 
	j.box_success, 
	j.box_failure,
	status,
    status_time,
    last_start,
    last_end,
    next_start,
    run_window_end,
	exit_code,
	run_machine,
	que_name,
	jc_pid,
	pid,
	run_num, 
	ntry, 
	appl_ntry, 
	last_heartbeat,
	run_priority,
	next_priority, 
	evt_num, 
	over_num,
	b.job_name, 
	j2.command2,
	j2.external_app, 
	j2.timezone, 
	j2.as_applic,
    j2.as_group,    
	j.send_notification,
    j.service_desk  

FROM  	ujo_job_status s , ujo_job2 j2, ujo_job j 
LEFT OUTER JOIN ujo_job b ON j.box_joid = b.joid
WHERE 	j.joid = @joid AND j2.joid = @joid AND s.joid = @joid

return -999 /*SUCCESS*/

GO

grant execute on ujo_get_jobrow to ujoadmin
go
/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14930657, getdate(), 1, 4, 'Patch Star 14930657 Autosys: Replace ujo_get_jobrow stored procedure - coding error in the join' )
GO

COMMIT TRANSACTION 
GO


