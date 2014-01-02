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
/* Star 14843603 DSM: New index on usd_applic.  Additional view. Change 2 views       	*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from usd_applic with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ********************** 10297 begin  ******************* */
ALTER  view usd_v_query_del_time
as
select APPL.target,
case when APPL.status in (1,2,3) then APPL.activationtime
else APPL.completiontime
end as anytime
from usd_applic APPL
/* not uninstalled */
where APPL.uninstallstate <> 2
/* Delivery and WAITING,DELIVERY_ORDERED,DELIVERING,DELIVERY_OK */
and APPL.task = 0x00000010 and status in (1,2,3,4)
go

ALTER  view usd_v_query_inst_time
as
select APPL.target,
case when APPL.status in (1,2,3,4,7,8,17,18,19,20,21,27) then APPL.activationtime
else APPL.completiontime
end as anytime
from usd_applic APPL
/* not uninstalled */
where APPL.uninstallstate <> 2
/* task&install and status!=execution_error and status!=already_installed and status!=manipulation_not_allowed */
and (APPL.task = 0x00000001 and APPL.status != 10 and APPL.status != 15 and APPL.status != 16)
go

create view usd_vq_target
as
select agent_name as lanname, object_uuid as objectid, NULL as dis_hw_uuid, agent_type
from ca_agent
go
GRANT  SELECT on [dbo].[usd_vq_target]  TO [ca_itrm_group]
go

CREATE INDEX [usd_applic4] ON [dbo].[usd_applic]([actproc], [status], [task], [uninstallstate], [target]) ON [PRIMARY]
go

/* ********************** 10297 end  ******************* */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14843603, getdate(), 1, 4, 'Star 14843603 DSM: New index on usd_applic. Additional view. Change 2 views' )
GO

COMMIT TRANSACTION 
GO

