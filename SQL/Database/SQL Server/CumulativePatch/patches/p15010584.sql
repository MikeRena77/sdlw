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
/* Star 15010584 : DSM: Class & Hierarchy Content						*/	
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO

Select top 1 1 from ca_class_hierarchy with (tablockx)
GO

Select top 1 1 from ca_class_def with (tablockx)
GO
 
/* Start of locks for dependent tables */

Select top 1 1 from ca_dscv_class_combo_rules with (tablockx)
GO
 
Select top 1 1 from ca_dscv_class_relationships with (tablockx)
GO
 
Select top 1 1 from ca_dscv_class_rules with (tablockx)
GO
 
Select top 1 1 from ca_link_logical_asset_class_def with (tablockx)
GO
 
Select top 1 1 from ca_requirement_spec_item with (tablockx)
GO
 
Select top 1 1 from ca_software_def with (tablockx)
GO
 
Select top 1 1 from ca_software_def_class_def_matrix with (tablockx)
GO
 
Select top 1 1 from ca_hierarchy with (tablockx)
GO
 
Select top 1 1 from ca_asset_class with (tablockx)
GO
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */


CREATE TABLE #ca_class_def
(
class_id integer not null, 
class_name nvarchar(100) COLLATE !!sensitive, 
class_description nvarchar(255) COLLATE !!sensitive
);
go

CREATE TABLE #ca_class_hierarchy
(
parent_class_id integer not null, 
child_class_id integer not null, 
hierarchy_id integer not null, 
level integer, 
hierarchy_path nvarchar(100) COLLATE !!sensitive
);
go

INSERT INTO #ca_class_def(class_id, class_name, class_description) 
VALUES(27, 'Windows XP Professional x64 Edition', '');
go

insert into #ca_class_def (class_id,class_name,class_description)
values (297,'Windows Vista', '');
go

insert into #ca_class_def (class_id,class_name,class_description) 
values (298, 'Windows Vista Business', '');
go

insert into #ca_class_def (class_id,class_name,class_description) 
values (299, 'Windows Vista Enterprise', '');
go

insert into #ca_class_def (class_id,class_name,class_description) 
values (300, 'Windows Vista Home Premium', '');
go

insert into #ca_class_def (class_id,class_name,class_description) 
values (301, 'Windows Vista Home Basic', '');
go

insert into #ca_class_def (class_id,class_name,class_description) 
values (302, 'Windows Vista Ultimate', '');
go

insert into #ca_class_def (class_id,class_name,class_description) 
values (5068, 'Windows Vista Editions','');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (1,297,2,2,'1.0.2.297');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (1,298,297,3,'1.0.2.297.298');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path)
values (1,299,297,3,'1.0.2.297.299');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (1,300,297,3,'1.0.2.297.300');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (1,301,297,3,'1.0.2.297.301');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (1,302,297,3,'1.0.2.297.302');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (5,5068,5024,7,'5.0.5001.2.5004.5010.5017.5024.5068');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (5,298,5068,8,'5.0.5001.2.5004.5010.5017.5024.5068.298');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (5,299,5068,8,'5.0.5001.2.5004.5010.5017.5024.5068.299');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (5,300,5068,8,'5.0.5001.2.5004.5010.5017.5024.5068.300');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (5,301,5068,8,'5.0.5001.2.5004.5010.5017.5024.5068.301');
go

insert into #ca_class_hierarchy(hierarchy_id,child_class_id,parent_class_id,level,hierarchy_path) 
values (5,302,5068,8,'5.0.5001.2.5004.5010.5017.5024.5068.302');
go

INSERT INTO ca_class_def (class_id, class_name, class_description) 
SELECT t.class_id, t.class_name, t.class_description FROM #ca_class_def t 
WHERE t.class_id NOT IN ( SELECT class_id FROM ca_class_def ) ;
go

UPDATE ca_class_def
   SET class_name = t.class_name, 
       class_description = t.class_description
FROM #ca_class_def t
WHERE ca_class_def.class_id = t.class_id;
go

INSERT INTO ca_class_hierarchy (parent_class_id, child_class_id, hierarchy_id, level, hierarchy_path) 
SELECT t.parent_class_id, t.child_class_id, t.hierarchy_id, t.level, t.hierarchy_path FROM #ca_class_hierarchy t 
WHERE convert(char,t.child_class_id)+':'+convert(char,t.hierarchy_id) NOT IN ( SELECT convert(char,child_class_id)+':'+convert(char,hierarchy_id) FROM ca_class_hierarchy ) ;
go

UPDATE ca_class_hierarchy
   SET parent_class_id = t.parent_class_id, 
       level = t.level, 
       hierarchy_path = t.hierarchy_path
FROM #ca_class_hierarchy t
WHERE ca_class_hierarchy.child_class_id = t.child_class_id AND ca_class_hierarchy.hierarchy_id = t.hierarchy_id;
go

DROP TABLE #ca_class_def;
go
DROP TABLE #ca_class_hierarchy;
go



/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15010584, getdate(), 1, 4, 'Star 15010584 : DSM: Class & Hierarchy Content' )
GO

COMMIT TRANSACTION 
GO

