/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   mrgcopy.cmd  $
*               $Revision:   1.0  $
*               $Date:   Aug 19 1997 15:59:08  $
* DESCRIPTION:  See usage below.
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/mrgcopy.cmdv  $
*  
*     Rev 1.0   Aug 19 1997 15:59:08   BrettL
*  Initial revision.
   
      Rev 1.1   19 Mar 1996 10:18:38   MajeedA
   Fxied the application invalid check. Fixed the help too.
   
      Rev 1.0   13 Mar 1996 09:22:36   MajeedA
   Initial revision.
*****************************************************************************/
/* end extraction */

ARG args

GlobalEnv = 'ENVIRONMENT'

IF ARG(1)\="DO" THEN DO
   /* then request for usage help */
   SAY ""
   SAY "Usage:  MRGCOPY DO"
   SAY ""
   SAY "This script assumes that BDROOT and PROMS_BROOT environment variables"
   SAY "have been defined for BASE merge. If ADROOT and PROMS_APPL_BROOT"
   SAY "are defined then it does applications merge. This utility will move"
   SAY "the files in PROMS_BROOT(PROMS_APPL_BROOT) into backup files, and"
   SAY "copy the new files from DBROOT(ADROOT) into the PROMS_BROOT "
   SAY "(PROMS_APPL_BROOT)."
   EXIT 0
END /* THEN usage help */


/* collect root information */
PROMS_BROOT      = translate(value('PROMS_BROOT',,      GlobalEnv))
BDROOT           = translate(value('BDROOT',,           GlobalEnv))
PROMS_APPL_BROOT = translate(value('PROMS_APPL_BROOT',, GlobalEnv))
ADROOT           = translate(value('ADROOT',,           GlobalEnv))

IF PROMS_BROOT == "" THEN
   CALL error_exit "PROMS_BROOT is not defined."

/* make PROMS_BROOT a full, absolute directory pathname */
PROMS_BROOT = make_absolute_path(PROMS_BROOT)

IF PROMS_BROOT \= "D:\NBASE" THEN
   CALL error_exit "PROMS_BROOT is '"PROMS_BROOT"'.  It must be 'D:\NBASE' to do a refresh."

IF \isDir(PROMS_BROOT) THEN
   CALL error_exit "The PROMS_BROOT directory," PROMS_BROOT", does not exist."

IF PROMS_BROOT == PROMS_APPL_BROOT THEN
   CALL error_exit "PROMS_APPL_BROOT cannot be the same as PROMS_BROOT."

IF PROMS_APPL_BROOT \= "" THEN DO
   /* then determine if this is a legal application broot */
   PROMS_APPL_BROOT = make_absolute_path(PROMS_APPL_BROOT)
   IF left(PROMS_APPL_BROOT, 3) \= "D:\" THEN
      /* then this is not a legal application base root, so complain */
      CALL error_exit "PROMS_APPL_BROOT is '"PROMS_APPL_BROOT"'.  It must be 'D:\<applName>' to be a refresh."
END /* THEN appl_broot */

CALL RxFuncAdd 'SysFileTree',     'RexxUtil', 'SysFileTree'

IF isDir(PROMS_BROOT) & isDir(BDROOT) THEN DO
/* Do the base build */
SAY "Merging the BASEs" PROMS_BROOT " and "  BDROOT "."
CALL mrg1root 'BDROOT', BDROOT, PROMS_BROOT
END /* THEN */

IF PROMS_APPL_BROOT \= "" & ADROOT\="" THEN DO
  SAY "Trying Application merge..." PROMS_APPL_BROOT " and "  ADROOT
  IF isDir(PROMS_APPL_BROOT) & isDir(ADROOT) THEN DO
    /* Now Do the Application build */
    SAY "Merging the APPLICATION" PROMS_APPL_BROOT " and "  ADROOT "."
    CALL mrg1root 'ADROOT', ADROOT, PROMS_APPL_BROOT
  END  /* THEN */
END  /* THEN */

SAY "MRGCOPY completed normally."
EXIT 0
/*==========================================================================*/


