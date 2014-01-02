%% ============================================================
%%   Database name:  PROJECT                                   
%%   DBMS name:      Sybase SQL Anywhere 5.5                   
%%   Created on:     14/11/1997  12:47                         
%% ============================================================

if exists(select 1 from sysdomain where domain_name='T_ID') then
   drop datatype T_ID
end if;

create datatype T_ID numeric(5)  
        check (
            @column >= 1);

if exists(select 1 from sysdomain where domain_name='T_MONNEY') then
   drop datatype T_MONNEY
end if;

create datatype T_MONNEY numeric(8,2)  ;

if exists(select 1 from sysdomain where domain_name='T_NAME') then
   drop datatype T_NAME
end if;

create datatype T_NAME char(30)  ;

if exists(select 1 from sysdomain where domain_name='T_PHONE') then
   drop datatype T_PHONE
end if;

create datatype T_PHONE char(12)  ;

if exists(select 1 from sysdomain where domain_name='T_SHORT_TEXT') then
   drop datatype T_SHORT_TEXT
end if;

create datatype T_SHORT_TEXT char(80)  ;

%% ============================================================
%%   Table: DIVISION                                           
%% ============================================================
create table ADMIN.DIVISION
(
    DIVNUM      T_ID                  not null,
    DIVNAME     T_NAME                not null,
    DIVADDR     T_SHORT_TEXT                  ,
    primary key (DIVNUM)
);

%% ============================================================
%%   Table: CUSTOMER                                           
%% ============================================================
create table PROJ.CUSTOMER
(
    CUSNUM      T_ID                  not null,
    CUSNAME     T_NAME                not null,
    CUSADDR     T_SHORT_TEXT          not null,
    CUSACT      T_SHORT_TEXT                  ,
    CUSTEL      T_PHONE                       ,
    CUSFAX      T_PHONE                       ,
    primary key (CUSNUM)
);

%% ============================================================
%%   Table: TEAM                                               
%% ============================================================
create table PROJ.TEAM
(
    TEANUM      T_ID                  not null,
    TEASPE      T_SHORT_TEXT                  ,
    primary key (TEANUM)
);

%% ============================================================
%%   Table: MATERIAL                                           
%% ============================================================
create table PROJ.MATERIAL
(
    MATNUM      T_ID                  not null,
    MATNAME     T_NAME                not null,
    MATTYPE     T_NAME                not null,
    primary key (MATNUM)
);

%% ============================================================
%%   Table: EMPLOYEE                                           
%% ============================================================
create table PROJ.EMPLOYEE
(
    EMPNUM      T_ID                  not null,
    EMP_EMPNUM  T_ID                          ,
    DIVNUM      T_ID                  not null,
    EMPFNAM     T_NAME                        ,
    EMPLNAM     T_NAME                not null,
    EMPFUNC     T_NAME                        ,
    EMPSAL      T_MONNEY                      ,
    primary key (EMPNUM),
    unique (EMPLNAM, EMPFNAM, EMPFUNC)
);

%% ============================================================
%%   Table: PROJECT                                            
%% ============================================================
create table PROJ.PROJECT
(
    PRONUM      T_ID                  not null,
    CUSNUM      T_ID                  not null,
    EMPNUM      T_ID                          ,
    ACTBEG      timestamp                     
        check (
            ACTBEG is null or ((activity.begindate < activity.enddate))),
    ACTEND      timestamp                     
        check (
            ACTEND is null or ((activity.begindate < activity.enddate))),
    PRONAME     T_NAME                not null,
    PROLABL     T_SHORT_TEXT                  ,
    primary key (PRONUM)
);

%% ============================================================
%%   Table: TASK                                               
%% ============================================================
create table PROJ.TASK
(
    PRONUM      T_ID                  not null,
    TSKNAME     T_NAME                not null,
    ACTBEG      timestamp                     
        check (
            ACTBEG is null or ((activity.begindate < activity.enddate))),
    ACTEND      timestamp                     
        check (
            ACTEND is null or ((activity.begindate < activity.enddate))),
    TSKCOST     T_MONNEY              not null,
    primary key (PRONUM, TSKNAME),
    check (
            (task.begindate < min(participate.begindate)
            and
            task.enddate < max(participate.enddate)))
);

