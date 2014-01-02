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
/* Star 15321639 : TNGAMO: 11748: add view ca_v_query_def				*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */

Select top 1 1 from ca_query_def with (tablockx)
GO

select top 1 1 from ca_discovered_user with (tablockx)
GO 
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */


create view ca_v_query_def_user
as
select 
	q.domain_uuid as q_domain_uuid,
	q.query_uuid as query_uuid,
	q.label as q_label,
	q.query_type as query_type,
	q.query_cont as query_cont,
	q.target_table as q_target_table,
	q.target_type as q_target_type,
	q.creation_user as q_creation_user,
	q.creation_date as q_creation_date,
	q.last_update_user as q_last_update_user,
	q.last_update_date as q_last_update_date,
--	q.version_number as q_version_number, 
--	q.auto_rep_version as q_autorep_version,
	u.user_uuid as user_uuid,
	u.label		as u_label,
	u.user_name	 as user_name,
	u.domain_uuid	as u_domain_uuid,
	u.creation_user as u_creation_user,
	u.creation_date as u_creation_date,
	u.last_update_user as u_last_update_user,
	u.last_update_date as u_last_update_date,
--	u.version_number as u_version_number 
--	u.auto_rep_version as u_autorep_version
	u.uri	as u_uri,
	u.user_type as user_type,
	u.usage_list	as u_usage_list,
	u.directory_url as u_directory_url


from ca_query_def q, ca_discovered_user u
where  u.uri = q.creation_user collate !!insensitive
	and u.uri is not null
	and q.creation_user is not null
	and q.domain_uuid = u.domain_uuid
go

grant select on ca_v_query_def_user to ca_itrm_group
go


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15321639, getdate(), 1, 4, 'Star 15321639 (MODIFIED 16208491 v1) TNGAMO: 11748: add view ca_v_query_def' )
GO

COMMIT TRANSACTION 
GO

