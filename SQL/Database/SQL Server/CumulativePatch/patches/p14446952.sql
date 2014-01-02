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

/****************************************************************************************/
/*                                                                                      */
/* Patch Star 14446952 Autosys: Changes to table defaults                               */
/*                                                                                      */
/****************************************************************************************/

if exists (select * from sysobjects where name = 'ujo_external_dependency' and type = 'P')
begin
	drop procedure ujo_external_dependency
end
go

if exists (select * from sysobjects where name = 'ujo_charcodes' and type = 'U')
begin
	drop table ujo_charcodes
end
go

if exists (select * from sysobjects where name = 'ujo_machine_group' and type = 'U')
begin
	drop table ujo_machine_group
end
go

if exists (select * from sysobjects where name = 'ujo_alarm' and type = 'U')
begin
	drop table ujo_alarm
end
go
CREATE TABLE ujo_alarm (
       eoid               varchar(12) COLLATE !!sensitive NOT NULL,
       alarm              integer NULL,
       alarm_time         integer NULL,
       job_name           varchar(64) COLLATE !!sensitive NULL,
       joid               integer NULL,
       evt_num            integer NULL,
       state              integer NULL,
       the_user           varchar(60) COLLATE !!sensitive NULL,
       state_time         integer NULL,
       event_comment      varchar(255) COLLATE !!sensitive NULL,
       len                integer NULL,
       response           varchar(255) COLLATE !!sensitive NULL
)
go


CREATE UNIQUE CLUSTERED INDEX alarm_PUC ON ujo_alarm(eoid ASC)
go

if exists (select * from sysobjects where name = 'ujo_audit_info' and type = 'U')
begin
	drop table ujo_audit_info
end
go
CREATE TABLE ujo_audit_info (
       audit_info_num     integer NOT NULL,
       entity             varchar(80) COLLATE !!sensitive NOT NULL,
       time               integer NOT NULL,
       type               varchar(1) COLLATE !!sensitive NOT NULL
)
go


CREATE UNIQUE INDEX audit_info_PUC ON ujo_audit_info(audit_info_num ASC)
go

if exists (select * from sysobjects where name = 'ujo_audit_msg' and type = 'U')
begin
	drop table ujo_audit_msg
end
go
CREATE TABLE ujo_audit_msg (
       audit_info_num     integer NOT NULL,
       seq_no             integer NOT NULL,
       attribute          varchar(30) COLLATE !!sensitive NULL,
       value              varchar(4096) COLLATE !!sensitive NULL,
       is_edit            varchar(1) COLLATE !!sensitive NULL
)
go


CREATE UNIQUE CLUSTERED INDEX audit_msg_PUC ON ujo_audit_msg(audit_info_num ASC, seq_no ASC)
go

if exists (select * from sysobjects where name = 'ujo_avg_job_runs' and type = 'U')
begin
	drop table ujo_avg_job_runs
end
go
CREATE TABLE ujo_avg_job_runs (
       joid               integer NOT NULL,
       avg_runtime        integer NULL,
       num_runs           integer NULL
)
go


CREATE UNIQUE CLUSTERED INDEX avg_job_runs_PUC ON ujo_avg_job_runs(joid ASC)
go

if exists (select * from sysobjects where name = 'ujo_calendar' and type = 'U')
begin
	drop table ujo_calendar
end
go
CREATE TABLE ujo_calendar (
       name               varchar(30) COLLATE !!sensitive NOT NULL,
       cal_id             integer NOT NULL,
       day                datetime NOT NULL       
)
go


CREATE UNIQUE CLUSTERED INDEX calendar_PUC ON ujo_calendar(name ASC, day ASC)
go

if exists (select * from sysobjects where name = 'ujo_chase' and type = 'U')
begin
	drop table ujo_chase
end
go

CREATE TABLE ujo_chase (
       nstart             integer NOT NULL,
       joid               integer NOT NULL,
       eoid               varchar(12) COLLATE !!sensitive NULL,
       job_name           varchar(64)COLLATE !!sensitive NULL,
       job_type           char(1)COLLATE !!sensitive NULL,
       status             integer NULL,
       run_machine        varchar(80)COLLATE !!sensitive NULL,
       pid                integer NULL,
       jc_pid             integer NULL
)
go

CREATE UNIQUE CLUSTERED INDEX chase_PUC ON ujo_chase(nstart ASC, joid ASC, eoid ASC)
go


if exists (select * from sysobjects where name = 'ujo_chkpnt_rstart' and type = 'U')
begin
	drop table ujo_chkpnt_rstart
end
go
CREATE TABLE ujo_chkpnt_rstart (
       dest_machine       varchar(80) COLLATE !!sensitive NOT NULL,
       dest_app           varchar(20) COLLATE !!sensitive NOT NULL,
       as_evt_time        varchar(25) COLLATE !!sensitive NOT NULL,
       ubc_name           varchar(9) COLLATE !!sensitive NOT NULL,
       ubc_jobnumbr       varchar(15) COLLATE !!sensitive NOT NULL,
       ubc_sysid          varchar(65) COLLATE !!sensitive NULL,
       ubc_date           varchar(8) COLLATE !!sensitive NULL,
       ubc_time           varchar(9) COLLATE !!sensitive NULL,
       ubc_procid         varchar(9) COLLATE !!sensitive NULL,
       ubc_userid         varchar(33) COLLATE !!sensitive NULL,
       ubc_compcod        varchar(9) COLLATE !!sensitive NULL,
       ubc_jobname        varchar(65) COLLATE !!sensitive NULL,
       ubc_setname        varchar(65) COLLATE !!sensitive NULL,
       ubc_jobnumb        varchar(5) COLLATE !!sensitive NULL,
       ubc_server         varchar(8) COLLATE !!sensitive NULL,
       ubc_from_sysid     varchar(65) COLLATE !!sensitive NULL,
       enefill            float NULL,
       ubt_cputime        varchar(9) COLLATE !!sensitive NULL,
       ubt_errcod         varchar(9) COLLATE !!sensitive NULL
)
go


