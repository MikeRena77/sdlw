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
/* Star 14585259 DSM : MSSQL Change to Views                                            */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ca_manager with (tablockx)
GO
 
Select top 1 1 from ca_n_tier with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

/* ********************** 9544 end *********************************** */
/* this views are replaced by ca_coapi_...._v1						   */

drop view ca_coapi_agent_view_nodom
GO
drop view ca_coapi_agent_view_nodomsrv
GO
drop view ca_coapi_agent_view_nosrv
GO

/* ********************** 9544 end *********************************** */

/* ********************** 9439 begin *********************************** */
/* Stack Windows: no highlighting of policy violators in case of replicated query based policy */
/* impact: no violator highlighting on enterprise level in case of enterprise policy has been violated */

drop view ca_am_asset_derived_status
GO
create view ca_am_asset_derived_status
as
select ca_agent.object_uuid,isnull(min(polsev),0) as object_status 
	FROM
ca_agent left outer join POLILOG
on ca_agent.object_uuid=polilog.object_uuid 
	WHERE agent_type>0 group by ca_agent.object_uuid
GO
GRANT  SELECT  ON [dbo].[ca_am_asset_derived_status]  TO [ca_itrm_group]
GO
GRANT  SELECT  ON [dbo].[ca_am_asset_derived_status]  TO [upmuser_group]
GO

/* ********************** 9439 begin *********************************** */

/********************** 9360 begin ****************** */


alter table ca_manager alter column [host_name] [nvarchar] (255) collate !!insensitive  NULL
go
alter table ca_n_tier alter column db_host_name nvarchar(255) collate !!insensitive NULL
go


/********************** 9360 end ****************** */


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14585259, getdate(), 1, 4, 'Star 14585259 DSM : MSSQL Change to Views' )
GO

COMMIT TRANSACTION 
GO


