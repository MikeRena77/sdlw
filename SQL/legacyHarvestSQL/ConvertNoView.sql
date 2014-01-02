/*
 * ConvertNoView.sql
 *
 * Convert "No View" views
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

INSERT INTO harView
     VALUES (
        -1,
        'No View',
        'NoView',
        0,
        'N',
        -1,
        SYSDATE,
        1,
        SYSDATE,
        1,
        SYSDATE,
        ''
     );

UPDATE harState S
   SET viewobjid = -1
 WHERE viewobjid IN (SELECT viewobjid
                       FROM OLDharView
                      WHERE viewtype = 'NoView');

UPDATE harstate
   SET viewobjid = -1
 WHERE stateobjid = 0;

UPDATE harState
   SET viewobjid = -1
 WHERE viewobjid = 0;

-- Make sure package views are set correctly
UPDATE harPackage p
   SET p.viewobjid = (SELECT s.viewobjid
                        FROM harState s
                       WHERE s.stateobjid = p.stateobjid);

DELETE OLDharView
 WHERE viewtype = 'NoView'
    OR viewobjid = 0
    OR viewtype IS NULL;







 