CREATE UNIQUE CLUSTERED INDEX chkpnt_rstart_PUC ON ujo_chkpnt_rstart(dest_machine ASC, dest_app ASC, 
              as_evt_time ASC, ubc_name ASC, ubc_jobnumbr ASC)
go

if exists (select * from sysobjects where name = 'ujo_config' and type = 'U')
begin
	drop table ujo_config
end
go
CREATE TABLE ujo_config (
       fld                varchar(30) COLLATE !!sensitive NOT NULL,
       code               char(1) COLLATE !!sensitive NOT NULL,
       text               varchar(30) COLLATE !!sensitive NULL
)
go

CREATE UNIQUE INDEX config_PUC ON ujo_config(fld ASC, code ASC) 
go

if exists (select * from sysobjects where name = 'ujo_cycle' and type = 'U')
begin
	drop table ujo_cycle
end
go
CREATE TABLE ujo_cycle (
       cycname            varchar(30) COLLATE !!sensitive NOT NULL,
       cycperiod          integer NOT NULL,
       cycperst           datetime NOT NULL,
       cycperen           datetime NOT NULL
)
go


CREATE UNIQUE CLUSTERED INDEX cycle_PUC ON ujo_cycle(cycname ASC, cycperiod ASC)
go


if exists (select * from sysobjects where name = 'ujo_event' and type = 'U')
begin
	drop table ujo_event
end
go
CREATE TABLE ujo_event (
       eoid               varchar(12) COLLATE !!sensitive NOT NULL,
       joid               integer NULL,
       job_name           varchar(64) COLLATE !!sensitive NULL,
       box_name           varchar(64) COLLATE !!sensitive NULL,
       AUTOSERV           varchar(30) COLLATE !!sensitive NULL,
       priority           integer NULL,
       event              integer NULL,
       status             integer NULL,
       alarm              integer NULL,
       event_time_gmt     integer NULL,
       exit_code          integer NULL,
       machine            varchar(80) COLLATE !!sensitive NULL,
       pid                integer NULL,
       jc_pid             integer NULL,
       run_num            integer NULL,
       ntry               integer NULL,
       text               varchar(255) COLLATE !!sensitive NULL,
       que_priority       integer NULL,
       stamp              datetime NULL,
       evt_num            integer NULL,
       que_status         integer NOT NULL,
       que_status_stamp   datetime NOT NULL
)
go

CREATE INDEX ujo_event_idx_01 ON ujo_event
(
       que_status                   ASC,
       priority                     ASC,
       stamp                        ASC
)
go

CREATE INDEX ujo_event_idx_02 ON ujo_event
(
       evt_num                      ASC
)
go

CREATE INDEX ujo_event_idx_03 ON ujo_event
(
       joid                         ASC,
       run_num                      ASC
)
go

CREATE INDEX ujo_event_idx_04 ON ujo_event
(
       event                        ASC,
       box_name                     ASC,
       run_num                      ASC
)
go

CREATE INDEX ujo_event_idx_05 ON ujo_event
(
       event_time_gmt               ASC,
       que_status                   ASC,
       que_status_stamp             ASC
)
go

CREATE INDEX ujo_event_idx_06 ON ujo_event
(
       joid                         ASC,
       que_status                   ASC
)
go
CREATE UNIQUE CLUSTERED INDEX event_PUC ON ujo_event(eoid ASC)
go

if exists (select * from sysobjects where name = 'ujo_ext_calendar' and type = 'U')
begin
	drop table ujo_ext_calendar
end
go
CREATE TABLE ujo_ext_calendar (
       name               varchar(30) COLLATE !!sensitive NOT NULL,
       cal_id             integer NOT NULL,
       as_work            char(7) COLLATE !!sensitive NULL,
       as_holcal          varchar(30) COLLATE !!sensitive NULL,
       as_cyccal          varchar(30) COLLATE !!sensitive NULL,
       as_hact            char(1) COLLATE !!sensitive NULL,
       as_nwact           char(1) COLLATE !!sensitive NULL,
       as_adj             integer NULL,
       as_datecon         varchar(255) COLLATE !!sensitive NULL
)
go


CREATE UNIQUE CLUSTERED INDEX ext_calendar_PUC ON ujo_ext_calendar(name ASC)
go


if exists (select * from sysobjects where name = 'ujo_glob' and type = 'U')
begin
	drop table ujo_glob
end
go
CREATE TABLE ujo_glob (
       glo_name           varchar(64) COLLATE !!sensitive NOT NULL,
       value              varchar(100) COLLATE !!sensitive NULL,
       value_set_time     integer NULL,
       owner              varchar(80) COLLATE !!sensitive NULL,
       permission         varchar(30) COLLATE !!sensitive NULL
)
go


CREATE UNIQUE CLUSTERED INDEX glob_PUC ON ujo_glob(glo_name ASC)
go

if exists (select * from sysobjects where name = 'ujo_globblob' and type = 'U')
begin
	drop table ujo_globblob
end
go
CREATE TABLE ujo_globblob (
       bname              varchar(64) COLLATE !!sensitive NOT NULL,
       value              image NULL,
       create_user        varchar(80) COLLATE !!sensitive NULL,
       create_stamp       datetime NULL,
       modify_user        varchar(80) COLLATE !!sensitive NULL,
       modify_stamp       datetime NULL
)
go

CREATE UNIQUE CLUSTERED INDEX globblob_PUC ON ujo_globblob(bname ASC) /* gecpi01 */
go

if exists (select * from sysobjects where name = 'ujo_intcodes' and type = 'U')
begin
	drop table ujo_intcodes
