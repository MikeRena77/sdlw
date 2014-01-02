
---
--- &1 = database owner uppercase (like HARVEST)
--- &2 = % of binary file size to the total version size
--- &3 = % growth ratio of total repository size in 1 year
--- &4 = DB_BLOCK_SIZE
--- &5 = output log
---
WHENEVER SQLERROR EXIT FAILURE
SPOOL &5

SET document ON
set feedback on
set timing off
set verify off
SET heading ON

prompt
prompt 'Database owner (must be in upper case) = &1'
prompt 'Percentage of total binary file size in all repositories = &2'
prompt 'Expected percentage of growth in total version size in one year = &3'
prompt 'DB_BLOCK_SIZE = &4'
prompt 'Output File = &5'
prompt
prompt 'You can run this script multiple times.'
prompt
 
prompt 'Calculating the total blob size in megabytes. This will take a while...'

SELECT CEIL((1.11 * SUM( TO_NUMBER( VERSIONFILESIZE, '999999999999999999999999'))/(1024*1024)) * 
(&2 * 0.52 + (1-&2) * 0.35))
AS TOTAL_BLOB_SIZE_IN_MB ,
CEIL((&3 * 1.11 * SUM( TO_NUMBER( VERSIONFILESIZE, '999999999999999999999999'))/(1024*1024)) * 
(&2 * 0.52 + (1-&2) * 0.35))
AS BLOB_EXTENT_SIZE_IN_MB
FROM harVersion
WHERE VERSIONFILESIZE IS NOT NULL AND VERSIONFILESIZE <> ' ';

--select distinct ((1+&3) * (&total_file_size * &2 * 0.90 + &total_file_size * (1-&2) * 0.30) )
--as reflected_total_file_size
--from harharvest

prompt 'Press return key to continue...'
pause;

WHENEVER SQLERROR CONTINUE;

--select CEIL(SUM(blocks)*&4*(1+&3)/1000000) as TOTAL_META_DATA_SIZE_IN_MB
--from dba_tables t
--where  t.owner='&1'; type=2 for tables;
prompt 'Calculating the total meta data size in megabytes. This will take a while...'

select SUM(s.blocks)*&4*(1+&3)/(1024*1024) as TOTAL_META_DATA_SIZE_IN_MB
  from sys.seg$ s, sys.obj$ o, sys.user$ u, sys.tab$ i
  where u.name = '&1' and o.owner# = u.user# and o.type = 2 and
  i.obj# = o.obj# and s.file# = i.file# and s.block# = i.block# ;

prompt 'Press return key to continue...'
pause;

--select CEIL((SUM(AVG_DATA_BLOCKS_PER_KEY*DISTINCT_KEYS) *&4*(1+&3))/1000000)
--as TOTAL_INDEX_SIZE_IN_MB
--from dba_indexes t
--where  t.owner='&1' and t.status='VALID';
prompt 'Calculating the total index size in megabytes. This will take a while...'

select 1.65 * SUM(s.blocks)*&4*(1+&3)/(1024*1024) as TOTAL_INDEX_SIZE_IN_MB
  from sys.seg$ s, sys.obj$ o, sys.user$ u, sys.ind$ i
  where u.name = '&1' and o.owner# = u.user# and o.type = 1 and
  i.obj# = o.obj# and s.file# = i.file# and s.block# = i.block# ;



prompt 'Press return key to end...'
pause;



-- The following will not work because some tables end up in shared -like SYSTEM- tablespaces
--select 
--round(sum(df.bytes)/1000000) as TOTAL_INDEX_SIZE_IN_MB
--from dba_data_files df 
--where df.status='AVAILABLE' 
--and df.tablespace_name in (select t.tablespace_name
--from dba_indexes t
--where t.owner='&1' and t.status='VALID');

--pause;

--select 
--round(sum(df.bytes)/1000000) as TOTAL_META_DATA_SIZE_IN_MB
--from dba_data_files df 
--where df.status='AVAILABLE' 
--and df.tablespace_name in (select t.tablespace_name
--from dba_tables t
--where t.owner='&1' );

--pause;

--select distinct  (1+&3) * &total_metadata_size
--as reflected_total_metadata_size
--from harharvest;


spool off


EXIT