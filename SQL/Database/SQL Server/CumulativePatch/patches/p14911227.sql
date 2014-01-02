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
/* MODIFIED Patch Star 14911227 Autosys: Remove 2 alarms from ujo_int_codes and add 2            */
/*                                                                                      */
/****************************************************************************************/
BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ujo_alamode with (tablockx)
GO
 
Select top 1 1 from ujo_config with (tablockx)
GO
 
Select top 1 1 from ujo_ha_process with (tablockx)
GO
 
Select top 1 1 from ujo_sys_ha_state with (tablockx)
GO
 
Select top 1 1 from ujo_ha_designator with (tablockx)
GO
 
Select top 1 1 from ujo_ha_state with (tablockx)
GO
 
Select top 1 1 from ujo_ha_status with (tablockx)
GO
 
Select top 1 1 from ujo_intcodes with (tablockx)
GO
 
Select top 1 1 from ujo_last_eoid_counter with (tablockx)
GO
 
Select top 1 1 from ujo_next_oid with (tablockx)
GO
 
Select top 1 1 from ujo_next_run_num with (tablockx)
GO
 
Select top 1 1 from ujo_timezones with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* Populating Autosys Tables */

/* First Delete from tables */

delete from ujo_alamode
go

delete from ujo_config
go

delete from ujo_ha_process
go

delete from ujo_sys_ha_state
go

delete from ujo_ha_designator
go

delete from ujo_ha_state
go

delete from ujo_ha_status
go

delete from ujo_intcodes
go

delete from ujo_last_Eoid_counter
go

delete from ujo_next_oid
go

delete from ujo_next_run_num
go

delete from ujo_timezones
go


/* Insert into ujo_alamode */
insert into ujo_alamode (type, int_val, str_val)
values( 'AUTOUSER', 0, NULL )
go

insert into ujo_alamode (type, int_val, str_val)
values( 'AUTO_REMOTE_DIR', 0, NULL )
go

insert into ujo_alamode (type, int_val, str_val)
values(	'DB', 1, NULL )
go

insert into ujo_alamode (type, int_val, str_val)
values( 'JOB', 0, NULL )
go

insert into ujo_alamode (type, int_val, str_val)
values( 'EVT', 0, NULL )
go

insert into ujo_alamode (type, int_val, str_val)
values( 'AUTOSERV', 0, 'ACE' )
go

insert into ujo_alamode (type, int_val, str_val)
values( 'event_demon', 0, 'INIT' ) 
go

insert into ujo_alamode (type, int_val, str_val)
values( 'gmt_offset', 18000, NULL )  /* EST */
go

insert into ujo_alamode (type, int_val, str_val)
values( 'job_edit_stamp', 0, NULL )
go

insert into ujo_alamode (type, int_val, str_val)
values( 'SERVER_TIMEZONE', 0, NULL )
go

/* AutoTrack: 0=off, 1=1 liners, 2=1 + jil-style job edit info */
insert into ujo_alamode (type, int_val, str_val)
values(	'AutoTrack', 0, NULL )
go

insert into ujo_alamode (type, int_val, str_val)
values('VERSION', 0, '11.0' )
go

insert into ujo_alamode (type, int_val, str_val) 
values ('password', 0, 'aDc?C)D~FDFbH{h>')
go

insert into ujo_alamode (type, int_val, str_val) 
values ('remauth', 1, '')
go

/* insert into ujo_config */

insert into ujo_config(fld,code) VALUES ('ServerType','E')
go

/* insert into ujo_ha_designator */
insert into ujo_ha_designator (name) values ( 'Primary')
go
insert into ujo_ha_designator (name) values ( 'Shadow')
go
insert into ujo_ha_designator (name) values ('Tertiary')
go
insert into ujo_ha_state (name) values ( 'No-change')
go

/* insert into ujo_ha_state */
insert into ujo_ha_state ( name) values ( 'Normal')
go
insert into ujo_ha_state ( name) values ('Pending')
go
insert into ujo_ha_state ( name) values ('Failed-over')
go

/* insert into ujo_ha_status */
insert into ujo_ha_status (name) values ('Active')
go
insert into ujo_ha_status (name) values ('Failed')
go
insert into ujo_ha_status (name) values ('Dormant')
go

