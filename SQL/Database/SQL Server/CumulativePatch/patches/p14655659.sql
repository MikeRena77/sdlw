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
/* Patch Star 14655659 Autosys: Modify ujo_asext_config table                           */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

if exists (select * from sysobjects where name = 'ujo_asext_config' and type = 'U')
begin
	drop table ujo_asext_config
end
go
CREATE TABLE ujo_asext_config (
       asext_AUTOSERV     varchar(64) COLLATE !!sensitive NOT NULL,       
       asext_instance_type char(1) COLLATE !!sensitive NOT NULL,
       asext_db_type      char(1) COLLATE !!sensitive NULL,
       asext_nod_name     varchar(256) COLLATE !!sensitive NOT NULL,
       asext_app_name     varchar(20) COLLATE !!sensitive NULL
)
go

CREATE UNIQUE CLUSTERED INDEX asext_PUC ON ujo_asext_config(asext_AUTOSERV ASC, asext_nod_name ASC)
go

grant delete on ujo_asext_config to ujoadmin
GO
grant insert on ujo_asext_config to ujoadmin
GO
grant select on ujo_asext_config to ujoadmin
GO
grant update on ujo_asext_config to ujoadmin
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14655659, getdate(), 1, 4, 'Patch Star 14655659 Modify ujo_asext_config table' )
GO

COMMIT TRANSACTION 
GO