%% ============================================================
%%   Table: PARTICIPATE                                        
%% ============================================================
create table PROJ.PARTICIPATE
(
    PRONUM      T_ID                  not null,
    TSKNAME     T_NAME                not null,
    EMPNUM      T_ID                  not null,
    PARBEG      timestamp                     
        check (
            PARBEG is null or (((task.begindate < min(participate.begindate)
            and
            task.enddate < max(participate.enddate)) and 
            (participate.begindate < participate.enddate)))),
    PAREND      timestamp                     
        check (
            PAREND is null or (((task.begindate < min(participate.begindate)
            and
            task.enddate < max(participate.enddate)) and 
            (participate.begindate < participate.enddate)))),
    primary key (PRONUM, TSKNAME, EMPNUM),
    check (
            ((task.begindate < min(participate.begindate)
            and
            task.enddate < max(participate.enddate)) and 
            (participate.begindate < participate.enddate)))
);

%% ============================================================
%%   Table: MEMBER                                             
%% ============================================================
create table PROJ.MEMBER
(
    TEANUM      T_ID                  not null,
    EMPNUM      T_ID                  not null,
    primary key (TEANUM, EMPNUM)
);

%% ============================================================
%%   Table: USED                                               
%% ============================================================
create table PROJ.USED
(
    MATNUM      T_ID                  not null,
    EMPNUM      T_ID                  not null,
    primary key (MATNUM, EMPNUM)
);

%% ============================================================
%%   Table: COMPOSE                                            
%% ============================================================
create table PROJ.COMPOSE
(
    MATNUM      T_ID                  not null,
    MAT_MATNUM  T_ID                  not null,
    primary key (MATNUM, MAT_MATNUM)
);

alter table PROJ.EMPLOYEE
    add foreign key FK_EMPLOYEE_CHIEF_EMPLOYEE (EMP_EMPNUM)
       references PROJ.EMPLOYEE (EMPNUM) on update restrict on delete restrict;

alter table PROJ.EMPLOYEE
    add foreign key FK_EMPLOYEE_BELONGS_T_DIVISION (DIVNUM)
       references ADMIN.DIVISION (DIVNUM) on update restrict on delete restrict;

alter table PROJ.PROJECT
    add foreign key FK_PROJECT_SUBCONTRA_CUSTOMER (CUSNUM)
       references PROJ.CUSTOMER (CUSNUM) on update restrict on delete restrict;

alter table PROJ.PROJECT
    add foreign key FK_PROJECT_IS_RESPON_EMPLOYEE (EMPNUM)
       references PROJ.EMPLOYEE (EMPNUM) on update restrict on delete restrict;

alter table PROJ.TASK
    add foreign key FK_TASK_BELONGS_T_PROJECT (PRONUM)
       references PROJ.PROJECT (PRONUM) on update restrict on delete restrict;

alter table PROJ.PARTICIPATE
    add foreign key FK_PARTICIP_WORKS_ON_EMPLOYEE (EMPNUM)
       references PROJ.EMPLOYEE (EMPNUM) on update restrict on delete restrict;

alter table PROJ.PARTICIPATE
    add foreign key FK_PARTICIP_IS_DONE_B_TASK (PRONUM, TSKNAME)
       references PROJ.TASK (PRONUM, TSKNAME) on update restrict on delete restrict;

alter table PROJ.MEMBER
    add foreign key FK_MEMBER_MEMBER_TEAM (TEANUM)
       references PROJ.TEAM (TEANUM) on update restrict on delete restrict;

alter table PROJ.MEMBER
    add foreign key FK_MEMBER_IS_MEMBER_EMPLOYEE (EMPNUM)
       references PROJ.EMPLOYEE (EMPNUM) on update restrict on delete restrict;

alter table PROJ.USED
    add foreign key FK_USED_USED_MATERIAL (MATNUM)
       references PROJ.MATERIAL (MATNUM) on update restrict on delete restrict;

alter table PROJ.USED
    add foreign key FK_USED_USES_EMPLOYEE (EMPNUM)
       references PROJ.EMPLOYEE (EMPNUM) on update restrict on delete restrict;

alter table PROJ.COMPOSE
    add foreign key FK_COMPOSE_COMPOSES_MATERIAL (MATNUM)
       references PROJ.MATERIAL (MATNUM) on update restrict on delete restrict;

alter table PROJ.COMPOSE
    add foreign key FK_COMPOSE_COMPOSED__MATERIAL (MAT_MATNUM)
       references PROJ.MATERIAL (MATNUM) on update restrict on delete restrict;