/* insert into ujo_intcodes */
insert into ujo_intcodes (fld, code, text) values('status', 0, '')
go
insert into ujo_intcodes (fld, code, text) values('status', 1, 'RUNNING')
go
insert into ujo_intcodes (fld, code, text) values('status', 3, 'STARTING')
go
insert into ujo_intcodes (fld, code, text) values('status', 4, 'SUCCESS')
go
insert into ujo_intcodes (fld, code, text) values('status', 5, 'FAILURE')
go
insert into ujo_intcodes (fld, code, text) values('status', 6, 'TERMINATED')
go
insert into ujo_intcodes (fld, code, text) values('status', 7, 'ON_ICE')
go
insert into ujo_intcodes (fld, code, text) values('status', 8, 'INACTIVE')
go
insert into ujo_intcodes (fld, code, text) values('status', 9, 'ACTIVATED')
go
insert into ujo_intcodes (fld, code, text) values('status', 10, 'RESTART')
go
insert into ujo_intcodes (fld, code, text) values('status', 11, 'ON_HOLD')
go
insert into ujo_intcodes (fld, code, text) values('status', 12, 'QUE_WAIT')
go
insert into ujo_intcodes (fld, code, text) values('event', 0, '')
go
insert into ujo_intcodes (fld, code, text) values('event', 101, 'CHANGE_STATUS')
go
insert into ujo_intcodes (fld, code, text) values('event', 103, 'CHK_N_START')
go
insert into ujo_intcodes (fld, code, text) values('event', 105, 'KILLJOB')
go
insert into ujo_intcodes (fld, code, text) values('event', 106, 'ALARM')
go
insert into ujo_intcodes (fld, code, text) values('event', 107, 'STARTJOB')
go
insert into ujo_intcodes (fld, code, text) values('event', 108, 'FORCE_STARTJOB')
go
insert into ujo_intcodes (fld, code, text) values('event', 109, 'STOP_DEMON')
go
insert into ujo_intcodes (fld, code, text) values('event', 110, 'JOB_ON_ICE')
go
insert into ujo_intcodes (fld, code, text) values('event', 111, 'JOB_OFF_ICE')
go
insert into ujo_intcodes (fld, code, text) values('event', 112, 'JOB_ON_HOLD')
go
insert into ujo_intcodes (fld, code, text) values('event', 113, 'JOB_OFF_HOLD')
go
insert into ujo_intcodes (fld, code, text) values('event', 114, 'CHK_MAX_ALARM')
go
insert into ujo_intcodes (fld, code, text) values('event', 115, 'HEARTBEAT')
go
insert into ujo_intcodes (fld, code, text) values('event', 116, 'CHECK_HEARTBEAT')
go
insert into ujo_intcodes (fld, code, text) values('event', 117, 'COMMENT')
go
insert into ujo_intcodes (fld, code, text) values('event', 118, 'CHK_BOX_TERM')
go
insert into ujo_intcodes (fld, code, text) values('event', 119, 'DELETEJOB')
go
insert into ujo_intcodes (fld, code, text) values('event', 120, 'CHANGE_PRIORITY')
go
insert into ujo_intcodes (fld, code, text) values('event', 121, 'QUE_RECOVERY')
go
insert into ujo_intcodes (fld, code, text) values('event', 122, 'CHK_RUN_WINDOW')
go
insert into ujo_intcodes (fld, code, text) values('event', 125, 'SET_GLOBAL')
go
insert into ujo_intcodes (fld, code, text) values('event', 126, 'SEND_SIGNAL')
go
insert into ujo_intcodes (fld, code, text) values('event', 127, 'EXTERNAL_DEPENDENCY')
go
insert into ujo_intcodes (fld, code, text) values('event', 128, 'RESEND_EXTERNAL_STATUS')
go
insert into ujo_intcodes (fld, code, text) values ('event', 129, 'REFRESH_BROKER')
go
insert into ujo_intcodes (fld, code, text) values ('event', 130, 'MACH_OFFLINE')
go
insert into ujo_intcodes (fld, code, text) values ('event', 131, 'MACH_ONLINE')
go
insert into ujo_intcodes (fld, code, text) values ('event', 132, 'EXT_REREAD')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 0, '')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 501, 'FORKFAIL')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 502, 'MINRUNALARM')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 503, 'JOBFAILURE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 505, 'MAX_RETRYS')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 506, 'STARTJOBFAIL')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 507, 'EVENT_HDLR_ERROR')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 508, 'EVENT_QUE_ERROR')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 509, 'JOBNOT_ONICEHOLD')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 510, 'MAXRUNALARM')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 512, 'RESOURCE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 513, 'MISSING_HEARTBEAT')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 514, 'CHASE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 516, 'DATABASE_COMM')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 518, 'VERSION_MISMATCH')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 519, 'DB_ROLLOVER')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 520, 'EP_ROLLOVER')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 521, 'EP_SHUTDOWN')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 522, 'EP_HIGH_AVAIL')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 523, 'DB_PROBLEM')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 524, 'DUPLICATE_EVENT')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 525, 'INSTANCE_UNAVAILABLE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 526, 'AUTO_PING')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 527, 'OB_SHUTDOWN')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 528, 'ALREADY_RUNNING')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 529, 'EXTERN_DEPS_ERROR')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 532, 'MACHINE_UNAVAILABLE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 533, 'SERVICEDESK_FAILURE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 534, 'UNINOTIFY_FAILURE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 535, 'CPI_JOBNAME_INVALID')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 536, 'CPI_UNAVAILABLE')
go
insert into ujo_intcodes (fld, code, text) values('sound', 221, 'for_job')
go
insert into ujo_intcodes (fld, code, text) values('sound', 222, 'big_alarm')
go
insert into ujo_intcodes (fld, code, text) values('sound', 223, 'excellent')
go
insert into ujo_intcodes (fld, code, text) values('sound', 224, 'bogus')
go
insert into ujo_intcodes (fld, code, text) values ('status', 14, 'PEND_MACH')
go

