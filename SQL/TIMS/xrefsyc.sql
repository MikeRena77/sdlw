CREATE TABLE dba.xref_info
       (object_ref nvarchar(128) NOT NULL,
       object_ref_type nvarchar(128) NOT NULL,
       event nvarchar(128) NOT NULL,
       referenced_in nvarchar(128) NOT NULL,
       ref_in_type nvarchar(128) NOT NULL,
       pbl nvarchar(128) NOT NULL,
       application nvarchar(64) NOT NULL,
       scope nvarchar(1) NOT NULL) ;
 
ALTER TABLE dba.xref_info
       ADD CONSTRAINT primary PRIMARY KEY  NONCLUSTERED
       (object_ref,
       object_ref_type,
       event,
       referenced_in,
       ref_in_type,
       pbl,
       application,
       scope) ;
 
INSERT INTO dbo.pbcattbl
        (pbt_tnam, pbt_tid, pbt_ownr,
       pbd_fhgt, pbd_fwgt, pbd_fitl, pbd_funl, pbd_fchr, pbd_fptc, pbd_ffce,
       pbh_fhgt, pbh_fwgt, pbh_fitl, pbh_funl, pbh_fchr, pbh_fptc, pbh_ffce,
       pbl_fhgt, pbl_fwgt, pbl_fitl, pbl_funl, pbl_fchr, pbl_fptc, pbl_ffce,
       pbt_cmnt)
       VALUES  ( 'xref_info',
       OBJECT_ID('dba.xref_info'),
        'dba',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
       'Cross Reference Detail') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'xref_info',
        OBJECT_ID('dba.xref_info'),
        'dba',  'object_ref', 1,
        'Reference Name:', 0 ,
        'Reference~r~nName', 0,
       23 , '',
       0 , 65 , 439 ,
        '', 'N',
        '',
        'The object or class referenced',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'xref_info',
        OBJECT_ID('dba.xref_info'),
        'dba',  'object_ref_type', 2,
        'Reference Type:', 0 ,
        'Reference~r~nType', 0,
       23 , '',
       0 , 65 , 878 ,
        '', 'N',
        '',
        'The class type of the reference',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'xref_info',
        OBJECT_ID('dba.xref_info'),
        'dba',  'event', 3,
        'Referenced From:', 0 ,
        'Referenced~r~nFrom', 0,
       23 , '',
       0 , 65 , 659 ,
        '', 'N',
        '',
        'Where the reference is made',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'xref_info',
        OBJECT_ID('dba.xref_info'),
        'dba',  'referenced_in', 4,
        'Object Reference In:', 0 ,
        'Object~r~nReferenced~r~nIn', 0,
       23 , '',
       0 , 65 , 439 ,
        '', 'N',
        '',
        'Object containing the reference',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'xref_info',
        OBJECT_ID('dba.xref_info'),
        'dba',  'ref_in_type', 5,
        'Refer. In Type', 0 ,
        'Refer. In ~r~nType', 0,
       23 , '',
       0 , 65 , 330 ,
        '', 'N',
        '',
        'The class type for the Referenced In',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'xref_info',
        OBJECT_ID('dba.xref_info'),
        'dba',  'pbl', 6,
        'Library:', 0 ,
        'Library', 0,
       23 , '',
       0 , 65 , 659 ,
        '', 'N',
        '',
        'The path and filename for the library containing the referenced class',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'xref_info',
        OBJECT_ID('dba.xref_info'),
        'dba',  'application', 7,
        'Application:', 0 ,
        'Application', 0,
       23 , '',
       0 , 65 , 330 ,
        '', 'N',
        '',
        'The name of the application object',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'xref_info',
        OBJECT_ID('dba.xref_info'),
        'dba',  'scope', 8,
        'Scope:', 0 ,
        'Scope', 0,
       23 , '',
       0 , 65 , 165 ,
        '', 'N',
        '',
        'The scope of the reference ( G or O )',
        '', '') ;
 
