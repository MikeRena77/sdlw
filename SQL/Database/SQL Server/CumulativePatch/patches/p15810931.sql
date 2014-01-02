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
/* Star 15810931 BSO Process Manager: BAM component changes				*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from kpi_control with (tablockx)
GO

Select top 1 1 from kpi_data with (tablockx)
GO

Select top 1 1 from kpi_exception_ack with (tablockx)
GO

Select top 1 1 from kpi_exceptions with (tablockx)
GO

Select top 1 1 from kpi_infer_summary_docs with (tablockx)
GO

Select top 1 1 from kpi_names with (tablockx)
GO

Select top 1 1 from kpi_personalization with (tablockx)
GO

Select top 1 1 from kpi_process_stats with (tablockx)
GO

Select top 1 1 from kpi_properties with (tablockx)
GO

Select top 1 1 from kpi_targets with (tablockx)
GO

Select top 1 1 from kpi_titles with (tablockx)
GO

Select top 1 1 from kpi_types with (tablockx)
GO

Select top 1 1 from kpi_values with (tablockx)
GO

Select top 1 1 from stats with (tablockx)
GO

Select top 1 1 from userlist_worklist with (tablockx)
GO

Select top 1 1 from productidview with (tablockx)
GO

Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */


drop table [dbo].[kpi_control]
GO
drop table [dbo].[kpi_data]
GO
drop table [dbo].[kpi_exception_ack]
GO
drop table [dbo].[kpi_exceptions]
GO
drop table [dbo].[kpi_infer_summary_docs]
GO
drop table [dbo].[kpi_names]
GO
drop table [dbo].[kpi_personalization]
GO
drop table [dbo].[kpi_process_stats]
GO
drop table [dbo].[kpi_properties]
Go
drop table [dbo].[kpi_targets]
Go
drop table [dbo].[kpi_titles]
Go
drop table [dbo].[kpi_types]
GO
drop table [dbo].[kpi_values]
GO


create table [dbo].[kpi_control]( kpi_id integer not null, datetime datetime not null, sample_size integer not null, sample_average float not null, sample_range integer not null,	sample_values_template nvarchar(255) COLLATE !!sensitive not null,	dimension_2 nvarchar(255) COLLATE !!sensitive not null,	dimension_3_template nvarchar(255) COLLATE !!sensitive not null,	sample_values nvarchar(255) COLLATE !!sensitive not null, dimension_3 nvarchar(255) COLLATE !!sensitive not null)
GO

create table [dbo].[kpi_data]( kpi_data_uuid binary(17) not null, kpi_id integer not null, datetime datetime not null, chart_element_label nvarchar(255) COLLATE !!sensitive not null, dimension_1 float not null,	dimension_2 nvarchar(255) COLLATE !!sensitive NULL,	dimension_3 nvarchar(255) COLLATE !!sensitive NULL,	dimension_3_template nvarchar(255) COLLATE !!sensitive NULL,	child_kpi_id integer NULL, parent_id integer NULL)
GO

create table [dbo].[kpi_exception_ack]( portal_user nvarchar(255) COLLATE !!sensitive,	ack_date datetime not null, kpi_exception_id binary(17) not null)
GO

create table [dbo].[kpi_exceptions]( kpi_exception_id binary(17),	kpi_id integer not null, datetime datetime not null, exception_name_template nvarchar(255) COLLATE !!sensitive not null,	description_template nvarchar(255) COLLATE !!sensitive,	status_symbol nvarchar(50) COLLATE !!sensitive,	startdate nvarchar(32) COLLATE !!sensitive NULL,	enddate nvarchar(32) COLLATE !!sensitive NULL, exception_name nvarchar(255) COLLATE !!sensitive NULL,	description nvarchar(255) COLLATE !!sensitive NULL)
GO

create table [dbo].[kpi_infer_summary_docs]( raw_key binary(17) not null, in_process char(1) not null, log_date datetime not null, msg text COLLATE !!sensitive)
GO

create table [dbo].[kpi_names](	kpi_names_key binary(17) not null,	name nvarchar(255) COLLATE !!sensitive not null, type nvarchar(64) COLLATE !!sensitive NULL)
GO

create table [dbo].[kpi_personalization](	kpi_id integer not null, username nvarchar(255) COLLATE !!sensitive not null,	startdate nvarchar(32) COLLATE !!sensitive NULL,	enddate nvarchar(32) COLLATE !!sensitive NULL,	dimension_2 nvarchar(255) COLLATE !!sensitive NULL,	dimension_3 nvarchar(255) COLLATE !!sensitive NULL,	limit integer NULL,	sort_order integer NULL,is_custom integer NULL)
GO

create table [dbo].[kpi_process_stats](	kpi_process_stats_key binary(17) not null,	log_date datetime not null, doc_class_key binary(17) not null,	doc_type_key binary(17) not null,	doc_name_key binary(17) not null,	doc_rulebase_dt datetime not null,	sess_id nvarchar(64) COLLATE !!sensitive NULL,	asset_id nvarchar(64) COLLATE !!sensitive NULL,	doc_timestamp datetime not null,	msg_name_key binary(17) not null,	msg_value_key binary(17) not null, p1_name_key binary(17) NULL,	p1_value_key binary(17) NULL,	p2_name_key binary(17) NULL,	p2_value_key binary(17) NULL,	p3_name_key binary(17) NULL,	p3_value_key binary(17) NULL,	p4_name_key binary(17) NULL,	p4_value_key binary(17) NULL,	p5_name_key binary(17) NULL,	p5_value_key binary(17) NULL,	p6_name_key binary(17) NULL,	p6_value_key binary(17) NULL,	p7_name_key binary(17) NULL,	p7_value_key binary(17) NULL,	p8_name_key binary(17) NULL,	p8_value_key binary(17) NULL,	p9_name_key binary(17) NULL,	p9_value_key binary(17) NULL,	p10_name_key binary(17) NULL,	p10_value_key binary(17) NULL)
GO

create table [dbo].[kpi_properties]( name nvarchar(128) COLLATE !!sensitive not null,	value nvarchar(255) COLLATE !!sensitive not null)
GO

create table [dbo].[kpi_targets](	kpi_id integer not null, lower_warn float, upper_warn float, lower_alarm float,	upper_alarm float,	duration float)
GO

create table [dbo].[kpi_titles]( chart_title_id integer not null, title nvarchar(255) COLLATE !!sensitive not null, visible integer,	kpi_id integer)
GO

create table [dbo].[kpi_types](	kpi_id integer not null, kpi_name nvarchar(255) COLLATE !!sensitive not null,	agg_type nvarchar(50) COLLATE !!sensitive, help_text nvarchar(2000) COLLATE !!sensitive, title_1 nvarchar(50) COLLATE !!sensitive,	title_2 nvarchar(50) COLLATE !!sensitive,	label_1 nvarchar(50) COLLATE !!sensitive,	label_2 nvarchar(50) COLLATE !!sensitive,	dimension_2_label nvarchar(50) COLLATE !!sensitive,	dimension_3_label nvarchar(50) COLLATE !!sensitive,	time_trending integer,	refresh_interval integer,	aggregation_period integer,	agg_last_ran datetime,	detail_url nvarchar(255) COLLATE !!sensitive)
GO

create table [dbo].[kpi_values]( kpi_values_key binary(17) not null, value nvarchar(255) COLLATE !!sensitive not null)
GO

