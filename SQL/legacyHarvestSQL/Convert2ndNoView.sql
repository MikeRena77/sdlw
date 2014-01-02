/*
 * Convert2ndNoView.sql
 *
 * Convert "No View" views
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

UPDATE harState S
   SET viewobjid = -1
 WHERE viewobjid IN (SELECT viewobjid
                       FROM harView
                      WHERE viewtype = 'NoView'
		      AND   viewobjid != -1 );


-- Make sure package views are set correctly
UPDATE harPackage p
   SET p.viewobjid = (SELECT s.viewobjid
                        FROM harState s
                       WHERE s.stateobjid = p.stateobjid);


EXIT








 