end
go
CREATE TABLE ujo_intcodes (
       fld                varchar(30) COLLATE !!sensitive NOT NULL,
       code               integer     NOT NULL,
       text               varchar(30) COLLATE !!sensitive NULL
)
go


CREATE UNIQUE CLUSTERED INDEX intcodes_PUC ON ujo_intcodes(fld ASC, code ASC)
go

if exists (select * from sysobjects where name = 'ujo_job' and type = 'U')
begin
	drop table ujo_job
end
go
CREATE TABLE ujo_job (
       joid               integer NOT NULL,
       job_name           varchar(64) COLLATE !!sensitive NOT NULL,
       job_type           char(1) COLLATE !!sensitive NOT NULL,
       box_joid           integer NULL,
       owner              varchar(80) COLLATE !!sensitive NULL,
       permission         varchar(30) COLLATE !!sensitive NULL,
       machine            varchar(80) COLLATE !!sensitive NULL,
       n_retrys           integer NULL,
       auto_hold          smallint NULL,
       command            varchar(255) COLLATE !!sensitive NULL,
       date_conditions    smallint NULL,
       days_of_week       varchar(80) COLLATE !!sensitive NULL,
       run_calendar       varchar(30) COLLATE !!sensitive NULL,
       exclude_calendar   varchar(30) COLLATE !!sensitive NULL,
       start_times        varchar(255) COLLATE !!sensitive NULL,
       start_mins         varchar(255) COLLATE !!sensitive NULL,
       run_window         varchar(20) COLLATE !!sensitive NULL,
       description        varchar(255) COLLATE !!sensitive NULL,
       term_run_time      integer NULL,
       box_terminator     smallint NULL,
       job_terminator     smallint NULL,
       std_in_file        varchar(255) COLLATE !!sensitive NULL,
       std_out_file       varchar(255) COLLATE !!sensitive NULL,
       std_err_file       varchar(255) COLLATE !!sensitive NULL,
       watch_file         varchar(255) COLLATE !!sensitive NULL,
       watch_file_min_size integer NULL,
       watch_interval     integer NULL,
       min_run_alarm      integer NULL,
       max_run_alarm      integer NULL,
       alarm_if_fail      smallint NULL,
       chk_files          varchar(255) COLLATE !!sensitive NULL,
       free_procs         integer NULL,
       profile            varchar(255) COLLATE !!sensitive NULL,
       heartbeat_interval integer NULL,
       job_load           integer NULL,
       priority           integer NULL,
       auto_delete        integer NULL,
       numero             integer NULL,
       max_exit_success   integer NULL,
       box_success        varchar(255) COLLATE !!sensitive NULL,
       box_failure        varchar(255) COLLATE !!sensitive NULL,
       send_notification  char(1) COLLATE !!sensitive NOT NULL,
       service_desk       integer NULL
)
go

CREATE UNIQUE INDEX ujo_job_idx_01 ON ujo_job
(
       job_name                     ASC,
       joid                         ASC
)
go

CREATE INDEX ujo_job_idx_02 ON ujo_job
(       
       box_joid                         ASC
)
go


CREATE UNIQUE CLUSTERED INDEX job_PUC ON ujo_job(joid ASC)
go

if exists (select * from sysobjects where name = 'ujo_job_cond' and type = 'U')
begin
	drop table ujo_job_cond
end
go
CREATE TABLE ujo_job_cond (
       cond_mode          integer NOT NULL,
       joid               integer NOT NULL,
       indx               integer NOT NULL,       
       type               char(1) COLLATE !!sensitive NULL,
       cond_job_name      varchar(64) COLLATE !!sensitive NULL,
       cond_job_AUTOSERV  varchar(30) COLLATE !!sensitive NULL,
       operator           char(2) COLLATE !!sensitive NULL,
       value              integer NULL,
       indx_ptr           integer NULL,
       test_glovalue      char(100) COLLATE !!sensitive NULL,
       lookback_secs      integer NULL,
       over_num           integer NULL
)
go

CREATE INDEX ujo_job_cond_idx_01 ON ujo_job_cond
(
       cond_mode                    ASC,       
       cond_job_name                ASC,
       joid                         ASC,
       over_num                     ASC
)
go

CREATE INDEX ujo_job_cond_idx_02 ON ujo_job_cond
(
       joid                         ASC,
       cond_mode                    ASC,
       over_num                     ASC
)
go

CREATE INDEX ujo_job_cond_idx_03 ON ujo_job_cond
(
       cond_job_name                ASC,
       type                         ASC,
       cond_job_AUTOSERV            ASC,
       joid                         ASC
)
go


CREATE UNIQUE CLUSTERED INDEX job_cond_PUC ON ujo_job_cond(cond_mode ASC, joid ASC, indx ASC, 
              over_num ASC)
go

if exists (select * from sysobjects where name = 'ujo_job_delete' and type = 'U')
begin
	drop table ujo_job_delete
end
go
CREATE TABLE ujo_job_delete (
       joid               integer NOT NULL,
       job_name           varchar(64) COLLATE !!sensitive NULL,
       stamp              integer NULL,
       owner              varchar(80) COLLATE !!sensitive NULL
)
go


CREATE UNIQUE CLUSTERED INDEX job_delete_PUC ON ujo_job_delete(joid ASC)
go

if exists (select * from sysobjects where name = 'ujo_job_runs' and type = 'U')
begin
	drop table ujo_job_runs
end
go
CREATE TABLE ujo_job_runs (
       joid               integer NULL,
       run_num            integer NULL,
       ntry               integer NULL,
       startime           integer NULL,
       endtime            integer NULL,
       status             integer NULL,
       exit_code          integer NULL,
       runtime            integer NULL,
       evt_num            integer NULL,
       machine            varchar(80) COLLATE !!sensitive NULL, /* Changed from not null to accept nulls */
       std_out_file       varchar(1024) COLLATE !!sensitive NULL,
       std_err_file       varchar(1024) COLLATE !!sensitive NULL,
       svcdesk_status     int,
       svcdesk_handle     varchar(32) COLLATE !!sensitive NULL
)
go