alter table kpi_data with nocheck add constraint XPKkpi_data primary key clustered ( kpi_data_uuid ) on [PRIMARY]
GO

create index XPKkpi_exception_ack on kpi_exception_ack ( kpi_exception_id ) on [PRIMARY]
GO

create index XPKkpi_exceptions on kpi_exceptions ( kpi_exception_id ) on [PRIMARY]
GO

alter table kpi_infer_summary_docs  with nocheck add constraint XPKkpi_infer_summary_docs primary key clustered ( raw_key ) on [PRIMARY]
GO

alter table kpi_names  with nocheck add constraint XPKkpi_names primary key clustered ( kpi_names_key ) on [PRIMARY]
GO

alter table kpi_personalization  with nocheck add constraint XPKkpi_personalization primary key clustered ( kpi_id, username ) on [PRIMARY]
GO

alter table kpi_process_stats  with nocheck add constraint XPKkpi_process_stats primary key clustered ( kpi_process_stats_key ) on [PRIMARY]
GO

alter table kpi_properties  with nocheck add constraint XPKkpi_properties primary key clustered ( name ) on [PRIMARY]
GO

alter table kpi_targets  with nocheck add constraint XPKkpi_targets primary key clustered ( kpi_id ) on [PRIMARY]
GO

alter table kpi_titles  with nocheck add constraint XPKkpi_titles primary key clustered ( chart_title_id ) on [PRIMARY]
GO

alter table kpi_types  with nocheck add constraint XPKkpi_types primary key clustered ( kpi_id ) on [PRIMARY]
GO

alter table kpi_values  with nocheck add constraint XPKkpi_values primary key clustered ( kpi_values_key ) on [PRIMARY]
GO

create index kpi_control_idx1 on kpi_control (kpi_id, datetime, dimension_2) on [PRIMARY]
GO

create index kpi_data_idx1 on kpi_data ( kpi_id, datetime, dimension_2 ) on [PRIMARY]
GO

create index kpi_data_idx2 on kpi_data ( kpi_id, datetime, chart_element_label, dimension_1 ) on [PRIMARY]
GO

create index kpi_exception_ack_idx1 on kpi_exception_ack (kpi_exception_id, portal_user ) on [PRIMARY]	
GO

create index kpi_exceptions_idx1 on kpi_exceptions (kpi_id, datetime, exception_name_template ) on [PRIMARY]
GO

create index kpi_infer_summary_docs_idx1 on kpi_infer_summary_docs (log_date, raw_key ) on [PRIMARY]
GO

create index kpi_names_idx1 on kpi_names (name ) on [PRIMARY]
GO

create index kpi_process_stats_idx1 on kpi_process_stats (log_date, msg_name_key ) on [PRIMARY]
GO

create index kpi_values_idx1 on kpi_values (value ) on [PRIMARY]
GO

grant select on kpi_control to aionadmin_group;
GO

grant insert on kpi_control to aionadmin_group;
GO

grant delete on kpi_control to aionadmin_group;
GO

grant update on kpi_control to aionadmin_group;
GO

grant delete on kpi_data to aionadmin_group;
GO

grant insert on kpi_data to aionadmin_group;
GO

grant select on kpi_data to aionadmin_group;
GO

grant update on kpi_data to aionadmin_group;
GO

grant insert on kpi_exception_ack to aionadmin_group;
GO

grant delete on kpi_exception_ack to aionadmin_group;
GO

grant update on kpi_exception_ack to aionadmin_group;
GO

grant select on kpi_exception_ack to aionadmin_group;
GO

grant update on kpi_exceptions to aionadmin_group;
GO

grant insert on kpi_exceptions to aionadmin_group;
GO

grant select on kpi_exceptions to aionadmin_group;
GO

grant delete on kpi_exceptions to aionadmin_group;
GO

grant update on kpi_infer_summary_docs to aionadmin_group;
GO

grant select on kpi_infer_summary_docs to aionadmin_group;
GO

grant insert on kpi_infer_summary_docs to aionadmin_group;
GO

grant delete on kpi_infer_summary_docs to aionadmin_group;
GO

grant delete on kpi_names to aionadmin_group;
GO

grant select on kpi_names to aionadmin_group;
GO

grant insert on kpi_names to aionadmin_group;
GO

grant update on kpi_names to aionadmin_group;
GO

grant delete on kpi_personalization to aionadmin_group;
GO

grant select on kpi_personalization to aionadmin_group;
GO

grant insert on kpi_personalization to aionadmin_group;
GO

grant update on kpi_personalization to aionadmin_group;
GO

grant delete on kpi_process_stats to aionadmin_group;
GO

grant select on kpi_process_stats to aionadmin_group;
GO

grant insert on kpi_process_stats to aionadmin_group;
GO

grant update on kpi_process_stats to aionadmin_group;
GO

grant insert on kpi_properties to aionadmin_group;
GO

grant delete on kpi_properties to aionadmin_group;
GO

grant select on kpi_properties to aionadmin_group;
GO

grant update on kpi_properties to aionadmin_group;
GO

grant select on kpi_targets to aionadmin_group;
GO

grant delete on kpi_targets to aionadmin_group;
GO

grant insert on kpi_targets to aionadmin_group;
GO

grant update on kpi_targets to aionadmin_group;
GO

grant update on kpi_titles to aionadmin_group;
GO

grant select on kpi_titles to aionadmin_group;
GO

grant insert on kpi_titles to aionadmin_group;
GO

grant delete on kpi_titles to aionadmin_group;
GO

grant update on kpi_types to aionadmin_group;
GO

grant select on kpi_types to aionadmin_group;
GO

grant insert on kpi_types to aionadmin_group;
GO

grant delete on kpi_types to aionadmin_group;
GO

grant select on kpi_values to aionadmin_group;
GO

grant insert on kpi_values to aionadmin_group;
GO

grant delete on kpi_values to aionadmin_group;
GO

grant update on kpi_values to aionadmin_group;
GO

drop view ActivitiesAvgOverdueView;
GO
drop view activitieslatecompview;
GO
drop view activitieslateincompview;
GO
drop view activitiestimetoduedate;
GO
drop view actorbottleneckview;
GO
drop view actorthroughputview;
GO


create view  ActivitiesLateCompView  as SELECT     stats.workitemid AS item_id, stats.PROCESSID AS instance_id, stats.NODENAME AS activity, (stats.completed - stats.duedate) / 1000 AS time_late, stats.PROCESSNAME AS process_name, NODEDESC AS activity_description, userlist_worklist.username AS actor
FROM stats, userlist_worklist, productidview
WHERE     (stats.workitemid = userlist_worklist.workitemid) AND (stats.completed > stats.duedate) AND (stats.duedate > 0) AND (stats.productid = productidview.productid)
GO

create view  ActivitiesLateIncompView  as SELECT stats.workitemid AS item_id, stats.PROCESSID AS instance_id, stats.NODENAME AS activity, stats.duedate / 1000 AS time_late, stats.PROCESSNAME AS process_name, NODEDESC AS activity_description, userlist_worklist.username AS actor
FROM stats, userlist_worklist, productidview 
WHERE (stats.workitemid = userlist_worklist.workitemid) AND ((stats.completed is null) OR (stats.completed = 0)) AND (stats.DUEDATE > 0) AND (stats.productid = productidview.productid)
GO

create view  ActivitiesAvgOverdueView  as SELECT     activity, AVG(time_late) AS late_avg, process_name
FROM ActivitiesLateCompView
GROUP BY activity, process_name
GO