CREATE TABLE dba.app_classes
       (application nvarchar(64) NOT NULL,
       pbl nvarchar(255) NOT NULL,
       object nvarchar(50) NOT NULL,
       nestedclass nvarchar(255) NOT NULL,
       parent nvarchar(255) NOT NULL,
       parenttypeof nvarchar(50) NOT NULL,
       scope nvarchar(1) NOT NULL,
       nestedin nvarchar(255) NOT NULL,
       isreferenced int NULL) ;
 
ALTER TABLE dba.app_classes
       ADD CONSTRAINT primary PRIMARY KEY  NONCLUSTERED
       (application,
       pbl,
       object,
       nestedclass,
       parent,
       parenttypeof,
       nestedin) ;
 
INSERT INTO dbo.pbcattbl
        (pbt_tnam, pbt_tid, pbt_ownr,
       pbd_fhgt, pbd_fwgt, pbd_fitl, pbd_funl, pbd_fchr, pbd_fptc, pbd_ffce,
       pbh_fhgt, pbh_fwgt, pbh_fitl, pbh_funl, pbh_fchr, pbh_fptc, pbh_ffce,
       pbl_fhgt, pbl_fwgt, pbl_fitl, pbl_funl, pbl_fchr, pbl_fptc, pbl_ffce,
       pbt_cmnt)
       VALUES  ( 'app_classes',
       OBJECT_ID('dba.app_classes'),
        'dba',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
       'Class information for the Cross Reference Report') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'application', 1,
        'Application:', 0 ,
        'Application', 0,
       23 , '',
       0 , 65 , 439 ,
        '', 'N',
        '',
        'The name of the application object',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'pbl', 2,
        'Pbl:', 0 ,
        'Pbl', 0,
       23 , '',
       0 , 65 , 878 ,
        '', 'N',
        '',
        'The path and filename for the library containing the object',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'object', 3,
        'Object:', 0 ,
        'Object', 0,
       23 , '',
       0 , 65 , 439 ,
        '', 'N',
        '',
        'The base object containing the class reference',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'nestedclass', 4,
        'Nested Class:', 0 ,
        'Nested~r~nClass', 0,
       23 , '',
       0 , 65 , 439 ,
        '', 'N',
        '',
        'The nested class ( could be controlname, function, event, variable, etc. ) ',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'parent', 5,
        'Parent:', 0 ,
        'Parent', 0,
       23 , '',
       0 , 65 , 878 ,
        '', 'N',
        '',
        'The name of the parent of the nested class',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'parenttypeof', 6,
        'Parent TypeOf:', 0 ,
        'Parent~r~nTypeOf', 0,
       23 , '',
       0 , 65 , 878 ,
        '', 'N',
        '',
        'The type of the parent class',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'scope', 7,
        'Scope:', 0 ,
        'Scope', 0,
       23 , '',
       0 , 65 , 69 ,
        '', 'N',
        '',
        'The object scope ( G or O ) ',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'nestedin', 8,
        'Nested In:', 0 ,
        'Nested~r~nIn', 0,
       23 , '',
       0 , 65 , 439 ,
        '', 'N',
        '',
        'The name of the class this is nested in',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_classes',
        OBJECT_ID('dba.app_classes'),
        'dba',  'isreferenced', 9,
        'Is Referenced:', 0 ,
        'Is~r~nReferenced', 0,
       24 , '[General]',
       0 , 65 , 165 ,
        '', 'N',
        '',
        'An indicator that the class was referenced in the application',
        '', '') ;
 
CREATE TABLE dba.app_info
       (application nvarchar(64) NOT NULL,
       report_globals int NOT NULL,
       list_sql int NOT NULL,
       list_sp int NOT NULL,
       list_ps_func int NOT NULL,
       list_all_events int NOT NULL,
       list_controls int NOT NULL,
       sort nvarchar(256) NOT NULL,
       rep_date datetime NOT NULL,
       rep_time datetime NOT NULL,
       pbl nvarchar(64) NULL) ;
 
