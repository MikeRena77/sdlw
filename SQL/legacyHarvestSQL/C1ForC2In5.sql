
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

insert into harConversionLog( tablename, lastobjid ) values ( '2ndPhase', 200 );
insert into harConversionLog( tablename, lastobjid ) values ( '2ndNewItem', 0 );
insert into harConversionLog( tablename, lastobjid ) values ( '2ndNewPath', 0 );
insert into harConversionLog( tablename, lastobjid ) values ( '2ndNewVersion', 0 );

COMMIT;

EXIT
