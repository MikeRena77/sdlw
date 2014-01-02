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

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[csm_v_parameter]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[csm_v_parameter]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create view csm_v_parameter(uuid, parname, parvalue, bootstatus)
as
select 	distinct c.uuid, bc_p.dname parname, bc_pv.value parvalue,bc_bs.value bootstatus 	/* uuid of the computer */
	
from  csm_object c,
--	csm_property c_pr,						/* computer property */
	csm_link l_bc, 		csm_object bc,		/* bootconfiguration*/
	csm_link l_bc_p, 	csm_object bc_p,	/* bootconfiguration parameter */
	csm_property bc_bs,						/* bootstatus in bootconfiguration */

	csm_link l_oi, 		csm_object oi,		/* osimage */
	csm_property bc_pv

where 
	c.class=102 		and /* top is computer */

	/* computer -> bootconfiguration */
	l_bc.parent	= c.id 	and	/* link computer to child: bootconfiguration */
	l_bc.child 	= bc.id	and	
	bc.class	= 1004	and	/* child is bootconfiguration */ 

	/* bootconfiguration -> bootstatus */
	bc_bs.object 	= bc.id		and
	bc_bs.name 		= 'bootstatus' and 
	
	/* bootconfiguration -> osimage */
	l_oi.parent	= bc.id	and /* link bootconfiguration to child: osimage */
	l_oi.child	= oi.id	and	
	oi.class	= 1008	and	/* child is osimage */ 

	/* bootconfiguration -> parameter */
	l_bc_p.parent	= bc.id		and /* link bootconfiguration to child: parameter */
	l_bc_p.child	= bc_p.id	and	
	bc_p.class		= 106		and	/* child is parameter */ 

	/* bootconfiguration -> parameter -> value */
	bc_p.id			= bc_pv.object 	and
	bc_pv.name		= 'value'			

union	
select 	distinct c.uuid, oi_p.dname parname, oi_pv.value parvalue,bc_bs.value boostatus 	/* uuid of the computer */
	
from  csm_object c, 
--	csm_property c_pr,						/* computer property */
	csm_link l_bc, 		csm_object bc,		/* bootconfiguration*/
	csm_property bc_bs,						/* bootstatus in bootconfiguration */

	csm_link l_oi, 		csm_object oi,		/* osimage */
	csm_link l_oi_p, 	csm_object oi_p, 	/* os image parameter */
	csm_property oi_pv

where 
	c.class=102 		and /* top is computer */

	/* computer -> bootconfiguration */
	l_bc.parent	= c.id 	and	/* link computer to child: bootconfiguration */
	l_bc.child 	= bc.id	and	
	bc.class	= 1004	and	/* child is bootconfiguration */ 

	/* bootconfiguration -> bootstatus */
	bc_bs.object 	= bc.id		and
	bc_bs.name 		= 'bootstatus' and 
	
	/* bootconfiguration -> osimage */
	l_oi.parent	= bc.id	and /* link bootconfiguration to child: osimage */
	l_oi.child	= oi.id	and	
	oi.class	= 1008	and	/* child is osimage */ 

	/* osimage -> parameter */
	l_oi_p.parent	= oi.id		and /* link bootconfiguration to child: parameter */
	l_oi_p.child	= oi_p.id	and	
	oi_p.class		= 106		and	/* child is parameter */ 

	/* osimage -> parameter -> value */
	oi_p.id			= oi_pv.object 	and
	oi_pv.name		= 'value'		and

	/* konfiguration parameter with same name as osimage parameter doesn't exist */
	oi_p.dname not in (
	select 	bc_p.dname /* uuid of the computer */
	
		from  csm_link l_bc_p, 	csm_object bc_p,	/* bootconfiguration parameter */

			csm_property bc_pv

		where 
			/* bootconfiguration -> parameter */
			l_bc_p.parent	= bc.id		and /* link bootconfiguration to child: parameter */
			l_bc_p.child	= bc_p.id	and	
			bc_p.class		= 106		and	/* child is parameter */ 
			bc_p.dname		= oi_p.dname and

			/* bootconfiguration -> parameter -> value */
			bc_p.id			= bc_pv.object 	and
			bc_pv.name		= 'value'		
	)


GO
grant select on csm_v_parameter to ca_itrm_group
GO
grant select on csm_v_parameter to ca_itrm_group_ams
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


/*****************************************************************************/
/*                                                                           */
/* Register patch                                                     	     */
/*                                                                           */
/*****************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15819026, getdate(), 1, 4, 'Star 15819026 : DSM: MDB:ENGINE-QUERY PERFORMANCE' )
GO

COMMIT
