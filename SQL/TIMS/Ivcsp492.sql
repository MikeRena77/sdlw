/*
SYCSP492.SQL
 ODBC catalog stored procedures for 4.9.2 Sybase SQL Server

Confidential property of Sybase, Inc.
(c) Copyright Sybase Inc., 1987, 1997.
All rights reserved.

Use, duplication, or disclosure by the United States Government
is subject to restrictions as set forth in FAR subparagraphs
52.227-19(a)-(d) for civilian agency contracts and DFARS
252.227-7013(c) (1) (ii) for Department of Defense contracts.
Sybase reserves all unpublished rights under the copyright
laws of the United States.
Sybase, Inc. 6475 Christie Avenue, Emeryville, CA 94608 USA.
*/

set nocount on
go

use master
go


if  (charindex('4.9.2', @@version) = 0)
begin
        print ""
        print ""
        print "Warning:"
        print ""
 print "These stored procedures should only be"
 print "installed on a 4.9.2 SQL Server"
 print ""
 print "You are installing them on a SQL Server version:"
 print @@version
        print ""
        print ""
end
go


dump tran master with truncate_only
go


if exists (select * from sysobjects
           where name = 'sp_configure' and sysstat & 7 = 4)
begin
    execute sp_configure 'update',1
end
print "Executing RECONFIGURE..."
reconfigure with override
go


/*
** If the catalog stored procedures already exist, drop them.
*/
if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_tables')
begin
        print "Dropping sp_tables"
        drop procedure sp_tables
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_statistics')
begin
        print "Dropping sp_statistics"
        drop procedure sp_statistics 
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_columns')
begin
        print "Dropping sp_columns"
        drop procedure sp_columns
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_fkeys')
begin
        print "Dropping sp_fkeys"
        drop procedure sp_fkeys 
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_pkeys')
begin
        print "Dropping sp_pkeys"
        drop procedure sp_pkeys 
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_stored_procedures')
begin
        print "Dropping sp_stored_procedures"
        drop procedure sp_stored_procedures 
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_sproc_columns')
begin
        print "Dropping sp_sproc_columns"
        drop procedure sp_sproc_columns 
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_table_privileges')
begin
        print "Dropping sp_table_privileges"
        drop procedure sp_table_privileges 
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_server_info')
begin
        print "Dropping sp_server_info"
        drop procedure sp_server_info 
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_datatype_info')
begin
        print "Dropping sp_datatype_info"
        drop procedure sp_datatype_info 
end
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_special_columns')
begin
        print "Dropping sp_special_columns"
        drop procedure sp_special_columns
end
go


if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_databases')
begin
        print "Dropping sp_databases"
        drop procedure sp_databases
end
go

dump tran master with truncate_only
go

/*
** If the tables already exist, drop and recrate them.
*/

/*
** spt_datatype_info_ext
*/
if (exists (select * from sysobjects
                where name = 'spt_datatype_info_ext' and type = 'U'))
begin
    print "Dropping table spt_datatype_info_ext"
    drop table spt_datatype_info_ext
end
go

print "Creating table spt_datatype_info_ext"
go

create table spt_datatype_info_ext
(
        user_type       smallint  not null,
        create_params   varchar(32) null
)
go

grant select on spt_datatype_info_ext to public
go


insert into spt_datatype_info_ext
        /* CHAR          user_type, create_params */
        values                   (1, "length" )

insert into spt_datatype_info_ext
        /* VARCHAR       user_type, create_params */
        values                   (2, "max length" )

insert into spt_datatype_info_ext
        /* BINARY        user_type, create_params */
        values                   (3, "length" )

insert into spt_datatype_info_ext
        /* VARBINARY     user_type, create_params */
        values                   (4, "max length" )

insert into spt_datatype_info_ext
        /* SYSNAME       user_type, create_params */
        values                   (18, "max length" )

go


/*
** spt_datatype_info
*/
if (exists (select * from sysobjects
                where name = 'spt_datatype_info' and type = 'U'))
begin
    print "Dropping table spt_datatype_info"
    drop table spt_datatype_info
end
go

print "Creating table spt_datatype_info"
go

create table spt_datatype_info
(
        ss_dtype           tinyint      not null,
        type_name          varchar(32)  not null,
        data_type          smallint     not null,
        data_precision     int          null,
        numeric_scale      smallint     null,
        numeric_radix      smallint     null,
        length             int          null,
        literal_prefix     varchar(32)  null,
        literal_suffix     varchar(32)  null,
        create_params      varchar(32)  null,
        nullable           smallint     not null,
        case_sensitive     smallint     not null,
        searchable         smallint     not null,
        unsigned_attribute smallint     null,
        money              smallint     not null,
 auto_increment     smallint     null,
        local_type_name    varchar(128) not null,
        aux                int          null
)
go

grant select on spt_datatype_info to public
go

/*
**      There is a complicated set of SQL used to deal with
**      the SQL Server Null data types (MONEYn, INTn, etc.)
**      ISNULL is the only conditional SQL Server function that can be used
**      to differentiate between these types depending on size.
**
**      The aux column in the above table is used to differentiate
**      the null data types from the non-null types.
**
**      The aux column contains NULL for the null data types and 0
**      for the non-null data types.
**
**      The following SQL returns the contents of the aux column (0)
**      for the non-null data types and returns a variable non-zero
**      value for the null data types.
**
**                       " I   I I FFMMDD"
**                       " 1   2 4 484848"
**      isnull(d.aux, ascii(substring("666AAA@@@CB??GG",
**      2*(d.ss_dtype%35+1)+2-8/c.length, 1))-60)
**
**      The '2*(d.ss_dtype%35+1)+2-8/c.length' selects a specific character of
**      the substring mask depending on the null data type and its size, i.e.
**      null MONEY4 or null MONEY8.  The character selected is then converted
**      to its binary value and an appropriate bias (i.e. 60) is subtracted to
**      return the correct non-zero value.      This value may be used as a
**      constant, i.e. ODBC data type, precision, scale, etc., or used as an
**      index with a substring to pick out a character string, i.e. type name.
**
**      The comments above the substring mask denote which character is
**      selected for each null data type, i.e. In (INTn), Fn (FLOATn),
**      Mn (MONEYn) and Dn (DATETIMn).
*/


declare @case smallint

select @case = 0
select @case = 1 where 'a' != 'A'

/* Local Binary */
insert into spt_datatype_info values
/* ss_type, name, data_type, prec, scale, rdx, len, prf, suf,
** cp, nul, case, srch, unsigned, money, auto, local, aux
*/
(45, "binary", -2, null, null, null, null, "0x", null,
        "length", 1, 0, 2, null, 0, null, "binary", 0)

/* Local Bit */
insert into spt_datatype_info values
(50, "bit", -7, 1, 0, 2, null, null, null,
 null, 0, 0, 2, null, 0, null, "bit", 0)

/* Local Char */
insert into spt_datatype_info values
(47, "char", 1, null, null, null, null, "'", "'",
"length", 1, @case, 3, null, 0, null, "char", 0)

/* Local Datetime */
insert into spt_datatype_info values
(61, "datetime", 11, 23, 3, 10, 16, "'", "'",
 null, 1, 0, 3, null, 0, null, "datetime", 0)

/* Local Smalldatetime */
insert into spt_datatype_info values
(58, "smalldatetime", 11, 16, 0, 10, 16, "'", "'",
null, 1, 0, 3, null, 0, null, "smalldatetime", 0)

/* Local Datetimn  sql server type is "datetimn" */
insert into spt_datatype_info values
(111, "smalldatetime", 0, 0, 0, 10, 0, "'", "'",
null, 1, 0, 3, null, 0, null, "datetime", null)

/* Decimal sql server type is "decimal" */
insert into spt_datatype_info values
(55, "decimal", 3, 38, 0, 10, 0, null, null,
"precision,scale", 1, 0, 2, 0, 0, 0, "decimal", 0)

/* Numeric sql server type is "numeric" */
insert into spt_datatype_info values
(63, "numeric", 2, 38, 0, 10, 0, null, null,
"precision,scale", 1, 0, 2, 0, 0, 0, "numeric", 0)

/* Local Float */
insert into spt_datatype_info values
(62, "float", 6, 15, null, 10, null, null, null,
null, 1, 0, 2, 0, 0, 0, "float", 0)

/* Local RealFloat   sql server type is "floatn" */
insert into spt_datatype_info values
(109, "float        real", 0, 0, null, 10, 0, null, null,
null, 1, 0, 2, 0, 0, 0, "real      float", null)

/* Local Real */
insert into spt_datatype_info values
(59, "real", 7, 7, null, 10, null, null, null,
null, 1, 0, 2, 0, 0, 0, "real", 0)

/* Local Smallmoney */
insert into spt_datatype_info values
(122, "smallmoney", 3, 10, 4, 10, null, "$", null,
null, 1, 0, 2, 0, 1, 0, "smallmoney", 0)

/* Local Int */
insert into spt_datatype_info values
(56, "int", 4, 10, 0, 10, null, null, null,
null, 1, 0, 2, 0, 0, 0, "int", 0)

/* Local Intn  sql server type is "intn" */
insert into spt_datatype_info values
(38, "smallint     tinyint", 0, 0, 0, 10, 0, null, null,
null, 1, 0, 2, 0, 0, 0, "tinyint   smallint", null)

/* Local Money */
insert into spt_datatype_info values
(60, "money", 3, 19, 4, 10, null, "$", null,
null, 1, 0, 2, 0, 1, 0, "money", 0)

