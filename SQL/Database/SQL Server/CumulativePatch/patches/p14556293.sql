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
/* Star Issue 14556293 DSM:MSSQL TRIGGER UPDATES                                        */
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

/* *********************** 9232 begin ************************************ */

/****************************************************************************/
/* Procedure that cleans up USD objects when a ca_agent object is removed   */
/*                                                                          */
/* This procedure will cleanup USD jobs (in case of no active jobs):        */

/* Bug fix 9232:
	The problems are that the permissionmask can be wrongly and that some 
	of the counters are wrong.  If the permission masks are wrong some GUI 
	operations can be incorrectly disabled/enabled after you remove a 
	computer involved in completed (or waiting) job(s).
																			*/
/*                                                                          */
/****************************************************************************/
drop trigger usd_trg_d_agent_usd_rel
go
create trigger usd_trg_d_agent_usd_rel
on ca_agent
for delete as
declare
    @counted int
begin
    -- Only work with usd agents
    set @counted = (select count(*) from deleted where agent_type = 1 or agent_type = 4) 
    if(@counted = 0)
    begin
	-- No USD agents exit
	return
    end

    -- If we are involved in an active job, raise error
    set @counted = (select count(*)
    from usd_v_nr_of_active_applics aa, deleted d
    where aa.target = d.object_uuid 
    and activity <> 0x00000000000000000000000000000000)
    if(@counted > 0)
    begin
	raiserror('Error 9011: Cannot remove the computer because of active Software Delivery jobs', 16, 1 )
        rollback transaction
	return
    end

    -- Get all the activities related to this computer
            
    -- Store some of the data of the activities involved in the deleted computer(s)
    -- We must store away this as we need to delete applics early on.
    -- If we delete the applics first then we would not find the relevant activities
    select act.objectid, act.actproc into #activity
    from usd_applic a, usd_activity act, deleted d
    where a.activity = act.objectid
    and a.target = d.object_uuid

    set @counted = (select count(*) from #activity)
    if(@counted = 0)
    begin
	-- Not involved in any job exit
	return
    end
    
    -- Cleanup 1
    -- Delete the following: usd_link_grp_cmp,usd_target
    -- usd_link_act_cmp,usd_link_jc_srv,usd_link_act_inst
    delete from usd_link_grp_cmp from deleted where comp = object_uuid
    delete from usd_link_act_cmp from deleted where comp = object_uuid
    delete from usd_link_jc_srv from deleted where server = object_uuid
    delete from usd_link_act_inst 
    from deleted d inner join usd_applic a on d.object_uuid = a.target
    where usd_link_act_inst.installation = a.objectid
    delete from usd_target from deleted where objectid = object_uuid

    -- Update the class version
    update usd_class_version set modify_version = modify_version + 1
    where name = 'link_grp_cmp'
    or name = 'link_act_cmp'
    or name = 'link_jc_srv'
    or name = 'link_act_inst'
    or name = 'target'
    
   
    -- We must now remove all the applics of these computer as we need to recalculate counters
    -- Cleanup 2
    delete from usd_applic 
    from deleted 
    where target = object_uuid

    -- Now store the activities from #activity that only targeted the applics deleted above
    -- We only want to keep activites that involve other computers than the ones we deleted.
    -- For these kept activities we need to update counters and masks
    select objectid into #activity_deleted
    from #activity
    where objectid not in (select appl.activity
    from usd_applic appl, #activity act
    where appl.activity = act.objectid)

    -- Remove the unwanted activities        
    delete from #activity
    from #activity_deleted ad
    where #activity.objectid = ad.objectid

    -- Update the class version
    update usd_class_version set modify_version = modify_version + 1 where name = 'applic'

    -- Create a temp table to hold the new counters
    create table #actcount(oid binary(16), totcnt int default 0, waitcnt int default 0, actcnt int default 0, okcnt int default 0, errcnt int default 0,
                      totrencnt int default 0, waitrencnt int default 0, actrencnt int default 0, okrencnt int default 0, errrencnt int default 0)

    -- Be careful understanding how the counterid is used, this table is used for many things
    -- and you must not mix up objects taken from this table.
    create table #interm_count(oid binary(16), cnt int, counterid int)

    -- Insert the tot counters, use the temp table above
    insert into #actcount(oid, totcnt)
    select act.objectid, count(*)
    from usd_applic app, #activity act
    where app.activity = act.objectid
    group by act.objectid

    -- Update the renew tot counters
    insert into #interm_count(oid, cnt, counterid)
    select act.objectid, count(*), 1
    from usd_applic appv, #activity act
    where appv.activity = act.objectid
    and renewstatus <> 0
    group by act.objectid

    update #actcount set totrencnt = cnt 
    from #interm_count
    where #actcount.oid = #interm_count.oid and #interm_count.counterid = 1

    -- Update the wait counters, use the temp table above and also store 
    -- temp data in a new temp table
    insert into #interm_count(oid, cnt, counterid)
    select act.objectid, count(*) cnt, 2
    from usd_v_nr_of_waiting_applics appv, #activity act
    where appv.activity = act.objectid
    group by act.objectid
    
    update #actcount set waitcnt = cnt 
    from #interm_count
    where #actcount.oid = #interm_count.oid and #interm_count.counterid = 2

    -- Update the renew wait counters
    insert into #interm_count(oid, cnt, counterid)
    select act.objectid, count(*) cnt, 3
    from usd_v_nr_of_renew_wait_applics appv, #activity act
    where appv.activity = act.objectid
    group by act.objectid

    update #actcount set waitrencnt = cnt 
    from #interm_count
    where #actcount.oid = #interm_count.oid and #interm_count.counterid = 3

    -- Update the active counters, use the temp table above and also store 
    -- temp data in a new temp table
    insert into #interm_count(oid, cnt, counterid)
    select act.objectid, count(*) cnt, 4
    from usd_v_nr_of_active_applics appv, #activity act
    where appv.activity = act.objectid
    group by act.objectid
    
    update #actcount set actcnt = cnt 
    from #interm_count
    where #actcount.oid = #interm_count.oid and #interm_count.counterid = 4

    -- Update the renew active counters
    insert into #interm_count(oid, cnt, counterid)
    select act.objectid, count(*) cnt, 5
    from usd_v_nr_of_renew_active_applics appv, #activity act
    where appv.activity = act.objectid
    group by act.objectid

    update #actcount set actrencnt = cnt 
    from #interm_count
    where #actcount.oid = #interm_count.oid and #interm_count.counterid = 5

    -- Update the ok counters, use the temp table above and also store 
    -- temp data in a new temp table
    insert into #interm_count(oid, cnt, counterid)
    select act.objectid, count(*) cnt, 6
    from usd_v_nr_of_ok_applics appv, #activity act
    where appv.activity = act.objectid
    group by act.objectid
    
    update #actcount set okcnt = cnt 
    from #interm_count
    where #actcount.oid = #interm_count.oid and #interm_count.counterid = 6

    -- Update the renew ok counters
    insert into #interm_count(oid, cnt, counterid)
    select act.objectid, count(*) cnt, 7
    from usd_v_nr_of_renew_ok_applics appv, #activity act
    where appv.activity = act.objectid
    group by act.objectid

    update #actcount set okrencnt = cnt 
    from #interm_count
    where #actcount.oid = #interm_count.oid and #interm_count.counterid = 7

    -- Update the error counters, use the temp table above
    update #actcount set errcnt = totcnt - waitcnt - actcnt - okcnt
    
    -- Update the renew error counters, use the temp table above

    update #actcount set errrencnt = totrencnt - waitrencnt - actrencnt - okrencnt

    -- Go and do the big update to the real activity table
    update usd_activity set
    waitingcnt = waitcnt,
    activecnt = actcnt,
    okcnt = #actcount.okcnt,
    errorcnt = errcnt,
    waitingrenewcnt = waitrencnt,
    activerenewcnt = actrencnt,
    okrenewcnt = okrencnt,
    errorrenewcnt = errrencnt
    from #actcount
    where objectid = oid

    -- set the new states
    update usd_activity set state = 1 -- INPROGRESS
    from #actcount
    where objectid = oid
    and #actcount.actcnt > 0
    
    update usd_activity set state = 0 -- WAITING
    from #actcount
    where objectid = oid
    and #actcount.actcnt = 0
    and #actcount.waitcnt > 0
    
    update usd_activity set state = 2 -- ACTOK
    from #actcount
    where objectid = oid
    and #actcount.actcnt = 0
    and #actcount.waitcnt = 0
    and #actcount.totcnt = #actcount.okcnt
    and state <> 7
    
    update usd_activity set state = 3 -- ACTERROR
    from #actcount
    where objectid = oid
    and #actcount.actcnt = 0
    and #actcount.waitcnt = 0
    and #actcount.totcnt <> #actcount.okcnt
    and state <> 7

    -- set the new renew states
    update usd_activity set renewstate = 1 -- INPROGRESS
    from #actcount
    where objectid = oid
    and #actcount.actrencnt > 0
    and renewstate <> 8

    update usd_activity set renewstate = 0 -- WAITING
    from #actcount
    where objectid = oid
    and #actcount.actrencnt = 0
    and #actcount.waitrencnt > 0
    and renewstate <> 8

    update usd_activity set renewstate = 8 -- NOT_YET_RENEWED
    from #actcount
    where objectid = oid
    and #actcount.actrencnt = 0
    and #actcount.waitrencnt = 0
    and #actcount.okrencnt+#actcount.errrencnt+#actcount.actrencnt+#actcount.waitrencnt = 0
    and renewstate <> 8

    update usd_activity set renewstate = 3 --  ACTERROR
    from #actcount
    where objectid = oid
    and #actcount.actrencnt = 0
    and #actcount.waitrencnt = 0
    and #actcount.okrencnt+#actcount.errrencnt+#actcount.actrencnt+#actcount.waitrencnt <> 0
    and #actcount.errrencnt > 0
    and renewstate <> 8

    update usd_activity set renewstate = 2 --  ACTOK
    from #actcount
    where objectid = oid
    and #actcount.actrencnt = 0
    and #actcount.waitrencnt = 0
    and #actcount.okrencnt+#actcount.errrencnt+#actcount.actrencnt+#actcount.waitrencnt <> 0
    and #actcount.errrencnt = 0
    and #actcount.actcnt = 0
    and #actcount.waitcnt = 0
    and #actcount.totrencnt = #actcount.errcnt
    and renewstate <> 8

    update usd_activity set renewstate = 50 --  ACT_PARTIALLY_RENEWED_OK
    from #actcount
    where objectid = oid
    and #actcount.actrencnt = 0
    and #actcount.waitrencnt = 0
    and #actcount.okrencnt+#actcount.errrencnt+#actcount.actrencnt+#actcount.waitrencnt <> 0
    and #actcount.errrencnt = 0
    and #actcount.actcnt = 0
    and #actcount.waitcnt = 0
    and #actcount.totrencnt <> #actcount.errcnt
    and renewstate <> 8

    update usd_activity set renewstate = 50 --  ACT_PARTIALLY_RENEWED_OK
    from #actcount
    where objectid = oid
    and #actcount.actrencnt = 0
    and #actcount.waitrencnt = 0
    and #actcount.okrencnt+#actcount.errrencnt+#actcount.actrencnt+#actcount.waitrencnt <> 0
    and #actcount.errrencnt = 0
    and (#actcount.actcnt <> 0 or #actcount.waitcnt <> 0)
    and renewstate <> 8

    -- now, this can cause the permission mask to change...
    
    -- Set bit SDAPI_JOB_CANCEL_ALLOWED
    update usd_activity set permmask = permmask | 2
    from #activity b
    where usd_activity.objectid = b.objectid
    and state in (0,2,3) -- ACTOK or ACTERROR

    -- Clear bit SDAPI_JOB_CANCEL_ALLOWED
    update usd_activity set permmask = permmask & ~2
    from #activity b
    where usd_activity.objectid = b.objectid
    and state not in (0,2,3) -- WAITING, ACTOK or ACTERROR

    -- Set bit SDAPI_JOB_RESCHEDULE_ALLOWED if activity waiting and no applics exists
    update usd_activity set usd_activity.permmask = usd_activity.permmask | 8
    from #activity b, usd_applic appl
    where usd_activity.objectid = b.objectid
    and usd_activity.state = 0 -- WAITING
    and appl.activity = b.objectid

    -- Clear bit SDAPI_JOB_RESCHEDULE_ALLOWED if activity not waiting
    update usd_activity set permmask = permmask & ~8
    from #activity b
    where usd_activity.objectid = b.objectid
    and usd_activity.state <> 0 -- WAITING

    -- Figure out the recover bit
    
    -- Count the recovery procs for each activity
    
    -- Get the rsw for each activity
    select act.objectid as actoid, rsw.objectid as rswoid into #actrsw
    from #activity act,usd_actproc ap, usd_rsw rsw
    where act.actproc = ap.objectid
    and rsw.objectid = ap.rsw
    
    -- Get the uninst procs for each rsw
    insert into #interm_count(oid, cnt, counterid)
    select rsw.rswoid oid, count(ap.objectid) cnt, 9
    from usd_actproc ap, #actrsw rsw
    where ap.rsw = rsw.rswoid
    and ap.task = 1 -- UNINSTALL
    and (ap.includedproc = 0 or ap.includedproc = 1 or ap.includedproc = 3) -- ADDEDPROC, EMBEDDEDPROC, CONVERTED
    group by rsw.rswoid

    -- Remove the activities where there are no recovery procs        
    delete from #actrsw
    where rswoid not in (select oid from #interm_count where counterid = 9)
    
    -- We now have a list of activites (#actrsw) with recovery procs
    
    -- Let us now see if we are go for recovery, check other existing applics...
    
    -- We should only consider these activities for recovery
    select objectid, activity, actproc, target into #act_valid_for_rec
    from usd_applic
    where(renewstatus = 0 -- UNDEFINED
    or renewstatus = 10) -- EXECUTION_ERROR
    and actproc <> 0x00000000000000000000000000000000
    and status = 10
    and task = 0x00000001
    and errorcause in (228001, 228002, 228003, 228004, 228005)
    and objectid in (select
        case
        when AP.firstrenew <> 0x00000000000000000000000000000000 then AP.firstrenew
        else AP.objectid
        end as objid
        from usd_applic AP, #activity ACT
        where AP.activity = ACT.objectid)
        
    -- Get rid of activities that have no recovery procs
    delete from #act_valid_for_rec
    where #act_valid_for_rec.activity not in (select #actrsw.actoid from #actrsw)

    -- Are there any other activites that (using the same proc and targeting the same comp)
    -- have succeeded applics?
    select AP.objectid, AP.activity, AP.target, AP.actproc into #act_not_valid_for_rec
    from usd_applic AP, #act_valid_for_rec AVFR
    where AP.target = AVFR.target
    and AP.actproc = AVFR.actproc
    and (
    /* task=install and status!=execution_error and status!=already_installed and status!=manipulation_not_allowed */
    (AP.task = 0x01 and AP.status != 10 and AP.status != 15 and AP.status != 16) or
    /* task=deliver and status!=delivery_error and status!=already_delivered */
    (AP.task = 0x10 and AP.status != 5 and AP.status != 6)
    )
    /* not uninstalled */
    and AP.uninstallstate <> 2
    and (AP.status = 9 or AP.status = 4)
    
    -- Get rid of them
    delete from #act_valid_for_rec
    from #act_not_valid_for_rec
    where #act_valid_for_rec.target = #act_not_valid_for_rec.target
    and #act_valid_for_rec.actproc = #act_not_valid_for_rec.actproc
    
    -- Last a check if there are any ongoing uninstalls
    select a.installation into #ongoing_uninstall_appl
    from usd_applic a, #act_valid_for_rec avfr
    where installation = avfr.objectid
    and  a.installation <> a.objectid /* do not read myself */
    and a.task = 0x02 -- UNINSTALL
    and status <> 10 -- EXECUTION_ERROR
    and status <> 5 -- DELIVERY_ERROR

    -- Get rid of them
    delete from #act_valid_for_rec
    from #ongoing_uninstall_appl
    where #act_valid_for_rec.objectid = #ongoing_uninstall_appl.installation

    -- Set bit SDAPI_JOB_RECOVER_ALLOWED
    update usd_activity set permmask = permmask | 4
    from #act_valid_for_rec avfr
    where usd_activity.objectid = avfr.activity
    and state in (3,1) -- ACTERROR or INPROGRESS

    -- Clear bit SDAPI_JOB_RECOVER_ALLOWED 1
    update usd_activity set permmask = permmask & ~4
    from #act_valid_for_rec avfr
    where usd_activity.objectid = avfr.activity
    and state not in (3,1) -- ACTERROR or INPROGRESS

    -- Clear bit SDAPI_JOB_RECOVER_ALLOWED 2
    update usd_activity set permmask = permmask & ~4
    from #activity
    where #activity.objectid not in (select activity from #act_valid_for_rec)
    and usd_activity.objectid = #activity.objectid

    -- Do the update, it is also time to update the version number
    -- This may be too much, can optimize it?
    update usd_activity set version = version + 1
    from #activity
    where usd_activity.objectid = #activity.objectid
    
    -- Time to delete objects...#activity_deleted
    -- Cleanup 3
    delete from usd_activity from #activity_deleted ad where usd_activity.objectid = ad.objectid
    delete from usd_link_jc_act from #activity_deleted ad where activity = ad.objectid

    -- Update the class versions
    update usd_class_version set modify_version = modify_version + 1 where name = 'link_jc_act'
    update usd_class_version set modify_version = modify_version + 1 where name = 'activity'

    -- Activities DONE!
    
    -- Get all the job container views related to this computer
    select distinct JCV.objectid as jcvoid, JC.objectid as jcoid into #jcview_jc
    from usd_jcappgr APG, usd_jcview JCV, usd_job_cont JC, deleted d
    where APG.jobtarget = d.object_uuid
    and APG.jobcontview = JCV.objectid
    and JC.objectid = JCV.jobcont

    -- We must now remove all the jcappgr of this computer as we need to recalculate
    
    -- Cleanup 4
    delete from usd_jcappgr from deleted where jobtarget = object_uuid
    -- Update the class version
    update usd_class_version set modify_version = modify_version + 1 where name = 'jcappgr'
    
    -- Now remove the jcviews from #jcview_jc that only targeted the jcappgr deleted above
    -- We only want to keep jcviews that involve other computers than the ones we deleted.
    -- For these kept jcviews we need to update counters
    select jcvoid, jcoid into #jcview_jc_deleted
    from #jcview_jc 
    where jcvoid not in (select japg.jobcontview
     			 from usd_jcappgr japg, #jcview_jc jv
        		 where japg.jobcontview = jv.jcvoid)
        
    -- Remove the unwanted jcviews
    delete from #jcview_jc
    from #jcview_jc_deleted jjd
    where #jcview_jc.jcvoid = jjd.jcvoid

    -- Update class version
    update usd_class_version set modify_version = modify_version + 1 where name = 'jcappgr'
    
    -- Create a temp table to hold the new counters
    create table #jcvcount(jcvoid binary(16), waitcnt int default 0, actcnt int default 0, okcnt int default 0, errcnt int default 0,
                                waitrencnt int default 0, actrencnt int default 0, okrencnt int default 0, errrencnt int default 0)

    -- Insert all the objects to count for the views
    insert into #jcvcount(jcvoid)
    select distinct jcv.jcvoid
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid

    -- Update the counters for the view (JOBWAITING)
    insert into #interm_count(oid, cnt, counterid)
    select jcv.jcvoid, count(*) cnt, 17
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid
    and jobstatus = 0
    group by jcv.jcvoid

    update #jcvcount set waitcnt = cnt 
    from #interm_count
    where #jcvcount.jcvoid = #interm_count.oid and #interm_count.counterid = 17

    -- Update the counters for the view (JOBACTIVE)
    insert into #interm_count(oid, cnt, counterid)
    select jcv.jcvoid, count(*) cnt, 10
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid
    and jobstatus = 1
    group by jcv.jcvoid

    update #jcvcount set actcnt = cnt 
    from #interm_count
    where #jcvcount.jcvoid = #interm_count.oid and #interm_count.counterid = 10

    -- Update the counters for the view (JOBOK)
    insert into #interm_count(oid, cnt, counterid)
    select jcv.jcvoid, count(*) cnt, 11
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid
    and jobstatus = 2
    group by jcv.jcvoid

    update #jcvcount set okcnt = cnt 
    from #interm_count
    where #jcvcount.jcvoid = #interm_count.oid and #interm_count.counterid = 11

    -- Update the counters for the view (JOBERROR)
    insert into #interm_count(oid, cnt, counterid)
    select jcv.jcvoid, count(*) cnt, 12
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid
    and jobstatus = 3
    group by jcv.jcvoid

    update #jcvcount set errcnt = cnt 
    from #interm_count
    where #jcvcount.jcvoid = #interm_count.oid and #interm_count.counterid = 12

    -- Update the counters for the view (JOBWAITING RENEWED)
    insert into #interm_count(oid, cnt, counterid)
    select jcv.jcvoid, count(*) cnt, 13
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid
    and renewedjobstatus = 0
    group by jcv.jcvoid

    update #jcvcount set waitrencnt = cnt 
    from #interm_count
    where #jcvcount.jcvoid = #interm_count.oid and #interm_count.counterid = 13

    -- Update the counters for the view (JOBACTIVE RENEWED)
    insert into #interm_count(oid, cnt, counterid)
    select jcv.jcvoid, count(*) cnt, 14
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid
    and renewedjobstatus = 1
    group by jcv.jcvoid

    update #jcvcount set actrencnt = cnt 
    from #interm_count
    where #jcvcount.jcvoid = #interm_count.oid and #interm_count.counterid = 14

    -- Update the counters for the view (JOBOK RENEWED)
    insert into #interm_count(oid, cnt, counterid)
    select jcv.jcvoid, count(*) cnt, 15
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid
    and renewedjobstatus = 2
    group by jcv.jcvoid

    update #jcvcount set okrencnt = cnt 
    from #interm_count
    where #jcvcount.jcvoid = #interm_count.oid and #interm_count.counterid = 15

    -- Update the counters for the view (JOBERROR RENEWED)
    insert into #interm_count(oid, cnt, counterid)
    select jcv.jcvoid, count(*) cnt, 16
    from usd_jcappgr jcap, #jcview_jc jcv
    where jcap.jobcontview = jcv.jcvoid
    and renewedjobstatus = 3
    group by jcv.jcvoid

    update #jcvcount set errrencnt = cnt 
    from #interm_count
    where #jcvcount.jcvoid = #interm_count.oid and #interm_count.counterid = 16

    -- Go and do the big update to the real jcview table
    update usd_jcview set
    waitingcnt = waitcnt,
    activecnt = actcnt,
    okcnt = #jcvcount.okcnt,
    errorcnt = errcnt,
    waitingrenewcnt = waitrencnt,
    activerenewcnt = actrencnt,
    okrenewcnt = okrencnt,
    errorrenewcnt = errrencnt
    from #jcvcount
    where objectid = jcvoid
    
    -- Cleanup 5
    -- Delete usd_jcview,usd_job_cont,usd_link_jc
    delete from usd_jcview from #jcview_jc_deleted where objectid = jcvoid
    delete from usd_link_jc from #jcview_jc_deleted where jcparent = jcoid
    delete from usd_link_jc from #jcview_jc_deleted where jcchild = jcoid
    delete from usd_job_cont from #jcview_jc_deleted where objectid = jcoid
    -- Update the class version
    update usd_class_version set modify_version = modify_version + 1
    where name = 'link_jc'
    or name = 'job_cont'
end
GO
/* *********************** 9232 end ************************************ */

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14556293, getdate(), 1, 4, 'Star Issue 14556293 DSM:MSSQL TRIGGER UPDATES ' )
GO

COMMIT TRANSACTION 
GO

