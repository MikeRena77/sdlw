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
/* Star 14640144 DSM : MSSQL: UNUSED TRIGGER FOR USD                                    */
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

/* ******************** 9907 begin ************************* */

drop trigger usd_rule_d_target_ag_comp
GO
drop trigger usd_rule_u_usd_target_status
GO
drop procedure usd_proc_d_target_ag_comp
GO
drop procedure usd_proc_u_usd_target_status
GO

/* ******************** 9907 end ************************* */




/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14640144, getdate(), 1, 4, 'Star 14640144 DSM : MSSQL: Unused Trigger for USD ' )
GO

COMMIT TRANSACTION 
GO