/* Local Moneyn  sql server type is "moneyn" */
insert into spt_datatype_info values
(110, "smallmoney", 0, 0, 4, 10, 0, "$", null,
null, 1, 0, 2, 0, 1, 0, "smallmoneymoney", null)

/* Local Smallint */
insert into spt_datatype_info values
(52, "smallint", 5, 5, 0, 10, null, null, null,
null, 1, 0, 2, 0, 0, 0, "smallint", 0)

/* Local Text */
insert into spt_datatype_info values
(35, "text", -1, 2147483647, null, null, 2147483647, "'", "'",
null, 1, @case, 1, null, 0, null, "text", 0)

/* Local Varbinary */
insert into spt_datatype_info values
(37, "varbinary", -3, null, null, null, null, "0x", null,
"max length", 1, 0, 2, null, 0, null, "varbinary", 0)

/* Local Tinyint */
insert into spt_datatype_info values
(48, "tinyint", -6, 3, 0, 10, null, null, null,
null, 1, 0, 2, 1, 0, 0, "tinyint", 0)

/* Local Varchar */
insert into spt_datatype_info values
(39, "varchar", 12, null, null, null, null, "'", "'",
"max length", 1, @case, 3, null, 0, null, "varchar", 0)

/* Local Image */
insert into spt_datatype_info values
(34, "image", -4, 2147483647, null, null, 2147483647, "0x", null,
null, 1, 0, 1, null, 0, null, "image", 0)
go



dump tran master with truncate_only
go

/*
** spt_server_info
*/
if (exists (select * from sysobjects
                where name = 'spt_server_info' and type = 'U'))
begin
    print "Dropping table spt_server_info"
    drop table spt_server_info
end
go

print "Creating table spt_server_info"
go

create table spt_server_info (
          attribute_id          int,
          attribute_name        varchar(60),
          attribute_value       varchar(255))
go

insert into spt_server_info
        values (1, "DBMS_NAME", "SQL Server")
insert into spt_server_info
        values (2, "DBMS_VER", @@version)
insert into spt_server_info
        values (6, "DBE_NAME", "")
insert into spt_server_info
        values (10, "OWNER_TERM", "owner")
insert into spt_server_info
        values (11, "TABLE_TERM", "table")
insert into spt_server_info
        values (12, "MAX_OWNER_NAME_LENGTH", "30")
insert into spt_server_info
        values (16, "IDENTIFIER_CASE", "MIXED")
insert into spt_server_info
        values (15, "COLUMN_LENGTH", "30")
insert into spt_server_info
        values (13, "TABLE_LENGTH", "30")
insert into spt_server_info
        values (100, "USERID_LENGTH", "30")
insert into spt_server_info
        values (17, "TX_ISOLATION", "2")
insert into spt_server_info
        values (18, "COLLATION_SEQ", "")
insert into spt_server_info
        values (14, "MAX_QUAL_LENGTH", "30")
insert into spt_server_info
        values (101, "QUALIFIER_TERM", "database")
insert into spt_server_info
        values (19, "SAVEPOINT_SUPPORT", "Y")
insert into spt_server_info
        values (20, "MULTI_RESULT_SETS", "Y")
insert into spt_server_info
        values (102, "NAMED_TRANSACTIONS", "Y")
insert into spt_server_info
        values (103, "SPROC_AS_LANGUAGE", "Y")
insert into spt_server_info
        values (103, "REMOTE_SPROC", "Y")
insert into spt_server_info
        values (22, "ACCESSIBLE_TABLES", "Y")
insert into spt_server_info
        values (104, "ACCESSIBLE_SPROC", "Y")
insert into spt_server_info
        values (105, "MAX_INDEX_COLS", "16")
insert into spt_server_info
        values (106, "RENAME_TABLE", "Y")
insert into spt_server_info
        values (107, "RENAME_COLUMN", "Y")
insert into spt_server_info
        values (108, "DROP_COLUMN", "Y")
insert into spt_server_info
        values (109, "INCREASE_COLUMN_LENGTH", "N")
insert into spt_server_info
        values (110, "DDL_IN_TRANSACTION", "Y")
insert into spt_server_info
        values (111, "DESCENDING_INDEXES", "N")
insert into spt_server_info
        values (112, "SP_RENAME", "Y")
go

/*
** NOTE: the following applies to Microsoft changes, not Sybase.  Do not change
** for Sybase check-ins unless we are synchronizing with Microsoft changes.
**
** The last row in spt_server_info has been used as the version number of the
** file. The convention is jj.nn.dddd, where:
**      jj is the major version number ("01" now),
**      nn is the minor version number ("01" now), and
**      dddd is the date in the form of month and day (mmdd) of the date you
**      check in this file.  Add (current year-1991)*12 to the month to keep
**      in sync with the driver version numbers.  Checking in on Feb 5 1993
**      would mean setting the value to 01.01.2605.
**
*/
insert into spt_server_info
        values (500, "SYS_SPROC_VERSION", "01.01.7302")
go

grant select on spt_server_info to public
go

dump tran master with truncate_only
go



/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */
/* 10.0 1.1 06/16/93 sproc/tables */


print "Creating sp_tables"
go

create procedure sp_tables
@table_name  varchar(32)  = null,
@table_owner     varchar(32)  = null,
@table_qualifier varchar(32)  = null,
@table_type  varchar(100) = null
as

declare @msg varchar(90)
declare @type1 varchar(3)
declare @tableindex int

/* temp table */
if (@table_name like "#%" and
   db_name() != "tempdb")
begin
 /*
        ** Can return data about temp. tables only in tempdb
        */
 print "This may be a temporary object. Please execute procedure from tempdb."
 return(1)
end

/*
** Special feature #1: enumerate databases when owner and name
** are blank but qualifier is explicitly '%'.  
*/
if @table_qualifier = '%' and
 @table_owner = '' and
 @table_name = ''
begin 

 /*
 ** If enumerating databases 
 */
 select
  table_qualifier = name,
  table_owner = null,
  table_name = null,
  table_type = 'Database',

  /*
  ** Remarks are NULL 
  */
  remarks = convert(varchar(254),null)

  from master..sysdatabases

  /*
  ** eliminate MODEL database 
  */
  where name != 'model'
  order by table_qualifier
end

/*
** Special feature #2: enumerate owners when qualifier and name
** are blank but owner is explicitly '%'.
*/
else if @table_qualifier = '' and
 @table_owner = '%' and
 @table_name = ''
 begin 

  /*
  ** If enumerating owners 
  */
  select distinct
   table_qualifier = null,
   table_owner = user_name(uid),
   table_name = null,
   table_type = 'Owner',

  /*
  ** Remarks are NULL 
  */
  remarks = convert(varchar(254),null)

  from sysobjects
  order by table_owner
 end
 else
 begin 

  /*
  ** end of special features -- do normal processing 
  */
  if @table_qualifier is not null
  begin
   if db_name() != @table_qualifier
   begin
    if @table_qualifier = ''
    begin   

     /*
     ** If empty qualifier supplied
     ** Force an empty result set 
     */
     select @table_name = ''
     select @table_owner = ''
    end
    else
    begin

     /*
     ** If qualifier doesn't match current 
     ** database. 
     */
     print "Table qualifier must be name of current database."
     return 1
    end
   end
  end
  if @table_type is null
  begin 

   /*
   ** Select all ODBC supported table types 
   */
   select @type1 = 'SUV'
  end
  else
  begin
   /*
   ** TableType are case sensitive if CS server 
   */
   select @type1 = null

   /*
   ** Add System Tables 
   */
   if (charindex("'SYSTEM TABLE'",@table_type) != 0)
    select @type1 = @type1 + 'S'

   /*
   ** Add User Tables 
   */
   if (charindex("'TABLE'",@table_type) != 0)
    select @type1 = @type1 + 'U'

   /*
   ** Add Views 
   */
   if (charindex("'VIEW'",@table_type) != 0)
    select @type1 = @type1 + 'V'
  end
  if @table_name is null
  begin 

   /*
   ** If table name not supplied, match all 
   */
   select @table_name = '%'
  end
  else
  begin
   if (@table_owner is null) and 
      (charindex('%', @table_name) = 0)
   begin 

   /*
   ** If owner not specified and table is specified 
   */
    if exists (select * from sysobjects
     where uid = user_id()
     and id = object_id(@table_name)
     and (type = 'U' or type = 'V' 
      or type = 'S'))
    begin 

    /*
    ** Override supplied owner w/owner of table 
    */
     select @table_owner = user_name()
    end
   end
  end

  /*
  ** If no owner supplied, force wildcard 
  */
  if @table_owner is null 
   select @table_owner = '%'
  select
   table_qualifier = db_name(),
   table_owner = user_name(o.uid),
   table_name = o.name,
   table_type = rtrim ( 
     substring('SYSTEM TABLE            TABLE       VIEW       ',
     /*
     ** 'S'=0,'U'=2,'V'=3 
     */
     (ascii(o.type)-83)*12+1,12)),

   /*
   ** Remarks are NULL
   */
   remarks = convert(varchar(254),null)

  from sysusers u, sysobjects o
  where
   /* Special case for temp. tables.  Match ids */
   (o.name like @table_name or o.id=object_id(@table_name))
   and user_name(o.uid) like @table_owner

   /*
   ** Only desired types
   */
   and charindex(substring(o.type,1,1),@type1)! = 0 

   /*
   ** constrain sysusers uid for use in subquery 
   */
   and u.uid = user_id() 
  and (
  suser_id() = 1
  or o.uid = user_id()
  or ((select max(((sign(uid)*abs(uid-16383))*2)+(protecttype&1))
   from sysprotects p
   where p.id =* o.id
   /*
   ** get rows for public, current users, user's groups
   */
         and (p.uid = 0 or 
        p.uid = user_id() or 
        p.uid =* u.gid) 

   /*
   ** check for SELECT, EXECUTE privilege.
   */
    and (action in (193,224)))&1

   /*
   ** more magic...normalise GRANT
   ** and final magic...compare
   ** Grants.
   */
   ) = 1)
  order by table_type, table_qualifier, table_owner, table_name