/* Delete from ujo_intcodes */
delete from ujo_intcodes where fld='status' and code=14 and text='REFRESH_DEPENDENCIES'
go
delete from ujo_intcodes where fld='status' and code=15 and text='REFRESH_FILEWATCHER'
go

/* insert into ujo_last_Eoid_counter */
insert into ujo_last_Eoid_counter (counter) values ( '0000100')
go

/* insert into ujo_next_oid */

insert into ujo_next_oid (oid, field) values( 100, 'audit_info_num')
go
insert into ujo_next_oid (oid, field) values( 100, 'joid')
go
insert into ujo_next_oid (oid, field) values( 1000, 'evt_num')
go
insert into ujo_next_oid (oid, field) values( 10000000,'eoid')
go


/* insert into ujo_next_run_num */
insert into ujo_next_run_num (run_num) values ( 100 )
go

/* insert into ujo_sys_ha_state */
insert into ujo_sys_ha_state (id, ha_state_id)  
  select 1, id FROM ujo_ha_state WHERE name = 'Pending'  
go  

/* insert into ujo_timezones */
insert into ujo_timezones (name, type, zone) values( 'AKST9AKDT', 'Z', 'AKS9AKDT' )
go
insert into ujo_timezones (name, type, zone) values( 'AST-3', 'Z', 'AST-3' )
go
insert into ujo_timezones (name, type, zone) values( 'AST4', 'Z', 'AST4' )
go
insert into ujo_timezones (name, type, zone) values( 'AbuDhabi', 'C', 'Arabian-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Adelaide', 'C', 'Australia/Adelaide' )
go
insert into ujo_timezones (name, type, zone) values( 'Africa-Z', 'Z', 'SAT-2' )
go
insert into ujo_timezones (name, type, zone) values( 'Africa/Cairo', 'A', 'Egypt' )
go
insert into ujo_timezones (name, type, zone) values( 'Africa/Cape_Verde', 'Z', 'AAT1' )
go
insert into ujo_timezones (name, type, zone) values( 'Africa/Casablanca', 'Z', 'WET+0' )
go
insert into ujo_timezones (name, type, zone) values( 'Africa/Harare', 'A', 'Africa-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Africa/Johannesburg', 'Z', 'SAS-2' )
go
insert into ujo_timezones (name, type, zone) values( 'Africa/Monrovia', 'Z', 'WAT+0' )
go
insert into ujo_timezones (name, type, zone) values( 'Alaska', 'A', 'US/Alaska' )
go
insert into ujo_timezones (name, type, zone) values( 'Almaty', 'C', 'Asia/Almaty' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Anchorage', 'Z', 'AKS9AKDT' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Atka', 'Z', 'HAS10HADT' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Bogota', 'Z', 'EST5' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Buenos_Aires', 'Z', 'EST3' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Caracas', 'Z', 'AST4' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Fort_Wayne', 'Z', 'EST5' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Guyana', 'Z', 'EST3' )
go
insert into ujo_timezones (name, type, zone) values( 'America/La_Paz', 'Z', 'AST4' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Lima', 'Z', 'EST5' )
go
insert into ujo_timezones (name, type, zone) values( 'America/MexicoCity', 'Z', 'CST6' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Nassau', 'Z', 'EST5EDT' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Phoenix', 'Z', 'AST7' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Regina', 'Z', 'CST6' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Santiago', 'Z', 'CST4CDT,M10.2.0/00:00:00,M3.2.0/00:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Sao_Paulo', 'Z', 'EST3EDT,M10.3.0/00:00:00,M2.2.0/00:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Tegucigalpa', 'Z', 'CST6' )
go
insert into ujo_timezones (name, type, zone) values( 'America/Tijuana', 'Z', 'PST8PDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Amsterdam', 'C', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Anchorage', 'C', 'US/Alaska' )
go
insert into ujo_timezones (name, type, zone) values( 'Arabian-Z', 'Z', 'GST-4' )
go
insert into ujo_timezones (name, type, zone) values( 'Arizona', 'A', 'US/Arizona' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Almaty', 'A', 'CentralAsia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Baghdad', 'A', 'Baghdad-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Bangkok', 'A', 'Bangkok-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Calcutta', 'A', 'India' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Columbo', 'A', 'India' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Dhaka', 'A', 'India' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Hong_Kong', 'Z', 'HKS-8' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Jakarta', 'Z', 'JVT-7' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Kabul', 'Z', 'AFT-4' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Kamchatka', 'Z', 'PSK-11PSD,M3.5.0,M9.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Karachi', 'A', 'WestAsia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Kuwait', 'Z', 'AST-3' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Magadan', 'Z', 'GSK-10GSD,M3.5.0,M9.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Manila', 'Z', 'PST-8' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Muscat', 'A', 'Arabian-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Nairobi', 'Z', 'AST-3' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Riyadh', 'Z', 'AST-3' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Seoul', 'A', 'ROK' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Shanghai', 'A', 'China-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Singapore', 'Z', 'SGT-8' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Taipei', 'Z', 'CST-8' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Tashkent', 'A', 'CentralAsia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Tbilisi', 'A', 'Moscow-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Tehran', 'A', 'Tehran-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Tokyo', 'A', 'Tokyo-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Asia/Yakutsk', 'Z', 'YSK-8YSD,M3.5.0,M9.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'Athens', 'C', 'Europe/Athens' )
go
insert into ujo_timezones (name, type, zone) values( 'Atlanta', 'C', 'US/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'Atlantic/Azores', 'Z', 'ACT1ACTDST,M3.5.0/01:00:00,M9.5.0' )
go
insert into ujo_timezones (name, type, zone) values( 'AtlanticTime', 'A', 'Canada/Atlantic' )
go
insert into ujo_timezones (name, type, zone) values( 'Auckland', 'C', 'Pacific/Auckland' )
go
insert into ujo_timezones (name, type, zone) values( 'Auckland-Z', 'Z', 'NZS-12NZDT,M10.1.0,M3.3.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'Australia-Z', 'Z', 'CST-09:30' )
go
insert into ujo_timezones (name, type, zone) values( 'Australia/Adelaide', 'A', 'CentralAustralia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Australia/Brisbane', 'A', 'Sydney-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Australia/Darwin', 'A', 'Australia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Australia/Hobart', 'Z', 'EST-10EST,M10.1.0,M3.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'Australia/Melbourne', 'A', 'Sydney-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Australia/Perth', 'Z', 'WST-8' )
go
insert into ujo_timezones (name, type, zone) values( 'Australia/Sydney', 'A', 'Sydney-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Azores', 'C', 'Atlantic/Azores' )
go
insert into ujo_timezones (name, type, zone) values( 'Baghdad', 'C', 'Asia/Baghdad' )
go
insert into ujo_timezones (name, type, zone) values( 'Baghdad-Z', 'Z', 'IST-3IDT,M3.5.0/01:00:00,M9.5.0' )
go
insert into ujo_timezones (name, type, zone) values( 'Bahamas', 'A', 'America/Nassau' )
go
insert into ujo_timezones (name, type, zone) values( 'Bangkok', 'C', 'Asia/Bangkok' )
go
insert into ujo_timezones (name, type, zone) values( 'Bangkok-Z', 'Z', 'ICT-7' )
go
insert into ujo_timezones (name, type, zone) values( 'Beijing', 'C', 'Asia/Shanghai' )
go
insert into ujo_timezones (name, type, zone) values( 'Berlin', 'C', 'Europe/Berlin' )
go
insert into ujo_timezones (name, type, zone) values( 'Bern', 'C', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Bogota', 'C', 'America/Bogota' )
go
insert into ujo_timezones (name, type, zone) values( 'Bombay', 'C', 'India' )
go
insert into ujo_timezones (name, type, zone) values( 'Boston', 'C', 'US/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'Brasilia', 'C', 'America/Sao_Paulo' )
go
insert into ujo_timezones (name, type, zone) values( 'Brisbane', 'C', 'Australia/Brisbane' )
go
insert into ujo_timezones (name, type, zone) values( 'Brussels', 'C', 'Europe/Brussels' )
go
insert into ujo_timezones (name, type, zone) values( 'Budapest', 'C', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'BuenosAires', 'C', 'America/Buenos_Aires' )
go
insert into ujo_timezones (name, type, zone) values( 'CST-09:30', 'Z', 'CST-09:30' )
go
insert into ujo_timezones (name, type, zone) values( 'CST-8', 'Z', 'CST-8' )
go
insert into ujo_timezones (name, type, zone) values( 'CST6', 'Z', 'CST6' )
go
insert into ujo_timezones (name, type, zone) values( 'CST6CDT', 'Z', 'CST6CDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Cairo', 'C', 'Africa/Cairo' )
go
insert into ujo_timezones (name, type, zone) values( 'Calcutta', 'C', 'Asia/Calcutta' )
go
insert into ujo_timezones (name, type, zone) values( 'Calgary', 'C', 'Canada/Mountain' )
go
insert into ujo_timezones (name, type, zone) values( 'Canada/Central', 'Z', 'CST6CDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Canada/Eastern', 'Z', 'EST5EDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Canada/Mountain', 'Z', 'MST7MDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Canada/Newfoundland', 'A', 'Canada/St_Johns' )
go
insert into ujo_timezones (name, type, zone) values( 'Canada/Pacific', 'Z', 'PST8PDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Canada/Saskatchewan', 'A', 'America/Regina' )
go
insert into ujo_timezones (name, type, zone) values( 'Canada/St_Johns', 'Z', 'NST3:30NDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Canberra', 'C', 'Sydney-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'CapeTown', 'C', 'Africa/Johannesburg' )
go
insert into ujo_timezones (name, type, zone) values( 'CapeVerdeIs', 'A', 'Africa/Cape_Verde' )
go
insert into ujo_timezones (name, type, zone) values( 'CapeVerdeIslands', 'A', 'Africa/Cape_Verde' )
go
insert into ujo_timezones (name, type, zone) values( 'Caracas', 'C', 'America/Caracas' )
go
insert into ujo_timezones (name, type, zone) values( 'Casablanca', 'C', 'Africa/Casablanca' )
go
insert into ujo_timezones (name, type, zone) values( 'CentralAsia-Z', 'Z', 'TSK-5TSD,M3.5.0,M9.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'CentralAustralia-Z', 'Z', 'CST-09:30CST,M10.5.0,M3.3.0' )
go
insert into ujo_timezones (name, type, zone) values( 'CentralEurope-West', 'Z', 'MET-1METDST,M3.5.0/01:00:00,M9.5.0' )
go
insert into ujo_timezones (name, type, zone) values( 'CentralTime', 'A', 'US/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'Chicago', 'C', 'US/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'China-Z', 'Z', 'CST-8' )
go
insert into ujo_timezones (name, type, zone) values( 'Chongqing', 'C', 'China-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Columbo', 'C', 'Asia/Columbo' )
go
insert into ujo_timezones (name, type, zone) values( 'Dallas', 'C', 'US/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'Darwin', 'C', 'Australia/Darwin' )
go
insert into ujo_timezones (name, type, zone) values( 'Denver', 'C', 'US/Mountain' )
go
insert into ujo_timezones (name, type, zone) values( 'Detroit', 'C', 'US/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'Dhaka', 'C', 'Asia/Dhaka' )
go
insert into ujo_timezones (name, type, zone) values( 'Dublin', 'C', 'Europe/Dublin' )
go
insert into ujo_timezones (name, type, zone) values( 'EET', 'Z', 'EET-2EETDST,M3.5.0/03:00:00,M9.5.0/04:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'EST3', 'Z', 'EST3' )
go
insert into ujo_timezones (name, type, zone) values( 'EST5', 'Z', 'EST5' )
go
insert into ujo_timezones (name, type, zone) values( 'EST5EDT', 'Z', 'EST5EDT' )
go
insert into ujo_timezones (name, type, zone) values( 'EastIndiana', 'A', 'US/East-Indiana' )
go
insert into ujo_timezones (name, type, zone) values( 'EasternEurope', 'A', 'EET' )
go
insert into ujo_timezones (name, type, zone) values( 'EasternEurope-Mid', 'Z', 'EET-2EETDST,M3.5.0,M9.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'EasternTime', 'A', 'US/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'Edinburgh', 'C', 'GB-Eire' )
go
insert into ujo_timezones (name, type, zone) values( 'Edmonton', 'C', 'Canada/Mountain' )
go
insert into ujo_timezones (name, type, zone) values( 'Egypt', 'Z', 'EET-2EETDST,J121/01:00:00,J274/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'Ekaterinburg', 'C', 'WestAsia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Eniwetok', 'A', 'Pacific/Kwajalein' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Athens', 'A', 'EasternEurope-Mid' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Berlin', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Brussels', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Dublin', 'A', 'GB-Eire' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Helsinki', 'A', 'EasternEurope-Mid' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Istanbul', 'A', 'EasternEurope-Mid' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Lisbon', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/London', 'A', 'GB-Eire' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Madrid', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Moscow', 'A', 'Moscow-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Paris', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Prague', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Rome', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/St_Petersburg', 'A', 'Moscow-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Stockholm', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Vienna', 'A', 'MET' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Vladivostok', 'Z', 'VSK-9VSD,M3.5.0,M9.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Warsaw', 'A', 'CentralEurope-West' )
go
insert into ujo_timezones (name, type, zone) values( 'Europe/Zurich', 'A', 'MET' )
go

insert into ujo_timezones (name, type, zone) values( 'Fiji', 'A', 'Pacific/Fiji' )
go
insert into ujo_timezones (name, type, zone) values( 'Fiji-Z', 'Z', 'NZS-12' )
go
insert into ujo_timezones (name, type, zone) values( 'FortWorth', 'C', 'US/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'GB-Eire', 'Z', 'GMT+0BST,M3.5.0/01:00:00,M10.5.0' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT', 'Z', 'GMT+0' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+0', 'Z', 'GMT+0' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+1', 'Z', 'GMT+1' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+10', 'Z', 'GMT+10' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+11', 'Z', 'GMT+11' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+12', 'Z', 'GMT+12' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+13', 'Z', 'GMT+13' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+2', 'Z', 'GMT+2' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+3', 'Z', 'GMT+3' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+5', 'Z', 'GMT+5' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+6', 'Z', 'GMT+6' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+7', 'Z', 'GMT+7' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+8', 'Z', 'GMT+8' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT+9', 'Z', 'GMT+9' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-0', 'Z', 'GMT-0' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-1', 'Z', 'GMT-1' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-10', 'Z', 'GMT-10' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-11', 'Z', 'GMT-11' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-12', 'Z', 'GMT-12' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-2', 'Z', 'GMT-2' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-3', 'Z', 'GMT-3' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-4', 'Z', 'GMT-4' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-5', 'Z', 'GMT-5' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-6', 'Z', 'GMT-6' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-7', 'Z', 'GMT-7' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-8', 'Z', 'GMT-8' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT-9', 'Z', 'GMT-9' )
go
insert into ujo_timezones (name, type, zone) values( 'Georgetown', 'C', 'America/Guyana' )
go
insert into ujo_timezones (name, type, zone) values( 'GreenwichMeanTime', 'A', 'Greenwich' )
go
insert into ujo_timezones (name, type, zone) values( 'Greenwich', 'Z', 'GMT+0' )
go
insert into ujo_timezones (name, type, zone) values( 'Guam', 'C', 'Pacific/Guam' )
go
insert into ujo_timezones (name, type, zone) values( 'HAST10HADT', 'Z', 'HAS10HADT' )
go
insert into ujo_timezones (name, type, zone) values( 'HKST-8', 'Z', 'HKS-8' )
go
insert into ujo_timezones (name, type, zone) values( 'HST10', 'Z', 'HST10' )
go
insert into ujo_timezones (name, type, zone) values( 'Halifax', 'C', 'Canada/Atlantic' )
go
insert into ujo_timezones (name, type, zone) values( 'Hanoi', 'C', 'Bangkok-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Harare', 'C', 'Africa/Harare' )
go
insert into ujo_timezones (name, type, zone) values( 'Hawaii', 'A', 'US/Hawaii' )
go
insert into ujo_timezones (name, type, zone) values( 'Helsinki', 'C', 'Europe/Helsinki' )
go
insert into ujo_timezones (name, type, zone) values( 'Hobart', 'C', 'Australia/Hobart' )
go
insert into ujo_timezones (name, type, zone) values( 'HongKong', 'A', 'Asia/Hong_Kong' )
go
insert into ujo_timezones (name, type, zone) values( 'Honolulu', 'C', 'Pacific/Honolulu' )
go
insert into ujo_timezones (name, type, zone) values( 'India', 'Z', 'IST-5:30' )
go
insert into ujo_timezones (name, type, zone) values( 'Indiana', 'A', 'US/East-Indiana' )
go
insert into ujo_timezones (name, type, zone) values( 'IndianaEast', 'A', 'US/East-Indiana' )
go
insert into ujo_timezones (name, type, zone) values( 'Islamabad', 'C', 'WestAsia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Israel', 'Z', 'IST-2IDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Istanbul', 'C', 'Europe/Istanbul' )
go
insert into ujo_timezones (name, type, zone) values( 'Jakarta', 'C', 'Asia/Jakarta' )
go
insert into ujo_timezones (name, type, zone) values( 'Japan', 'Z', 'JST-9' )
go
insert into ujo_timezones (name, type, zone) values( 'Johannesburg', 'C', 'Africa/Johannesburg' )
go
insert into ujo_timezones (name, type, zone) values( 'JST-9', 'Z', 'JST-9' )
go
insert into ujo_timezones (name, type, zone) values( 'Kabul', 'C', 'Asia/Kabul' )
go
insert into ujo_timezones (name, type, zone) values( 'Kamchatka', 'A', 'Asia/Kamchatka' )
go
insert into ujo_timezones (name, type, zone) values( 'Karachi', 'C', 'Asia/Karachi' )
go
insert into ujo_timezones (name, type, zone) values( 'Kazan', 'C', 'Arabian-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Kuwait', 'A', 'Asia/Kuwait' )
go
insert into ujo_timezones (name, type, zone) values( 'Kwajalein', 'A', 'Pacific/Kwajalein' )
go
insert into ujo_timezones (name, type, zone) values( 'La_Paz', 'C', 'America/La_Paz' )
go
insert into ujo_timezones (name, type, zone) values( 'Lima', 'C', 'America/Lima' )
go
insert into ujo_timezones (name, type, zone) values( 'Lisbon', 'C', 'Europe/Lisbon' )
go
insert into ujo_timezones (name, type, zone) values( 'London', 'C', 'Europe/London' )
go
insert into ujo_timezones (name, type, zone) values( 'LosAngeles', 'C', 'US/Pacific' )
go
insert into ujo_timezones (name, type, zone) values( 'MET', 'Z', 'MET-1METDST,M3.5.0,M10.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'MST7MDT', 'Z', 'MST7MDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Madras', 'C', 'India' )
go
insert into ujo_timezones (name, type, zone) values( 'Madrid', 'C', 'Europe/Madrid' )
go
insert into ujo_timezones (name, type, zone) values( 'Magadan', 'C', 'Asia/Magadan' )
go
insert into ujo_timezones (name, type, zone) values( 'Malaysia', 'A', 'Asia/Singapore' )
go
insert into ujo_timezones (name, type, zone) values( 'Manila', 'C', 'Asia/Manila' )
go
insert into ujo_timezones (name, type, zone) values( 'MarshallIs', 'A', 'Fiji-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'MarshallIsland', 'A', 'Fiji-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Melbourne', 'C', 'Australia/Melbourne' )
go
insert into ujo_timezones (name, type, zone) values( 'MexicoCity', 'C', 'America/MexicoCity' )
go
insert into ujo_timezones (name, type, zone) values( 'Miami', 'C', 'US/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'Mid-Atlantic', 'Z', 'MGT2MGTDST,M3.5.0,M9.5.0' )
go
insert into ujo_timezones (name, type, zone) values( 'MidwayIs', 'A', 'Pacific/Midway' )
go
insert into ujo_timezones (name, type, zone) values( 'MidwayIsland', 'A', 'Pacific/Midway' )
go
insert into ujo_timezones (name, type, zone) values( 'Minneapolis', 'C', 'US/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'Monrovia', 'C', 'Africa/Monrovia' )
go
insert into ujo_timezones (name, type, zone) values( 'Montreal', 'C', 'Canada/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'Moscow', 'C', 'Europe/Moscow' )
go
insert into ujo_timezones (name, type, zone) values( 'Moscow-Z', 'Z', 'MSK-3MSD,M3.5.0,M9.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'MountainTime', 'A', 'US/Mountain' )
go
insert into ujo_timezones (name, type, zone) values( 'Muscat', 'C', 'Asia/Muscat' )
go
insert into ujo_timezones (name, type, zone) values( 'NZST-12', 'Z', 'NZS-12' )
go
insert into ujo_timezones (name, type, zone) values( 'NZST12', 'Z', 'NZS12' )
go
insert into ujo_timezones (name, type, zone) values( 'Nairobi', 'C', 'Asia/Nairobi' )
go
insert into ujo_timezones (name, type, zone) values( 'NewCaledonia', 'A', 'Pacific/Noumea' )
go
insert into ujo_timezones (name, type, zone) values( 'NewCaledonia-Z', 'Z', 'NCS-11' )
go
insert into ujo_timezones (name, type, zone) values( 'NewDelhi', 'C', 'India' )
go
insert into ujo_timezones (name, type, zone) values( 'NewYork', 'C', 'US/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'Newfoundland', 'A', 'Canada/Newfoundland' )
go
insert into ujo_timezones (name, type, zone) values( 'Omaha', 'C', 'US/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'Osaka', 'C', 'Tokyo-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Ottawa', 'C', 'Canada/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'PKT-5', 'Z', 'PKT-5' )
go
insert into ujo_timezones (name, type, zone) values( 'PST-8', 'Z', 'PST-8' )
go
insert into ujo_timezones (name, type, zone) values( 'PST8PDT', 'Z', 'PST8PDT' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Auckland', 'A', 'Auckland-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Fiji', 'A', 'Fiji-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Guam', 'Z', 'GST-10' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Honolulu', 'Z', 'HST10' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Kwajalein', 'Z', 'NZS12' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Midway', 'Z', 'SST11' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Noumea', 'A', 'NewCaledonia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Port_Moresby', 'Z', 'EST-10' )
go
insert into ujo_timezones (name, type, zone) values( 'Pacific/Samoa', 'Z', 'SST11' )
go
insert into ujo_timezones (name, type, zone) values( 'PacificTime', 'A', 'US/Pacific' )
go
insert into ujo_timezones (name, type, zone) values( 'Paris', 'C', 'Europe/Paris' )
go
insert into ujo_timezones (name, type, zone) values( 'Peking', 'C', 'Asia/Shanghai' )
go
insert into ujo_timezones (name, type, zone) values( 'Perth', 'C', 'Australia/Perth' )
go
insert into ujo_timezones (name, type, zone) values( 'Phoenix', 'C', 'US/Arizona' )
go
insert into ujo_timezones (name, type, zone) values( 'PortMoresby', 'C', 'Pacific/Port_Moresby' )
go
insert into ujo_timezones (name, type, zone) values( 'Prague', 'C', 'Europe/Prague' )
go
insert into ujo_timezones (name, type, zone) values( 'Pretoria', 'C', 'Africa-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Quebec', 'C', 'Canada/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'ROC', 'A', 'Asia/Taipei' )
go
insert into ujo_timezones (name, type, zone) values( 'ROK', 'Z', 'KST-9' )
go
insert into ujo_timezones (name, type, zone) values( 'Regina', 'C', 'America/Regina' )
go
insert into ujo_timezones (name, type, zone) values( 'RioDeJaneiro', 'C', 'America/Sao_Paulo' )
go
insert into ujo_timezones (name, type, zone) values( 'Riyadh', 'C', 'Asia/Riyadh' )
go
insert into ujo_timezones (name, type, zone) values( 'Rome', 'C', 'Europe/Rome' )
go
insert into ujo_timezones (name, type, zone) values( 'SAST-2', 'Z', 'SAS-2' )
go
insert into ujo_timezones (name, type, zone) values( 'SGT-8', 'Z', 'SGT-8' )
go
insert into ujo_timezones (name, type, zone) values( 'SST11', 'Z', 'SST11' )
go
insert into ujo_timezones (name, type, zone) values( 'Samoa', 'A', 'Pacific/Samoa' )
go
insert into ujo_timezones (name, type, zone) values( 'SanFrancisco', 'C', 'US/Pacific' )
go
insert into ujo_timezones (name, type, zone) values( 'Santiago', 'C', 'America/Santiago' )
go
insert into ujo_timezones (name, type, zone) values( 'SaoPaulo', 'C', 'America/Sao_Paulo' )
go
insert into ujo_timezones (name, type, zone) values( 'Sapporo', 'C', 'Tokyo-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Saskatchewan', 'A', 'Canada/Saskatchewan' )
go
insert into ujo_timezones (name, type, zone) values( 'Seattle', 'C', 'US/Pacific' )
go
insert into ujo_timezones (name, type, zone) values( 'Seoul', 'C', 'Asia/Seoul' )
go
insert into ujo_timezones (name, type, zone) values( 'Shanghai', 'C', 'Asia/Shanghai' )
go
insert into ujo_timezones (name, type, zone) values( 'Singapore', 'C', 'Asia/Singapore' )
go
insert into ujo_timezones (name, type, zone) values( 'SolomanIs', 'A', 'NewCaledonia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'SolomanIslands', 'A', 'NewCaledonia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'StJohns', 'A', 'Canada/St_Johns' )
go
insert into ujo_timezones (name, type, zone) values( 'StLouis', 'C', 'US/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'StPetersburg', 'C', 'Europe/St_Petersburg' )
go
insert into ujo_timezones (name, type, zone) values( 'Stockholm', 'C', 'Europe/Stockholm' )
go
insert into ujo_timezones (name, type, zone) values( 'Sverdlovsk', 'C', 'WestAsia-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Sydney', 'C', 'Australia/Sydney' )
go
insert into ujo_timezones (name, type, zone) values( 'Sydney-Z', 'Z', 'EST-10EST,M10.5.0,M3.1.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'Taipei', 'C', 'Asia/Taipei' )
go
insert into ujo_timezones (name, type, zone) values( 'Tashkent', 'C', 'Asia/Tashkent' )
go
insert into ujo_timezones (name, type, zone) values( 'Tbilisi', 'C', 'Asia/Tbilisi' )
go
insert into ujo_timezones (name, type, zone) values( 'Tegucigalpa', 'C', 'America/Tegucigalpa' )
go
insert into ujo_timezones (name, type, zone) values( 'Tehran', 'C', 'Asia/Tehran' )
go
insert into ujo_timezones (name, type, zone) values( 'Tehran-Z', 'Z', 'IST-3:30IDT,M3.5.0,M9.3.0' )
go
insert into ujo_timezones (name, type, zone) values( 'Tijuana', 'C', 'America/Tijuana' )
go
insert into ujo_timezones (name, type, zone) values( 'Tokyo', 'C', 'Asia/Tokyo' )
go
insert into ujo_timezones (name, type, zone) values( 'Tokyo-Z', 'Z', 'JST-9' )
go
insert into ujo_timezones (name, type, zone) values( 'Toronto', 'C', 'Canada/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'UCT', 'A', 'GMT+0' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Alaska', 'A', 'America/Anchorage' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Aleutian', 'A', 'America/Atka' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Arizona', 'A', 'America/Phoenix' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Central', 'Z', 'CST6CDT' )
go
insert into ujo_timezones (name, type, zone) values( 'US/East-Indiana', 'A', 'America/Fort_Wayne' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Eastern', 'Z', 'EST5EDT' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Hawaii', 'A', 'Pacific/Honolulu' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Mountain', 'Z', 'MST7MDT' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Pacific', 'Z', 'PST8PDT' )
go
insert into ujo_timezones (name, type, zone) values( 'US/Samoa', 'A', 'Pacific/Samoa' )
go
insert into ujo_timezones (name, type, zone) values( 'UTC', 'A', 'GMT+0' )
go
insert into ujo_timezones (name, type, zone) values( 'Universal', 'A', 'GMT+0' )
go
insert into ujo_timezones (name, type, zone) values( 'Urumqi', 'C', 'China-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'Vancouver', 'C', 'Canada/Pacific' )
go
insert into ujo_timezones (name, type, zone) values( 'Vienna', 'C', 'Europe/Vienna' )
go
insert into ujo_timezones (name, type, zone) values( 'Vladivostok', 'C', 'Europe/Vladivostok' )
go
insert into ujo_timezones (name, type, zone) values( 'Volgograd', 'C', 'Arabian-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'WET', 'Z', 'WET+0WETDST,M3.5.0,M9.5.0/03:00:00' )
go
insert into ujo_timezones (name, type, zone) values( 'WST-8', 'Z', 'WST-8' )
go
insert into ujo_timezones (name, type, zone) values( 'Warsaw', 'C', 'Europe/Warsaw' )
go
insert into ujo_timezones (name, type, zone) values( 'WashingtonDC', 'C', 'US/Eastern' )
go
insert into ujo_timezones (name, type, zone) values( 'Wellington', 'C', 'Auckland-Z' )
go
insert into ujo_timezones (name, type, zone) values( 'WestAsia-Z', 'Z', 'PKT-5' )
go
insert into ujo_timezones (name, type, zone) values( 'Winnipeg', 'C', 'Canada/Central' )
go
insert into ujo_timezones (name, type, zone) values( 'Yakutsk', 'C', 'Asia/Yakutsk' )
go
insert into ujo_timezones (name, type, zone) values( 'Zulu', 'Z', 'GMT+0' )
go
insert into ujo_timezones (name, type, zone) values( 'Zurich', 'C', 'Europe/Zurich' )
go
insert into ujo_timezones (name, type, zone) values( 'GMT0BST', 'Z', 'GMT+0BST,M3.5.0/01:00:00,M10.5.0' )
go

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14911227, getdate(), 1, 4, 'MODIFIED Patch Star 14911227 Autosys: Remove 2 alarms from ujo_int_codes and add 2' )
GO

COMMIT TRANSACTION 
GO