CREATE INDEX ujo_job_runs_idx_01 ON ujo_job_runs
(
       evt_num                      ASC
)
go

CREATE INDEX ujo_job_runs_idx_02 ON ujo_job_runs
(
       machine                      ASC
)
go

CREATE INDEX job_runs_PUC ON ujo_job_runs(joid ASC, run_num ASC, ntry ASC, machine ASC)
go

if exists (select * from sysobjects where name = 'ujo_jobblob' and type = 'U')
begin
	drop table ujo_jobblob
end
go
CREATE TABLE ujo_jobblob (
       joid               integer NOT NULL,
       type               char(1) COLLATE !!sensitive NOT NULL,
       sequence           integer NOT NULL,
       data               image NULL
)
go


CREATE UNIQUE CLUSTERED INDEX jobblob_PUC ON ujo_jobblob(joid ASC, type ASC, sequence ASC)
go


if exists (select * from sysobjects where name = 'ujo_keymaster' and type = 'U')
begin
	drop table ujo_keymaster
end
go
CREATE TABLE ujo_keymaster (
       hostid             varchar(32) COLLATE !!sensitive NOT NULL,
       hostname           varchar(64) COLLATE !!sensitive NOT NULL,
       product            varchar(31) COLLATE !!sensitive NOT NULL,
       type               char(1) COLLATE !!sensitive NOT NULL,
       server             char(12) COLLATE !!sensitive NOT NULL,
       dakey              varchar(255) COLLATE !!sensitive NOT NULL,
       not_used           varchar(16) COLLATE !!sensitive NOT NULL
)
go


CREATE UNIQUE INDEX keymaster_PUC ON ujo_keymaster(hostid ASC, hostname ASC,
              product ASC, type ASC, server ASC, dakey ASC, 
              not_used ASC)
go

if exists (select * from sysobjects where name = 'ujo_last_Eoid_counter' and type = 'U')
begin
	drop table ujo_last_Eoid_counter
end
go
CREATE TABLE ujo_last_Eoid_counter (
       counter            char(7) COLLATE !!sensitive NOT NULL
)
go

if exists (select * from sysobjects where name = 'ujo_machine' and type = 'U')
begin
	drop table ujo_machine
end
go

CREATE TABLE ujo_machine (
       name               varchar(80) COLLATE !!sensitive NOT NULL,
       parent_name        varchar(80) COLLATE !!sensitive NOT NULL,
       que_name           varchar(160) COLLATE !!sensitive NULL,
       type               char(1) COLLATE !!sensitive NULL,
       factor             float NULL,
       max_load           integer NULL,
       mstatus            char(1) COLLATE !!sensitive  NULL,
       last_good_ping     integer NULL
)
go

CREATE UNIQUE CLUSTERED INDEX machine_PUC ON ujo_machine(name ASC, parent_name ASC)
go

if exists (select * from sysobjects where name = 'ujo_monbro' and type = 'U')
begin
	drop table ujo_monbro
end
go
CREATE TABLE ujo_monbro (
       name               varchar(30) COLLATE !!sensitive NOT NULL,
       mon_mode           char(1) COLLATE !!sensitive NULL,
       do_output          char(1) COLLATE !!sensitive NULL,
       sound              smallint NULL,
       alarm_verif        smallint NULL,
       alarm              smallint NULL,
       all_events         smallint NULL,
       all_status         smallint NULL,
       running            smallint NULL,
       success            smallint NULL,
       failure            smallint NULL,
       terminate          smallint NULL,
       starting           smallint NULL,
       restart            smallint NULL,
       on_ice             smallint NULL,
       on_hold            smallint NULL,
       job_filter         char(1) COLLATE !!sensitive NULL,
       job_name           varchar(64) COLLATE !!sensitive NULL,
       currun             smallint NULL,
       after_time         varchar(20) COLLATE !!sensitive NULL,
       autoserv           varchar(30) COLLATE !!sensitive NULL
)
go


CREATE UNIQUE CLUSTERED INDEX monbro_PUC ON ujo_monbro(name ASC)
go

if exists (select * from sysobjects where name = 'ujo_msg_ack' and type = 'U')
begin
	drop table ujo_msg_ack
end
go
CREATE TABLE ujo_msg_ack (
       eoid               varchar(12) COLLATE !!sensitive NOT NULL,
       who                varchar(30) COLLATE !!sensitive NULL,
       timein             integer NULL,
       timeack            integer NULL,
       comm               varchar(80) COLLATE !!sensitive NULL
)
go


CREATE INDEX msg_ack_PC ON ujo_msg_ack(eoid ASC)
go

if exists (select * from sysobjects where name = 'ujo_next_oid' and type = 'U')
begin
	drop table ujo_next_oid
end
go
CREATE TABLE ujo_next_oid (
      oid                integer NULL,
      field              varchar(31) COLLATE !!sensitive NOT NULL
)
go


CREATE UNIQUE CLUSTERED INDEX next_oid_PUC ON ujo_next_oid(field ASC)
go


if exists (select * from sysobjects where name = 'ujo_proc_event' and type = 'U')
begin
	drop table ujo_proc_event