end

go

grant execute on sp_tables to public
go

dump tran master with truncate_only
go


/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */


/*
** Sp_statistics returns statistics for the given table, passed as first 
** argument. A row is returned for the table and then for each index found
** in sysindexes, starting with lowest value index id in sysindexes and 
** proceeding through the highest value index.  
**
** Returned rows consist of the columns:
** table qualifier (database name), table owner, table name from sysobjects, 
** non_unique (0/1), index qualifier (same as table name), 
** index name from sysindexes, type (SQL_INDEX_CLUSTERED/SQL_INDEX_OTHER), 
** sequence in index, column name, collation (currently, this is always "A"), 
** table cardinality (row count), and number of pages used by table (doampg).
*/

print "Creating sp_statistics"
go

create procedure sp_statistics (
 @table_name  varchar(32),
 @table_owner  varchar(32) = null,
 @table_qualifier varchar(32) = null,
 @index_name  varchar(32) = '%',
 @is_unique   char(1) = 'N')
as
declare @indid   int
declare @lastindid  int
declare @full_table_name char(70)
declare @msg    varchar(250)

/*
** Verify table qualifier is name of current database.
*/
if @table_qualifier is not null
begin
 if db_name() != @table_qualifier
 begin /* If qualifier doesn't match current database */
  print "Table qualifier must be name of current database."
  return (1)
 end
end

if @@trancount > 0
begin
 raiserror 20001 "Catalog procedure sp_statistics can not be run in a transaction."
 return (1)
end

create table #TmpIndex(
 table_qualifier varchar(32),
 table_owner varchar(32),
 table_name varchar(32),
 index_qualifier varchar(32) null,
 index_name varchar(32) null,
 non_unique smallint null,
 type  smallint,
 seq_in_index smallint null,
 column_name varchar(32) null,
 collation char(1) null,
 index_id int null,
 cardinality int null,
 pages  int null,
 status  smallint)

/*
** Fully qualify table name.
*/
if @table_owner is null
begin /* If unqualified table name */
 select @full_table_name = @table_name
end
else
begin /* Qualified table name */
 select @full_table_name = @table_owner + '.' + @table_name
end

/*
** Start at lowest index id, while loop through indexes. 
** Create a row in #TmpIndex for every column in sysindexes, each is
** followed by an row in #TmpIndex with table statistics for the preceding
** index.
*/
select @indid = min(indid)
 from sysindexes
 where id = object_id(@full_table_name)
  and indid > 0
  and indid < 255

while @indid != NULL
begin
 insert #TmpIndex /* Add all columns that are in index */
 select
  db_name(),  /* table_qualifier */
  user_name(o.uid), /* table_owner    */
  o.name,   /* table_name    */
  o.name,   /* index_qualifier */
  x.name,   /* index_name    */
  0,   /* non_unique    */
  1,   /* SQL_INDEX_CLUSTERED */
  colid,   /* seq_in_index    */
  INDEX_COL(@full_table_name,indid,colid),/* column_name    */
  "A",   /* collation    */
  @indid,   /* index_id     */
  rowcnt(x.doampg), /* cardinality    */
  data_pgs(x.id,doampg), /* pages    */
  x.status  /* status    */
 from sysindexes x, syscolumns c, sysobjects o
 where x.id = object_id(@full_table_name)
  and x.id = o.id
  and x.id = c.id
  and c.colid < keycnt+(x.status&16)/16
  and x.indid = @indid

 /*
 ** Save last index and increase index id to next higher value.
 */
 select @lastindid = @indid
 select @indid = NULL

 select @indid = min(indid)
 from sysindexes
 where id = object_id(@full_table_name)
  and indid > @lastindid
  and indid < 255
end

update #TmpIndex
 set non_unique = 1
 where status&2 != 2 /* If non-unique index */

update #TmpIndex
 set
  type = 3,  /* SQL_INDEX_OTHER */
  cardinality = NULL,
  pages = NULL
 where index_id > 1  /* If non-clustered index */

/* 
** Now add row with table statistics 
*/
insert #TmpIndex
 select
  db_name(),   /* table_qualifier */
  user_name(o.uid),  /* table_owner    */
  o.name,    /* table_name    */
  null,    /* index_qualifier */
  null,    /* index_name    */
  null,    /* non_unique    */
  0,    /* SQL_table_STAT  */
  null,    /* seq_in_index */
  null,    /* column_name    */
  null,    /* collation    */
  0,    /* index_id     */
  rowcnt(x.doampg),  /* cardinality    */
  data_pgs(x.id,doampg),  /* pages    */
  0    /* status    */
 from sysindexes x, sysobjects o
 where o.id = object_id(@full_table_name)
  and x.id = o.id
  and (x.indid = 0 or x.indid = 1) 
 /*  
 ** If there are no indexes
 ** then table stats are in a row with indid = 0
 */

if @is_unique != 'Y' 
begin
 /* If all indexes desired */
 select
  table_qualifier,
  table_owner,
  table_name,
  non_unique,
  index_qualifier,
  index_name,
  type,
  seq_in_index,
  column_name,
  collation,
  cardinality,
  pages
 from #TmpIndex
 where index_name like @index_name  /* If matching name */
  or index_name is null  /* If SQL_table_STAT row */
 order by non_unique, type, index_name, seq_in_index
end
else 
begin
 /* else only unique indexes desired */
 select
  table_qualifier,
  table_owner,
  table_name,
  non_unique,
  index_qualifier,
  index_name,
  type,
  seq_in_index,
  column_name,
  collation,
  cardinality,
  pages
 from #TmpIndex
 where (non_unique = 0    /* If unique */
  or non_unique is NULL)  /* If SQL_table_STAT row */
  and (index_name like @index_name /* If matching name */
  or index_name is NULL)  /* If SQL_table_STAT row */
 order by non_unique, type, index_name, seq_in_index

end

drop table #TmpIndex

return (0)

go

grant execute on sp_statistics to public
go

dump tran master with truncate_only
go


/* Sccsid = "%Z% generic/sproc/%M% %I% %G% " */
/*      10.0        07/20/93        sproc/columns */
 

/* This is the version for servers which support UNION */

/* This routine is intended for support of ODBC connectivity.  Under no
** circumstances should changes be made to this routine unless they are
** to fix ODBC related problems.  All other users are at there own risk!
**
** Please be aware that any changes made to this file (or any other ODBC
** support routine) will require Sybase to recertify the SQL server as
** ODBC compliant.  This process is currently being managed internally
** by the "Interoperability Engineering Technology Solutions Group" here
** within Sybase.
*/

print "Creating sp_columns"
go

CREATE PROCEDURE sp_columns (
     @table_name  varchar(32),
     @table_owner  varchar(32) = null,
     @table_qualifier varchar(32) = null,
     @column_name  varchar(32) = null )