create view  ActivitiesTimeToDueDate  as SELECT     stats.workitemid AS item_id, stats.PROCESSID AS instance_id, stats.NODENAME AS activity, stats.DUEDATE / 1000 AS time_to_due_date, stats.PROCESSNAME AS process_name, NODEDESC AS activity_description, userlist_worklist.username AS actor
FROM stats, userlist_worklist, productidview
WHERE     (stats.workitemid = userlist_worklist.workitemid) AND ((stats.completed is null) OR (stats.completed = 0)) AND (stats.DUEDATE > 0) AND (stats.productid = productidview.productid)
GO

create view  ActorBottleneckView  as SELECT     userlist_worklist.username AS actor, stats.NODENAME AS activity_name, AVG((stats.completed - stats.duedate) / 1000) AS avg_time_late, NODEDESC AS activity_description, stats.PROCESSNAME AS process_name, stats.PROCESSID AS instance_id
FROM stats, userlist_worklist, productidview
WHERE     (stats.workitemid = userlist_worklist.workitemid) AND (stats.completed > stats.duedate) AND (stats.duedate > 0) AND (stats.productid = productidview.productid)
GROUP BY userlist_worklist.username, stats.NODENAME, NODEDESC, stats.PROCESSNAME, stats.PROCESSID
GO

create view  ActorThroughputView  as SELECT     userlist_worklist.username AS actor, stats.NODENAME AS activity_name, AVG((stats.completed - stats.started) / 1000) AS time_completed, NODEDESC AS activity_description, stats.PROCESSNAME AS process_name, stats.PROCESSID AS instance_id
FROM stats, userlist_worklist, productidview
WHERE     (stats.workitemid = userlist_worklist.workitemid) AND (stats.completed < stats.duedate) AND (stats.duedate > 0) AND (stats.completed is not null) AND (stats.completed > 0) AND (stats.productid = productidview.productid)
GROUP BY userlist_worklist.username, stats.NODENAME, NODEDESC, stats.PROCESSNAME, stats.PROCESSID
GO

create table top_n_ids (id int not null);
GO