end
go
CREATE TABLE ujo_proc_event (
       eoid               varchar(12) COLLATE !!sensitive NOT NULL,
       joid               integer NULL,
       job_name           varchar(64) COLLATE !!sensitive NULL,
       box_name           varchar(64) COLLATE !!sensitive NULL,
       AUTOSERV           varchar(30) COLLATE !!sensitive NULL,
       priority           integer NULL,
       event              integer NULL,
       status             integer NULL,
       alarm              integer NULL,
       event_time_gmt     integer NULL,
       exit_code          integer NULL,
       machine            varchar(80) COLLATE !!sensitive NULL,
       pid                integer NULL,
       jc_pid             integer NULL,
       run_num            integer NULL,
       ntry               integer NULL,
       text               varchar(255) COLLATE !!sensitive NULL,
       que_priority       integer NULL,
       stamp              datetime NULL,
       evt_num            integer NULL,
       que_status         integer NOT NULL,
       que_status_stamp   datetime NOT NULL
)
go

CREATE INDEX ujo_proc_event_idx_01 ON ujo_proc_event
(
       que_status                   ASC,
       priority                     ASC,
       stamp                        ASC
)
go

CREATE INDEX ujo_proc_event_idx_02 ON ujo_proc_event
(
       evt_num                      ASC
)
go

CREATE INDEX ujo_proc_event_idx_03 ON ujo_proc_event
(
       joid                         ASC,
       run_num                      ASC
)
go

CREATE INDEX ujo_proc_event_idx_04 ON ujo_proc_event
(
       event                        ASC,
       box_name                     ASC,
       run_num                      ASC
)
go


CREATE UNIQUE CLUSTERED INDEX proc_event_PUC ON ujo_proc_event(eoid ASC)
go

if exists (select * from sysobjects where name = 'ujo_rep_daily' and type = 'U')
begin
	drop table ujo_rep_daily
end
go
CREATE TABLE ujo_rep_daily (
       hour                integer NOT NULL,
       hour_display        varchar(32) COLLATE !!sensitive NOT NULL,
       js_running_n       integer NULL,
       js_running_p       float NULL,
       js_starting_n      integer NULL,
       js_starting_p      float NULL,
       js_success_n       integer NULL,
       js_success_p       float NULL,
       js_failure_n       integer NULL,
       js_failure_p       float NULL,
       js_terminated_n    integer NULL,
       js_terminated_p    float NULL,
       js_onhold_n        integer NULL,
       js_onhold_p        float NULL,
       js_onice_n         integer NULL,
       js_onice_p         float NULL,
       js_inactive_n      integer NULL,
       js_inactive_p      float NULL,
       js_activated_n     integer NULL,
       js_activated_p     float NULL,
       js_restart_n       integer NULL,
       js_restart_p       float NULL,       
       jc_jrun_n          integer NULL,
       jc_jfail_n         integer NULL,
       jc_jforce_n        integer NULL,
       jc_jrestart_n      integer NULL,
       jc_quewait_n       integer NULL,
       jc_kill_n          integer NULL,
       jc_jedit_n         integer NULL,
       jc_svcdesk_n       integer NULL,
       jc_svcdesk_p       float   NULL,       
       ag_alarmres_n      float NULL,
       ac_alarm_n         integer NULL,
       ac_noresponse_n    integer NULL,
       ac_jobfail_n       integer NULL,
       ac_stjobfail_n     integer NULL,
       ac_maxretry_n      integer NULL,
       ac_maxrunt_n       integer NULL,
       ac_minrunt_n       integer NULL,
       ac_dbroll_n        integer NULL,
       ac_scroll_n        integer NULL,
       ac_schshut_n       integer NULL
)
go


CREATE UNIQUE CLUSTERED INDEX rep_daily_PUC ON ujo_rep_daily(hour ASC)
go

if exists (select * from sysobjects where name = 'ujo_rep_hourly' and type = 'U')
begin
	drop table ujo_rep_hourly
end
go
CREATE TABLE ujo_rep_hourly (
       hour               integer NOT NULL,
       hour_display       varchar(32) COLLATE !!sensitive NOT NULL,
       js_running_n       integer NULL,
       js_running_p       float NULL,
       js_starting_n      integer NULL,
       js_starting_p      float NULL,
       js_success_n       integer NULL,
       js_success_p       float NULL,
       js_failure_n       integer NULL,
       js_failure_p       float NULL,
       js_terminated_n    integer NULL,
       js_terminated_p    float NULL,
       js_onhold_n        integer NULL,
       js_onhold_p        float NULL,
       js_onice_n         integer NULL,
       js_onice_p         float NULL,
       js_inactive_n      integer NULL,
       js_inactive_p      float NULL,
       js_activated_n     integer NULL,
       js_activated_p     float NULL,
       js_restart_n       integer NULL,
       js_restart_p       float NULL,       
       jc_jrun_n          integer NULL,
       jc_jfail_n         integer NULL,
       jc_jforce_n        integer NULL,
       jc_jrestart_n      integer NULL,
       jc_quewait_n       integer NULL,
       jc_kill_n          integer NULL,
       jc_jedit_n         integer NULL,
       jc_svcdesk_n       integer NULL,
       jc_svcdesk_p       float   NULL,
       ag_alarmres_n      float NULL,
       ac_alarm_n         integer NULL,
       ac_noresponse_n    integer NULL,              
       ac_jobfail_n       integer NULL,
       ac_stjobfail_n     integer NULL,
       ac_maxretry_n      integer NULL,
       ac_maxrunt_n       integer NULL,
       ac_minrunt_n       integer NULL,              
       ac_dbroll_n        integer NULL,
       ac_scroll_n        integer NULL,
       ac_schshut_n       integer NULL
)
go


CREATE UNIQUE CLUSTERED INDEX rep_hourly_PUC ON ujo_rep_hourly(hour ASC)
go

if exists (select * from sysobjects where name = 'ujo_rep_monthly' and type = 'U')
begin
	drop table ujo_rep_monthly