ALTER TABLE dba.app_info
       ADD CONSTRAINT primary PRIMARY KEY  NONCLUSTERED
       (application) ;
 
INSERT INTO dbo.pbcattbl
        (pbt_tnam, pbt_tid, pbt_ownr,
       pbd_fhgt, pbd_fwgt, pbd_fitl, pbd_funl, pbd_fchr, pbd_fptc, pbd_ffce,
       pbh_fhgt, pbh_fwgt, pbh_fitl, pbh_funl, pbh_fchr, pbh_fptc, pbh_ffce,
       pbl_fhgt, pbl_fwgt, pbl_fitl, pbl_funl, pbl_fchr, pbl_fptc, pbl_ffce,
       pbt_cmnt)
       VALUES  ( 'app_info',
       OBJECT_ID('dba.app_info'),
        'dba',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
        -8,  400,  'N',  'N',  0,  34,
        'MS Sans Serif',
       'Application Header information') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'application', 1,
        'Application:', 0 ,
        'Application', 0,
       23 , '',
       0 , 65 , 654 ,
        '', 'N',
        '',
        'The name of the application object',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'report_globals', 2,
        'Report Globals:', 0 ,
        'Report~r~nGlobals', 0,
       24 , '',
       0 , 65 , 206 ,
        '', 'N',
        '',
        'Report Globals Only option',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'list_sql', 3,
        'List Sql:', 0 ,
        'List~r~nSql', 0,
       24 , '',
       0 , 65 , 206 ,
        '', 'N',
        '',
        'List SQL References option',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'list_sp', 4,
        'List SP:', 0 ,
        'List~r~nSP', 0,
       0 , '',
       0 , 65 , 206 ,
        '', 'N',
        '',
        'List stored procedure references option',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'list_ps_func', 5,
        'List PS Functions:', 0 ,
        'List PS~r~nFunctions', 0,
       24 , '',
       0 , 65 , 206 ,
        '', 'N',
        '',
        'List Powerscript function references option',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'list_all_events', 6,
        'List Events:', 0 ,
        'List~r~nEvents', 0,
       24 , '',
       0 , 65 , 206 ,
        '', 'N',
        '',
        'List all events option',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'list_controls', 7,
        'List Controls:', 0 ,
        'List~r~nControls', 0,
       0 , '',
       0 , 65 , 206 ,
        '', 'N',
        '',
        'List control references option',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'sort', 8,
        'Sort:', 0 ,
        'Sort', 0,
       23 , '',
       0 , 65 , 654 ,
        '', 'N',
        '',
        'Sort Sequence',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'rep_date', 9,
        'Report Date:', 0 ,
        'Report~r~nDate', 0,
       23 , '',
       0 , 65 , 252 ,
        '', 'N',
        '',
        'Date report was created',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'rep_time', 10,
        'Report Time:', 0 ,
        'Report~r~nTime', 0,
       23 , '',
       0 , 65 , 252 ,
        '', 'N',
        '',
        'Time report was created',
        '', '') ;
 
INSERT INTO dbo.pbcatcol
       (pbc_tnam, pbc_tid, pbc_ownr, pbc_cnam,
       pbc_cid, pbc_labl, pbc_lpos, pbc_hdr,
       pbc_hpos, pbc_jtfy, pbc_mask, pbc_case,
       pbc_hght, pbc_wdth, pbc_ptrn, pbc_bmap,
       pbc_init, pbc_cmnt, pbc_edit, pbc_tag)
        VALUES  ( 'app_info',
        OBJECT_ID('dba.app_info'),
        'dba',  'pbl', 11,
        'Library:', 0 ,
        'Library', 0,
       23 , '',
       0 , 65 , 878 ,
        '', 'N',
        '',
        'The path and filename of the library for the application',
        '', '') ;
