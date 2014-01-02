/*
 * InitialPhase.sql
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved.
--
WHENEVER SQLERROR EXIT FAILURE
SPOOL &5
-- Commit every change in order to avoid huge rollback segments
DEFINE initext = &1
DEFINE nextext = &2
DEFINE initindex = &3
DEFINE nextindex = &4
DEFINE HARVESTINDEXTSNAME = &6
DEFINE HARVESTBLOBTSNAME = &7
-- Drop foreign key constraints
@DropConstraints.sql &5

SET autocommit ON
SET document ON
set feedback on
set timing off
set verify off

-- Verify that there are no Merge tags
@ReportMergeTags.sql

WHENEVER SQLERROR CONTINUE
--
-- Remove triggers - they don't work with new schema
--
DROP TRIGGER DEFECT_INSERT;
DROP TRIGGER MR_INSERT;
/*
-- The following triggers may not be there - they go with multi-site option
*/
DROP TRIGGER HARMSMAPPING;
DROP TRIGGER HARMSMAPPINGDELETE;
DROP TRIGGER HARMSSITEDEF;
DROP TRIGGER HARMSSITEDEFDELETE;

-- Fill in Nullable columns that will be made non-NULL;
@FillInNulls.sql
-- Rename tables that must be recreated
@RenameTables.sql
-- Alter remaining tables
@AlterTables.sql &HARVESTINDEXTSNAME
-- Create all the new tables that are needed
@CreateTables.sql &HARVESTINDEXTSNAME
-- Create indexes before copying data to prevent duplicates
@indexes.sql &HARVESTINDEXTSNAME
-- Migrate data from old tables to new
@CopyData.sql
--
-- Delete history of deleted packages before adding foreign key
--
DELETE harpkghistory h
 WHERE NOT EXISTS (SELECT packageobjid
                     FROM harpackage p
                    WHERE p.packageobjid = h.packageobjid);
--
-- Fix data from Models database
@FixModels.sql
-- Massage the data
@UpdateData.sql
-- Convert old "No View" views to one "No View" view
@ConvertNoView.sql
-- Convert form associations
@ConvertFormAssoc.sql
-- Create database views
@CreateViews.sql
--
-- Create version data tables
--  pass in storage parameters
@CreateBlobTables.sql &initext &nextext &initindex &nextindex &HARVESTINDEXTSNAME &HARVESTBLOBTSNAME
--
-- Create conversion log
@ConversionLog.sql &HARVESTINDEXTSNAME
/*
 * Replace cross-platform extensions with text file extensions
 * generated as a pre-conversion step.
 */
DELETE harfileextension;

INSERT INTO harfileextension( repositobjid, fileextension)
   SELECT DISTINCT repositobjid, fileextension
     FROM convharfileextension;

SET autocommit OFF
SPOOL off
EXIT































