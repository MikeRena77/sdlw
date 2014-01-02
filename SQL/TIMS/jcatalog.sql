/*
** Confidential property of Sybase, Inc.
** (c) Copyright Sybase, Inc. 1997.
** All rights reserved
*/

/*
** SQL Anywhere
** Aug 13th, 1997
** Requires Open Server Gateway that comes with SQL Anywhere 5.5.02 or   
higher
**
** Note: It looks like the trim function has a bug. A 'select trim(expression)'
**       still returns a lot of trailing blanks. So the ugly workaround with
**	 substring() is used. This lowers the performance.
*/

if (exists (select * from sysobjects
  where name = 'spt_datatype_info' and type = 'U'))
    drop table spt_datatype_info
go
create table spt_datatype_info
(
 ss_dtype    tinyint not null,
 TYPE_NAME          varchar(30)  not null,
 DATA_TYPE    smallint not null,
 typelength         int          not null,
 LITERAL_PREFIX     varchar(32)  null,
 LITERAL_SUFFIX     varchar(32)  null,
 CREATE_PARAMS      varchar(32)  null,
 NULLABLE           smallint     not null,
 CASE_SENSITIVE     smallint     not null,
 SEARCHABLE         smallint     not null,
 UNSIGNED_ATTRIBUTE smallint     null,
 FIXED_PREC_SCALE   smallint     not null,
 -- MONEY              smallint     not null,
 AUTO_INCREMENT     smallint     null,
 LOCAL_TYPE_NAME    varchar(128) not null,
 MINIMUM_SCALE    smallint null,
 MAXIMUM_SCALE    smallint null,
 SQL_DATA_TYPE    smallint null,
 SQL_DATETIME_SUB   smallint null,
 NUM_PREC_RADIX    smallint null
 -- INTERVAL_PRECISION smallint null
)
go

grant select on spt_datatype_info to PUBLIC
go