end
go
CREATE TABLE ujo_rep_monthly (
       hour              integer NOT NULL,
       hour_display      varchar(32) COLLATE !!sensitive NOT NULL,
       js_running_n       integer NULL,
       js_running_p       float NULL,
       js_starting_n      integer NULL,
       js_starting_p      float NULL,
       js_success_n       integer NULL,
       js_success_p       float NULL,
       js_failure_n       integer NULL,
       js_failure_p       float NULL,
       js_terminated_n    integer NULL,
       js_terminated_p    float NULL,
       js_onhold_n        integer NULL,
       js_onhold_p        float NULL,
       js_onice_n         integer NULL,
       js_onice_p         float NULL,
       js_inactive_n      integer NULL,
       js_inactive_p      float NULL,
       js_activated_n     integer NULL,
       js_activated_p     float NULL,
       js_restart_n       integer NULL,
       js_restart_p       float NULL,       
       jc_jrun_n          integer NULL,
       jc_jfail_n         integer NULL,
       jc_jforce_n        integer NULL,
       jc_jrestart_n      integer NULL,
       jc_quewait_n       integer NULL,
       jc_kill_n          integer NULL,
       jc_jedit_n         integer NULL,
       jc_svcdesk_n       integer NULL,
       jc_svcdesk_p       float NULL,
       ag_alarmres_n      float NULL,
       ac_alarm_n         integer NULL,
       ac_noresponse_n    integer NULL,              
       ac_jobfail_n       integer NULL,
       ac_stjobfail_n     integer NULL,
       ac_maxretry_n      integer NULL,
       ac_maxrunt_n       integer NULL,
       ac_minrunt_n       integer NULL,              
       ac_dbroll_n        integer NULL,
       ac_scroll_n        integer NULL,
       ac_schshut_n       integer NULL
)
go


CREATE UNIQUE CLUSTERED INDEX rep_monthly_PUC ON ujo_rep_monthly(hour ASC)
go

if exists (select * from sysobjects where name = 'ujo_rep_weekly' and type = 'U')
begin
	drop table ujo_rep_weekly
end
go
CREATE TABLE ujo_rep_weekly (
       hour               integer NOT NULL,
       hour_display       varchar(32) COLLATE !!sensitive NOT NULL,
       js_running_n       integer NULL,
       js_running_p       float NULL,
       js_starting_n      integer NULL,
       js_starting_p      float NULL,
       js_success_n       integer NULL,
       js_success_p       float NULL,
       js_failure_n       integer NULL,
       js_failure_p       float NULL,
       js_terminated_n    integer NULL,
       js_terminated_p    float NULL,
       js_onhold_n        integer NULL,
       js_onhold_p        float NULL,
       js_onice_n         integer NULL,
       js_onice_p         float NULL,
       js_inactive_n      integer NULL,
       js_inactive_p      float NULL,
       js_activated_n     integer NULL,
       js_activated_p     float NULL,
       js_restart_n       integer NULL,
       js_restart_p       float NULL,       
       jc_jrun_n          integer NULL,
       jc_jfail_n         integer NULL,
       jc_jforce_n        integer NULL,
       jc_jrestart_n      integer NULL,
       jc_quewait_n       integer NULL,
       jc_kill_n          integer NULL,
       jc_jedit_n         integer NULL,
       jc_svcdesk_n       integer NULL,
       jc_svcdesk_p       float NULL,
       ag_alarmres_n      float NULL,
       ac_alarm_n         integer NULL,
       ac_noresponse_n    integer NULL,
       ac_jobfail_n       integer NULL,
       ac_stjobfail_n     integer NULL,
       ac_maxretry_n      integer NULL,
       ac_maxrunt_n       integer NULL,
       ac_minrunt_n       integer NULL,
       ac_dbroll_n        integer NULL,
       ac_scroll_n        integer NULL,
       ac_schshut_n       integer NULL
)
go


CREATE UNIQUE CLUSTERED INDEX rep_weekly_PUC ON ujo_rep_weekly(hour ASC)
go

if exists (select * from sysobjects where name = 'ujo_req_job' and type = 'U')
begin
	drop table ujo_req_job
end
go
CREATE TABLE ujo_req_job (
       job_name           varchar(64) COLLATE !!sensitive NOT NULL,
       req_AUTOSERV       varchar(4) COLLATE !!sensitive NOT NULL,
       req_job_name       varchar(64) COLLATE !!sensitive NOT NULL,
       pending_delete     char(1) COLLATE !!sensitive NULL,
       schd0005           varchar(7) COLLATE !!sensitive NULL,
       nsm_system_ID      varchar(64) COLLATE !!sensitive NOT NULL,
       nsm_jobset_ID      varchar(64) COLLATE !!sensitive NOT NULL,
       nsm_jobno_ID       varchar(4) COLLATE !!sensitive NOT NULL
)
go


CREATE UNIQUE CLUSTERED INDEX req_job_PUC ON ujo_req_job(job_name ASC, req_AUTOSERV ASC, 
              req_job_name ASC, nsm_system_ID ASC, 
              nsm_jobset_ID ASC, nsm_jobno_ID ASC)
go

if exists (select * from sysobjects where name = 'ujo_send_buffer' and type = 'U')
begin
	drop table ujo_send_buffer
end
go
CREATE TABLE ujo_send_buffer (
       eoid               varchar(12) COLLATE !!sensitive NOT NULL,
       serverdb           varchar(40) COLLATE !!sensitive NOT NULL,
       stamp              datetime NULL,
       send_status        integer NULL
)
go


CREATE UNIQUE CLUSTERED INDEX send_buffer_PUC ON ujo_send_buffer(eoid ASC, serverdb ASC)
go


/* Creating Views */
if exists (select * from sysobjects where name = 'ujo_eventvu' and type = 'V')
begin
	drop view ujo_eventvu
end
go

create view ujo_eventvu
as
select 	eoid, 
	stamp, 
	evt_num,
	joid,
	job_name, 
	box_name,
	AUTOSERV,
	event,
	ev.text eventtxt,
	status,
	s.text statustxt,
	alarm,
	a.text alarmtxt,
	event_time_gmt,
	exit_code, 
	que_status,
	que_status_stamp,
	run_num,
	ntry,
	e.text text,
	machine

