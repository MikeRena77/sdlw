select e.tablespace_name, l.pctversion, l.cache, l.logging, l.chunk
from dba_extents e,  dba_lobs l
where e.segment_name = l.segment_name
and l.owner='HARVEST'
and l.table_name = 'HARVERSIONDATA'
and l.column_name = 'VERSIONDATA'