MRG1ROOT: PROCEDURE;
  ARG srcRootName,srcRoot,destRoot
  /* for each file in srcRoot, rename the matching file (if any) in destRoot */

  srcRootName = strip(srcRootName)
  srcRoot     = strip(srcRoot)
  destRoot    = strip(destRoot)
  SAY "'"srcRoot"' -> '"destRoot"'"
 
  IF srcRoot == ""  |  srcRoot == destRoot THEN RETURN
  IF \isDir(srcRoot) THEN
     /* then srcRoot doesn't exist, so warn and return */
     CALL error_exit srcRootName "directory" srcRoot "does not exist."

  SAY "Recording files in" srcRoot"..."
  files.0 = 0
  CALL collect_files srcRoot
  SAY files.0 "files found."

  IF files.0 == 0 THEN DO
     /* then no files found in srcRoot */
     SAY "WARNING: No files found to merge in" srcRootName"," srcRoot"."
     RETURN
  END /* THEN no files */

  prefix_len = length(srcRoot'\')
  DO i=1 TO files.0
     file = translate(substr(files.i, prefix_len+1))
 
     /* filter out noise files */
     PARSE VAR file ."."ext
     IF ext == "OUT" | ext == "$$$" |,
        ext == "@@@" | ext == "DEF" THEN ITERATE
     IF filespec('Name', file) == "VCS.CFG"         THEN ITERATE

     srcFile  = srcRoot'\'file
     destFile = destRoot'\'file

     IF stream(destFile, 'C', 'QUERY EXISTS') \= "" THEN DO
        /* then we need to overlay src on dest */
        SAY "Merge" srcFile "->" destFile

        /* determine rename name */
        PARSE VAR destFile drive_dir_file'.'ext

        ext = DelStr( ext, 3 )
        ext = ext"0"
        backupName   = drive_dir_file'.'ext

        /* do the rename */
        IF stream(backupName, 'C', 'QUERY EXISTS') == "" THEN DO
          cmd = 'REN' destFile filespec('N', backupName)
          SAY cmd
         '@'cmd
          IF rc \= 0 THEN
            CALL error_exit "Rename failed."
        END
        '@attrib -r -s -h' destFile '1> NUL'

     END /* THEN destFile exists */

     /* copy src into dest now */
     cmd = 'COPY' srcFile destFile
     SAY cmd
     '@'cmd

     IF rc \= 0 THEN
       SAY cmd "failed."

  END /* DO all srcRoot files */
  SAY " Merging done "
RETURN
/*==========================================================================*/

COLLECT_FILES: PROCEDURE EXPOSE files.;
  ARG srcRoot

  queueName = andirs("V****")
  IF queueName == "" THEN
     CALL error_exit "Failed to read PVCS directory names from ANDIRS.TXT."

  CALL RxQueue 'Set', queueName
  DO WHILE lines('QUEUE:') \= 0
     directory = linein('QUEUE:')
     dirPath   = srcRoot||directory
     sysFileTree_rc = SysFileTree(dirPath'*.*', tmpFiles, 'FO')

     IF sysFileTree_rc \= 0 THEN
        /* then SysFileTree failed in some way */
        CALL error_exit "SysFileTree() failed to collect file list in" dirPath"."

     /* append tmpFiles to files */
     j = files.0
     DO i = 1 TO tmpFiles.0
        j = j+1
        files.j = tmpFiles.i
     END /* DO all tmpFiles */
     files.0 = j
  END /* DO WHILE queue */
  CALL RxQueue 'Delete', queueName
RETURN
/*==========================================================================*/


MAKE_ABSOLUTE_PATH: PROCEDURE;
   ARG root
   /* root is a directory pathname.  Modify it, if necessary, so that it */
   /* begins with a drive letter and return it.                          */

   IF left(root, 1) == "\" THEN
      /* then this is a root directory on current drive, so prepend drive */
      root =filespec("DRIVE", directory())||root

   IF substr(root, 2, 1) \= ":" THEN
      /* then does not have a drive letter, so must be relative */
      root =directory()||root
RETURN root
/*==========================================================================*/


ERROR_EXIT: PROCEDURE;
  PARSE ARG msg

  IF msg \= "" THEN
     SAY msg
  SAY "MRGCOPY aborted."
  CALL err_beep
EXIT 1
/*==========================================================================*/