insert into spt_datatype_info values
(48, 'tinyint', -6, 3, NULL, NULL, NULL, 1, 0, 2, 1, 0, 0, 'tinyint',   
NULL, NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(34, 'image', -4, 2147483647, '0x', NULL, NULL, 1, 0, 1, NULL, 0, NULL,   
'image', NULL, NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(37, 'varbinary', -3, 255, '0x', NULL, 'max length', 1, 0, 2, NULL, 0,   
NULL, 'varbinary', NULL, NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(45, 'binary', -2, 255, '0x', NULL, 'length', 1, 0, 2, NULL, 0, NULL,   
'binary', NULL, NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(35, 'text', -1, 2147483647, '''', '''', NULL, 1, 1, 1, NULL, 0, NULL,   
'text', NULL, NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(47, 'char', 1, 255, '''', '''', 'length', 1, 1, 3, NULL, 0, NULL,   
'char', NULL, NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(63, 'numeric', 2, 38, NULL, NULL, 'precision,scale', 1, 0, 2, 0, 0, 0,   
'numeric', 0, 38, NULL, NULL, NULL)
insert into spt_datatype_info values
(55, 'decimal', 3, 38, NULL, NULL, 'precision,scale', 1, 0, 2, 0, 0, 0,   
'decimal', 0, 38, NULL, NULL, NULL)
insert into spt_datatype_info values
(60, 'money', 3, 12, '$', NULL, NULL, 1, 0, 2, 0, 1, 0, 'money', NULL,   
NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(122, 'smallmoney', 3, 8, '$', NULL, NULL, 1, 0, 2, 0, 1, 0,   
'smallmoney', NULL, NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(56, 'int', 4, 4, NULL, NULL, NULL, 1, 0, 2, 0, 0, 0, 'int', NULL, NULL,   
NULL, NULL, NULL)
insert into spt_datatype_info values
(52, 'smallint', 5, 2, NULL, NULL, NULL, 1, 0, 2, 0, 0, 0, 'smallint',   
NULL, NULL, NULL, NULL, NULL)
insert into spt_datatype_info values
(62, 'float', 8, 8, NULL, NULL, NULL, 1, 0, 2, 0, 0, 0, 'double', NULL,   
NULL, NULL, NULL, 10)
insert into spt_datatype_info values
(59, 'real', 7, 7, NULL, NULL, NULL, 1, 0, 2, 0, 0, 0, 'real', NULL,   
NULL, NULL, NULL, 10)
insert into spt_datatype_info values
(61, 'datetime', 93, 23, '''', '''', NULL, 1, 0, 3, NULL, 0, NULL,   
'datetime', NULL, NULL, 93, NULL, NULL)
insert into spt_datatype_info values
(58, 'smalldatetime', 93, 16, '''', '''', NULL, 1, 0, 3, NULL, 0, NULL,   
'smalldatetime', NULL, NULL, 93, NULL, NULL)
insert into spt_datatype_info values
(39, 'varchar', 12, 255, '''', '''', 'max length', 1, 1, 3, NULL, 0,   
NULL, 'varchar', NULL, NULL, NULL, NULL, NULL)
go

if exists (select * from sysobjects where name =
    'sp_jdbc_datatype_info')
    begin
        drop procedure sp_jdbc_datatype_info
    end
go
set option quoted_identifier = 'ON'
go
create procedure sp_jdbc_datatype_info
as
 select 
     TYPE_NAME,
     DATA_TYPE,
     typelength as "PRECISION",
     LITERAL_PREFIX,
     LITERAL_SUFFIX,
     CREATE_PARAMS,
     NULLABLE,
     CASE_SENSITIVE,
     SEARCHABLE,
     UNSIGNED_ATTRIBUTE,
     FIXED_PREC_SCALE,
     AUTO_INCREMENT,
     LOCAL_TYPE_NAME,
     MINIMUM_SCALE,
     MAXIMUM_SCALE,
     SQL_DATA_TYPE,
     SQL_DATETIME_SUB,
     NUM_PREC_RADIX
    -- INTERVAL_PRECISION
 from DBA.spt_datatype_info
 order by DATA_TYPE
return (0)
go

grant execute on sp_jdbc_datatype_info to PUBLIC
go
/*
** This script creates a table which is used by jCONNECT to
** obtain information on this specific server types implementation
** of the various static functions for which JDBC provides escape
** sequences.
**
** Each row has two columns.  Escape_name is the name of the
** static function escape.  Map_string is a string showing how the
** function call should be sent to the server.  %i is a placeholder
** for the i'th argument to the escape.  This numbering is used
** to support skipping arguments.  Reordering of arguments is NOT
** supported.  Thus, a map string of "foo(%2)" is ok (skips first
** argument) "foo(%2, %1)" is not ok, at least until the driver
** changes to support this.
**
** Don't include rows for unsupported functions.
**
** Three escapes, convert, timestampadd, and timestampdiff, have
** one argument which takes special constant values.  These constants
** may also need to be mapped.  Therefore, include one row for each
** possible constant value, using the concatenation of the function name
** and the constant value as the escape_name column.  E.g.:
** convertsql_binary, convertsql_bit, convertsql_char, etc.
** DO count the constant in figuring argument numbers.  Thus,
** timestampadd(sql_tsi_second, ts, ts) gets the map string
** 'dateadd(ss, %2, %3)')
**
** Use lower case for the escape name.  Use whatever case you
** need to for the map string.
**
*/
if exists (select * from sysobjects where name =
    'jdbc_function_escapes')
    begin
        drop table jdbc_function_escapes
    end
go

create table jdbc_function_escapes (escape_name varchar(40),
    map_string varchar(40))
go

grant select on jdbc_function_escapes to PUBLIC
go

/* don't bother inserting rows for unsupported functions
** insert into jdbc_function_escapes values ('mod', null)
** insert into jdbc_function_escapes values ('truncate', null)
** insert into jdbc_function_escapes values ('left', null)
** insert into jdbc_function_escapes values ('locate', null)
** insert into jdbc_function_escapes values ('replace', null)
** insert into jdbc_function_escapes values   
(timestampdiffsql_tsi_frac_second, null)
** insert into jdbc_function_escapes values   
(timestampaddsql_tsi_frac_second, null)
** insert into jdbc_function_escapes values ('convertsql_bigint', null)
** insert into jdbc_function_escapes values ('insert', null)
** insert into jdbc_function_escapes values ('space', null)
** insert into jdbc_function_escapes values ('user', null)
*/
insert into jdbc_function_escapes values ('abs', 'abs(%1)')
insert into jdbc_function_escapes values ('acos', 'acos(%1)')
insert into jdbc_function_escapes values ('asin', 'asin(%1)')
insert into jdbc_function_escapes values ('atan', 'atan(%1)')
insert into jdbc_function_escapes values ('atan2', 'atn2(%1, %2)')
insert into jdbc_function_escapes values ('ceiling', 'ceiling(%1)')
insert into jdbc_function_escapes values ('cos', 'cos(%1)')
insert into jdbc_function_escapes values ('cot', 'cot(%1)')
insert into jdbc_function_escapes values ('degrees', 'degrees(%1)')
insert into jdbc_function_escapes values ('exp', 'exp(%1)')
insert into jdbc_function_escapes values ('floor', 'floor(%1)')
insert into jdbc_function_escapes values ('log', 'log(%1)')
insert into jdbc_function_escapes values ('log10', 'log10(%1)')
insert into jdbc_function_escapes values ('pi', 'pi()')
insert into jdbc_function_escapes values ('power', 'power(%1, %2)')
insert into jdbc_function_escapes values ('radians', 'radians(%1)')
insert into jdbc_function_escapes values ('rand', 'rand(%1)')
insert into jdbc_function_escapes values ('round', 'round(%1, %2)')
insert into jdbc_function_escapes values ('sign', 'sign(%1)')
insert into jdbc_function_escapes values ('sin', 'sin(%1)')
insert into jdbc_function_escapes values ('sqrt', 'sqrt(%1)')
insert into jdbc_function_escapes values ('tan', 'tan(%1)')
insert into jdbc_function_escapes values ('ascii', 'ascii(%1)')
insert into jdbc_function_escapes values ('char', 'char(%1)')
insert into jdbc_function_escapes values ('concat', '%1 + %2')
insert into jdbc_function_escapes values ('difference', 'difference(%1,   
%2)')
insert into jdbc_function_escapes values ('length', 'length(%1)')
insert into jdbc_function_escapes values ('lcase', 'lower(%1)')
insert into jdbc_function_escapes values ('ltrim', 'ltrim(%1)')
insert into jdbc_function_escapes values ('repeat', 'replicate(%1, %2)')
insert into jdbc_function_escapes values ('right', 'right(%1, %2)')
insert into jdbc_function_escapes values ('rtrim', 'rtrim(%1)')
insert into jdbc_function_escapes values ('soundex', 'soundex(%1)')
insert into jdbc_function_escapes values ('substring', 'substring(%1, %2,   
%3)')
insert into jdbc_function_escapes values ('ucase', 'upper(%1)')
insert into jdbc_function_escapes values ('curdate', 'getdate()')
insert into jdbc_function_escapes values ('curtime', 'getdate()')
insert into jdbc_function_escapes values ('dayname', 'datename(dw, %1)')
insert into jdbc_function_escapes values ('dayofmonth',
    'datepart(dd, %1)')
insert into jdbc_function_escapes values ('dayofweek',
    'datepart(dw, %1)')
insert into jdbc_function_escapes values ('dayofyear',
    'datepart(dy, %1)')
insert into jdbc_function_escapes values ('hour', 'datepart(hh, %1)')
insert into jdbc_function_escapes values ('minute', 'datepart(mi, %1)')
insert into jdbc_function_escapes values ('month', 'datepart(mm, %1)')
insert into jdbc_function_escapes values ('monthname',
    'datename(mm, %1)')
insert into jdbc_function_escapes values ('now', 'getdate()')
insert into jdbc_function_escapes values ('quarter', 'datepart(qq, %1)')
insert into jdbc_function_escapes values ('second', 'datepart(ss, %1)')
insert into jdbc_function_escapes values ('timestampaddsql_tsi_second',
 'dateadd(ss, %2, %3)')
insert into jdbc_function_escapes values ('timestampaddsql_tsi_minute',
 'dateadd(mi, %2, %3)')
insert into jdbc_function_escapes values ('timestampaddsql_tsi_hour',
 'dateadd(hh, %2, %3)')
insert into jdbc_function_escapes values ('timestampaddsql_tsi_day',
 'dateadd(dd, %2, %3)')
insert into jdbc_function_escapes values ('timestampaddsql_tsi_week',
 'dateadd(wk, %2, %3)')
insert into jdbc_function_escapes values ('timestampaddsql_tsi_month',
 'dateadd(mm, %2, %3)')
insert into jdbc_function_escapes values ('timestampaddsql_tsi_quarter',
 'dateadd(qq, %2, %3)')
insert into jdbc_function_escapes values ('timestampaddsql_tsi_year',
 'dateadd(yy, %2, %3)')
insert into jdbc_function_escapes values ('timestampdiffsql_tsi_second',
 'datediff(ss, %2, %3)')
insert into jdbc_function_escapes values ('timestampdiffsql_tsi_minute',
 'datediff(mi, %2, %3)')
insert into jdbc_function_escapes values ('timestampdiffsql_tsi_hour',
 'datediff(hh, %2, %3)')
insert into jdbc_function_escapes values ('timestampdiffsql_tsi_day',
 'datediff(dd, %2, %3)')
insert into jdbc_function_escapes values ('timestampdiffsql_tsi_week',
 'datediff(wk, %2, %3)')
insert into jdbc_function_escapes values ('timestampdiffsql_tsi_month',
 'datediff(mm, %2, %3)')
insert into jdbc_function_escapes values ('timestampdiffsql_tsi_quarter',
 'datediff(qq, %2, %3)')
insert into jdbc_function_escapes values ('timestampdiffsql_tsi_year',
 'datediff(yy, %2, %3)')
insert into jdbc_function_escapes values ('week', 'datepart(wk, %1)')
insert into jdbc_function_escapes values ('year', 'datepart(yy, %1)')
insert into jdbc_function_escapes values ('database', 'db_name()')
insert into jdbc_function_escapes values ('ifnull', 'isnull(%1, %2)')
insert into jdbc_function_escapes values ('convertsql_binary',
 'convert(varbinary(255), %1)')
insert into jdbc_function_escapes values ('convertsql_bit',
    'convert(bit, %1)')
insert into jdbc_function_escapes values ('convertsql_char',
 'convert(varchar(255), %1)')
insert into jdbc_function_escapes values ('convertsql_date',
 'convert(datetime, %1)')
insert into jdbc_function_escapes values ('convertsql_decimal',
 'convert(decimal, %1)')
insert into jdbc_function_escapes values ('convertsql_double',
 'convert(double, %1)')
insert into jdbc_function_escapes values ('convertsql_float',
 'convert(double, %1)')
insert into jdbc_function_escapes values ('convertsql_integer',
 'convert(int, %1)')
insert into jdbc_function_escapes values ('convertsql_longvarbinary',
 'convert(image, %1)')
insert into jdbc_function_escapes values ('convertsql_longvarchar',
 'convert(text, %1)')
insert into jdbc_function_escapes values ('convertsql_real',
 'convert(real, %1)')
insert into jdbc_function_escapes values ('convertsql_smallint',
 'convert(smallint, %1)')
insert into jdbc_function_escapes values ('convertsql_time',
 'convert(datetime, %1)')
insert into jdbc_function_escapes values ('convertsql_timestamp',
 'convert(datetime, %1)')
insert into jdbc_function_escapes values ('convertsql_tinyint',
 'convert(tinyint, %1)')
insert into jdbc_function_escapes values ('convertsql_varbinary',
 'convert(varbinary(255), %1)')
insert into jdbc_function_escapes values ('convertsql_varchar',
 'convert(varchar(255), %1)')
go

commit
go

if exists (select * from sysobjects where name =
    'sp_jdbc_function_escapes')
    begin
        drop procedure sp_jdbc_function_escapes
    end
go

create procedure sp_jdbc_function_escapes
as
    select * from DBA.jdbc_function_escapes

go

grant execute on sp_jdbc_function_escapes to PUBLIC
go

/*
**   sp_jdbc_tables
**
*/

if exists (select * from sysobjects where name = 'sp_jdbc_tables')
begin
    drop procedure sp_jdbc_tables
end
go

create procedure sp_jdbc_tables
 @table_name  varchar(128)  = null,
 @table_owner varchar(128)  = null,
 @table_qualifier        varchar(128)  = null,
 @table_type  varchar(64) = null
as
declare @id int
declare @searchstr char(10)

if @table_name is null select @table_name = '%'

select @id = id from sysobjects where name like @table_name 
if (@id is null)
begin	
 	raiserror 17461 'Table does not exist'
	return (3)
end

if (patindex('%table%',lcase(@table_type)) > 0)
  	select @table_type = 'base'

if (patindex('%base%',lcase(@table_type)) > 0)
	select @searchstr = 'base'

else if (patindex('%view%',lcase(@table_type)) > 0) 
	select @searchstr = 'view' 

else if @table_type is null 
 	select @searchstr = '%' 
else
begin
	raiserror 99998 'Only valid table types are TABLE, BASE, VIEW or null'
	return(3)
end

if @table_owner is null select @table_owner = '%'


select
   TABLE_CAT = 	substring(db_name(),1,length(db_name())),
   TABLE_SCHEM=	substring(user_name(creator),1,length(user_name(creator))),
   TABLE_NAME = substring(table_name,1,length(table_name)),
   TYBLE_TYPE = substring(table_type,1,length(table_type)),
   REMARKS=	remarks
from systable where table_name like @table_name and
user_name(creator) like @table_owner and table_type like @searchstr
order by TABLE_TYPE, TABLE_CAT, TABLE_SCHEM, TABLE_NAME

go

/*
**   sp_jdbc_columns
**
*/

if exists (select * from sysobjects where name = 'sp_jdbc_columns')
    begin
 drop procedure sp_jdbc_columns
    end
go

CREATE PROCEDURE sp_jdbc_columns (
     @table_name  varchar(32),
     @table_owner  varchar(32) = null,
     @table_qualifier varchar(32) = null,
     @column_name  varchar(32) = null )
AS
declare @tableid int
declare @columnid int
declare @id int

if @column_name is null
	select @column_name = '%'

if @table_name is null
	select @table_name = '%'

if @table_owner is null
	select @table_owner = '%'

select @id = id from sysobjects where name like @table_name 

if (@id is null)
begin	
/* This returns sqlstate = WW012 */
 	raiserror 17461 'Table does not exist'
	return (3)
end

select	TABLE_CAT =	db_name(),
        TABLE_SCHEM = 	creator,
        TABLE_NAME = 	tname,
        COLUMN_NAME = 	cname,
        DATA_TYPE =  	(select ss_dtype from spt_datatype_info 
			 where type_name = (select if coltype='integer'
					    then 'int' else coltype endif)),
        TYPE_NAME = 	coltype,
        COLUMN_SIZE = 	length,
        BUFFER_LENGTH = length,
        DECIMAL_DIGITS= syslength,
        NUM_PREC_RADIX= (select NUM_PREC_RADIX from spt_datatype_info 
			 where type_name = (select if coltype='integer'
					    then 'int' else coltype endif)),
        NULLABLE = 	(select if nulls = 'N' then 0 else 1 endif),
        REMARKS = 	remarks,
        COLUMN_DEF = 	default_value,
        SQL_DATA_TYPE =	(select SQL_DATA_TYPE from spt_datatype_info 
			 where type_name = (select if coltype='integer'
					    then 'int' else coltype endif)),
        SQL_DATETIME_SUB=(select SQL_DATETIME_SUB from spt_datatype_info 
			 where type_name = (select if coltype='integer'
					    then 'int' else coltype endif)),
        CHAR_OCTET_LENGTH = (select if DATA_TYPE in (47,39,45,37,35,34) then
				     length else 0 endif),
        ORDINAL_POSITION=colno,
        IS_NULLABLE = 	(select if nulls = 'N' then 'NO' else 'YES' endif)
 from syscolumns
 where tname like @table_name and creator like @table_owner and
       cname like @column_name 
 order by TABLE_SCHEM, TABLE_NAME, ORDINAL_POSITION
go

grant execute on sp_jdbc_columns to PUBLIC
go

/*
**   sp_mda
**
*/

/*
** create the table of metadata access info
*/
if exists (select * from sysobjects where name = 'spt_mda')
begin
    drop table spt_mda
end
go

/*
** querytype: 1 == RPC, 2 == LANGUAGE, 3 == NOT_SUPPORTED
*/
create table spt_mda (mdinfo varchar(30), querytype tinyint,
    query varchar(255) null)
go

grant select on spt_mda to PUBLIC
go

insert spt_mda values ('FUNCTIONCALL', 1, 'DBA.sp_jdbc_function_escapes')
insert spt_mda values ('TYPEINFO', 1, 'DBA.sp_jdbc_datatype_info')
insert spt_mda values ('TABLES', 1, 'DBA.sp_jdbc_tables(?,?,?,?)')
insert spt_mda values ('COLUMNS', 1, 'sp_jdbc_columns(?,?,?,?)')
insert spt_mda values ('IMPORTEDKEYS', 1, 'sp_jdbc_importkey(?,?,?)')
insert spt_mda values ('EXPORTEDKEYS', 1, 'sp_jdbc_exportkey(?,?,?)')
insert spt_mda values ('PRIMARYKEYS', 1, 'sp_jdbc_primarykey(?,?,?)')
insert spt_mda values ('PRODUCTNAME', 2, 'select ''Sybase SQL Anywhere''')
insert spt_mda values ('ISREADONLY', 2, 'select 0')
insert spt_mda values ('ALLPROCSCALLABLE', 2, 'select 1')
insert spt_mda values ('ALLTABLESSELECTABLE', 2, 'select 1')
insert spt_mda values ('COLUMNALIASING', 2, 'select 1')
insert spt_mda values ('IDENTIFIERQUOTE', 2, 'select ''"''')
insert spt_mda values ('ALTERTABLESUPPORT', 2, 'select 1, 1')
insert spt_mda values ('CONNECTCONFIG', 2, 'set chained off')
insert spt_mda values ('CONVERTSUPPORT', 2, 'select 1')
insert spt_mda values ('CONVERTMAP', 1, 'DBA.sp_jdbc_convert_datatype(?,?)')
insert spt_mda values ('LIKEESCAPECLAUSE', 2, 'select 1')
insert spt_mda values ('MULTIPLERESULTSETS', 2, 'select 1')
insert spt_mda values ('MULTIPLETRANSACTIONS', 2, 'select 1')
insert spt_mda values ('NONNULLABLECOLUMNS', 2, 'select 1')
insert spt_mda values ('POSITIONEDDELETE', 2, 'select 1')
insert spt_mda values ('POSITIONEDUPDATE', 2, 'select 1')
insert spt_mda values ('STOREDPROCEDURES', 2, 'select 1')
insert spt_mda values ('SELECTFORUPDATE', 2, 'select 1')
insert spt_mda values ('CURSORTRANSACTIONS', 2, 'select 1, 1')
insert spt_mda values ('STATEMENTTRANSACTIONS', 2, 'select 1, 1')
insert spt_mda values ('TRANSACTIONSUPPORT', 2, 'select 1')
// note - transaction levels here match Connection.TRANSACTION* values
insert spt_mda values ('TRANSACTIONLEVELS', 2, 'select 1, 2, 4, 8')
insert spt_mda values ('TRANSACTIONLEVELDEFAULT', 2, 'select 1')
insert spt_mda values ('SET_ISOLATION', 2, 'set option isolation_level =   
')
insert spt_mda values ('GET_ISOLATION', 2, 'select @@isolation')
insert spt_mda values ('SET_ROWCOUNT', 2, 'set rowcount ?')
insert spt_mda values ('GET_AUTOCOMMIT', 2, 'select @@tranchained')
insert spt_mda values ('SET_AUTOCOMMIT_ON', 1, 'set chained off')
insert spt_mda values ('SET_AUTOCOMMIT_OFF', 1, 'set chained on')
insert spt_mda values ('SET_CATALOG', 2, 'use ?')
insert spt_mda values ('GET_CATALOG', 2, 'select db_name()')
insert spt_mda values ('NULLSORTING', 2, 'select 0, 0, 1, 0')
insert spt_mda values ('PRODUCTVERSION', 2, 'select @@version')
insert spt_mda values ('FILEUSAGE', 2, 'select 0, 0')
insert spt_mda values ('IDENTIFIERCASES', 2, 'select 1, 0, 0, 0, 1, 0, 0, 0')
insert spt_mda values ('SQLKEYWORDS', 2,    
    'select value from dba.spt_jtext where mdinfo = ''SQLKEYWORDS''')
insert spt_mda values ('NUMERICFUNCTIONLIST', 2,
    'select ''abs,acos,asin,atan,atn2,ceiling,cos,cot,degrees,exp,floor,log,log10,pi,power,radians,rand,remainder,round,sign,sqrt,tan,truncate''')
insert spt_mda values ('STRINGFUNCTIONLIST', 2,
    'select ''ascii,byte_length,byte_substr,char,difference,insertstr,lcase,left,length,locate,ltrim,patindex,repeat,right,rtrim,similar,soundex,space,s0tring,,substr,trim,ucase''')
insert spt_mda values ('SYSTEMFUNCTIONLIST', 2,
    'select ''connection_property,datalength,db_id,db_name,db_property,next_connection,nextdatabase,property,property_name,property_number,property_description''')
insert spt_mda values ('TIMEDATEFUNCTIONLIST', 2,
    'select ''date,dateformat,datename,datetime,day,dayname,days,dow,hour,hours,minute,minutes,mod,month,monthname,months,now,quarter,second,seconds,today,week,weeks,year,years,ymd''')
insert spt_mda values ('NULLPLUSNONNULL', 2, 'select 1')
insert spt_mda values ('EXTRANAMECHARS', 2, 'select ''@#$''')
insert spt_mda values ('MAXBINARYLITERALLENGTH', 2, 'select 32767')
insert spt_mda values ('MAXCHARLITERALLENGTH', 2, 'select 32767')
insert spt_mda values ('SCHEMAS', 1, 'sp_jdbc_getschemas')
insert spt_mda values ('COLUMNPRIVILEGES', 1, 'sp_jdbc_getcolumnprivileges(?,?,?,?)')
insert spt_mda values ('TABLEPRIVILEGES', 1, 'sp_jdbc_gettableprivileges(?,?,?)')
insert spt_mda values ('ROWIDENTIFIERS', 1, 'sp_jdbc_getbestrowidentifier(?,?,?,?,?)')
insert spt_mda values ('VERSIONCOLUMNS', 1, 'sp_jdbc_getversioncolumns(?,?,?)')
insert spt_mda values ('KEYCROSSREFERENCE', 1, 'sp_jdbc_getcrossreferences(?,?,?,?,?,?)')
insert spt_mda values ('INDEXINFO', 1, 'sp_jdbc_getindexinfo(?,?,?,?,?)')
insert spt_mda values ('PROCEDURECOLUMNS', 1, 'sp_jdbc_getprocedurecolumns(?,?,?,?)')
insert spt_mda values ('PROCEDURES', 1, 'sp_jdbc_stored_procedures(?,?,?)')
insert spt_mda values ('CATALOGS', 2, 'select db_name() as TABLE_CAT')
insert spt_mda values ('TABLETYPES', 2, 'select distinct table_type from systable')

/* Not available in SQL Anywhere */
insert spt_mda values ('SEARCHSTRING', 2, 'select '' ''')
/*
max column name length, max columns in group by,
max columns in index, max columns in order by,
max columns in select, max columns in table
*/
insert spt_mda values ('COLUMNINFO', 2, 'select 128, 64, 999, 64, 999, 999')

insert spt_mda values ('MAXINDEXLENGTH', 2, 'select 32767')

/*
supportsExpressionsInOrderBy: true
supportsOrderByUnrelated: true
*/
insert spt_mda values ('ORDERBYSUPPORT', 2, 'select 1, 1')

/* 
The following DatabaseMetaData methods are defined and for SQL Server 
they return true=1 or false=0
*/

/*
supportsTableCorrelationNames: true
supportsDifferentTableCorrelationNames: false
*/
insert spt_mda values ('CORRELATIONNAMES', 2, 'select 1, 0')

/* 
supportsGroupBy: true
supportsGroupByUnrelated: false
supportsGroupByBeyondSelect: false
*/
insert spt_mda values ('GROUPBYSUPPORT', 2, 'select 1, 0, 0')

/* 
supportsMinimumSQLGrammar: true
supportsCoreSQLGrammar: true
supportsExtendedSQLGrammar: true
*/
insert spt_mda values ('SQLGRAMMAR', 2, 'select 1, 1, 1')

/* 
supportsANSI92EntryLevelSQL: false
supportsANSI92IntermediateSQL: false
supportsANSI92FullSQL: false
*/
insert spt_mda values ('ANSI92LEVEL', 2, 'select 0, 0, 0')

/* 
supportsIntegrityEnhancementFacility: true
*/
insert spt_mda values ('INTEGRITYENHANCEMENT', 2, 'select 1')

/* 
supportsOuterJoins: true
supportsFullOuterJoins: false
supportsLimitedOuterJoins: true
*/
insert spt_mda values ('OUTERJOINS', 2, 'select 1, 0, 1')

/* 
SQL Server's terms for 'schema', 'procedure' and 'catalog' 
and how to separate them
*/
insert spt_mda values ('SCHEMATERM', 2, 'select ''owner''')
insert spt_mda values ('PROCEDURETERM', 2, 'select ''stored procedure''')
insert spt_mda values ('CATALOGTERM', 2, 'select ''database''')
insert spt_mda values ('CATALOGSEPARATOR', 2, 'select ''.''')

/* 
isCatalogAtStart: true
*/
insert spt_mda values ('CATALOGATSTART', 2, 'select 1')

/* 
supportsSchemasInDataManipulation: true
supportsSchemasInProcedureCalls: true
supportsSchemasInTableDefinitions: true
supportsSchemasInIndexDefinitions: true
supportsSchemasInPrivilegeDefinitions: false
*/
insert spt_mda values ('SCHEMASUPPORT', 2, 'select 1, 1, 1, 1, 0')

/* 
same with catalog
*/
insert spt_mda values ('CATALOGSUPPORT', 2, 'select 1, 1, 1, 1, 0')

/* 
supportsUnion: true
supportsUnionAll: true
*/
insert spt_mda values ('UNIONSUPPORT', 2, 'select 1, 1')

/* 
supportsSubqueriesInComparisons: true
supportsSubqueriesInExists: true
supportsSubqueriesInIns: true
supportsSubqueriesInQuantifieds: true
supportsCorrelatedSubqueries: true
*/
insert spt_mda values ('SUBQUERIES', 2, 'select 1, 1, 1, 1, 1')

/* 
supportsDataDefinitionAndDataManipulationTransactions: true
supportsDataManipulationTransactionsOnly: false
dataDefinitionCausesTransactionCommit: false
dataDefinitionIgnoredInTransactions: false
*/
insert spt_mda values ('TRANSACTIONDATADEFINFO', 2, 'select 1, 0, 0, 0')

insert spt_mda values ('MAXCONNECTIONS', 2, 'select @@max_connections')

/*
max cursor name length, max user name length,
max schema name length, max procedure name length,
max catalog name length
*/
insert spt_mda values ('MAXNAMELENGTHS', 2, 'select 128, 128, 128, 128, 128')
/*
max bytes in a row is 2 Gig, 0 is for "no, that doesn't include blobs"
*/
insert spt_mda values ('ROWINFO', 2, 'select 214783647, 0')
/*
max length of a statement, max number of open statements
both are unlimited
*/
insert spt_mda values ('STATEMENTINFO', 2, 'select 0, 0')
/*
max table name length, max tables in a select
*/
insert spt_mda values ('TABLEINFO', 2, 'select 128, 256')
go

commit
go
/*
** create the well-known sp_mda procedure for accessing the data
*/
if exists (select * from sysobjects where name = 'sp_mda')
begin
    drop procedure sp_mda
end
go

create procedure sp_mda(@clienttype int, @clientversion int) as
begin
    select mdinfo, querytype, query from DBA.spt_mda
end
go

grant execute on sp_mda to PUBLIC
go


if exists (select * from dbo.sysobjects where name = 'spt_jtext')
begin
    drop table spt_jtext
end
go

create table spt_jtext (mdinfo varchar(30) unique, value text)
go

grant select on spt_jtext to PUBLIC
go

insert spt_jtext values ('SQLKEYWORDS', 'ADD, ALL, ALTER, AND, ANY, AS,
ASC, BEGIN, BETWEEN, BINARY, BREAK, BY, CALL, CASCADE, CAST, CHAR,
CHAR_CONVERT, CHARACTER, CHECK, CHECKPOINT, CLOSE, COMMENT, COMMIT,
CONNECT, CONSTRAINT, CONTINUE, CONVERT, CREATE, CROSS, CURRENT,
CURSOR, DATE, DBA, DBSPACE, DEALLOCATE, DEC, DECIMAL, DECLARE,
DEFAULT, DELETE, DESC, DISTINCT, DO, DOUBLE, DROP, ELSE, ELSEIF,
ENCRYPTED, END, ENDIF, ESCAPE, EXCEPTION, EXEC, EXECUTE, EXISTS,
FETCH, FIRST, FLOAT, FOR, FOREIGN, FROM, FULL, GOTO, GRANT, GROUP,
HAVING, HOLDLOCK, IDENTIFIED, IF, IN, INDEX, INNER, INOUT, INSERT,
INSTEAD, INT, INTEGER, INTO, IS, ISOLATION, JOIN, KEY, LEFT, LIKE,
LOCK, LONG, MATCH, MEMBERSHIP, MESSAGE, MODE, MODIFY, NAMED, NATURAL,
NOHOLDLOCK, NOT, NULL, NUMERIC, OF, OFF, ON, OPEN, OPTION, OPTIONS,
OR, ORDER, OTHERS, OUT, OUTER, PASSTHROUGH, PRECISION, PREPARE,
PRIMARY, PRINT, PRIVILEGES, PROC, PROCEDURE, RAISERROR, READTEXT,
REAL, REFERENCE, REFERENCES, RELEASE, REMOTE, RENAME, RESOURCE,
RESTRICT, RETURN, REVOKE, RIGHT, ROLLBACK, SAVE, SAVEPOINT, SCHEDULE,
SELECT, SET, SHARE, SMALLINT, SOME, SQLCODE, SQLSTATE, START, STOP,
SUBTRANS, SUBTRANSACTION, SYNCHRONIZE, SYNTAX_ERROR, TABLE, TEMPORARY,
THEN, TIME, TINYINT, TO, TRAN, TRIGGER, TRUNCATE, TSEQUAL, UNION,
UNIQUE, UNKNOWN, UPDATE, USER, USING, VALIDATE, VALUES, VARBINARY,
VARCHAR, VARIABLE, VARYING, VIEW, WHEN, WHERE, WHILE, WITH, WORK,
WRITETEXT') 
go

commit
go

/* sp_jdbc_exportkey */
if exists (select * from sysobjects where name = 'sp_jdbc_exportkey')
    begin
        drop procedure sp_jdbc_exportkey
    end
go
CREATE PROCEDURE sp_jdbc_exportkey (
				 @table_qualifier	varchar(128) = null,
				 @table_owner		varchar(128) = null,
				 @table_name		varchar(128))
as
    exec sp_fkeys @table_name, @table_owner, @table_qualifier, NULL, NULL, NULL
go


/* sp_jdbc_importkey */

if exists (select * from sysobjects where name =  'sp_jdbc_importkey')
begin
	drop procedure sp_jdbc_importkey
end
go

CREATE PROCEDURE sp_jdbc_importkey (
				 @table_qualifier	varchar(128) = null,
				 @table_owner		varchar(128) = null,
				 @table_name		varchar(128))
as
    exec sp_fkeys NULL, NULL, NULL, @table_name, @table_owner, @table_qualifier

go

/* sp_jdbc_getschemas */
if exists (select * from sysobjects where name = 'sp_jdbc_getschemas')
    begin
        drop procedure sp_jdbc_getschemas
    end
go

CREATE PROCEDURE sp_jdbc_getschemas 
as
    select name from sysusers where suid >= -2 order by name
go

grant execute on sp_jdbc_getschemas to PUBLIC
go

if exists (select * from sysobjects where name = 'sp_jdbc_convert_datatype')
    begin
        drop procedure sp_jdbc_convert_datatype
    end
go

/*
** create table with conversion information
*/
if exists (select * from master.dbo.sysobjects 
	where name = 'spt_jdbc_conversion')
begin
    drop table spt_jdbc_conversion
end
go

create table spt_jdbc_conversion (datatype int, conversion char(20))
go

grant select on spt_jdbc_conversion to PUBLIC
go

/*Values based on the table info from the SQL Server Ref Man Chapter 4*/
/*bit*/
insert into spt_jdbc_conversion values(0,'11111110111111110001')
/*integers+numerics*/
insert into spt_jdbc_conversion values(1,'11111100011111110000')
insert into spt_jdbc_conversion values(2,'11111100011111110000')
insert into spt_jdbc_conversion values(9,'11111100011111110000')
insert into spt_jdbc_conversion values(10,'11111100011111110000')
insert into spt_jdbc_conversion values(11,'11111100011111110000')
insert into spt_jdbc_conversion values(12,'11111100011111110000')
insert into spt_jdbc_conversion values(13,'11111100011111110000')
insert into spt_jdbc_conversion values(14,'11111100011111110000')
insert into spt_jdbc_conversion values(15,'11111100011111110000')
/*Binaries*/
insert into spt_jdbc_conversion values(5,'11111110111111111111')
insert into spt_jdbc_conversion values(4,'11111110111111111111')
insert into spt_jdbc_conversion values(3,'11111110111111111111')
/*Characters*/
insert into spt_jdbc_conversion values(6,'00011110100000001111')
insert into spt_jdbc_conversion values(8,'00011110100000001111')
insert into spt_jdbc_conversion values(19,'00011110100000001111')
/*Dates*/
insert into spt_jdbc_conversion values(16,'00000010000000001110')
insert into spt_jdbc_conversion values(17,'00000010000000001110')
insert into spt_jdbc_conversion values(18,'00000010000000001110')
/*NULL*/
insert into spt_jdbc_conversion values(7,'00000000000000000000')
go
commit
go

create procedure sp_jdbc_convert_datatype (
					@source int,
					@destination int)
as
	/* Make source non-negative */
	select @source = @source + 7
	/* Put the strange date numbers into this area between 0-19*/
	if (@source > 90)
		select @source = @source - 82

	/*Convert destination the same way*/
	/* Put the strange date numbers into this area between 0-19*/
	if (@destination > 90)
		select @destination = @destination - 82

	/* Need 8 added instead of 7 because substring starts at 1 instead */
	/* of 0 */
	select @destination = @destination + 8

	/* Check the conversion. If the bit string in the table has a 1 
	** on the place's number of the destination's value we have to 
	** return true, else false
	*/
	if ((select substring(conversion,@destination,1) from 
		dba.spt_jdbc_conversion where datatype = @source) = '1')

		select 1
	else 
		select 0
go

grant execute on sp_jdbc_convert_datatype to PUBLIC
go

commit
go


if exists (select * from sysobjects where name =
    'sp_jdbc_getprocedurecolumns')
    begin
        drop procedure sp_jdbc_getprocedurecolumns
    end
go

create procedure sp_jdbc_getprocedurecolumns (
@sp_qualifier   varchar(128) = null,     /* stored procedure qualifier*/
@sp_owner       varchar(128) = null,     /* stored procedure owner */
@sp_name        varchar(128),            /* stored procedure name */
@column_name    varchar(128) = null)
as
declare @id int

select @id = id from sysobjects where name = @sp_name 
if (@id is null)
begin	
/* This returns sqlstate = WW012 */
 	raiserror 17461 'Procedure does not exist'
	return (3)
end

  declare @full_sp_name char(255)
  declare @objid integer
  if @sp_owner is null
    select @full_sp_name=@sp_name
  else
    select @full_sp_name=@sp_owner+'.'+@sp_name
  
  if @column_name is null 
    select @column_name='%'
  
  select @objid=object_id(@full_sp_name)
  select substr(db_name(),1,length(db_name())) as PROCEDURE_CAT,
    substr(user_name,1,length(user_name)) as PROCEDURE_SCHEM,
    substr(proc_name,1,length(proc_name)) as PROCEDURE_NAME,
    substr(parm_name,1,length(parm_name)) as COLUMN_NAME,
    COLUMN_TYPE = 0,
    d.type_id as DATA_TYPE,
    substr(domain_name,1,length(domain_name)) as TYPE_NAME,
    d."precision" as "PRECISION",
    width as LENGTH,
    scale as SCALE,
    RADIX = 0,
    NULLABLE = 2,
    REMARKS = null
    from SYS.SYSPROCEDURE as p,SYS.SYSPROCPARM as pp,SYS.SYSDOMAIN as d
    ,SYS.SYSUSERPERM as u
    where p.proc_id=@objid-200000
    and p.proc_id=pp.proc_id
    and pp.domain_id=d.domain_id
    and p.creator=u.user_id
    and pp.parm_type=0
    and parm_name like @column_name
    order by PROCEDURE_SCHEM, PROCEDURE_NAME
go

grant execute on sp_jdbc_getprocedurecolumns to PUBLIC
go

if exists (select * from sysobjects where name = 'sp_jdbc_primarykey')
begin
	drop procedure sp_jdbc_primarykey
end
go

create procedure sp_jdbc_primarykey
			   @table_qualifier varchar(128),
			   @table_owner 	varchar(128),
			   @table_name		varchar(128)
as
    declare @id int
    select @id = id from sysobjects where name = @table_name 
    if (@id is null)
    begin	
	/* This returns sqlstate = WW012 */
	raiserror 17461 'Tablename does not exist'
	return (3)
    end
    
    if (@table_owner is null)
	select @table_owner = (select user_name(uid) from sysobjects 
			where name=@table_name)  
    if @table_owner != (select user_name(uid) from sysobjects 
			where name=@table_name)
    begin
	/* This returns sqlstate = WW012 */
	raiserror 17208 'You specified the wrong owner'
	return (3)
    end

    select TABLE_CAT = substring(db_name(),1,length(db_name())),
        TABLE_SCHEM  = (select substring(user_name,1,length(user_name))
			from SYS.SYSUSERPERM
			where user_id=SYSINDEX.creator),
        TABLE_NAME =   substring(table_name,1,length(table_name)),
        COLUMN_NAME  = (select list(column_name) from SYSIXCOL==SYSCOLUMN 
			where SYSIXCOL.table_id=object_id(@table_name) - 100000
			and SYSINDEX.index_id=index_id),
        KEY_SEQ      = (select list(sequence) from SYSIXCOL==SYSCOLUMN 
			where SYSIXCOL.table_id=object_id(@table_name) - 100000
			and SYSINDEX.index_id=index_id),
        PK_NAME =      substring(index_name,1,length(index_name))
	from SYS.SYSTABLE KEY JOIN SYS.SYSINDEX
	where table_name = @table_name 
		and user_name(SYS.SYSINDEX.creator) = @table_owner
	order by COLUMN_NAME
go

grant execute on sp_jdbc_primarykey to PUBLIC
go


if exists (select * from sysobjects where name = 'sp_jdbc_stored_procedures')
begin
	drop procedure sp_jdbc_stored_procedures
end
go

create procedure sp_jdbc_stored_procedures
@sp_qualifier   varchar(128) = null,  
@sp_owner       varchar(128) = null,
@sp_name        varchar(128) = null    
as
declare @id int
declare @procid int

if @sp_name is null
begin 
	select @sp_name = '%'
	if @sp_owner is null
	begin
		/* This returns sqlstate = WW012 */
	 	raiserror 99997 'You must specify procedure name or owner'
		return (3)
	end
end

select @id = id from sysobjects where name like @sp_name 
if (@id is null)
begin	
/* This returns sqlstate = WW012 */
 	raiserror 17461 'Procedure does not exist'
	return (3)
end

if (@sp_owner is null)
	select @sp_owner = (select user_name(uid) from sysobjects 
			where name=@sp_name)  

select @procid = proc_id from sysprocedure where proc_name = @sp_name

select  PROCEDURE_CAT =	substring(db_name(),1,length(db_name())),
        PROCEDURE_SCHEM = substring(user_name(creator),1,
			  length(user_name(creator))),
        PROCEDURE_NAME = substring(proc_name,1,length(proc_name)),
        num_input_params = (select count(*) from sysprocparm 
			    where proc_id= @procid and parm_mode_in='Y'),
        num_output_params = (select count(*) from sysprocparm 
			    where proc_id= @procid and parm_mode_out='Y'),
        num_result_sets = (select count(*) from sysprocparm 
			    where proc_id= @procid and parm_type=1),
        REMARKS = null,
        PROCEDURE_TYPE = (select (if (select count(*) from sysprocparm 
                                      where proc_id= @procid and parm_type=1) 
				  > 0 then 1 else  2 endif))
from sysprocedure 
where proc_name like @sp_name and @sp_owner like user_name(creator)
order by PROCEDURE_SCHEM, PROCEDURE_NAME
go

grant execute on sp_jdbc_stored_procedures to PUBLIC
go

if exists (select * from sysobjects where name = 'tableprivileges')
    begin
        drop table tableprivileges
    end
go

if exists (select * from sysobjects where name = 'sp_jdbc_gettableprivileges')
    begin
        drop procedure sp_jdbc_gettableprivileges
    end
go
if exists (select * from sysobjects where name = 'jdbc_tableprivileges')
    begin
        drop table jdbc_tableprivileges
    end
go

create table jdbc_tableprivileges ( TABLE_CAT varchar(128) null,
			        TABLE_SCHEM varchar(128) null,
			      	TABLE_NAME varchar(128) null,
				GRANTOR varchar(128) null,
				GRANTEE varchar(128) null,
				PRIVILEGE varchar(15) null,
				IS_GRANTABLE char(1) null)
go

create procedure sp_jdbc_gettableprivileges (
		@table_qualifier varchar(128) = null,
	 	@table_owner varchar(128) = null,
                @table_name varchar(128)= null)
as      

declare @schem varchar(128)
declare @grantor varchar(128)
declare @grantee varchar(128)
declare @tableid int
declare @id int

select @id = id from sysobjects where name = @table_name 
if (@id is null)
begin	
/* This returns sqlstate = WW012 */
 	raiserror 17461 'Table does not exist'
	return (3)
end

select @tableid= table_id from systable where table_name = @table_name
select @schem  = trim(user_name) 
		 from SYS.SYSUSERPERM == SYS.SYSTABLE, SYSTABLEPERM  
		 where table_id = SYSTABLEPERM.ttable_id and 
		 SYSTABLEPERM.stable_id = @tableid
select @grantor= trim(user_name) from SYS.SYSUSERPERM,SYS.SYSTABLEPERM 
		 where user_id = SYSTABLEPERM.grantor and 
		 SYSTABLEPERM.stable_id = @tableid
select @grantee= trim(user_name) from SYS.SYSUSERPERM,SYS.SYSTABLEPERM 
		 where user_id=SYSTABLEPERM.grantee and  
		 SYSTABLEPERM.stable_id = @tableid
insert into jdbc_tableprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @grantor, @grantee,
	if selectauth = 'Y' or selectauth='G' then 'SELECT' else 'null' endif, 
	if selectauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_tableprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @grantor, @grantee,
	if insertauth = 'Y' or insertauth='G' then 'INSERT' else 'null' endif, 
	if insertauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_tableprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @grantor, @grantee,
	if deleteauth = 'Y' or deleteauth='G' then 'DELETE' else 'null' endif, 
	if deleteauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_tableprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @grantor, @grantee,
	if updateauth = 'Y' or updateauth='G' then 'UPDATE' else 'null' endif, 
	if updateauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_tableprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @grantor, @grantee,
	if alterauth = 'Y' or alterauth='G' then 'ALTER' else 'null' endif, 
	if alterauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_tableprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @grantor, @grantee,
	if referenceauth='Y' or referenceauth='G' then 'REFERENCE' 
						  else 'null' endif, 
	if referenceauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid

select * from jdbc_tableprivileges where PRIVILEGE != 'null'
	order by TABLE_SCHEM, TABLE_NAME, PRIVILEGE
delete jdbc_tableprivileges
go
grant execute on sp_jdbc_gettableprivileges to PUBLIC
go

/* SQL Anywhere just has the option to give UPDATE grants to columns
** all other permissions are taken over from the table permissions
*/
if exists (select * from sysobjects where name = 'sp_jdbc_getcolumnprivileges')
    begin
        drop procedure sp_jdbc_getcolumnprivileges
    end
go
if exists (select * from sysobjects where name = 'jdbc_columnprivileges')
    begin
        drop table jdbc_columnprivileges
    end
go

create table jdbc_columnprivileges ( TABLE_CAT varchar(128) null,
			        TABLE_SCHEM varchar(128) null,
			      	TABLE_NAME varchar(128) null,
				COLUMN_NAME varchar(128) null,
				GRANTOR varchar(128) null,
				GRANTEE varchar(128) null,
				PRIVILEGE varchar(15) null,
				IS_GRANTABLE char(1) null)
go

create procedure sp_jdbc_getcolumnprivileges (
		@table_qualifier varchar(128) = null,
	 	@table_owner varchar(128) = null,
                @table_name varchar(128)= null,
		@column_name varchar(128)= null)
as      

declare @schem varchar(128)
declare @grantor varchar(128)
declare @grantee varchar(128)
declare @tableid int
declare @columnid int
declare @id int

select @id = id from sysobjects where name = @table_name 

if (@id is null)
begin	
/* This returns sqlstate = WW012 */
 	raiserror 17461 'Table does not exist'
	return (3)
end

select @tableid= table_id from systable where table_name = @table_name
select @columnid = column_id from syscolumn where table_id = @tableid and 
		 column_name = @column_name

if (@columnid is null)
begin
/* This returns sqlstate = WW012 */
	raiserror 17563 'The table does not have a column named '+@column_name
	return(3)
end

select @schem  = trim(user_name)
		 from SYS.SYSUSERPERM == SYS.SYSTABLE, SYSTABLEPERM  
		 where table_id = SYSTABLEPERM.ttable_id and 
		 SYSTABLEPERM.stable_id = @tableid
select @grantor= trim(user_name) from SYS.SYSUSERPERM,SYS.SYSTABLEPERM 
		 where user_id = SYSTABLEPERM.grantor and 
		 SYSTABLEPERM.stable_id = @tableid
select @grantee= trim(user_name) from SYS.SYSUSERPERM,SYS.SYSTABLEPERM 
		 where user_id=SYSTABLEPERM.grantee and  
		 SYSTABLEPERM.stable_id = @tableid
insert into jdbc_columnprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name,@column_name,@grantor, @grantee,
	if selectauth = 'Y' or selectauth='G' then 'SELECT' else 'null' endif, 
	if selectauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_columnprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @column_name,@grantor,@grantee,
	if insertauth = 'Y' or insertauth='G' then 'INSERT' else 'null' endif, 
	if insertauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_columnprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @column_name, @grantor, @grantee,
	if deleteauth = 'Y' or deleteauth='G' then 'DELETE' else 'null' endif, 
	if deleteauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_columnprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @column_name, @grantor, @grantee,
	if updateauth = 'Y' or updateauth='G' then 'UPDATE' else 'null' endif, 
	if updateauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_columnprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @column_name, @grantor, @grantee,
	if alterauth = 'Y' or alterauth='G' then 'ALTER' else 'null' endif, 
	if alterauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid
insert into jdbc_columnprivileges 
   select substring(db_name(),1,length(db_name())), @schem, @table_name, @column_name, @grantor, @grantee,
	if referenceauth='Y' or referenceauth='G' then 'REFERENCE'  
						  else 'null' endif, 
	if referenceauth = 'G' then 'YES' else 'NO' endif 
   from SYS.SYSTABLEPERM 
   where stable_id = @tableid

if (select count(*) from syscolperm where table_id = @tableid) > 0
begin
	update jdbc_columnprivileges set PRIVILEGE = 'UPDATE' 
	       where syscolperm.column_id = @columnid
        if (select is_grantable from syscolperm 
	    where table_id = @tableid and column_id = @columnid) = 'Y'
	begin
		update jdbc_columnprivileges set IS_GRANTABLE='YES'
		       where PRIVILEGE = 'UPDATE'
	end
end	

select * from jdbc_columnprivileges where PRIVILEGE != 'null' 
	order by COLUMN_NAME, PRIVILEGE
delete jdbc_columnprivileges
go
grant execute on sp_jdbc_getcolumnprivileges to PUBLIC
go

if exists (select *
	from sysobjects where name = 'sp_jdbc_getbestrowidentifier')
begin
	drop procedure sp_jdbc_getbestrowidentifier
end
go

/* Get a description of a table's optimal set of columns that uniquely 
** identifies a row
** In SQL Anywhere it is usually the primary key 
*/

create procedure sp_jdbc_getbestrowidentifier (
				 @table_qualifier	varchar(128) = null,
				 @table_owner		varchar(128) = null,
				 @table_name		varchar(128),
				 @scope			int,
				 @nullable		smallint)
as
declare @nulls char(1) 
declare @id int

select @id = id from sysobjects where name = @table_name 
if (@id is null)
begin	
/* This returns sqlstate = WW012 */
 	raiserror 17461 'Table does not exist'
	return (3)
end

    if (@table_owner is null)
	select @table_owner = (select user_name(uid) from sysobjects 
			where name=@table_name)  
    if @table_owner != (select user_name(uid) from sysobjects 
			where name=@table_name)
    begin
	/* This returns sqlstate = WW012 */
	raiserror 17208 'You specified the wrong owner'
	return (3)
    end


if (@nullable = 0) 
	select @nulls = 'N'
else
	select @nulls = 'Y'

select 	SCOPE = 	0,
	COLUMN_NAME = 	substring(cname,1,length(cname)),
	DATA_TYPE = 	(select ss_dtype from spt_datatype_info 
				where type_name = 
				     (select if coltype='integer'
					then 'int' else coltype endif)),
	TYPE_NAME =	substring(coltype,1,length(coltype)),
	COLUMN_SIZE = 	length,
	BUFFER_LENGTH =	length,
	DECIMAL_DIGITS=	syslength,
	PSEUDO_COLUMN = 1
from sys.syscolumns 
where tname = @table_name and in_primary_key = 'Y' and nulls = @nulls
order by SCOPE
go
grant execute on sp_jdbc_getbestrowidentifier to PUBLIC
go

if exists (select * from sysobjects where name = 'sp_jdbc_getversioncolumns')
begin
	drop procedure sp_jdbc_getversioncolumns
end
go

create procedure sp_jdbc_getversioncolumns (
				 @table_qualifier	varchar(128) = null,
				 @table_owner		varchar(128) = null,
				 @table_name		varchar(128))
as
    declare @id int
    select @id = id from sysobjects where name = @table_name 
    if (@id is null)
    begin	
	/* This returns sqlstate = WW012 */
	raiserror 17461 'Tablename does not exist'
	return (3)
    end
    if (@table_owner is null)
	select @table_owner = (select user_name(uid) from sysobjects 
			where name=@table_name)  
    if @table_owner != (select user_name(uid) from sysobjects 
			where name=@table_name)
    begin
	/* This returns sqlstate = WW012 */
	raiserror 17208 'You specified the wrong owner'
	return (3)
    end

select 	SCOPE = 	0,
	COLUMN_NAME = 	substring(cname,1,length(cname)),
	DATA_TYPE = 	(select ss_dtype from spt_datatype_info
		     		where type_name = (select if coltype='integer'
					then 'int' else coltype endif)),
	TYPE_NAME = 	substring(coltype,1,length(coltype)),
	COLUMN_SIZE =	length,
	BUFFER_LENGTH = length,
	DECIMAL_DIGITS=	syslength,
	PSEUDO_COLUMN =	1
from syscolumns where default_value = 'autoincrement' and tname=@table_name
go
grant execute on sp_jdbc_getversioncolumns to PUBLIC
go

if exists (select * from sysobjects where name = 'sp_jdbc_getcrossreferences')
begin
	drop procedure sp_jdbc_getcrossreferences
end
go

CREATE PROCEDURE sp_jdbc_getcrossreferences
			   @pktable_qualifier	varchar(128) = null,
			   @pktable_owner	varchar(128) = null,
			   @pktable_name	varchar(128) = null,
			   @fktable_qualifier	varchar(128) = null ,
			   @fktable_owner	varchar(128) = null,
			   @fktable_name	varchar(128) = null
as

declare @id int

select @id = id from sysobjects where name = @fktable_name 
if (@id is null)
begin	
/* This returns sqlstate = WW012 */
 	raiserror 17461 'Foreign key table does not exist'
	return (3)
end
select @id = id from sysobjects where name = @pktable_name 
if (@id is null)
begin	
 	raiserror 17461 'Primary Key table does not exist'
	return (3)
end

if (@pktable_owner is null)
	select @pktable_owner = (select user_name(uid) from sysobjects 
			where name=@pktable_name)  
if @pktable_owner != (select user_name(uid) from sysobjects 
			where name=@pktable_name)
begin
	/* This returns sqlstate = WW012 */
	raiserror 17208 'You specified the wrong owner for the primary key table'
	return (3)
end
if (@fktable_owner is null)
	select @fktable_owner = (select user_name(uid) from sysobjects 
			where name=@fktable_name)  
if @fktable_owner != (select user_name(uid) from sysobjects 
			where name=@fktable_name)
begin
	/* This returns sqlstate = WW012 */
	raiserror 17208 'You specified the wrong owner for the foreign key table'
	return (3)
end


select 	PKTABLE_CAT = 	substring(db_name(),1,length(db_name())),
	PKTABLE_SCHEM =	substring(primary_creator,1,length(primary_creator)),
	PKTABLE_NAME = 	substring(primary_tname,1,length(primary_tname)),
	PKCOLUMN_NAME = (select trim(left(
			 columns,patindex('% IS %',columns)))),
	FKTABLE_CAT = 	substring(db_name(),1,length(db_name())),
	FKTABLE_SCHEM =	substring(foreign_creator,1,length(foreign_creator)),
	FKTABLE_NAME = 	substring(foreign_tname,1,length(foreign_tname)),
	FKCOLUMN_NAME = (select trim(right(columns,length(columns)-
				patindex('% IS %', columns)-3))),
	KEY_SEQ =	foreign_key_id,
	UPDATE_RULE =	(select (if event = 'C' or event = 'U' then (
					if referential_action = 'C' then 1 
					else if referential_action='N' then 2 
			 		else if referential_action='D' then 3 
			 		else 4 endif endif endif)
			 	else 0 endif)),
	DELETE_RULE =	(select (if event = 'D' then (
					if referential_action = 'C' then 1 
					else if referential_action='N' then 2 
			 		else if referential_action='D' then 3 
			 		else 4 endif endif endif)
			 	else 0 endif)),
	FK_NAME	=	substring(role,1,length(role)),
	PK_NAME = 	null,
	DEFERRABILITY = 1

from sysforeignkeys, sys.systrigger 
where foreign_tname = @fktable_name and primary_tname = @pktable_name
and sys.systrigger.table_id = (select table_id from systable 
			       where table_name = @pktable_name)

go
grant execute on sp_jdbc_getcrossreferences to PUBLIC
go


/* getindexinfo returns information on the indexes of a page
** if unique is set to TRUE only indexes on indexes where it's value's must
** be unique are returned.
** approximate is a little needless because SQL Anywhere guarantees 
** accurate data
** Additionally SQL Anywhere doesn't have clustered indexes nor 
** index statistics and no way to estimate the amount of rows if the table_name
** is a variable. In SQL Server there is rowcnt() for that.
*/

if exists (select * from sysobjects where name = 'sp_jdbc_getindexinfo')
begin
	drop procedure sp_jdbc_getindexinfo
end
go

if exists (select * from sysobjects where name = 'jdbc_indexhelp')
begin
	drop table jdbc_indexhelp
end
go

create procedure sp_jdbc_getindexinfo (
	@table_qualifier	varchar(128) = NULL,
	@table_owner		varchar(128) = NULL,
	@table_name		varchar(128),
	@unique			varchar(5),
	@approximate 		char(5))
as
declare @is_unique char(1)
declare @id int

select @id = id from sysobjects where name = @table_name 
if (@id is null)
begin	
/* This returns sqlstate = WW012 */
 	raiserror 17461 'Table does not exist'
	return (3)
end
if (@table_owner is null)
	select @table_owner = (select user_name(uid) from sysobjects 
			where name=@table_name)  
if @table_owner != (select user_name(uid) from sysobjects 
			where name=@table_name)
begin
	/* This returns sqlstate = WW012 */
	raiserror 17208 'You specified the wrong owner'
	return (3)
end

if (@unique = 'true') 
	select @is_unique = 1 
else 
	select @is_unique = 0


create table jdbc_indexhelp (iname char(128),non_unique int, new_order char(1))

insert into jdbc_indexhelp 
select iname, 
       if (left(trim(indextype),1) = 'N') then 1  else 0 endif,
       if (right(trim(colnames),3) = 'E') then 'D' else 'A' endif
from sysindexes where tname = @table_name

select  TABLE_CAT = 	substring(db_name(),1,length(db_name())),
	TABLE_SCHEM =	(select substring(user_name,1,length(user_name)) 
			 from SYS.sysuserperm 
			 where user_id=sysindex.creator),
	TABLE_NAME = 	substring(table_name,1,length(table_name)),
	NON_UNIQUE = 	 (select non_unique from jdbc_indexhelp 
			 where iname = index_name),
	INDEX_QUALIFIER=substring(db_name(),1,length(db_name())),
	INDEX_NAME = 	substring(index_name,1,length(index_name)),
	TYPE = 		3,  /*No clustered indeces available */
	ORDINAL_POSITION= (select list(sys.sysixcol.column_id) from 
			   sys.sysixcol == sys.syscolumn
			   where sysixcol.table_id = 
			   (select table_id from systable 
			   	   where table_name = @table_name)),
	COLUMN_NAME = 	(select list(column_name) from 
			 sys.sysixcol==sys.syscolumn where sysixcol.table_id = 
			 (select table_id from systable 
			    where table_name = @table_name)),
	ASC_OR_DESC = 	(select new_order from jdbc_indexhelp 
			 where iname = index_name),
	CARDINALITY = 	0, /* select count(*) from VARIABLE doesn't work*/
			   /* Unfortunately SQL Anywhere doesn't have a 
			      rowcnt() function because it doesn't have
			      OAM pages to store table data. So I don't 
			      see any way to find out the number of rows
			      in a table with a variable table_name.
			      If I'm wrong, please let me know */
	PAGES = 	0,  /*Not available */
	FILTER_CONDITION = null

from sys.systable key join sys.sysindex where table_name = @table_name and
NON_UNIQUE  = @is_unique

drop table jdbc_indexhelp

go
grant execute on sp_jdbc_getindexinfo to PUBLIC
go

