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
 
 
Select top 1 1 from ca_install_package with (tablockx)
GO
 
Select top 1 1 from upm_baseline_sw with (tablockx)
GO
 
Select top 1 1 from upm_deployment with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
/* End of lines added to convert to online lock */


/* ca_install_package.pmode -- NEW COLUMN & INDEX */
alter table ca_install_package
    add pmode tinyint not null default 0;
go
create index xie5ca_install_package 
    on ca_install_package (pmode)
    on [PRIMARY];
go

/* upm_baseline_sw.pmode -- NEW COLUMN & INDEX */
alter table upm_baseline_sw
    add pmode tinyint not null default 0;
go
create index xie3upm_baseline_sw 
    on upm_baseline_sw (pmode)
    on [PRIMARY];
go


/* ca_install_package.distribution_uuid -- NEW COLUMN */
alter table ca_install_package
    add distribution_uuid binary(16) null;
go

/* upm_baseline_sw.properties -- NEW COLUMN */
alter table upm_baseline_sw
    add properties ntext;
go

/* upm_baseline_sw.name -- widen column for sev. 1 issue */
alter table upm_baseline_sw
    alter column name nvarchar(450);
go

/* upm_baseline_sw.status -- new index for queries that retrieve by status */
create index xie1upm_baseline_sw 
    on upm_baseline_sw (status)
    on [PRIMARY];
go

create index xie2upm_baseline_sw
    on upm_baseline_sw (name)
    on [PRIMARY];
go

alter table upm_deployment
    add properties ntext;
go

alter table upm_deployment
    add name nvarchar(450);
go

create index xie2upm_deployment ON upm_deployment ( name asc ) on [primary];
go





/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15592233, getdate(), 1, 4, 'Patch Star 15592233 UPDATES FOR UPM R11.2' )
GO

COMMIT TRANSACTION 
GO

