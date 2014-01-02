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
/* Star 14567794 WF:NEW COL IN CA WORKFLOW TABL						*/
/*                                                                                      */
/****************************************************************************************/
BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from actors with (tablockx)
GO
 
Select top 1 1 from assignments with (tablockx)
GO
 
Select top 1 1 from definitions with (tablockx)
GO
 
Select top 1 1 from workflow_groups with (tablockx)
GO
 
Select top 1 1 from instances with (tablockx)
GO
 
Select top 1 1 from objclasses with (tablockx)
GO
 
Select top 1 1 from objstore with (tablockx)
GO
 
Select top 1 1 from serviceproviders with (tablockx)
GO
 
Select top 1 1 from setting with (tablockx)
GO
 
Select top 1 1 from simpleevent with (tablockx)
GO
 
Select top 1 1 from stats with (tablockx)
GO
 
Select top 1 1 from timedevent with (tablockx)
GO
 
Select top 1 1 from triggers with (tablockx)
GO
 
Select top 1 1 from user_roles with (tablockx)
GO
 
Select top 1 1 from users with (tablockx)
GO
 
Select top 1 1 from worklist with (tablockx)
GO
 
Select top 1 1 from wfschema with (tablockx)
GO
 
Select top 1 1 from securitypredicate with (tablockx)
GO
 
Select top 1 1 from workflow_configuration with (tablockx)
GO
 
Select top 1 1 from ldapconfiguration with (tablockx)
GO
 
Select top 1 1 from ldapactors_worklist with (tablockx)
GO
 
Select top 1 1 from process_listeners with (tablockx)
GO
 
Select top 1 1 from dynamic_worklist with (tablockx)
GO
 
Select top 1 1 from workitems with (tablockx)
GO
 
Select top 1 1 from instance_history with (tablockx)
GO
 
Select top 1 1 from userlist_worklist with (tablockx)
GO
 
Select top 1 1 from wf_locks with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

alter table actors add  lastcheckin BIGINT NOT NULL default 0
GO
alter table assignments add  lastcheckin BIGINT NOT NULL default 0
GO
alter table definitions add  lastcheckin BIGINT NOT NULL default 0
GO
alter table workflow_groups add  lastcheckin BIGINT NOT NULL default 0
GO
alter table instances add  lastcheckin BIGINT NOT NULL default 0
GO
alter table objclasses add  lastcheckin BIGINT NOT NULL default 0
GO
alter table objstore add  lastcheckin BIGINT NOT NULL default 0
GO
alter table serviceproviders add  lastcheckin BIGINT NOT NULL default 0
GO
alter table setting add  lastcheckin BIGINT NOT NULL default 0
GO
alter table simpleevent add  lastcheckin BIGINT NOT NULL default 0
GO

alter table stats add  lastcheckin BIGINT NOT NULL default 0
GO
alter table timedevent add  lastcheckin BIGINT NOT NULL default 0
GO
alter table triggers add  lastcheckin BIGINT NOT NULL default 0
GO
alter table user_roles add  lastcheckin BIGINT NOT NULL default 0
GO
alter table users add  lastcheckin BIGINT NOT NULL default 0
GO
alter table worklist add  lastcheckin BIGINT NOT NULL default 0
GO
alter table wfschema add  lastcheckin BIGINT NOT NULL default 0
GO
alter table securitypredicate add  lastcheckin BIGINT NOT NULL default 0
GO
alter table workflow_configuration add  lastcheckin BIGINT NOT NULL default 0
GO
alter table ldapconfiguration add  lastcheckin BIGINT NOT NULL default 0
GO



alter table ldapactors_worklist add  lastcheckin BIGINT NOT NULL default 0
GO
alter table process_listeners add  lastcheckin BIGINT NOT NULL default 0
GO
alter table dynamic_worklist add  lastcheckin BIGINT NOT NULL default 0
GO
alter table workitems add  lastcheckin BIGINT NOT NULL default 0
GO
alter table instance_history add  lastcheckin BIGINT NOT NULL default 0
GO
alter table userlist_worklist add  lastcheckin BIGINT NOT NULL default 0
GO
alter table wf_locks add  lastcheckin BIGINT NOT NULL default 0
GO


CREATE INDEX actors_ind1 ON actors
(
       productid                      ASC,
       lastcheckin                    ASC
)
GO


CREATE INDEX objclasses_ind1 ON objclasses
(
       productid                      ASC,
       lastcheckin                    ASC
)
GO


CREATE INDEX workflow_configuration_ind1 ON workflow_configuration
(
       productid                      ASC,
       lastcheckin                    ASC
)
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14567794, getdate(), 1, 4, 'Star 14567794 WF:NEW COL IN CA WORKFLOW TABL' )
GO

COMMIT TRANSACTION 
GO