AS
    declare @msg      varchar(250)
    declare @full_table_name    char(70)
    declare @table_id int

    if @column_name is null /* If column name not supplied, match all */
 select @column_name = '%'

    /* Check if the current database is the same as the one provided */
    if @table_qualifier is not null
    begin
  if db_name() != @table_qualifier
  begin 
                        print "Table qualifier must be name of current database."
                        return (1)

  end
    end

    if @table_name is null
    begin /* If table name not supplied, match all */
  select @table_name = '%'
    end

    if @table_owner is null
    begin /* If unqualified table name */
  SELECT @full_table_name = @table_name
    end
    else
    begin /* Qualified table name */
  SELECT @full_table_name = @table_owner + '.' + @table_name
    end

    /* Get Object ID */
    SELECT @table_id = object_id(@full_table_name)


    /* If the table name parameter is valid, get the information */ 
    if ((charindex('%',@full_table_name) = 0) and
  (charindex('_',@full_table_name) = 0)  and
  @table_id != 0)
    begin
  /* 
  ** This block is for the case where there is no pattern
  ** matching required for the table name
  */
  SELECT /* INTn, FLOATn, DATETIMEn and MONEYn types */
   table_qualifier = DB_NAME(),
   table_owner = USER_NAME(o.uid),
   table_name = o.name,
   column_name = c.name,
   data_type = d.data_type+convert(smallint,
      isnull(d.aux,
      ascii(substring("666AAA@@@CB??GG",
      2*(d.ss_dtype%35+1)+2-8/c.length,1))
      -60)),
   type_name = rtrim(substring(d.type_name,
      1+isnull(d.aux,
      ascii(substring("III<<<MMMI<<A<A",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-60), 13)),
   "precision" = (isnull(convert(int, d.data_precision),
             convert(int,c.length)))
      +isnull(d.aux, convert(int,
      ascii(substring("???AAAFFFCKFOLS",
      2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
   length = isnull(convert(int, c.length), 
            convert(int, d.length)) +
        convert(int, isnull(d.aux,
      ascii(substring("AAA<BB<DDDHJSPP",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-64)),
   scale =  (convert(smallint, d.numeric_scale))
      +convert(smallint,
      isnull(d.aux,
      ascii(substring("<<<<<<<<<<<<<<?",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-60)),
   radix = d.numeric_radix,
   nullable = /* set nullability from status flag */
    convert(smallint, convert(bit, c.status&8)),
   remarks = convert(varchar(254),null), /* Remarks are NULL */
   ss_data_type = c.type,
   colid = c.colid
  FROM
   syscolumns c,
   sysobjects o,
   master.dbo.spt_datatype_info d,
   systypes t
  WHERE
   o.id = @table_id
   AND c.id = o.id
   /*
   ** We use syscolumn.usertype instead of syscolumn.type
   ** to do join with systypes.usertype. This is because
   ** for a column which allows null, type stores its
   ** Server internal datatype whereas usertype still
   ** stores its user defintion datatype.  For an example,
   ** a column of type 'decimal NULL', its usertype = 26,
   ** representing decimal whereas its type = 106 
   ** representing decimaln. nullable in the select list
   ** already tells user whether the column allows null.
   ** In the case of user defining datatype, this makes
   ** more sense for the user.
   */
   AND c.usertype = t.usertype
   AND t.type = d.ss_dtype
   AND c.name like @column_name
   AND d.ss_dtype IN (111, 109, 38, 110) /* Just *N types */
   AND c.usertype < 100  /* No user defined types */
  UNION
  SELECT /* All other types including user data types */
   table_qualifier = DB_NAME(),
   table_owner = USER_NAME(o.uid),
   table_name = o.name,
   column_name = c.name,
   data_type = d.data_type+convert(smallint,
      isnull(d.aux,
      ascii(substring("666AAA@@@CB??GG",
      2*(d.ss_dtype%35+1)+2-8/c.length,1))
      -60)),
   type_name = rtrim(substring(d.type_name,
      1+isnull(d.aux,
      ascii(substring("III<<<MMMI<<A<A",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-60), 13)),
   "precision" = (isnull(convert(int, d.data_precision), 
      convert(int,c.length)))
      +isnull(d.aux, convert(int,
      ascii(substring("???AAAFFFCKFOLS",
      2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
   length = isnull(convert(int, c.length), 
     convert(int, d.length)) +
        convert(int, isnull(d.aux,
      ascii(substring("AAA<BB<DDDHJSPP",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-64)),
   scale = (convert(smallint, d.numeric_scale)) +
      convert(smallint, isnull(d.aux,
      ascii(substring("<<<<<<<<<<<<<<?",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-60)),
   radix = d.numeric_radix,
   nullable = /* set nullability from status flag */
    convert(smallint, convert(bit, c.status&8)),
   remarks = convert(varchar(254),null), /* Remarks are NULL */
   ss_data_type = c.type,
   colid = c.colid
  FROM
   syscolumns c,
   sysobjects o,
   master.dbo.spt_datatype_info d,
   systypes t
  WHERE
   o.id = @table_id
   AND c.id = o.id
   /*
   ** We use syscolumn.usertype instead of syscolumn.type
   ** to do join with systypes.usertype. This is because
   ** for a column which allows null, type stores its
   ** Server internal datatype whereas usertype still
   ** stores its user defintion datatype.  For an example,
   ** a column of type 'decimal NULL', its usertype = 26,
   ** representing decimal whereas its type = 106 
   ** representing decimaln. nullable in the select list
   ** already tells user whether the column allows null.
   ** In the case of user defining datatype, this makes
   ** more sense for the user.
   */
   AND c.usertype = t.usertype
   /*
   ** We need a equality join with 
   ** master.dbo.spt_datatype_info here so that
   ** there is only one qualified row returned from 
   ** master.dbo.spt_datatype_info, thus avoiding
   ** duplicates.
   */
   AND t.type = d.ss_dtype
   AND c.name like @column_name
   AND (d.ss_dtype NOT IN (111, 109, 38, 110) /* No *N types */

    OR c.usertype >= 100) /* User defined types */

    ORDER BY colid
 end
 else
    begin
  /* 
  ** This block is for the case where there IS pattern
  ** matching done on the table name. 
  */
  if @table_owner is null /* If owner not supplied, match all */
   select @table_owner = '%'

  SELECT /* INTn, FLOATn, DATETIMEn and MONEYn types */
   table_qualifier = DB_NAME(),
   table_owner = USER_NAME(o.uid),
   table_name = o.name,
   column_name = c.name,
   data_type = d.data_type+convert(smallint,
      isnull(d.aux,
      ascii(substring("666AAA@@@CB??GG",
      2*(d.ss_dtype%35+1)+2-8/c.length,1))
      -60)),
   type_name = rtrim(substring(d.type_name,
      1+isnull(d.aux,
      ascii(substring("III<<<MMMI<<A<A",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-60), 13)),
   "precision" = (isnull(convert(int, d.data_precision),
              convert(int, c.length)))
      +isnull(d.aux, convert(int,
      ascii(substring("???AAAFFFCKFOLS",
      2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
   length = isnull(convert(int, c.length), 
     convert(int,d.length)) +
        convert(int, isnull(d.aux,
      ascii(substring("AAA<BB<DDDHJSPP",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-64)),
   scale = (convert(smallint, d.numeric_scale)) +
      convert(smallint, isnull(d.aux,
      ascii(substring("<<<<<<<<<<<<<<?",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-60)),
   radix = d.numeric_radix,
   nullable = /* set nullability from status flag */
    convert(smallint, convert(bit, c.status&8)),
   remarks = convert(varchar(254),null), /* Remarks are NULL */
   ss_data_type = c.type,
   colid = c.colid
  FROM
   syscolumns c,
   sysobjects o,
   master.dbo.spt_datatype_info d,
   systypes t
  WHERE
   o.name like @table_name
   AND user_name(o.uid) like @table_owner
   AND o.id = c.id
   /*
   ** We use syscolumn.usertype instead of syscolumn.type
   ** to do join with systypes.usertype. This is because
   ** for a column which allows null, type stores its
   ** Server internal datatype whereas usertype still
   ** stores its user defintion datatype.  For an example,
   ** a column of type 'decimal NULL', its usertype = 26,
   ** representing decimal whereas its type = 106 
   ** representing decimaln. nullable in the select list
   ** already tells user whether the column allows null.
   ** In the case of user defining datatype, this makes
   ** more sense for the user.
   */
   AND c.usertype = t.usertype
   AND t.type = d.ss_dtype
   AND o.type != 'P'
   AND c.name like @column_name
   AND d.ss_dtype IN (111, 109, 38, 110) /* Just *N types */
   AND c.usertype < 100
  UNION
  SELECT /* All other types including user data types */
   table_qualifier = DB_NAME(),
   table_owner = USER_NAME(o.uid),
   table_name = o.name,
   column_name = c.name,
   data_type = d.data_type+convert(smallint,
      isnull(d.aux,
      ascii(substring("666AAA@@@CB??GG",
      2*(d.ss_dtype%35+1)+2-8/c.length,1))
      -60)),
   type_name = rtrim(substring(d.type_name,
      1+isnull(d.aux,
      ascii(substring("III<<<MMMI<<A<A",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-60), 13)),
   "precision" = (isnull(convert(int, d.data_precision),
       convert(int,c.length)))
      +isnull(d.aux, convert(int,
      ascii(substring("???AAAFFFCKFOLS",
      2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
   length = isnull(convert(int, c.length), 
     convert(int, d.length)) +
        convert(int, isnull(d.aux,
      ascii(substring("AAA<BB<DDDHJSPP",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-64)),
   scale = (convert(smallint, d.numeric_scale)) +
      convert(smallint, isnull(d.aux,
      ascii(substring("<<<<<<<<<<<<<<?",
      2*(d.ss_dtype%35+1)+2-8/c.length,
      1))-60)),
   radix = d.numeric_radix,
   nullable = /* set nullability from status flag */
    convert(smallint, convert(bit, c.status&8)),
   remarks  = convert(varchar(254),null),
   ss_data_type = c.type,
   colid = c.colid
  FROM
   syscolumns c,
   sysobjects o,
   master.dbo.spt_datatype_info d,
   systypes t
  WHERE
   o.name like @table_name
   AND user_name(o.uid) like @table_owner
   AND o.id = c.id
   /*
   ** We use syscolumn.usertype instead of syscolumn.type
   ** to do join with systypes.usertype. This is because
   ** for a column which allows null, type stores its
   ** Server internal datatype whereas usertype still
   ** stores its user defintion datatype.  For an example,
   ** a column of type 'decimal NULL', its usertype = 26,
   ** representing decimal whereas its type = 106 
   ** representing decimaln. nullable in the select list
   ** already tells user whether the column allows null.
   ** In the case of user defining datatype, this makes
   ** more sense for the user.
   */
   AND c.usertype = t.usertype
   /*
   ** We need a equality join with 
   ** master.dbo.spt_datatype_info here so that
   ** there is only one qualified row returned from 
   ** master.dbo.spt_datatype_info, thus avoiding
   ** duplicates.
   */
   AND t.type = d.ss_dtype
   AND c.name like @column_name
   AND o.type != 'P'
   AND c.name like @column_name
   AND (d.ss_dtype NOT IN (111, 109, 38, 110) /* No *N types */

    OR c.usertype >= 100) /* User defined types */

  ORDER BY table_owner, table_name, colid
 end
 
 return(0)
                                               
go

grant execute on sp_columns to public
go

dump tran master with truncate_only
go

 
/* Sccsid = "%Z% generic/sproc/src/%M% %I% %G%" */

print "Creating sp_fkeys"
go

create procedure sp_fkeys( @pktable_name      varchar(32) = null,
                           @pktable_owner      varchar(32) = null,
                           @pktable_qualifier varchar(32) = null,
                           @fktable_name      varchar(32) = null,
                           @fktable_owner      varchar(32) = null,
                           @fktable_qualifier varchar(32) = null )
as
declare @order_by_pk int
 select  @order_by_pk = 0

 if (@pktable_name is null) and (@fktable_name is null)
 begin
  print "pk table name or fk table name must be given"
  return
 end

 if @fktable_qualifier is not null
 begin
  if db_name() != @fktable_qualifier
  begin
  print "Foreign Key Table qualifier must be name of current database"
   return
  end
 end
 if @pktable_qualifier is not null
 begin
  if db_name() != @pktable_qualifier
  begin
   print "Primary Key Table qualifier must be name of current database"
   return
  end
 end

 if @pktable_name is null
 begin
  select @pktable_name = '%'
  select @order_by_pk = 1
 end

 if @pktable_owner is null
  select @pktable_owner = '%'
 if @fktable_name is null
  select @fktable_name = '%'
 if @fktable_owner is null
  select @fktable_owner = '%'

 if @@trancount != 0
 begin
  raiserror 20001 "catalog procedure sp_fkeys can not be run in a transaction"
  return
 end

 create table #fkeys( pktable_qualifier varchar(32),
  pktable_owner  varchar(32),
  pktable_name  varchar(32),
  pkcolumn_name  varchar(32),
  fktable_qualifier varchar(32),
  fktable_owner  varchar(32),
  fktable_name  varchar(32),
  fkcolumn_name  varchar(32),
  key_seq    smallint)

 insert into #fkeys
  select
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.depid),
   object_name(k.depid),
   (select name from syscolumns where id = k.depid and colid = k.depkey1),
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.id),
   object_name(k.id),
   c.name,
   1
  from
   syskeys k,syscolumns c
  where
   c.id = k.id
   and k.type = 2
   and c.colid = key1

 if (@@rowcount    = 0)
  goto done

 insert into #fkeys
  select
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.depid),
   object_name(k.depid),
   (select name 
    from syscolumns
    where id = k.depid and colid = k.depkey2),
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.id),
   object_name(k.id),
   c.name,
   2
  from
   syskeys k,syscolumns c
  where
   c.id = k.id
   and k.type = 2
   and c.colid = key2

 if (@@rowcount = 0)
  goto done

 insert into #fkeys
  select
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.depid),
   object_name(k.depid),
   (select name
   from syscolumns
   where id = k.depid
   and colid = k.depkey3),
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.id),
   object_name(k.id),
   c.name,
   3
  from
   syskeys k,syscolumns c
  where
   c.id = k.id
   and k.type = 2
   and c.colid = key3

 if (@@rowcount = 0)
  goto done

 insert into #fkeys
  select
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.depid),
   object_name(k.depid),
   (select name
   from syscolumns
   where id = k.depid
   and colid = k.depkey4),
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.id),
   object_name(k.id),
   c.name,
   4
  from
   syskeys k,syscolumns c
  where
   c.id = k.id
   and k.type = 2
   and c.colid = key4

 if (@@rowcount = 0)
  goto done

 insert into #fkeys
  select
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.depid),
   object_name(k.depid),
   (select name
   from syscolumns
   where id = k.depid
   and colid = k.depkey5),
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.id),
   object_name(k.id),
   c.name,
   5
  from
   syskeys k,syscolumns c
  where
   c.id = k.id
   and k.type = 2
   and c.colid = key5
 
 if (@@rowcount = 0)
  goto done

 insert into #fkeys
  select
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.depid),
   object_name(k.depid),
   (select name
   from syscolumns
   where id = k.depid
   and colid = k.depkey6),
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.id),
   object_name(k.id),
   c.name,
   6
  from
   syskeys k,syscolumns c
  where
   c.id = k.id
   and k.type =2
   and c.colid = key6

 if (@@rowcount = 0)
  goto done

 insert into #fkeys
  select
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.depid),
   object_name(k.depid),
   (select name
   from syscolumns
   where id = k.depid
   and colid = k.depkey7),
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.id),
   object_name(k.id),
   c.name,
   7
  from
   syskeys k,syscolumns c
  where
   c.id = k.id
   and k.type = 2
   and c.colid = key7
 
 if (@@rowcount    = 0)
  goto done

 insert into #fkeys
  select
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.depid),
   object_name(k.depid),
   (select name
   from syscolumns
   where id = k.depid
   and colid = k.depkey8),
   db_name(),
   (select user_name(uid) from sysobjects o where o.id = k.id),
   object_name(k.id),
   c.name,
   8
  from
   syskeys k,syscolumns c
  where
   c.id = k.id
   and k.type = 2
   and c.colid = key8
 
 done:
  if @order_by_pk = 1
   select
    pktable_qualifier,
    pktable_owner,
    pktable_name,
    pkcolumn_name,
    fktable_qualifier,
    fktable_owner,
    fktable_name,
    fkcolumn_name,
    key_seq,
    update_rule = convert(smallint, null),
    delete_rule = convert(smallint,null)
   from #fkeys
   where fktable_name like @fktable_name
    and fktable_owner like @fktable_owner
    and pktable_name  like @pktable_name
    and pktable_owner like @pktable_owner
   order by pktable_qualifier,pktable_owner,pktable_name, key_seq
  else
   select
    pktable_qualifier,
    pktable_owner,
    pktable_name,
    pkcolumn_name,
    fktable_qualifier,
    fktable_owner,
    fktable_name,
    fkcolumn_name,
    key_seq,
    update_rule = convert(smallint,null),
    delete_rule = convert(smallint,null)
   from #fkeys
   where fktable_name like @fktable_name
    and fktable_owner like @fktable_owner
    and pktable_name  like @pktable_name
    and pktable_owner like @pktable_owner
   order by fktable_qualifier,fktable_owner,fktable_name, key_seq

go

grant execute on sp_fkeys to public
go

dump tran master with truncate_only
go


/* Sccsid = "%Z% generic/sproc/src/%M% %I% %G%" */

print "Creating sp_pkeys"
go

create procedure sp_pkeys
      @table_name  varchar(32),
      @table_owner  varchar(32) = null,
      @table_qualifier varchar(32) = null 
as
declare @msg varchar(255)
declare @keycnt smallint
declare @indexid smallint
declare @i int
declare @id int
declare @uid smallint
select @id = NULL


 set nocount on

 if (@@trancount != 0)
 begin
  /* if inside a transaction */
  /* catalog procedure sp_pkeys can not be run in a transaction.*/
  raiserror 20001 "Catalog procedure sp_pkeys can not be run in a transaction."
  return (1)
 end

 if @table_qualifier is not null
 begin
  if db_name() != @table_qualifier
  begin 
   /* if qualifier doesn't match current database */
   /* "table qualifier must be name of current database"*/
   print "Table qualifier must be name of current database."
   return (1)
  end
 end

 if @table_owner is null
 begin
  select @id = id , @uid = uid
  from sysobjects 
  where name = @table_name
   and uid = user_id()
  if (@id is null)
  begin
   select @id = id ,@uid = uid
   from sysobjects 
   where name = @table_name
   and uid = 1
  end
 end
 else
 begin
  select @id = id , @uid = uid
  from sysobjects 
  where name = @table_name and uid = user_id(@table_owner)
 end
 
 if (@id is null)
 begin 
  print "Object does not exist in this database."
  return (1)
 end

 create table #pkeys(
    table_qualifier varchar(32),
    table_owner     varchar(32),
    table_name      varchar(32),
    column_name     varchar(32),
    key_seq  smallint)

/*
**  now we search for primary key (only declarative) constraints
**  There is only one primary key per table.
*/

 select @keycnt = keycnt, @indexid = indid
 from   sysindexes
 where  id = @id
 and indid > 0 /* make sure it is an index */
 and status & 2 = 2 /* make sure it is a declarative constr */

/*
**  For non-clustered indexes, keycnt as returned from sysindexes is one
**  greater than the actual key count. So we need to reduce it by one to
**  get the actual number of keys.
*/

 if (@indexid >= 2)
 begin
  select @keycnt = @keycnt - 1
 end

 select @i = 1

 while @i <= @keycnt
 begin
  insert into #pkeys values
  (db_name(), user_name(@uid), @table_name, 
   index_col(@table_name, @indexid, @i), @i)
  select @i = @i + 1
 end

 select table_qualifier, table_owner, table_name, column_name, key_seq
 from #pkeys
 order by table_qualifier, table_owner, table_name, key_seq
 
 return (0)

go

grant execute on sp_pkeys to public
go

dump tran master with truncate_only
go


/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */


print "Creating sp_stored_procedures"
go

create procedure sp_stored_procedures
@sp_name varchar(36) = null, /* stored procedure name */
@sp_owner varchar(32) = null, /* stored procedure owner */
@sp_qualifier varchar(32) = null /* stored procedure qualifier; 
     ** For the SQL Server, the only valid
     ** values are NULL or the current 
     ** database name
     */
as

declare @msg varchar(90)

/* If qualifier is specified */
if @sp_qualifier is not null
begin
 /* If qualifier doesn't match current database */
 if db_name() != @sp_qualifier
 begin
  /* If qualifier is not specified */
  if @sp_qualifier = ''
  begin
   /* in this case, we need to return an empty 
   ** result set because the user has requested a 
   ** database with an empty name 
   */
   select @sp_name = ''
   select @sp_owner = ''
  end

  /* qualifier is specified and does not match current database */
  else
  begin 
   print "Stored procedure qualifier must be name of current database."
   return (1)
  end
 end
end

/* If procedure name not supplied, match all */
if @sp_name is null
begin  
 select @sp_name = '%'
end
else 
begin
 /* If owner name is not supplied, but procedure name is */ 
 if (@sp_owner is null) and (charindex('%', @sp_name) = 0)
 begin
  /* If procedure exists and is owned by the current user */
  if exists (select * 
      from sysobjects
      where uid = user_id()
    and name = @sp_name
    and type = 'P') /* Object type of Procedure */
  begin
   /* Set owner name to current user */
   select @sp_owner = user_name()
  end
 end
end

/* If procedure owner not supplied, match all */
if @sp_owner is null 
 select @sp_owner = '%'

/* 
** Retrieve the stored procedures and associated info on them
*/
select procedure_qualifier = db_name(),
 procedure_owner = user_name(o.uid),
 procedure_name = o.name +';'+ ltrim(str(p.number,5)),
 num_input_params = -1,  /* Constant since value unknown */
 num_output_params = -1,  /* Constant since value unknown */
 num_result_sets = -1,  /* Constant since value unknown */
 remarks = convert(varchar(254),null) /* Remarks are NULL */
from sysobjects o,sysprocedures p,sysusers u
where o.name like @sp_name
 and p.sequence = 0
 and user_name(o.uid) like @sp_owner
 and o.type = 'P'  /* Object type of Procedure */
 and p.id = o.id
 and u.uid = user_id()  /* constrain sysusers uid for use in 
     ** subquery 
     */

 and (suser_id() = 1   /* User is the System Administrator */
      or  o.uid = user_id() /* User created the object */
     /* here's the magic..select the highest 
     ** precedence of permissions in the 
     ** order (user,group,public)  
     */

      or  ((select max(((sign(uid)*abs(uid-16383))*2)+(protecttype&1))
          from sysprotects p
     where p.id =* o.id  /* outer join to correlate 
      ** with all rows in sysobjects 
      */
     and (p.uid = 0    /* get rows for public */
          or p.uid = user_id() /* current user */
          or p.uid =* u.gid)  /* users group */
        
            and (action in (193,224)) /* check for SELECT,EXECUTE 
      ** privilege 
      */
     )&1    /* more magic...normalize GRANT */
        ) = 1    /* final magic...compare Grants */
     )
order by procedure_qualifier, procedure_owner, procedure_name

go

grant execute on sp_stored_procedures to public
go

dump tran master with truncate_only
go


/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */

print "Creating sp_sproc_columns"
go

create procedure sp_sproc_columns
@procedure_name  varchar(36) = '%',  /* name of stored procedure  */
@procedure_owner  varchar(32) = null, /* owner of stored procedure */
@procedure_qualifier varchar(32) = null, /* name of current database  */
@column_name  varchar(32) = null /* col name or param name    */
as

declare @msg   varchar(250)
declare @group_num  int
declare @semi_position  int
declare @full_procedure_name char(70)
declare @procedure_id  int

/* If column name not supplied, match all */
if @column_name is null 
 select @column_name = '%'

/* The qualifier must be the name of current database or null */
if @procedure_qualifier is not null
begin
 if db_name() != @procedure_qualifier
 begin
 if @procedure_qualifier = ''
  begin
   /* in this case, we need to return an empty result 
   ** set because the user has requested a database with
   ** an empty name
   */
   select @procedure_name = ''
   select @procedure_owner = ''
  end
  else
  begin
   print "Table qualifier must be name of current database."
   return
  end
 end
end


/* first we need to extract the procedure group number, if one exists */
select @semi_position = charindex(';',@procedure_name)
if (@semi_position > 0)
begin /* If group number separator (;) found */
 select @group_num = convert(int,substring(@procedure_name, 
        @semi_position + 1, 2))
 select @procedure_name = substring(@procedure_name, 1, 
        @semi_position -1)
end
else
begin /* No group separator, so default to group number of 1 */
 select @group_num = 1
end

if @procedure_owner is null
begin /* If unqualified procedure name */
 select @full_procedure_name = @procedure_name
end
else
begin /* Qualified procedure name */
 select @full_procedure_name = @procedure_owner + '.' + @procedure_name
end

/* Get Object ID */
select @procedure_id = object_id(@full_procedure_name)

if ((charindex('%',@full_procedure_name) = 0) and
 (charindex('_',@full_procedure_name) = 0)  and
 @procedure_id != 0)
begin
/*
** this block is for the case where there is no pattern
** matching required for the table name
*/
 select /* INTn, FLOATn, DATETIMEn and MONEYn types */
  procedure_qualifier = db_name(),
  procedure_owner = user_name(o.uid),
  procedure_name = o.name +';'+ ltrim(str(c.number,5)),
  column_name = c.name,
  column_type = convert(smallint, 0),
  data_type = d.data_type
       +convert(smallint, 
         isnull(d.aux,
         ascii(substring("666AAA@@@CB??GG",
                  2*(d.ss_dtype%35+1)
           +2-8/c.length,
           1)) - 60)),
  type_name = rtrim(substring(d.type_name,
     1+isnull(d.aux,
          ascii(substring("III<<<MMMI<<A<A",
       2*(d.ss_dtype%35+1)
       +2-8/c.length,
              1)) - 60), 
         13)),
  "precision"= isnull(d.data_precision, convert(int,c.length))
        +isnull(d.aux, convert(int,
          ascii(substring("???AAAFFFCKFOLS",
                2*(d.ss_dtype%35+1)
         +2-8/c.length,1))
         -60)),
  length = isnull(d.length, convert(int,c.length))
    +convert(int, isnull(d.aux,
          ascii(substring("AAA<BB<DDDHJSPP",
                2*(d.ss_dtype%35
            +1)+2-8/c.length,
                   1))-64)),
  scale = d.numeric_scale +convert(smallint,
        isnull(d.aux,
          ascii(substring("<<<<<<<<<<<<<<?",
              2*(d.ss_dtype%35+1)
       +2-8/c.length,
              1))-60)),
  radix = d.numeric_radix,
  nullable = /* set nullability from status flag */
   convert(smallint, convert(bit, c.status&8)),
  remarks = convert(varchar(254),null), /* Remarks are NULL */
  ss_data_type = c.type,
  colid = c.colid
 from
  syscolumns c,
  sysobjects o,
  master.dbo.spt_datatype_info d,
  systypes t,
  sysprocedures p
 where
  o.id = @procedure_id
  and c.id = o.id
  and c.type = d.ss_dtype
  and c.name like @column_name
  and d.ss_dtype in (111, 109, 38, 110) /* Just *N types */
  and c.number = @group_num
 union
 select     /* All other types including user data types */
  procedure_qualifier = db_name(),
  procedure_owner = user_name(o.uid),
  procedure_name = o.name +';'+ ltrim(str(c.number,5)),
  column_name = c.name,
  column_type = convert(smallint, 0),

  /*   Map systypes.type to ODBC type          */
  /*   SS-Type "     1       " */
  /*      "33 3 3 4 44 5 5 2 5 55666"         */
  /*      "45 7 9 5 78 0 2 2 6 89012"             */
  data_type = convert(smallint,
          ascii(substring("8;<9<H<<<<<:<=6<5<A<?<@<GC?GD",
      t.type%34+1,1))-60),
  type_name = t.name,
  "precision"= isnull(d.data_precision, convert(int,c.length))
        +isnull(d.aux, convert(int,
          ascii(substring("???AAAFFFCKFOLS",
             2*(d.ss_dtype%35+1)
             +2-8/c.length,1))
             -60)),
  length = isnull(d.length, convert(int,c.length))
    +convert(int, isnull(d.aux,
          ascii(substring("AAA<BB<DDDHJSPP",
                   2*(d.ss_dtype%35
            +1)+2-8/c.length,
                   1))-64)),
  scale = d.numeric_scale +convert(smallint,
       isnull(d.aux,
         ascii(substring("<<<<<<<<<<<<<<?",
           2*(d.ss_dtype%35+1)
           +2-8/c.length,
           1))-60)),
  radix = d.numeric_radix,

  /* set nullability from status flag */
  nullable = convert(smallint, convert(bit, c.status&8)),
  remarks = convert(varchar(254),null), /* Remarks are NULL */
  ss_data_type = c.type,
  colid = c.colid
 from
  syscolumns c,
  sysobjects o,
  master.dbo.spt_datatype_info d,
  systypes t
 where
  o.id = @procedure_id
  and c.id = o.id
  and c.type = d.ss_dtype
  and c.usertype *= t.usertype
  and c.name like @column_name
  and c.number = @group_num
  and d.ss_dtype not in (111, 109, 38, 110) /* No *N types */

  order by colid
end
else
begin
 /* 
 ** this block is for the case where there IS pattern
 ** matching done on the table name
 */
 if @procedure_owner is null
  select @procedure_owner = '%'

 select /* INTn, FLOATn, DATETIMEn and MONEYn types */
  procedure_qualifier = db_name(),
  procedure_owner = user_name(o.uid),
  procedure_name = o.name +';'+ ltrim(str(c.number,5)),
  column_name = c.name,
  column_type = convert(smallint, 0),
  data_type = d.data_type+convert(smallint,
       isnull(d.aux,
          ascii(substring("666AAA@@@CB??GG",
                2*(d.ss_dtype%35+1)
         +2-8/c.length,1))
                -60)),
  type_name = rtrim(substring(d.type_name,
        1+isnull(d.aux,
          ascii(substring("III<<<MMMI<<A<A",
                       2*(d.ss_dtype%35+1)
         +2-8/c.length,
                1))-60), 13)),
  "precision"= isnull(d.data_precision, convert(int,c.length))
        +isnull(d.aux, convert(int,
          ascii(substring("???AAAFFFCKFOLS",
                 2*(d.ss_dtype%35+1)
          +2-8/c.length,1))
                 -60)),
  length = isnull(d.length, convert(int,c.length))
    +convert(int, isnull(d.aux,
          ascii(substring("AAA<BB<DDDHJSPP",
          2*(d.ss_dtype%35+1)
          +2-8/c.length,
          1))-64)),
  scale = d.numeric_scale +convert(smallint,
         isnull(d.aux,
          ascii(substring("<<<<<<<<<<<<<<?",
          2*(d.ss_dtype%35+1)
          +2-8/c.length,
          1))-60)),
  radix = d.numeric_radix,
  /* set nullability from status flag */
  nullable = convert(smallint, convert(bit, c.status&8)),
  remarks = convert(varchar(254),null), /* Remarks are NULL */
  ss_data_type = c.type,
  colid = c.colid
 from
  syscolumns c,
  sysobjects o,
  master.dbo.spt_datatype_info d,
  systypes t
 where
  o.name like @procedure_name
  and user_name(o.uid) like @procedure_owner
  and o.id = c.id
  and c.type = d.ss_dtype
  and c.name like @column_name
  and o.type = 'P'   /* Just Procedures */
  and d.ss_dtype in (111, 109, 38, 110) /* Just *N types */
 union
 select     /* All other types including user data types */
  procedure_qualifier = db_name(),
  procedure_owner = user_name(o.uid),
  procedure_name = o.name +';'+ ltrim(str(c.number,5)),
  column_name = c.name,
  column_type = convert(smallint, 0),
  /*   Map systypes.type to ODBC type       */
  /*   SS-Type  "     1       " */
  /*       "33 3 3 4 44 5 5 2 5 55666"  */
  /*       "45 7 9 5 78 0 2 2 6 89012"      */
  data_type = convert(smallint,
          ascii(substring("8;<9<H<<<<<:<=6<5<A<?<@<GC?GD",
            t.type%34+1,1))-60),
  type_name = t.name,
  "precision"= isnull(d.data_precision, convert(int,c.length))
        +isnull(d.aux, 
         convert(int,
          ascii(substring("???AAAFFFCKFOLS",
                        2*(d.ss_dtype%35+1)
          +2-8/c.length,1))
                -60)),
  length = isnull(d.length, convert(int,c.length))
    +convert(int,
      isnull(d.aux,
      ascii(substring("AAA<BB<DDDHJSPP",
                      2*(d.ss_dtype%35+1)
        +2-8/c.length,
                      1))-64)),
  scale = d.numeric_scale
   +convert(smallint,
     isnull(d.aux,
     ascii(substring("<<<<<<<<<<<<<<?",
                     2*(d.ss_dtype%35+1)
       +2-8/c.length,
                     1))-60)),
  radix = d.numeric_radix,
  /* set nullability from status flag */
  nullable = convert(smallint, convert(bit, c.status&8)),
  remarks = convert(varchar(254),null), /* Remarks are NULL */
  ss_data_type = c.type,
  colid = c.colid
 from
  syscolumns c,
  sysobjects o,
  master.dbo.spt_datatype_info d,
  systypes t
 where
  o.name like @procedure_name
  and user_name(o.uid) like @procedure_owner
  and o.id = c.id
  and c.type = d.ss_dtype
  and c.usertype *= t.usertype
  and o.type = 'P'      /* Just Procedures */
  and c.name like @column_name
  and d.ss_dtype not in (111, 109, 38, 110) /* No *N types */

 order by procedure_owner, procedure_name, colid
end

go

grant execute on sp_sproc_columns to public
go

dump tran master with truncate_only
go


/* Sccsid = "%Z% generic/sproc/src/%M% %I% %G%" */

print "Creating sp_table_privileges"
go

CREATE PROCEDURE sp_table_privileges (
                        @table_name  varchar(32),
                        @table_owner varchar(32) = null,
                        @table_qualifier varchar(32)= null)
as

    declare @table_id    int,
            @owner_id    int,
            @full_table_name char(70)


    if @table_qualifier is not null
    begin
        if db_name() != @table_qualifier
        begin
            print "Table qualifier must be name of current database"
            return
        end
    end
    if @table_owner is null
    begin
        SELECT @full_table_name = @table_name
    end
    else
    begin
        SELECT @full_table_name = @table_owner + '.' + @table_name
    end
    SELECT @table_id = object_id(@full_table_name)



    if @@trancount != 0
    begin
        raiserror 20001 "catalog procedure sp_table_privileges can not be run in
 a transaction"
        return
    end
    create table #table_privileges
            (table_qualifier         varchar(32),
            table_owner         varchar(32),
            table_name     varchar(32),
            grantor            varchar(32),
            grantee            varchar(32),
            select_privilege    int,
             insert_privilege    int,
             update_privilege    int,
             delete_privilege    int,
        is_grantable    varchar(3),
             uid                 int,
            gid                 int)

    insert into #table_privileges
    select distinct db_name(),
        user_name(o.uid),
        o.name,
        user_name(o.uid),
        u.name,
        0,
        0,
        0,
        0,
        'no',
        u.uid,
        u.gid
    from sysusers u, sysobjects o
    where o.id = @table_id
    and u.uid != u.gid

    /*
    ** now add row for table owner
    */
    if exists (
        select *
            from #table_privileges
            where grantor = grantee)
    begin
        update #table_privileges
            set select_privilege = 1,
               update_privilege = 1,
                insert_privilege = 1,
                 delete_privilege = 1,
           is_grantable = 'yes'
              where grantor = grantee
    end
    else
    begin
        insert into #table_privileges
        select  db_name(),
            user_name(o.uid),
            o.name,
            user_name(o.uid),
            user_name(o.uid),
            1,
            1,
            1,
            1,
            'yes',
            o.uid,
            u.gid
        from sysobjects o, sysusers u
        where o.id = @table_id
        and u.uid = o.uid
    end

    update #table_privileges
        set select_privilege = 1
        where exists (select * from sysprotects
            where id = @table_id
            and (#table_privileges.uid = uid
                or #table_privileges.gid = uid
                or uid = 0)
            and protecttype = 205
            and action = 193)
        and not exists (select * from sysprotects
            where id = @table_id
            and (#table_privileges.uid = uid
                or #table_privileges.gid = uid
                or uid = 0)
            and protecttype = 206
            and action = 193)


    update #table_privileges
        set insert_privilege = 1
        where exists (select * from sysprotects
            where id = @table_id
            and (#table_privileges.uid = uid
                or #table_privileges.gid = uid
                or uid = 0)
            and protecttype = 205
            and action = 195)
        and not exists (select * from sysprotects
            where id = @table_id
            and (#table_privileges.uid = uid
                or #table_privileges.gid = uid
                or uid = 0)
            and protecttype = 206
            and action = 195)

    update #table_privileges
        set delete_privilege = 1
        where exists (select * from sysprotects
            where id = @table_id
            and (#table_privileges.uid = uid
                or #table_privileges.gid = uid
                or uid = 0)
            and protecttype = 205
            and action = 196)
        and not exists (select * from sysprotects
            where id = @table_id
            and (#table_privileges.uid = uid
                or #table_privileges.gid = uid
                or uid = 0)
            and protecttype = 206
            and action = 196)




    update #table_privileges
        set update_privilege = 1
        where exists (select * from sysprotects
            where id = @table_id
            and (#table_privileges.uid = uid
                or #table_privileges.gid = uid
                or uid = 0)
            and protecttype = 205
            and action = 197)
        and not exists (select * from sysprotects
            where id = @table_id
            and (#table_privileges.uid = uid
                or #table_privileges.gid = uid
                or uid = 0)
            and protecttype = 206
            and action = 197)

    create table #table_priv2
        (table_qualifier         varchar(32),
            table_owner         varchar(32),
            table_name     varchar(32),
            grantor            varchar(32),
            grantee            varchar(32),
            privilege            varchar(32),
        is_grantable    varchar(3))

     insert into #table_priv2
     select
        table_qualifier,
            table_owner,
            table_name,
            grantor,
            grantee,
            'SELECT',
        is_grantable
        from #table_privileges
        where select_privilege = 1


     insert into #table_priv2
     select
        table_qualifier,
            table_owner,
            table_name,
            grantor,
            grantee,
            'INSERT',
        is_grantable
        from #table_privileges
        where insert_privilege = 1


     insert into #table_priv2
     select
        table_qualifier,
            table_owner,
            table_name,
            grantor,
            grantee,
            'DELETE',
        is_grantable
        from #table_privileges
        where delete_privilege = 1


     insert into #table_priv2
     select
        table_qualifier,
            table_owner,
            table_name,
            grantor,
            grantee,
            'UPDATE',
        is_grantable
        from #table_privileges
        where update_privilege = 1


    select * from #table_priv2
        order by privilege

go


grant execute on sp_table_privileges to public
go

dump tran master with truncate_only
go


/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */

print "Creating sp_server_info"
go

create procedure sp_server_info
@attribute_id int = NULL  /* optional attribute id */
as

declare @msg varchar(250)

set nocount on

/* If an attribute id was specified then just return the info for that
** attribute.
*/
if @attribute_id is not null
begin
 /* Verify that the attribute is valid. */
 if not exists ( select attribute_id 
  from master.dbo.spt_server_info
   where attribute_id = @attribute_id )
 begin
  print  "Attribute id %1! is not supported.", @attribute_id
  return (1)
 end

 select * from master.dbo.spt_server_info
  where attribute_id = @attribute_id
end

/* If no attribute was specified then return info for all supported
** attributes.
*/
else
begin
 select * from master.dbo.spt_server_info
end

return (0)

go

grant execute on sp_server_info to public
go

 


/* 
** Sccsid = "%Z% generic/sproc/%M% %I% %G%"
**
** History:
** 10.0 steven 1.1 07/13/93 sproc/src/datatype_info
**      Ported from MS catalog SP's
**
** Implementation Notes:
**  The messiness of 'sp_data_type_info' was to get around the
** problem of returning the correct lengths for user defined types.  The
** join on the type name ensures all user defined types are returned, but
** this puts a null in the data_type column.  By forcing an embedded
** select and correlating it with the current row in systypes, we get the
** correct data_type mapping even for user defined types.  
*/

print "Creating sp_datatype_info"
go

create procedure sp_datatype_info
@data_type int = 0   /* Provide datatype_info for type # */
as
 if (select @data_type) = 0
  select /* Real SQL Server data types */
   type_name = t.name,
   d.data_type,
   "precison" = isnull(d.data_precision, 
         convert(int,t.length)),
   d.literal_prefix,
   d.literal_suffix,
   e.create_params,
   d.nullable,
   d.case_sensitive,
   d.searchable,
   d.unsigned_attribute,
   d.money,
   d.auto_increment,
   d.local_type_name
  from  master.dbo.spt_datatype_info d, 
   master.dbo.spt_datatype_info_ext e, systypes t
  where
   d.ss_dtype = t.type
   and t.usertype *= e.user_type
       /* restrict results to "real" datatypes */
   and t.name not in ("nchar","nvarchar",
        "sysname","timestamp",
        "datetimn","floatn","intn","moneyn")
   and t.usertype < 100 /* No user defined types */
  UNION
  select /* SQL Server user data types */
   type_name = t.name,
   d.data_type,
   "precison" = isnull(d.data_precision, 
         convert(int,t.length)),
   d.literal_prefix,
   d.literal_suffix,
   e.create_params,
   d.nullable,
   d.case_sensitive,
   d.searchable,
   d.unsigned_attribute,
   d.money,
   d.auto_increment,
   t.name
  from  master.dbo.spt_datatype_info d, 
   master.dbo.spt_datatype_info_ext e, systypes t
  where
   d.ss_dtype = t.type
   and t.usertype *= e.user_type
       /* 
       ** Restrict to user defined types (value > 100)
       ** and Sybase user defined types (listed)
       */
   and (t.name in ("nchar","nvarchar",
         "sysname","timestamp")
       or t.usertype >= 100)      /* User defined types */
  order by d.data_type, type_name
 else
  select /* Real SQL Server data types */
   type_name = t.name,
   d.data_type,
   "precison" = isnull(d.data_precision, 
         convert(int,t.length)),
   d.literal_prefix,
   d.literal_suffix,
   e.create_params,
   d.nullable,
   d.case_sensitive,
   d.searchable,
   d.unsigned_attribute,
   d.money,
   d.auto_increment,
   d.local_type_name
  from  master.dbo.spt_datatype_info d, 
   master.dbo.spt_datatype_info_ext e, systypes t
  where
   data_type = @data_type
   and d.ss_dtype = t.type
   and t.usertype *= e.user_type
       /* restrict results to "real" datatypes */
   and t.name not in ("nchar","nvarchar",
        "sysname","timestamp",
        "datetimn","floatn","intn","moneyn")
   and t.usertype < 100 /* No user defined types */
  UNION
  select /* SQL Server and user data types */
   type_name = t.name,
   d.data_type,
   "precison" = isnull(d.data_precision, 
         convert(int,t.length)),
   d.literal_prefix,
   d.literal_suffix,
   e.create_params,
   d.nullable,
   d.case_sensitive,
   d.searchable,
   d.unsigned_attribute,
   d.money,
   d.auto_increment,
   t.name
  from  master.dbo.spt_datatype_info d, 
   master.dbo.spt_datatype_info_ext e, systypes t
  where
   data_type = @data_type
   and d.ss_dtype = t.type
   and t.usertype *= e.user_type
       /* 
       ** Restrict to user defined types (value > 100)
       ** and Sybase user defined types (listed)
       */
   and (t.name in ("nchar","nvarchar",
         "sysname","timestamp")
       or t.usertype >= 100)     /* User defined types */
  order by type_name
return (0)

go

grant execute on sp_datatype_info to public
go

dump tran master with truncate_only
go
 

/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */
/* 10.0 1.0 9 JUL 93 sproc/src/special_columns */


print "Creating sp_special_columns"
go

create procedure sp_special_columns (
     @table_name  varchar(32),
     @table_owner  varchar(32) = null,
     @table_qualifier varchar(32) = null,
     @col_type  char(1) = 'R' )
as
 declare @indid   int
 declare @table_id  int
 declare @dbname   char(30)
 declare @full_table_name char(70)
 declare @msg   char(70)

 /* get database name */
 select @dbname = db_name()

 /* we don't want a temp table unless we're in tempdb */
 if @table_name like "#%" and @dbname != "tempdb"
 begin 
  print "There is no table named %1! in the current database.", @table_name
  return (1)
 end

 if @table_qualifier is not null
 begin
  /* if qualifier doesn't match current database */
  if @dbname != @table_qualifier
  begin 
   print "Table qualifier must be name of current database."
   return (1)
  end
 end

 if @table_owner is null
 begin /* if unqualified table name */
  select @full_table_name = @table_name
 end
 else
 begin /* qualified table name */
  select @full_table_name = @table_owner + '.' + @table_name
 end

 /* get object ID */
 select @table_id = object_id(@full_table_name)

 if @col_type = 'V'
 begin /* if ROWVER, just run that query */
  select
   scope = convert(smallint, 0),
   column_name = c.name,
   data_type = d.data_type + convert(smallint,
     isnull(d.aux,
     ascii(substring("666AAA@@@CB??GG",
     2*(d.ss_dtype%35+1)+2-8/c.length,1))
     -60)),
   type_name = t.name,
   "precision" = isnull(d.data_precision,
     convert(int,c.length))
     + isnull(d.aux, convert(int,
     ascii(substring("???AAAFFFCKFOLS",
     2*(d.ss_dtype%35+1)+2-8/c.length,1))
     -60)),
   length = isnull(d.length, convert(int,c.length))
     + convert(int,
     isnull(d.aux,
     ascii(substring("AAA<BB<DDDHJSPP",
     2*(d.ss_dtype%35+1)+2-8/c.length, 1))
     -64)),
   scale = d.numeric_scale + convert(smallint,
     isnull(d.aux,
     ascii(substring("<<<<<<<<<<<<<<?",
     2*(d.ss_dtype%35+1)+2-8/c.length, 1))
     -60))
  from
   systypes t, syscolumns c, master.dbo.spt_datatype_info d
  where
   c.id = @table_id
   and c.type = d.ss_dtype
   and c.usertype = 80 /* TIMESTAMP */
   and t.usertype = 80 /* TIMESTAMP */
  return (0)
 end

 if @col_type != 'R'
 begin
  print "Illegal value for 'col_type' argument. Legal values are 'V' or 'R'."
  return (1)
 end

 /* ROWID, now find the id of the 'best' index for this table */

 select @indid = (
  select min(indid)
  from sysindexes
  where
   status & 2 = 2  /* if unique index */
   and id = @table_id
   and indid > 0)  /* eliminate table row */

  select
  scope = convert(smallint, 0),
  column_name = index_col(@full_table_name,indid,c.colid),
  data_type = d.data_type + convert(smallint,
     isnull(d.aux,
     ascii(substring("666AAA@@@CB??GG",
     2*(d.ss_dtype%35+1)+2-8/c2.length,1))
     -60)),
  type_name = rtrim(substring(d.type_name,
     1 + isnull(d.aux,
     ascii(substring("III<<<MMMI<<A<A",
     2*(d.ss_dtype%35+1)+2-8/c2.length, 1))
     -60), 13)),
  "precision" = isnull(d.data_precision, convert(int,c2.length))
     + isnull(d.aux, convert(int,
     ascii(substring("???AAAFFFCKFOLS",
     2*(d.ss_dtype%35+1)+2-8/c2.length,1))
     -60)),
  length = isnull(d.length, convert(int,c2.length))
     + convert(int, isnull(d.aux,
     ascii(substring("AAA<BB<DDDHJSPP",
     2*(d.ss_dtype%35+1)+2-8/c2.length, 1))
     -64)),
  scale = d.numeric_scale + convert(smallint,
     isnull(d.aux,
     ascii(substring("<<<<<<<<<<<<<<?",
     2*(d.ss_dtype%35+1)+2-8/c2.length, 1))
     -60))
 from
  sysindexes x,
  syscolumns c,
  master.dbo.spt_datatype_info d,
  systypes t,
  syscolumns c2 /* self-join to generate list of index
    ** columns and to extract datatype names */
 where
  x.id = @table_id
  and c2.name = index_col(@full_table_name, @indid,c.colid)
  and c2.id =x.id
  and c.id = x.id
  and c.colid < keycnt + (x.status & 16) / 16
  and x.indid = @indid
  and c2.type = d.ss_dtype
  and c2.usertype *= t.usertype

 return (0)

go

grant execute on sp_special_columns to public
go

dump tran master with truncate_only
go


/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */

print "Creating sp_databases"
go

create procedure sp_databases
as

 /* Use temporary table to sum up database size w/o using group by */
 create table #databases (
      database_name varchar(32),
      size int)

 /* Insert row for each database */
 insert into #databases
  select
   name,
   (select sum(size) from master.dbo.sysusages
    where dbid = d.dbid)
  from master.dbo.sysdatabases d

 select
   database_name,
    /* Convert from number of pages to K */
   database_size = size * (@@pagesize / 1024),
   remarks = convert(varchar(254),null) /* Remarks are NULL */
 from #databases

 return(0)
                                                      
go

grant execute on sp_databases to public
go

dump tran master with truncate_only
go

print "Done."
go
 
