/*
 * ReportMergeTags.sql
 *
 * Verify that there are no Merge-tags
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

SELECT e.environmentname, i.itemname, p.packagename, v.mappedversion
  FROM harVersion v, harEnvironment e, harPackage p, harItem i
 WHERE v.versionstatus = 'M'
   AND v.packageobjid = p.packageobjid
   AND v.itemobjid = i.itemobjid
   AND v.envobjid = e.envobjid;

DECLARE
   CURSOR merge_tags
   IS
    SELECT versionobjid
      FROM harVersion 
     WHERE versionstatus = 'M';

   mver       harVersion.versionobjid%TYPE;

BEGIN
   OPEN merge_tags;
   FETCH merge_tags INTO mver;

   IF merge_tags%FOUND
   THEN
      raise_application_error(-20000, 'Merge-tagged versions cannot be converted.');
   END IF;
END;
/