from	ujo_event e, ujo_intcodes ev, ujo_intcodes s, ujo_intcodes a

where	e.event = ev.code and ev.fld='event'
and	e.status = s.code  and s.fld='status'
and	e.alarm  = a.code and a.fld='alarm'

go

if exists (select * from sysobjects where name = 'ujo_jobst' and type = 'V')
begin
	drop view ujo_jobst
end
go

CREATE VIEW  ujo_jobst
AS
SELECT j.*, status, status_time, run_num, ntry, appl_ntry, last_start,
	last_end,next_start,exit_code,run_machine, que_name,
	run_priority, next_priority, pid, jc_pid,time_ok,
	last_heartbeat
FROM	ujo_job j, ujo_job_status
WHERE j.joid = ujo_job_status.joid

go

if exists (select * from sysobjects where name = 'ujo_proc_eventvu' and type = 'V')
begin
	drop view ujo_proc_eventvu
end
go

create view ujo_proc_eventvu
as

select 	eoid, 
	stamp, 
	evt_num,
	joid,
	job_name, 
	box_name,
	AUTOSERV,
	event,
	ev.text eventtxt,
	status,
	s.text statustxt,
	alarm,
	a.text alarmtxt,
	event_time_gmt,
	exit_code, 
	que_status,
	que_status_stamp,
	run_num,
	ntry,
	e.text text,
	machine

from	ujo_proc_event e, ujo_intcodes ev, ujo_intcodes s, ujo_intcodes a

where	e.event = ev.code and ev.fld='event'
and	e.status = s.code  and s.fld='status'
and	e.alarm  = a.code and a.fld='alarm'

go



