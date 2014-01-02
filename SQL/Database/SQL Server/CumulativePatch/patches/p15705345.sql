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
/* Star  15705345 NEW TABLE FOR CA WORKFLOW 1.0		*/ 
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from instances with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

ALTER TABLE instances ADD snapshotid nvarchar(20) NULL
GO

CREATE TABLE process_snapshots (
	id nvarchar(20) NOT NULL,
	process image NULL,
	timestamp bigint NOT NULL,
	definitionid nvarchar(20) NOT NULL,
	versionid nvarchar(20) NOT NULL,
	productid binary(16) NOT NULL
)
GO

ALTER TABLE process_snapshots
       ADD PRIMARY KEY NONCLUSTERED (productid ASC, id ASC)
GO

CREATE INDEX process_snapshots_ind1 ON process_snapshots
(
       productid ASC,
       id ASC
)
GO

CREATE INDEX process_snapshots_ind2 ON process_snapshots
(
       productid ASC,
       definitionid ASC,
       versionid ASC,
       timestamp ASC
)
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15705345, getdate(), 1, 4, 'Star 15705345 NEW TABLE FOR CA WORKFLOW 1.0' )
GO

COMMIT TRANSACTION 
GO
