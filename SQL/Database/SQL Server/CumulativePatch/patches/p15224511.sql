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
/* Star 15224511 DSM: USD rule					*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO

/* Start of locks for dependent tables */

/* End of lines added to convert to online lock */

/* ************************** 11682 begin  **************/

ALTER  trigger usd_trg_u_ca_dis_hw_tbl_ver
on ca_discovered_hardware
for update as
begin
    if update(primary_network_address) or update(host_uuid)
    begin
        exec usd_proc_u_tbl_ver 0, -1, 1, 40
    end
end
GO

/* ************************** 11682 end **************/

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15224511, getdate(), 1, 4, 'Star 15224511 DSM: USD rule' )
GO

COMMIT TRANSACTION 
GO



