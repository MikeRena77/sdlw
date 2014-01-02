/*
 * CreateViews.sql
 *
 * Create database views
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

CREATE OR REPLACE VIEW HARAPPROVEHISTACTIONVIEW (
   ENVOBJID,
   STATEOBJID,
   PACKAGEOBJID,
   USROBJID,
   ACTIONTIME,
   ACTION,
   NOTE
)
AS
   SELECT h.envobjid,
          h.stateobjid,
          h.packageobjid,
          h.usrobjid,
          h.execdtime,
          h.action,
          h.note
     FROM harApproveHist h, harApproveHistView v, harpackage p
    WHERE v.packageobjid = p.packageobjid
      AND v.stateobjid = p.stateobjid
      AND h.envobjid = v.envobjid
      AND h.stateobjid = v.stateobjid
      AND h.packageobjid = v.packageobjid
      AND h.usrobjid = v.usrobjid
      AND h.execdtime = v.actiontime;

CREATE OR REPLACE VIEW HARAPPROVEACTIONVIEW (
   ENVOBJID,
   STATEOBJID,
   PACKAGEOBJID,
   USROBJID,
   ACTIONTIME,
   ACTION,
   USRGRPOBJID,
   PROCESSOBJID
)
AS
   SELECT v.envobjid,
          v.stateobjid,
          v.packageobjid,
          v.usrobjid,
          v.actiontime,
          v.action,
          l.usrgrpobjid,
          l.processobjid
     FROM harApproveHistActionView v, harApproveList l
    WHERE v.stateobjid = l.stateobjid
      AND (  (   l.isgroup = 'N'
             AND l.usrobjid = v.usrobjid)
          OR (   l.isgroup = 'Y'
             AND l.usrgrpobjid IN (SELECT usrgrpobjid
                                     FROM harusersingroup g
                                    WHERE v.usrobjid = g.usrobjid)));
