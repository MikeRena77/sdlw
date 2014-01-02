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

/* lock objects... */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harudp with (tablockx)
GO
 
Select top 1 1 from haruserdata with (tablockx)
GO
 
Select top 1 1 from harlinkedprocess with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/****************************************************************************/
/*                                                                          */
/* Patch Star 14657517 HARVEST incorrect hsql query	                    */	
/*                                                                          */
/****************************************************************************/

update harudp
set inputparm = 'SELECT environmentname, statename, COUNT(*) AS number_of_packages FROM harpackage, harstate, harenvironment WHERE harstate.stateobjid = harpackage.stateobjid AND harpackage.envobjid = harenvironment.envobjid AND harenvironment.environmentname = ''Release Model'' GROUP BY environmentname, statename'
where processobjid = 85;
GO

update harudp
set inputparm = 'SELECT environmentname, statename, COUNT(*) AS number_of_packages FROM harpackage, harstate, harenvironment WHERE harstate.stateobjid = harpackage.stateobjid AND harpackage.envobjid = harenvironment.envobjid AND harenvironment.environmentname = ''Parallel Development Model'' GROUP BY environmentname, statename'
where processobjid = 248;
GO


/****************************************************************************/
/*                                                                          */
/*  register patch                                                          */
/*                                                                          */
/****************************************************************************/
insert into mdb_patch values ( 14657517, getdate(), null, 1, 4, null, 'Star 14657517 HARVEST incorrect hsql query' )
GO

COMMIT TRANSACTION
GO