/************************ Grants ***********************/
/* Grant on tables */
grant select on ujo_alarm to  ujoadmin
go
grant update on ujo_alarm to  ujoadmin
go
grant delete on ujo_alarm to  ujoadmin
go
grant insert on ujo_alarm to  ujoadmin
go
grant select on ujo_audit_info to  ujoadmin
go
grant update on ujo_audit_info to  ujoadmin
go
grant delete on ujo_audit_info to  ujoadmin
go
grant insert on ujo_audit_info to  ujoadmin
go
grant select on ujo_audit_msg to  ujoadmin
go
grant update on ujo_audit_msg to  ujoadmin
go
grant delete on ujo_audit_msg to  ujoadmin
go
grant insert on ujo_audit_msg to  ujoadmin
go
grant select on ujo_avg_job_runs to  ujoadmin
go
grant update on ujo_avg_job_runs to  ujoadmin
go
grant delete on ujo_avg_job_runs to  ujoadmin
go
grant insert on ujo_avg_job_runs to  ujoadmin
go
grant select on ujo_calendar to  ujoadmin
go
grant update on ujo_calendar to  ujoadmin
go
grant delete on ujo_calendar to  ujoadmin
go
grant insert on ujo_calendar to  ujoadmin
go
grant select on ujo_ext_calendar to  ujoadmin
go
grant update on ujo_ext_calendar to  ujoadmin
go
grant delete on ujo_ext_calendar to  ujoadmin
go
grant insert on ujo_ext_calendar to  ujoadmin
go
grant select on ujo_chase to  ujoadmin
go
grant update on ujo_chase to  ujoadmin
go
grant delete on ujo_chase to  ujoadmin
go
grant insert on ujo_chase to  ujoadmin
go
grant select on ujo_chkpnt_rstart to  ujoadmin
go
grant update on ujo_chkpnt_rstart to  ujoadmin
go
grant delete on ujo_chkpnt_rstart to  ujoadmin
go
grant insert on ujo_chkpnt_rstart to  ujoadmin
go
grant select on ujo_config to  ujoadmin
go
grant update on ujo_config to  ujoadmin
go
grant delete on ujo_config to  ujoadmin
go
grant insert on ujo_config to  ujoadmin
go
grant select on ujo_cred to  ujoadmin
go
grant update on ujo_cred to  ujoadmin
go
grant  delete  on ujo_cred to  ujoadmin
go
grant insert on ujo_cred to  ujoadmin
go
grant select on ujo_cycle to  ujoadmin
go
grant update on ujo_cycle to  ujoadmin
go
grant delete on ujo_cycle to  ujoadmin
go
grant insert on ujo_cycle to  ujoadmin
go
grant select on ujo_event to  ujoadmin
go
grant update on ujo_event to  ujoadmin
go
grant delete on ujo_event to  ujoadmin
go
grant insert on ujo_event to  ujoadmin
go
grant select on ujo_ext_job to  ujoadmin
go
grant update on ujo_ext_job to  ujoadmin
go
grant delete on ujo_ext_job to  ujoadmin
go
grant insert on ujo_ext_job to  ujoadmin
go
grant select on ujo_glob to  ujoadmin
go
grant update on ujo_glob to  ujoadmin
go
grant delete on ujo_glob to  ujoadmin
go
grant insert on ujo_glob to  ujoadmin
go
grant select on ujo_globblob to  ujoadmin
go
grant update on ujo_globblob to  ujoadmin
go
grant delete on ujo_globblob to  ujoadmin
go
grant insert on ujo_globblob to  ujoadmin
go
grant select on ujo_intcodes to  ujoadmin
go
grant update on ujo_intcodes to  ujoadmin
go
grant delete on ujo_intcodes to  ujoadmin
go
grant insert on ujo_intcodes to  ujoadmin
go
grant select on ujo_job to  ujoadmin
go
grant update on ujo_job to  ujoadmin
go
grant delete on ujo_job to  ujoadmin
go
grant insert on ujo_job to  ujoadmin
go
grant select on ujo_job_cond to  ujoadmin
go
grant update on ujo_job_cond to  ujoadmin
go
grant delete on ujo_job_cond to  ujoadmin
go
grant insert on ujo_job_cond to  ujoadmin
go
grant select on ujo_job_delete to  ujoadmin
go
grant update on ujo_job_delete to  ujoadmin
go
grant delete on ujo_job_delete to  ujoadmin
go
grant insert on ujo_job_delete to  ujoadmin
go
grant select on ujo_job_runs to  ujoadmin
go
grant update on ujo_job_runs to  ujoadmin
go
grant delete on ujo_job_runs to  ujoadmin
go
grant insert on ujo_job_runs to  ujoadmin
go
grant select on ujo_job_status to  ujoadmin
go
grant update on ujo_job_status to  ujoadmin
go
grant delete on ujo_job_status to  ujoadmin
go
grant insert on ujo_job_status to  ujoadmin
go
grant select on ujo_jobblob to  ujoadmin
go
grant update on ujo_jobblob to  ujoadmin
go
grant delete on ujo_jobblob to  ujoadmin
go
grant insert on ujo_jobblob to  ujoadmin
go
grant select on ujo_jobtype to  ujoadmin
go
grant update on ujo_jobtype to  ujoadmin
go
grant delete on ujo_jobtype to  ujoadmin
go
grant insert on ujo_jobtype to  ujoadmin
go
grant select on ujo_keymaster to  ujoadmin
go
grant update on ujo_keymaster to  ujoadmin
go
grant delete on ujo_keymaster to  ujoadmin
go
grant insert on ujo_keymaster to  ujoadmin
go
grant select on ujo_last_eoid_counter to  ujoadmin
go
grant update on ujo_last_eoid_counter to  ujoadmin
go
grant delete on ujo_last_eoid_counter to  ujoadmin
go
grant insert on ujo_last_eoid_counter to  ujoadmin
go
grant select on ujo_machine to  ujoadmin
go
grant update on ujo_machine to  ujoadmin
go
grant delete on ujo_machine to  ujoadmin
go
grant insert on ujo_machine to  ujoadmin
go
grant select on ujo_monbro to  ujoadmin
go
grant update on ujo_monbro to  ujoadmin
go
grant delete on ujo_monbro to  ujoadmin
go
grant insert on ujo_monbro to  ujoadmin
go
grant select on ujo_msg_ack to  ujoadmin
go
grant update on ujo_msg_ack to  ujoadmin
go
grant delete on ujo_msg_ack to  ujoadmin
go
grant insert on ujo_msg_ack to  ujoadmin
go
grant select on ujo_next_oid to  ujoadmin
go
grant update on ujo_next_oid to  ujoadmin
go
grant delete on ujo_next_oid to  ujoadmin
go
grant insert on ujo_next_oid to  ujoadmin
go
grant select on ujo_overjob to  ujoadmin
go
grant update on ujo_overjob to  ujoadmin
go
grant delete on ujo_overjob to  ujoadmin
go
grant insert on ujo_overjob to  ujoadmin
go
grant select on ujo_proc_event to  ujoadmin
go
grant update on ujo_proc_event to  ujoadmin
go
grant delete on ujo_proc_event to  ujoadmin
go
grant insert on ujo_proc_event to  ujoadmin
go
grant select on ujo_rep_daily to  ujoadmin
go
grant update on ujo_rep_daily to  ujoadmin
go
grant delete on ujo_rep_daily to  ujoadmin
go
grant insert on ujo_rep_daily to  ujoadmin
go
grant select on ujo_rep_hourly to  ujoadmin
go
grant update on ujo_rep_hourly to  ujoadmin
go
grant delete on ujo_rep_hourly to  ujoadmin
go
grant insert on ujo_rep_hourly to  ujoadmin
go
grant select on ujo_rep_monthly to  ujoadmin
go
grant update on ujo_rep_monthly to  ujoadmin
go
grant delete on ujo_rep_monthly to  ujoadmin
go
grant insert on ujo_rep_monthly to  ujoadmin
go
grant select on ujo_rep_weekly to  ujoadmin
go
grant update on ujo_rep_weekly to  ujoadmin
go
grant delete on ujo_rep_weekly to  ujoadmin
go
grant insert on ujo_rep_weekly to  ujoadmin
go
grant select on ujo_req_job to  ujoadmin
go
grant update on ujo_req_job to  ujoadmin
go
grant delete on ujo_req_job to  ujoadmin
go
grant insert on ujo_req_job to  ujoadmin
go
grant select on ujo_restart to  ujoadmin
go
grant update on ujo_restart to  ujoadmin
go
grant delete on ujo_restart to  ujoadmin
go
grant insert on ujo_restart to  ujoadmin
go
grant select on ujo_send_buffer to  ujoadmin
go
grant update on ujo_send_buffer to  ujoadmin
go
grant delete on ujo_send_buffer to  ujoadmin
go
grant insert on ujo_send_buffer to  ujoadmin
go

/* Grant on views */
grant select on ujo_eventvu to  ujoadmin
go
grant select on ujo_jobst to  ujoadmin
go
grant select on ujo_proc_eventvu to  ujoadmin
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
insert into ujo_intcodes (fld, code, text) values('alarm', 530, 'MULTIPLE_EP_SHUTDOWN')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 531, 'BROKER_UNAVAILABLE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 532, 'MACHINE_UNAVAILABLE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 533, 'SERVICEDESK_FAILURE')
go
insert into ujo_intcodes (fld, code, text) values('alarm', 534, 'UNINOTIFY_FAILURE')
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
if not exists ( select * from ujo_next_run_num where run_num = 100 )
  insert into ujo_next_run_num (run_num) values ( 100 )
go

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14446952, getdate(), 1, 4, 'Patch Star 14446952 Autosys: Changes to table defaults' )
GO

COMMIT TRANSACTION 
GO