insert into top_n_ids (id) values (1);
insert into top_n_ids (id) values (2);
insert into top_n_ids (id) values (3);
insert into top_n_ids (id) values (4);
insert into top_n_ids (id) values (5);
insert into top_n_ids (id) values (6);
insert into top_n_ids (id) values (7);
insert into top_n_ids (id) values (8);
insert into top_n_ids (id) values (9);
insert into top_n_ids (id) values (10);
insert into top_n_ids (id) values (11);
insert into top_n_ids (id) values (12);
insert into top_n_ids (id) values (13);
insert into top_n_ids (id) values (14);
insert into top_n_ids (id) values (15);
insert into top_n_ids (id) values (16);
insert into top_n_ids (id) values (17);
insert into top_n_ids (id) values (18);
insert into top_n_ids (id) values (19);
insert into top_n_ids (id) values (20);
insert into top_n_ids (id) values (21);
insert into top_n_ids (id) values (22);
insert into top_n_ids (id) values (23);
insert into top_n_ids (id) values (24);
insert into top_n_ids (id) values (25);
insert into top_n_ids (id) values (26);
insert into top_n_ids (id) values (27);
insert into top_n_ids (id) values (28);
insert into top_n_ids (id) values (29);
insert into top_n_ids (id) values (30);
insert into top_n_ids (id) values (31);
insert into top_n_ids (id) values (32);
insert into top_n_ids (id) values (33);
insert into top_n_ids (id) values (34);
insert into top_n_ids (id) values (35);
insert into top_n_ids (id) values (36);
insert into top_n_ids (id) values (37);
insert into top_n_ids (id) values (38);
insert into top_n_ids (id) values (39);
insert into top_n_ids (id) values (40);
insert into top_n_ids (id) values (41);
insert into top_n_ids (id) values (42);
insert into top_n_ids (id) values (43);
insert into top_n_ids (id) values (44);
insert into top_n_ids (id) values (45);
insert into top_n_ids (id) values (46);
insert into top_n_ids (id) values (47);
insert into top_n_ids (id) values (48);
insert into top_n_ids (id) values (49);
insert into top_n_ids (id) values (50);
insert into top_n_ids (id) values (51);
insert into top_n_ids (id) values (52);
insert into top_n_ids (id) values (53);
insert into top_n_ids (id) values (54);
insert into top_n_ids (id) values (55);
insert into top_n_ids (id) values (56);
insert into top_n_ids (id) values (57);
insert into top_n_ids (id) values (58);
insert into top_n_ids (id) values (59);
insert into top_n_ids (id) values (60);
insert into top_n_ids (id) values (61);
insert into top_n_ids (id) values (62);
insert into top_n_ids (id) values (63);
insert into top_n_ids (id) values (64);
insert into top_n_ids (id) values (65);
insert into top_n_ids (id) values (66);
insert into top_n_ids (id) values (67);
insert into top_n_ids (id) values (68);
insert into top_n_ids (id) values (69);
insert into top_n_ids (id) values (70);
insert into top_n_ids (id) values (71);
insert into top_n_ids (id) values (72);
insert into top_n_ids (id) values (73);
insert into top_n_ids (id) values (74);
insert into top_n_ids (id) values (75);
insert into top_n_ids (id) values (76);
insert into top_n_ids (id) values (77);
insert into top_n_ids (id) values (78);
insert into top_n_ids (id) values (79);
insert into top_n_ids (id) values (80);
insert into top_n_ids (id) values (81);
insert into top_n_ids (id) values (82);
insert into top_n_ids (id) values (83);
insert into top_n_ids (id) values (84);
insert into top_n_ids (id) values (85);
insert into top_n_ids (id) values (86);
insert into top_n_ids (id) values (87);
insert into top_n_ids (id) values (88);
insert into top_n_ids (id) values (89);
insert into top_n_ids (id) values (90);
insert into top_n_ids (id) values (91);
insert into top_n_ids (id) values (92);
insert into top_n_ids (id) values (93);
insert into top_n_ids (id) values (94);
insert into top_n_ids (id) values (95);
insert into top_n_ids (id) values (96);
insert into top_n_ids (id) values (97);
insert into top_n_ids (id) values (98);
insert into top_n_ids (id) values (99);
insert into top_n_ids (id) values (100);
insert into top_n_ids (id) values (101);
insert into top_n_ids (id) values (102);
insert into top_n_ids (id) values (103);
insert into top_n_ids (id) values (104);
insert into top_n_ids (id) values (105);
insert into top_n_ids (id) values (106);
insert into top_n_ids (id) values (107);
insert into top_n_ids (id) values (108);
insert into top_n_ids (id) values (109);
insert into top_n_ids (id) values (110);
insert into top_n_ids (id) values (111);
insert into top_n_ids (id) values (112);
insert into top_n_ids (id) values (113);
insert into top_n_ids (id) values (114);
insert into top_n_ids (id) values (115);
insert into top_n_ids (id) values (116);
insert into top_n_ids (id) values (117);
insert into top_n_ids (id) values (118);
insert into top_n_ids (id) values (119);
insert into top_n_ids (id) values (120);
insert into top_n_ids (id) values (121);
insert into top_n_ids (id) values (122);
insert into top_n_ids (id) values (123);
insert into top_n_ids (id) values (124);
insert into top_n_ids (id) values (125);
insert into top_n_ids (id) values (126);
insert into top_n_ids (id) values (127);
insert into top_n_ids (id) values (128);
insert into top_n_ids (id) values (129);
insert into top_n_ids (id) values (130);
insert into top_n_ids (id) values (131);
insert into top_n_ids (id) values (132);
insert into top_n_ids (id) values (133);
insert into top_n_ids (id) values (134);
insert into top_n_ids (id) values (135);
insert into top_n_ids (id) values (136);
insert into top_n_ids (id) values (137);
insert into top_n_ids (id) values (138);
insert into top_n_ids (id) values (139);
insert into top_n_ids (id) values (140);
insert into top_n_ids (id) values (141);
insert into top_n_ids (id) values (142);
insert into top_n_ids (id) values (143);
insert into top_n_ids (id) values (144);
insert into top_n_ids (id) values (145);
insert into top_n_ids (id) values (146);
insert into top_n_ids (id) values (147);
insert into top_n_ids (id) values (148);
insert into top_n_ids (id) values (149);
insert into top_n_ids (id) values (150);
insert into top_n_ids (id) values (151);
insert into top_n_ids (id) values (152);
insert into top_n_ids (id) values (153);
insert into top_n_ids (id) values (154);
insert into top_n_ids (id) values (155);
insert into top_n_ids (id) values (156);
insert into top_n_ids (id) values (157);
insert into top_n_ids (id) values (158);
insert into top_n_ids (id) values (159);
insert into top_n_ids (id) values (160);
insert into top_n_ids (id) values (161);
insert into top_n_ids (id) values (162);
insert into top_n_ids (id) values (163);
insert into top_n_ids (id) values (164);
insert into top_n_ids (id) values (165);
insert into top_n_ids (id) values (166);
insert into top_n_ids (id) values (167);
insert into top_n_ids (id) values (168);
insert into top_n_ids (id) values (169);
insert into top_n_ids (id) values (170);
insert into top_n_ids (id) values (171);
insert into top_n_ids (id) values (172);
insert into top_n_ids (id) values (173);
insert into top_n_ids (id) values (174);
insert into top_n_ids (id) values (175);
insert into top_n_ids (id) values (176);
insert into top_n_ids (id) values (177);
insert into top_n_ids (id) values (178);
insert into top_n_ids (id) values (179);
insert into top_n_ids (id) values (180);
insert into top_n_ids (id) values (181);
insert into top_n_ids (id) values (182);
insert into top_n_ids (id) values (183);
insert into top_n_ids (id) values (184);
insert into top_n_ids (id) values (185);
insert into top_n_ids (id) values (186);
insert into top_n_ids (id) values (187);
insert into top_n_ids (id) values (188);
insert into top_n_ids (id) values (189);
insert into top_n_ids (id) values (190);
insert into top_n_ids (id) values (191);
insert into top_n_ids (id) values (192);
insert into top_n_ids (id) values (193);
insert into top_n_ids (id) values (194);
insert into top_n_ids (id) values (195);
insert into top_n_ids (id) values (196);
insert into top_n_ids (id) values (197);
insert into top_n_ids (id) values (198);
insert into top_n_ids (id) values (199);
insert into top_n_ids (id) values (200);
insert into top_n_ids (id) values (201);
insert into top_n_ids (id) values (202);
insert into top_n_ids (id) values (203);
insert into top_n_ids (id) values (204);
insert into top_n_ids (id) values (205);
insert into top_n_ids (id) values (206);
insert into top_n_ids (id) values (207);
insert into top_n_ids (id) values (208);
insert into top_n_ids (id) values (209);
insert into top_n_ids (id) values (210);
insert into top_n_ids (id) values (211);
insert into top_n_ids (id) values (212);
insert into top_n_ids (id) values (213);
insert into top_n_ids (id) values (214);
insert into top_n_ids (id) values (215);
insert into top_n_ids (id) values (216);
insert into top_n_ids (id) values (217);
insert into top_n_ids (id) values (218);
insert into top_n_ids (id) values (219);
insert into top_n_ids (id) values (220);
insert into top_n_ids (id) values (221);
insert into top_n_ids (id) values (222);
insert into top_n_ids (id) values (223);
insert into top_n_ids (id) values (224);
insert into top_n_ids (id) values (225);
insert into top_n_ids (id) values (226);
insert into top_n_ids (id) values (227);
insert into top_n_ids (id) values (228);
insert into top_n_ids (id) values (229);
insert into top_n_ids (id) values (230);
insert into top_n_ids (id) values (231);
insert into top_n_ids (id) values (232);
insert into top_n_ids (id) values (233);
insert into top_n_ids (id) values (234);
insert into top_n_ids (id) values (235);
insert into top_n_ids (id) values (236);
insert into top_n_ids (id) values (237);
insert into top_n_ids (id) values (238);
insert into top_n_ids (id) values (239);
insert into top_n_ids (id) values (240);
insert into top_n_ids (id) values (241);
insert into top_n_ids (id) values (242);
insert into top_n_ids (id) values (243);
insert into top_n_ids (id) values (244);
insert into top_n_ids (id) values (245);
insert into top_n_ids (id) values (246);
insert into top_n_ids (id) values (247);
insert into top_n_ids (id) values (248);
insert into top_n_ids (id) values (249);
insert into top_n_ids (id) values (250);
insert into top_n_ids (id) values (251);
insert into top_n_ids (id) values (252);
insert into top_n_ids (id) values (253);
insert into top_n_ids (id) values (254);
insert into top_n_ids (id) values (255);
insert into top_n_ids (id) values (256);
insert into top_n_ids (id) values (257);
insert into top_n_ids (id) values (258);
insert into top_n_ids (id) values (259);
insert into top_n_ids (id) values (260);
insert into top_n_ids (id) values (261);
insert into top_n_ids (id) values (262);
insert into top_n_ids (id) values (263);
insert into top_n_ids (id) values (264);
insert into top_n_ids (id) values (265);
insert into top_n_ids (id) values (266);
insert into top_n_ids (id) values (267);
insert into top_n_ids (id) values (268);
insert into top_n_ids (id) values (269);
insert into top_n_ids (id) values (270);
insert into top_n_ids (id) values (271);
insert into top_n_ids (id) values (272);
insert into top_n_ids (id) values (273);
insert into top_n_ids (id) values (274);
insert into top_n_ids (id) values (275);
insert into top_n_ids (id) values (276);
insert into top_n_ids (id) values (277);
insert into top_n_ids (id) values (278);
insert into top_n_ids (id) values (279);
insert into top_n_ids (id) values (280);
insert into top_n_ids (id) values (281);
insert into top_n_ids (id) values (282);
insert into top_n_ids (id) values (283);
insert into top_n_ids (id) values (284);
insert into top_n_ids (id) values (285);
insert into top_n_ids (id) values (286);
insert into top_n_ids (id) values (287);
insert into top_n_ids (id) values (288);
insert into top_n_ids (id) values (289);
insert into top_n_ids (id) values (290);
insert into top_n_ids (id) values (291);
insert into top_n_ids (id) values (292);
insert into top_n_ids (id) values (293);
insert into top_n_ids (id) values (294);
insert into top_n_ids (id) values (295);
insert into top_n_ids (id) values (296);
insert into top_n_ids (id) values (297);
insert into top_n_ids (id) values (298);
insert into top_n_ids (id) values (299);
insert into top_n_ids (id) values (300);
insert into top_n_ids (id) values (301);
insert into top_n_ids (id) values (302);
insert into top_n_ids (id) values (303);
insert into top_n_ids (id) values (304);
insert into top_n_ids (id) values (305);
insert into top_n_ids (id) values (306);
insert into top_n_ids (id) values (307);
insert into top_n_ids (id) values (308);
insert into top_n_ids (id) values (309);
insert into top_n_ids (id) values (310);
insert into top_n_ids (id) values (311);
insert into top_n_ids (id) values (312);
insert into top_n_ids (id) values (313);
insert into top_n_ids (id) values (314);
insert into top_n_ids (id) values (315);
insert into top_n_ids (id) values (316);
insert into top_n_ids (id) values (317);
insert into top_n_ids (id) values (318);
insert into top_n_ids (id) values (319);
insert into top_n_ids (id) values (320);
insert into top_n_ids (id) values (321);
insert into top_n_ids (id) values (322);
insert into top_n_ids (id) values (323);
insert into top_n_ids (id) values (324);
insert into top_n_ids (id) values (325);
insert into top_n_ids (id) values (326);
insert into top_n_ids (id) values (327);
insert into top_n_ids (id) values (328);
insert into top_n_ids (id) values (329);
insert into top_n_ids (id) values (330);
insert into top_n_ids (id) values (331);
insert into top_n_ids (id) values (332);
insert into top_n_ids (id) values (333);
insert into top_n_ids (id) values (334);
insert into top_n_ids (id) values (335);
insert into top_n_ids (id) values (336);
insert into top_n_ids (id) values (337);
insert into top_n_ids (id) values (338);
insert into top_n_ids (id) values (339);
insert into top_n_ids (id) values (340);
insert into top_n_ids (id) values (341);
insert into top_n_ids (id) values (342);
insert into top_n_ids (id) values (343);
insert into top_n_ids (id) values (344);
insert into top_n_ids (id) values (345);
insert into top_n_ids (id) values (346);
insert into top_n_ids (id) values (347);
insert into top_n_ids (id) values (348);
insert into top_n_ids (id) values (349);
insert into top_n_ids (id) values (350);
insert into top_n_ids (id) values (351);
insert into top_n_ids (id) values (352);
insert into top_n_ids (id) values (353);
insert into top_n_ids (id) values (354);
insert into top_n_ids (id) values (355);
insert into top_n_ids (id) values (356);
insert into top_n_ids (id) values (357);
insert into top_n_ids (id) values (358);
insert into top_n_ids (id) values (359);
insert into top_n_ids (id) values (360);
insert into top_n_ids (id) values (361);
insert into top_n_ids (id) values (362);
insert into top_n_ids (id) values (363);
insert into top_n_ids (id) values (364);
insert into top_n_ids (id) values (365);
insert into top_n_ids (id) values (366);
insert into top_n_ids (id) values (367);
insert into top_n_ids (id) values (368);
insert into top_n_ids (id) values (369);
insert into top_n_ids (id) values (370);
insert into top_n_ids (id) values (371);
insert into top_n_ids (id) values (372);
insert into top_n_ids (id) values (373);
insert into top_n_ids (id) values (374);
insert into top_n_ids (id) values (375);
insert into top_n_ids (id) values (376);
insert into top_n_ids (id) values (377);
insert into top_n_ids (id) values (378);
insert into top_n_ids (id) values (379);
insert into top_n_ids (id) values (380);
insert into top_n_ids (id) values (381);
insert into top_n_ids (id) values (382);
insert into top_n_ids (id) values (383);
insert into top_n_ids (id) values (384);
insert into top_n_ids (id) values (385);
insert into top_n_ids (id) values (386);
insert into top_n_ids (id) values (387);
insert into top_n_ids (id) values (388);
insert into top_n_ids (id) values (389);
insert into top_n_ids (id) values (390);
insert into top_n_ids (id) values (391);
insert into top_n_ids (id) values (392);
insert into top_n_ids (id) values (393);
insert into top_n_ids (id) values (394);
insert into top_n_ids (id) values (395);
insert into top_n_ids (id) values (396);
insert into top_n_ids (id) values (397);
insert into top_n_ids (id) values (398);
insert into top_n_ids (id) values (399);
insert into top_n_ids (id) values (400);
insert into top_n_ids (id) values (401);
insert into top_n_ids (id) values (402);
insert into top_n_ids (id) values (403);
insert into top_n_ids (id) values (404);
insert into top_n_ids (id) values (405);
insert into top_n_ids (id) values (406);
insert into top_n_ids (id) values (407);
insert into top_n_ids (id) values (408);
insert into top_n_ids (id) values (409);
insert into top_n_ids (id) values (410);
insert into top_n_ids (id) values (411);
insert into top_n_ids (id) values (412);
insert into top_n_ids (id) values (413);
insert into top_n_ids (id) values (414);
insert into top_n_ids (id) values (415);
insert into top_n_ids (id) values (416);
insert into top_n_ids (id) values (417);
insert into top_n_ids (id) values (418);
insert into top_n_ids (id) values (419);
insert into top_n_ids (id) values (420);
insert into top_n_ids (id) values (421);
insert into top_n_ids (id) values (422);
insert into top_n_ids (id) values (423);
insert into top_n_ids (id) values (424);
insert into top_n_ids (id) values (425);
insert into top_n_ids (id) values (426);
insert into top_n_ids (id) values (427);
insert into top_n_ids (id) values (428);
insert into top_n_ids (id) values (429);
insert into top_n_ids (id) values (430);
insert into top_n_ids (id) values (431);
insert into top_n_ids (id) values (432);
insert into top_n_ids (id) values (433);
insert into top_n_ids (id) values (434);
insert into top_n_ids (id) values (435);
insert into top_n_ids (id) values (436);
insert into top_n_ids (id) values (437);
insert into top_n_ids (id) values (438);
insert into top_n_ids (id) values (439);
insert into top_n_ids (id) values (440);
insert into top_n_ids (id) values (441);
insert into top_n_ids (id) values (442);
insert into top_n_ids (id) values (443);
insert into top_n_ids (id) values (444);
insert into top_n_ids (id) values (445);
insert into top_n_ids (id) values (446);
insert into top_n_ids (id) values (447);
insert into top_n_ids (id) values (448);
insert into top_n_ids (id) values (449);
insert into top_n_ids (id) values (450);
insert into top_n_ids (id) values (451);
insert into top_n_ids (id) values (452);
insert into top_n_ids (id) values (453);
insert into top_n_ids (id) values (454);
insert into top_n_ids (id) values (455);
insert into top_n_ids (id) values (456);
insert into top_n_ids (id) values (457);
insert into top_n_ids (id) values (458);
insert into top_n_ids (id) values (459);
insert into top_n_ids (id) values (460);
insert into top_n_ids (id) values (461);
insert into top_n_ids (id) values (462);
insert into top_n_ids (id) values (463);
insert into top_n_ids (id) values (464);
insert into top_n_ids (id) values (465);
insert into top_n_ids (id) values (466);
insert into top_n_ids (id) values (467);
insert into top_n_ids (id) values (468);
insert into top_n_ids (id) values (469);
insert into top_n_ids (id) values (470);
insert into top_n_ids (id) values (471);
insert into top_n_ids (id) values (472);
insert into top_n_ids (id) values (473);
insert into top_n_ids (id) values (474);
insert into top_n_ids (id) values (475);
insert into top_n_ids (id) values (476);
insert into top_n_ids (id) values (477);
insert into top_n_ids (id) values (478);
insert into top_n_ids (id) values (479);
insert into top_n_ids (id) values (480);
insert into top_n_ids (id) values (481);
insert into top_n_ids (id) values (482);
insert into top_n_ids (id) values (483);
insert into top_n_ids (id) values (484);
insert into top_n_ids (id) values (485);
insert into top_n_ids (id) values (486);
insert into top_n_ids (id) values (487);
insert into top_n_ids (id) values (488);
insert into top_n_ids (id) values (489);
insert into top_n_ids (id) values (490);
insert into top_n_ids (id) values (491);
insert into top_n_ids (id) values (492);
insert into top_n_ids (id) values (493);
insert into top_n_ids (id) values (494);
insert into top_n_ids (id) values (495);
insert into top_n_ids (id) values (496);
insert into top_n_ids (id) values (497);
insert into top_n_ids (id) values (498);
insert into top_n_ids (id) values (499);
insert into top_n_ids (id) values (500);
insert into top_n_ids (id) values (501);
insert into top_n_ids (id) values (502);
insert into top_n_ids (id) values (503);
insert into top_n_ids (id) values (504);
insert into top_n_ids (id) values (505);
insert into top_n_ids (id) values (506);
insert into top_n_ids (id) values (507);
insert into top_n_ids (id) values (508);
insert into top_n_ids (id) values (509);
insert into top_n_ids (id) values (510);
insert into top_n_ids (id) values (511);
insert into top_n_ids (id) values (512);
insert into top_n_ids (id) values (513);
insert into top_n_ids (id) values (514);
insert into top_n_ids (id) values (515);
insert into top_n_ids (id) values (516);
insert into top_n_ids (id) values (517);
insert into top_n_ids (id) values (518);
insert into top_n_ids (id) values (519);
insert into top_n_ids (id) values (520);
insert into top_n_ids (id) values (521);
insert into top_n_ids (id) values (522);
insert into top_n_ids (id) values (523);
insert into top_n_ids (id) values (524);
insert into top_n_ids (id) values (525);
insert into top_n_ids (id) values (526);
insert into top_n_ids (id) values (527);
insert into top_n_ids (id) values (528);
insert into top_n_ids (id) values (529);
insert into top_n_ids (id) values (530);
insert into top_n_ids (id) values (531);
insert into top_n_ids (id) values (532);
insert into top_n_ids (id) values (533);
insert into top_n_ids (id) values (534);
insert into top_n_ids (id) values (535);
insert into top_n_ids (id) values (536);
insert into top_n_ids (id) values (537);
insert into top_n_ids (id) values (538);
insert into top_n_ids (id) values (539);
insert into top_n_ids (id) values (540);
insert into top_n_ids (id) values (541);
insert into top_n_ids (id) values (542);
insert into top_n_ids (id) values (543);
insert into top_n_ids (id) values (544);
insert into top_n_ids (id) values (545);
insert into top_n_ids (id) values (546);
insert into top_n_ids (id) values (547);
insert into top_n_ids (id) values (548);
insert into top_n_ids (id) values (549);
insert into top_n_ids (id) values (550);
insert into top_n_ids (id) values (551);
insert into top_n_ids (id) values (552);
insert into top_n_ids (id) values (553);
insert into top_n_ids (id) values (554);
insert into top_n_ids (id) values (555);
insert into top_n_ids (id) values (556);
insert into top_n_ids (id) values (557);
insert into top_n_ids (id) values (558);
insert into top_n_ids (id) values (559);
insert into top_n_ids (id) values (560);
insert into top_n_ids (id) values (561);
insert into top_n_ids (id) values (562);
insert into top_n_ids (id) values (563);
insert into top_n_ids (id) values (564);
insert into top_n_ids (id) values (565);
insert into top_n_ids (id) values (566);
insert into top_n_ids (id) values (567);
insert into top_n_ids (id) values (568);
insert into top_n_ids (id) values (569);
insert into top_n_ids (id) values (570);
insert into top_n_ids (id) values (571);
insert into top_n_ids (id) values (572);
insert into top_n_ids (id) values (573);
insert into top_n_ids (id) values (574);
insert into top_n_ids (id) values (575);
insert into top_n_ids (id) values (576);
insert into top_n_ids (id) values (577);
insert into top_n_ids (id) values (578);
insert into top_n_ids (id) values (579);
insert into top_n_ids (id) values (580);
insert into top_n_ids (id) values (581);
insert into top_n_ids (id) values (582);
insert into top_n_ids (id) values (583);
insert into top_n_ids (id) values (584);
insert into top_n_ids (id) values (585);
insert into top_n_ids (id) values (586);
insert into top_n_ids (id) values (587);
insert into top_n_ids (id) values (588);
insert into top_n_ids (id) values (589);
insert into top_n_ids (id) values (590);
insert into top_n_ids (id) values (591);
insert into top_n_ids (id) values (592);
insert into top_n_ids (id) values (593);
insert into top_n_ids (id) values (594);
insert into top_n_ids (id) values (595);
insert into top_n_ids (id) values (596);
insert into top_n_ids (id) values (597);
insert into top_n_ids (id) values (598);
insert into top_n_ids (id) values (599);
insert into top_n_ids (id) values (600);
insert into top_n_ids (id) values (601);
insert into top_n_ids (id) values (602);
insert into top_n_ids (id) values (603);
insert into top_n_ids (id) values (604);
insert into top_n_ids (id) values (605);
insert into top_n_ids (id) values (606);
insert into top_n_ids (id) values (607);
insert into top_n_ids (id) values (608);
insert into top_n_ids (id) values (609);
insert into top_n_ids (id) values (610);
insert into top_n_ids (id) values (611);
insert into top_n_ids (id) values (612);
insert into top_n_ids (id) values (613);
insert into top_n_ids (id) values (614);
insert into top_n_ids (id) values (615);
insert into top_n_ids (id) values (616);
insert into top_n_ids (id) values (617);
insert into top_n_ids (id) values (618);
insert into top_n_ids (id) values (619);
insert into top_n_ids (id) values (620);
insert into top_n_ids (id) values (621);
insert into top_n_ids (id) values (622);
insert into top_n_ids (id) values (623);
insert into top_n_ids (id) values (624);
insert into top_n_ids (id) values (625);
insert into top_n_ids (id) values (626);
insert into top_n_ids (id) values (627);
insert into top_n_ids (id) values (628);
insert into top_n_ids (id) values (629);
insert into top_n_ids (id) values (630);
insert into top_n_ids (id) values (631);
insert into top_n_ids (id) values (632);
insert into top_n_ids (id) values (633);
insert into top_n_ids (id) values (634);
insert into top_n_ids (id) values (635);
insert into top_n_ids (id) values (636);
insert into top_n_ids (id) values (637);
insert into top_n_ids (id) values (638);
insert into top_n_ids (id) values (639);
insert into top_n_ids (id) values (640);
insert into top_n_ids (id) values (641);
insert into top_n_ids (id) values (642);
insert into top_n_ids (id) values (643);
insert into top_n_ids (id) values (644);
insert into top_n_ids (id) values (645);
insert into top_n_ids (id) values (646);
insert into top_n_ids (id) values (647);
insert into top_n_ids (id) values (648);
insert into top_n_ids (id) values (649);
insert into top_n_ids (id) values (650);
insert into top_n_ids (id) values (651);
insert into top_n_ids (id) values (652);
insert into top_n_ids (id) values (653);
insert into top_n_ids (id) values (654);
insert into top_n_ids (id) values (655);
insert into top_n_ids (id) values (656);
insert into top_n_ids (id) values (657);
insert into top_n_ids (id) values (658);
insert into top_n_ids (id) values (659);
insert into top_n_ids (id) values (660);
insert into top_n_ids (id) values (661);
insert into top_n_ids (id) values (662);
insert into top_n_ids (id) values (663);
insert into top_n_ids (id) values (664);
insert into top_n_ids (id) values (665);
insert into top_n_ids (id) values (666);
insert into top_n_ids (id) values (667);
insert into top_n_ids (id) values (668);
insert into top_n_ids (id) values (669);
insert into top_n_ids (id) values (670);
insert into top_n_ids (id) values (671);
insert into top_n_ids (id) values (672);
insert into top_n_ids (id) values (673);
insert into top_n_ids (id) values (674);
insert into top_n_ids (id) values (675);
insert into top_n_ids (id) values (676);
insert into top_n_ids (id) values (677);
insert into top_n_ids (id) values (678);
insert into top_n_ids (id) values (679);
insert into top_n_ids (id) values (680);
insert into top_n_ids (id) values (681);
insert into top_n_ids (id) values (682);
insert into top_n_ids (id) values (683);
insert into top_n_ids (id) values (684);
insert into top_n_ids (id) values (685);
insert into top_n_ids (id) values (686);
insert into top_n_ids (id) values (687);
insert into top_n_ids (id) values (688);
insert into top_n_ids (id) values (689);
insert into top_n_ids (id) values (690);
insert into top_n_ids (id) values (691);
insert into top_n_ids (id) values (692);
insert into top_n_ids (id) values (693);
insert into top_n_ids (id) values (694);
insert into top_n_ids (id) values (695);
insert into top_n_ids (id) values (696);
insert into top_n_ids (id) values (697);
insert into top_n_ids (id) values (698);
insert into top_n_ids (id) values (699);
insert into top_n_ids (id) values (700);
insert into top_n_ids (id) values (701);
insert into top_n_ids (id) values (702);
insert into top_n_ids (id) values (703);
insert into top_n_ids (id) values (704);
insert into top_n_ids (id) values (705);
insert into top_n_ids (id) values (706);
insert into top_n_ids (id) values (707);
insert into top_n_ids (id) values (708);
insert into top_n_ids (id) values (709);
insert into top_n_ids (id) values (710);
insert into top_n_ids (id) values (711);
insert into top_n_ids (id) values (712);
insert into top_n_ids (id) values (713);
insert into top_n_ids (id) values (714);
insert into top_n_ids (id) values (715);
insert into top_n_ids (id) values (716);
insert into top_n_ids (id) values (717);
insert into top_n_ids (id) values (718);
insert into top_n_ids (id) values (719);
insert into top_n_ids (id) values (720);
insert into top_n_ids (id) values (721);
insert into top_n_ids (id) values (722);
insert into top_n_ids (id) values (723);
insert into top_n_ids (id) values (724);
insert into top_n_ids (id) values (725);
insert into top_n_ids (id) values (726);
insert into top_n_ids (id) values (727);
insert into top_n_ids (id) values (728);
insert into top_n_ids (id) values (729);
insert into top_n_ids (id) values (730);
insert into top_n_ids (id) values (731);
insert into top_n_ids (id) values (732);
insert into top_n_ids (id) values (733);
insert into top_n_ids (id) values (734);
insert into top_n_ids (id) values (735);
insert into top_n_ids (id) values (736);
insert into top_n_ids (id) values (737);
insert into top_n_ids (id) values (738);
insert into top_n_ids (id) values (739);
insert into top_n_ids (id) values (740);
insert into top_n_ids (id) values (741);
insert into top_n_ids (id) values (742);
insert into top_n_ids (id) values (743);
insert into top_n_ids (id) values (744);
insert into top_n_ids (id) values (745);
insert into top_n_ids (id) values (746);
insert into top_n_ids (id) values (747);
insert into top_n_ids (id) values (748);
insert into top_n_ids (id) values (749);
insert into top_n_ids (id) values (750);
insert into top_n_ids (id) values (751);
insert into top_n_ids (id) values (752);
insert into top_n_ids (id) values (753);
insert into top_n_ids (id) values (754);
insert into top_n_ids (id) values (755);
insert into top_n_ids (id) values (756);
insert into top_n_ids (id) values (757);
insert into top_n_ids (id) values (758);
insert into top_n_ids (id) values (759);
insert into top_n_ids (id) values (760);
insert into top_n_ids (id) values (761);
insert into top_n_ids (id) values (762);
insert into top_n_ids (id) values (763);
insert into top_n_ids (id) values (764);
insert into top_n_ids (id) values (765);
insert into top_n_ids (id) values (766);
insert into top_n_ids (id) values (767);
insert into top_n_ids (id) values (768);
insert into top_n_ids (id) values (769);
insert into top_n_ids (id) values (770);
insert into top_n_ids (id) values (771);
insert into top_n_ids (id) values (772);
insert into top_n_ids (id) values (773);
insert into top_n_ids (id) values (774);
insert into top_n_ids (id) values (775);
insert into top_n_ids (id) values (776);
insert into top_n_ids (id) values (777);
insert into top_n_ids (id) values (778);
insert into top_n_ids (id) values (779);
insert into top_n_ids (id) values (780);
insert into top_n_ids (id) values (781);
insert into top_n_ids (id) values (782);
insert into top_n_ids (id) values (783);
insert into top_n_ids (id) values (784);
insert into top_n_ids (id) values (785);
insert into top_n_ids (id) values (786);
insert into top_n_ids (id) values (787);
insert into top_n_ids (id) values (788);
insert into top_n_ids (id) values (789);
insert into top_n_ids (id) values (790);
insert into top_n_ids (id) values (791);
insert into top_n_ids (id) values (792);
insert into top_n_ids (id) values (793);
insert into top_n_ids (id) values (794);
insert into top_n_ids (id) values (795);
insert into top_n_ids (id) values (796);
insert into top_n_ids (id) values (797);
insert into top_n_ids (id) values (798);
insert into top_n_ids (id) values (799);
insert into top_n_ids (id) values (800);
insert into top_n_ids (id) values (801);
insert into top_n_ids (id) values (802);
insert into top_n_ids (id) values (803);
insert into top_n_ids (id) values (804);
insert into top_n_ids (id) values (805);
insert into top_n_ids (id) values (806);
insert into top_n_ids (id) values (807);
insert into top_n_ids (id) values (808);
insert into top_n_ids (id) values (809);
insert into top_n_ids (id) values (810);
insert into top_n_ids (id) values (811);
insert into top_n_ids (id) values (812);
insert into top_n_ids (id) values (813);
insert into top_n_ids (id) values (814);
insert into top_n_ids (id) values (815);
insert into top_n_ids (id) values (816);
insert into top_n_ids (id) values (817);
insert into top_n_ids (id) values (818);
insert into top_n_ids (id) values (819);
insert into top_n_ids (id) values (820);
insert into top_n_ids (id) values (821);
insert into top_n_ids (id) values (822);
insert into top_n_ids (id) values (823);
insert into top_n_ids (id) values (824);
insert into top_n_ids (id) values (825);
insert into top_n_ids (id) values (826);
insert into top_n_ids (id) values (827);
insert into top_n_ids (id) values (828);
insert into top_n_ids (id) values (829);
insert into top_n_ids (id) values (830);
insert into top_n_ids (id) values (831);
insert into top_n_ids (id) values (832);
insert into top_n_ids (id) values (833);
insert into top_n_ids (id) values (834);
insert into top_n_ids (id) values (835);
insert into top_n_ids (id) values (836);
insert into top_n_ids (id) values (837);
insert into top_n_ids (id) values (838);
insert into top_n_ids (id) values (839);
insert into top_n_ids (id) values (840);
insert into top_n_ids (id) values (841);
insert into top_n_ids (id) values (842);
insert into top_n_ids (id) values (843);
insert into top_n_ids (id) values (844);
insert into top_n_ids (id) values (845);
insert into top_n_ids (id) values (846);
insert into top_n_ids (id) values (847);
insert into top_n_ids (id) values (848);
insert into top_n_ids (id) values (849);
insert into top_n_ids (id) values (850);
insert into top_n_ids (id) values (851);
insert into top_n_ids (id) values (852);
insert into top_n_ids (id) values (853);
insert into top_n_ids (id) values (854);
insert into top_n_ids (id) values (855);
insert into top_n_ids (id) values (856);
insert into top_n_ids (id) values (857);
insert into top_n_ids (id) values (858);
insert into top_n_ids (id) values (859);
insert into top_n_ids (id) values (860);
insert into top_n_ids (id) values (861);
insert into top_n_ids (id) values (862);
insert into top_n_ids (id) values (863);
insert into top_n_ids (id) values (864);
insert into top_n_ids (id) values (865);
insert into top_n_ids (id) values (866);
insert into top_n_ids (id) values (867);
insert into top_n_ids (id) values (868);
insert into top_n_ids (id) values (869);
insert into top_n_ids (id) values (870);
insert into top_n_ids (id) values (871);
insert into top_n_ids (id) values (872);
insert into top_n_ids (id) values (873);
insert into top_n_ids (id) values (874);
insert into top_n_ids (id) values (875);
insert into top_n_ids (id) values (876);
insert into top_n_ids (id) values (877);
insert into top_n_ids (id) values (878);
insert into top_n_ids (id) values (879);
insert into top_n_ids (id) values (880);
insert into top_n_ids (id) values (881);
insert into top_n_ids (id) values (882);
insert into top_n_ids (id) values (883);
insert into top_n_ids (id) values (884);
insert into top_n_ids (id) values (885);
insert into top_n_ids (id) values (886);
insert into top_n_ids (id) values (887);
insert into top_n_ids (id) values (888);
insert into top_n_ids (id) values (889);
insert into top_n_ids (id) values (890);
insert into top_n_ids (id) values (891);
insert into top_n_ids (id) values (892);
insert into top_n_ids (id) values (893);
insert into top_n_ids (id) values (894);
insert into top_n_ids (id) values (895);
insert into top_n_ids (id) values (896);
insert into top_n_ids (id) values (897);
insert into top_n_ids (id) values (898);
insert into top_n_ids (id) values (899);
insert into top_n_ids (id) values (900);
insert into top_n_ids (id) values (901);
insert into top_n_ids (id) values (902);
insert into top_n_ids (id) values (903);
insert into top_n_ids (id) values (904);
insert into top_n_ids (id) values (905);
insert into top_n_ids (id) values (906);
insert into top_n_ids (id) values (907);
insert into top_n_ids (id) values (908);
insert into top_n_ids (id) values (909);
insert into top_n_ids (id) values (910);
insert into top_n_ids (id) values (911);
insert into top_n_ids (id) values (912);
insert into top_n_ids (id) values (913);
insert into top_n_ids (id) values (914);
insert into top_n_ids (id) values (915);
insert into top_n_ids (id) values (916);
insert into top_n_ids (id) values (917);
insert into top_n_ids (id) values (918);
insert into top_n_ids (id) values (919);
insert into top_n_ids (id) values (920);
insert into top_n_ids (id) values (921);
insert into top_n_ids (id) values (922);
insert into top_n_ids (id) values (923);
insert into top_n_ids (id) values (924);
insert into top_n_ids (id) values (925);
insert into top_n_ids (id) values (926);
insert into top_n_ids (id) values (927);
insert into top_n_ids (id) values (928);
insert into top_n_ids (id) values (929);
insert into top_n_ids (id) values (930);
insert into top_n_ids (id) values (931);
insert into top_n_ids (id) values (932);
insert into top_n_ids (id) values (933);
insert into top_n_ids (id) values (934);
insert into top_n_ids (id) values (935);
insert into top_n_ids (id) values (936);
insert into top_n_ids (id) values (937);
insert into top_n_ids (id) values (938);
insert into top_n_ids (id) values (939);
insert into top_n_ids (id) values (940);
insert into top_n_ids (id) values (941);
insert into top_n_ids (id) values (942);
insert into top_n_ids (id) values (943);
insert into top_n_ids (id) values (944);
insert into top_n_ids (id) values (945);
insert into top_n_ids (id) values (946);
insert into top_n_ids (id) values (947);
insert into top_n_ids (id) values (948);
insert into top_n_ids (id) values (949);
insert into top_n_ids (id) values (950);
insert into top_n_ids (id) values (951);
insert into top_n_ids (id) values (952);
insert into top_n_ids (id) values (953);
insert into top_n_ids (id) values (954);
insert into top_n_ids (id) values (955);
insert into top_n_ids (id) values (956);
insert into top_n_ids (id) values (957);
insert into top_n_ids (id) values (958);
insert into top_n_ids (id) values (959);
insert into top_n_ids (id) values (960);
insert into top_n_ids (id) values (961);
insert into top_n_ids (id) values (962);
insert into top_n_ids (id) values (963);
insert into top_n_ids (id) values (964);
insert into top_n_ids (id) values (965);
insert into top_n_ids (id) values (966);
insert into top_n_ids (id) values (967);
insert into top_n_ids (id) values (968);
insert into top_n_ids (id) values (969);
insert into top_n_ids (id) values (970);
insert into top_n_ids (id) values (971);
insert into top_n_ids (id) values (972);
insert into top_n_ids (id) values (973);
insert into top_n_ids (id) values (974);
insert into top_n_ids (id) values (975);
insert into top_n_ids (id) values (976);
insert into top_n_ids (id) values (977);
insert into top_n_ids (id) values (978);
insert into top_n_ids (id) values (979);
insert into top_n_ids (id) values (980);
insert into top_n_ids (id) values (981);
insert into top_n_ids (id) values (982);
insert into top_n_ids (id) values (983);
insert into top_n_ids (id) values (984);
insert into top_n_ids (id) values (985);
insert into top_n_ids (id) values (986);
insert into top_n_ids (id) values (987);
insert into top_n_ids (id) values (988);
insert into top_n_ids (id) values (989);
insert into top_n_ids (id) values (990);
insert into top_n_ids (id) values (991);
insert into top_n_ids (id) values (992);
insert into top_n_ids (id) values (993);
insert into top_n_ids (id) values (994);
insert into top_n_ids (id) values (995);
insert into top_n_ids (id) values (996);
insert into top_n_ids (id) values (997);
insert into top_n_ids (id) values (998);
insert into top_n_ids (id) values (999);
insert into top_n_ids (id) values (1000);
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15810931, getdate(), 1, 4, ' Star 15810931 BSO Process Manager: BAM component changes' )
GO

COMMIT TRANSACTION 
GO

