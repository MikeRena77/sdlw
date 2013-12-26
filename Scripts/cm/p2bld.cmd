/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   p2bld.cmd  $
*               $Revision:   1.3  $
*               $Date:   13 Jun 2005 13:24:06  $
* DESCRIPTION:  See usage below.
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/p2bld.cmdv  $
*  
*     Rev 1.3   13 Jun 2005 13:24:06   BMaster
*  Modified to allow build hierachy to be more than 4 levels deep.
*  
*     Rev 1.2   Apr 02 2002 15:32:32   StephenM
*  Add changes necessary for Canadian build - they added files to build greater than 3 
*  characters.  With this change, extensions up to 6 characters are valid.
*  
*     Rev 1.1   Dec 17 1998 09:44:00   brettl
*  Removed pvcs archive extention check .NNV
*  Doesn't make sense on NT.
*  Check caused build to fail when .WAV file was checked in
*  
*     Rev 1.0   Aug 19 1997 15:34:14   BrettL
*  Initial revision.

      Rev 1.16   22 Mar 1996 11:15:36   hartmute
   Delete temporary files at end of processing.

      Rev 1.15   11 Mar 1996 18:58:06   hartmute
   Temporarily removed verify_label functionality.

      Rev 1.14   11 Mar 1996 17:54:30   hartmute
   Corrected build of pvcs filename when working whith promoted files that
   start with a '.' as first character.

      Rev 1.13   11 Mar 1996 16:42:52   hartmute
   Corrected statement

      Rev 1.12   11 Mar 1996 16:28:14   hartmute
   Allow first character of a promoted file to be a .

      Rev 1.11   29 Feb 1996 09:31:16   hartmute
   Corrected handling of duplicate files.

      Rev 1.10   26 Feb 1996 16:50:42   hartmute
   When detecting multiple promotions for one single file, we no longer
   abort the process.  Instead we determine which of the revisions has
   the higher value.  That revision will then be promoted for the build.

      Rev 1.9   10 Feb 1996 13:46:06   MerrillC
   When the pathname of the file to be touched is turned into a directory
   name for use by the CD command, also include the drive letter of the
   touched file.  It was being left off before so that this script would
   work only if the current working directory was on the same drive as the
   file being touched.

      Rev 1.8   06 Dec 1995 10:01:46   MerrillC
   The LABEL argument is now required rather than optional.  If you do not want
   to attach a label, specify a label of NONE.

      Rev 1.7   04 Dec 1995 17:36:24   MerrillC
   If a file is promoted into Shell 2.1 and the Chevron build label is on the
   same revision as the Shell 2.1 label, then in addition to moving the
   SHELL21 label, we will move the Chevron build label, but NOT the SHELL20
   build label.

      Rev 1.6   01 Nov 1995 17:27:22   MerrillC
   Touch all files whose extension return TRUE from isTouchable() so that
   the have current timestamps.

      Rev 1.5   17 Oct 1995 13:46:48   BMASTER
   Add missing quote mark on line 533.

      Rev 1.4   13 Oct 1995 17:29:36   MerrillC
   Corrected destruction of the RELEASE.NUM file.

      Rev 1.3   12 Oct 1995 17:28:56   MerrillC
   Changed the temporary file names to all have the format of P2Bxnnnn.$$$
   where 'x' indicates which of the P2BLD temporary files it is and 'nnnn'
   is a number guaranteed to make the file unique within the directory.

      Rev 1.2   12 Oct 1995 14:16:16   MerrillC
   Stripped blanks for around PROMOTE_LST argument.
   Change usage help to reflect need for commas separating the arguments.
   If a label is set on the promoted file and if that label is BUILD,
   SHELL20, or SHELL21; then also attach the BUILD, SHELL20, or SHELL21 label
   IF the label revision is the same as the BUILD/SHELL20/SHELL21 revision.

      Rev 1.1   11 Oct 1995 15:09:04   MerrillC
   Subroutine-ized much of the code.
   Changed "ADD" string argument to a isADD boolean argument.
   Added error exits for label verify failures.
   Added check_errors() procedure for check output file for any strings
   suggesting errors and stop immediately.

      Rev 1.0   09 Oct 1995 14:16:06   SAMN
   Initial revision.

*****************************************************************************/
/* end extraction */

CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'
CALL RxFuncAdd 'SysTempFileName', 'RexxUtil', 'SysTempFileName'

/* get the arguments and default them */
ARG isAdd',' VERSION',' ROOT',' PROMOTE_LST',' LABEL .
/*
SAY "VERSION    =|"version"|"
SAY "ROOT       =|"ROOT"|"
SAY "PROMOTE_LST=|"PROMOTE_LST"|"
SAY "LABEL      =|"LABEL"|"
SAY "isADD      ="isADD
*/

VERSION     = strip(VERSION)
ROOT        = strip(ROOT)
PROMOTE_LST = strip(PROMOTE_LST)
LABEL       = strip(LABEL)
isADD       = strip(isADD)

IF ROOT  == '.' THEN ROOT  = directory()
IF isADD == ""  THEN isADD = 0

PARSE VAR PROMOTE_LST RFile"."ext    /* response file less its extension     */
outFile       = RFile'.out'          /* P2BLD log output file                */

/* Check for usage query */
IF isUsage(VERSION) | ROOT == "" | PROMOTE_LST == "" | LABEL == "" THEN DO
   /* then display usage */
   '@cls'
   SAY " "
   SAY " "
   IF isAdd THEN DO
      SAY "Usage:  ADD2BLD <build_name>, <root>, <promote_list>, <label>"
      SAY " "
      SAY "The <build_name> argument (e.g., N0202A, SH0202, CH0100A, etc.) determines"
      SAY "which PVCS archive the extraction is done from:  Q:\VCS or S:\VCS."
   END /* THEN ADD2BLD */
   ELSE DO
      SAY "Usage:  PVCS2BLD <build_name>, <root>, <promote_list>, <label>"
      SAY " "
      SAY "The <build_name> argument (e.g., N0202A, SH0202, CH0100A, etc.) determines the"
      SAY "release number that appears in the RELEASE.NUM file and which PVCS archive the"
      SAY "extraction is done from:  Q:\VCS or S:\VCS."
   END /* ELSE PVCS2BLD */
   SAY " "
   SAY "This script promotes files in the PVCS archive into <root> directory.  The"
   SAY "<promote_list> file records the file names and versions to promote.  File names"
   SAY "are written one per line withOUT the root (e.g., 'SC\SYS\foo.cpp' instead of"
   SAY "'Q:\VCS\SC\SYS\foo.cpv')."
   SAY " "
   SAY "The file name may be followed by one or more blanks and then either a"
   SAY "revision number or a version label."
   SAY "Each promoted files has the <label> version label attached to it.  If"
   SAY "<label> is specified as NONE, then no label is attached to the promoted file."
   SAY " "
   SAY "A blank line or a '*' or '~' in column 1 is treated as a comment line.  A '/',"
   SAY "non-alphabetic character in column 1 is an error."
   SAY " "
   SAY "This script writes its errors to <promote_list>.OUT."
   EXIT 0
END /* THEN usage */

/* default LABEL, if necessary */
IF LABEL == "NONE" THEN LABEL = ""

CALL SysFileDelete outFile
CALL stream outFile, 'C', 'OPEN WRITE'

/* Create unique, temporary file names.  Notice that each file has to be opened            */
/* before the next temporary name is created so it doesn't keep creating the               */
/* same temporary name over and over.                                                      */
CALL outputMsg "Creating temporary files..."
tmpFile       = SysTempFileName('P2BT????.$$$') /* output of individual PVCS steps.        */
CALL stream tmpFile,       'C', 'OPEN'
CALL stream tmpFile,       'C', 'CLOSE'         /* equivalent of touching tmpFile          */

getListFile   = SysTempFileName('P2BG????.$$$') /* PVCS response file for getting files    */
CALL stream getListFile,   'C', 'OPEN WRITE'

labelListFile = SysTempFileName('P2BL????.$$$') /* PVCS response file for attaching labels */
CALL stream labelListFile, 'C', 'OPEN WRITE'

labelChkFile  = SysTempFileName('P2BC????.$$$') /* PVCS response file for checking labels  */
CALL stream labelChkFile,  'C', 'OPEN WRITE'

CALL outputMsg "Temporary files created."
CALL outputMsg "*"


/* local variables */
pvcsBin          = 'J:\PVCS53\NT\NT'  /* PVCS executables directory            */
fileCount        = 0                 /* make sure this starts as 0            */
dupMsgs.0        = 0                 /* list of duplicates promotes found     */
pvcs_files.0     = 0                 /* list of files to be extracted         */
pvcs_revisions.0 = 0 /* list of revisions matching pvcs_files to be extracted */
touchFiles.0     = 0                 /* list of files to be touched           */
applName         = ""                /* applName associated with VERSION      */
archive          = ""                /* PVCS archive hierarchy for VERSION    */
drive            = ""                /* temporary drive, if any, for archive  */


/* determine which archive hierarchy to use */
CALL outputMsg "Finding archive for version" VERSION"..."
applName = applName(VERSION)
IF applName == "" THEN DO
   /* then can't convert VERSION into application Name, so complain and exit */
   CALL close_and_delete tmpFile getListFile labelListFile labelChkFile
   CALL error_exit "applName can't be deduced from version '"VERSION"'."
END /* THEN no applName */

/* convert applName into a PVCS archive directory */
CALL outputMsg "calling findpvcs " applName"...."
PARSE VALUE findpvcs(applName) WITH archive drive
IF archive == "" THEN DO
   /* then findpvcs() failed and printed a message, so just exit */
   CALL close_and_delete tmpFile getListFile labelListFile labelChkFile
   CALL error_exit ""
END /* THEN findpvs() failed */
archiveLength = length(archive)
CALL outputMsg "Archive" archive "found."
CALL outputMsg "*"

IF stream(PROMOTE_LST, 'C', 'QUERY EXISTS') == "" THEN DO
   /* then the promote file doesn't exist, so complain and exit */
   CALL close_and_delete tmpFile getListFile labelListFile labelChkFile
   CALL error_exit "Promote list '"PROMOTE_LST"' does not exist."
END /* THEN no promote list */


CALL outputMsg "Extracting from "applName" archive "archive"."
IF isAdd
   THEN CALL outputMsg 'ADD2BLD' ROOT',' PROMOTE_LST',' LABEL
   ELSE CALL outputMsg 'PVCS2BLD' ROOT',' PROMOTE_LST',' LABEL

CALL stream PROMOTE_LST, 'C', 'OPEN READ'
DO WHILE lines(PROMOTE_LST)
   /* read a line */
   line = linein(PROMOTE_LST)

   /* replace all the tab chars by spaces since space is delimiter   */
   /* for string parsing functions.                                  */
   line = translate(line, " ", "        ")

   IF strip(line) == "" THEN ITERATE /* it's blank, so skip it       */

   /* now we are ready with the "line" to parse it for args          */
   file     = word(line, 1)
   revision = strip(word(line, 2))

   /* check for a comment line and bad pathname                      */
   firstChar = left(file, 1)
   IF firstChar=="*" THEN ITERATE /* it's a comment, so skip it      */

   IF firstChar=="~" THEN ITERATE /* it's a remove BUILD, so skip it */

   /* check for valid file name */
   CALL validate_file line

   /* ASSERT: file should be a filename to be promoted */
   fileCount = fileCount+1
   file      = translate(file)
   file      = translate(file, '\', '/')
   CALL extract file revision fileCount
END /* WHILE PROMOTE_LST */

CALL BuildFiles

/* Close the files */
SAY " "
CALL stream PROMOTE_LST,   'C', 'CLOSE'
CALL stream getListFile,   'C', 'CLOSE'
CALL stream labelListFile, 'C', 'CLOSE'
CALL stream labelChkFile,  'C', 'CLOSE'

/* Check for duplicate promotions */
IF dupMsgs.0 \= 0 THEN DO
   /* then there were one or more duplicate promotions, so complain */
   /* BUT: we do no longer stop the process, we filter out the
           highest revision number, and that is what we promote */
   CALL outputMsg  "Duplicate promotions for the following:"
   DO i=1 to dupMsgs.0
      CALL outputMsg "    "||dupMsgs.i
   END /* DO all messages */
/* We used to stop the process here, but now we continue
   CALL outputMsg "No files were promoted.  No labels attached."
   CALL close_and_delete getListFile labelListFile labelChkFile tmpFile
   CALL error_exit ""
*/
END /* THEN duplicates */


/* Verify that there is something to do */
IF fileCount == 0 THEN DO
   /* then there are no file to promote, so exit quietly */
   CALL outputMsg "There are no files to promote."

   /* Update release.num even though there aren't any files to promote. */
   CALL updateReleaseNum root
   CALL close_and_delete getListFile labelListFile labelChkFile tmpFile
   CALL stream outFile, 'C', 'CLOSE'
   CALL check_drive drive
   EXIT 0
END /* THEN no files */
ELSE
   /* else we have files to promote */
   CALL outputMsg "There are" fileCount "file(s) to extract from" ARCHIVE "into" ROOT"."

/* turn off write-protect */
CALL outputMsg "Turning off write-protect in" ROOT"..."
'@attrib -r -h -s' root'\*.* /s 1> NUL'
CALL outputMsg "Write-protect turned off."
CALL outputMsg "*"

/* get files */
CALL outputMsg "There are" fileCount "file(s) to extract from" tmpFile "into" getListFile"."
CALL get_files tmpFile getListFile /* HPG */
getListFile = "" /* this has been closed and deleted */

/* touch promoted files, if necessary */
IF touchFiles.0 > 0 THEN DO
   /* then there are files that need to be touched */
   CALL outputMsg touchFiles.0 "file(s) need to be touched..."
   cwd = directory()
   DO i = 1 TO touchFiles.0
      touchFile      = touchFiles.i
      touchFileName = filespec('Name', touchFile)
      newDir        = filespec('Drive', touchFile) || filespec('Path', touchFile)
      newDir        = left(newDir, length(newDir)-1)
      CALL directory newDir

      '@attrib -r -s -h' touchFileName '1>NUL'
      '@COPY' touchFileName '+ ,, 1> NUL'
      copy_rc = rc
      CALL directory cwd
      IF copy_rc \= 0 THEN
         CALL error_exit "Touch of" touchFiles.i "failed with COPY rc="copy_rc"."
   END /* DO all touchable files */
   CALL outputMsg "File timestamps updated."
END /* THEN files to touch */
ELSE
   /* else no files to touch */
   CALL outputMsg "No files need to be touched."
CALL outputMsg "*"

/* attach & verify labels, if necessary */
IF LABEL \= "" THEN DO
   /* then we have a label to attach */
   CALL attach_labels tmpFile labelListFile LABEL
/*   CALL verify_labels tmpFile labelChkFile LABEL */
END /* THEN attaching label */

IF \isAdd THEN              /* Don't do this step if just adding files SWN*/
   /* Update release.num */
   CALL updateReleaseNum root

CALL outputMsg "*"

IF isAdd
   THEN CALL outputMsg "ADD2BLD completed normally."
   ELSE CALL outputMsg "PVCS2BLD completed normally."
SAY  "See" outFile "for any errors."
CALL stream outFile, 'C', 'CLOSE'
CALL check_drive drive
/* in case this hasen't been done, close all temp files and delete them */
CALL close_and_delete tmpFile getListFile labelListFile labelChkFile
EXIT 0
/*===========================================================================*/


VALIDATE_FILE: PROCEDURE EXPOSE outFile getFileList labelListFile labelChkFile,
                                tmpFile PROMOTE_LST drive;
   ARG line
   /* If file or revision is not a legal file for a promote list, then */
   /* display an error message.                                        */

   file     = word(line, 1)
   revision = strip(word(line, 2))

   firstChar = left(file, 1)
   /* first char is allowed to be a . or a character */
   IF firstChar \= '.' THEN DO
      IF \DATATYPE(firstChar, 'M') THEN DO
         /* then ill-formed pathname (firstChar \= letter), so complain */
         CALL close_and_delete getFileList labelListFile labelChkFile tmpFile
         CALL stream PROMOTE_LST, 'C', 'CLOSE'
         CALL error_exit "Pathname '"file"' begins with an illegal character."
      END /* THEN not letter */
   END


   PARSE VAR file part1 '\' part2 '\' part3 '\' part4 '\' part5 '\' part6 '\' part7 '\' part8 '\' part9

   IF part9 \= "" THEN DO
      filename = part9
   end
   else IF part8 \= "" THEN DO
      filename = part8
   END
   else IF part7 \= "" THEN DO
      filename = part7
   END
   else IF part6 \= "" THEN DO
      filename = part6
   END
   else IF part5 \= "" THEN DO
      filename = part5
   END
   else IF part4 \= "" THEN DO
      filename = part4
   END
   ELSE If part3 \= "" THEN DO
      filename = part3
   END
   ELSE If part2 \= "" THEN DO
      filename = part2
   END
   ELSE filename = part1

   PARSE VAR filename name'.'ext
   ext = translate(ext)

   /* check for existence of a file extension on this pathname */
   IF ext == "" | length(ext) > 8 THEN DO
      /* then this filename has no extension, so complain and exit */
      CALL close_and_delete getFileList labelListFile labelChkFile tmpFile
      CALL stream PROMOTE_LST, 'C', 'CLOSE'
      CALL error_exit "Pathname '"file"' has no file extension."
   END /* THEN no extension */

   /* check for double slashes in file */
   IF pos("\\", file) \= 0 THEN DO
      /* then we have a double \\ in the filename, so complain and exit */
      CALL close_and_delete getFileList labelListFile labelChkFile tmpFile
      CALL stream PROMOTE_LST, 'C', 'CLOSE'
      CALL error_exit "Pathname '"file"' contains a double back-slash."
   END /* THEN \\ pathname */

   /* check for existence of a valid release number */
   firstRevChar = left(revision, 1)
   lastRevChar  = right(revision, 1)
   IF \datatype(firstRevChar, 'N') |,    /* first character not a number */
      \datatype(lastRevChar, 'N') |,     /* last character not a number  */
      pos('.', revision) == 0  THEN DO   /* at least one decimal         */
      CALL close_and_delete getFileList labelFileList labelChkFile tmpFile
      CALL stream PROMOTE_LST, 'C', 'CLOSE'
      CALL error_exit "Line '"line"' has no revision number."
   END /* THEN no revision number */
RETURN
/*===========================================================================*/


EXTRACT: PROCEDURE EXPOSE root getListFile labelListFile labelChkFile archive,
                          LABEL pvcs_files. pvcs_revisions. dupMsgs. outFile,
                          touchFiles.;
  PARSE ARG promoteFile promoteRevision count

  CALL outputMsg "["count"] "promoteFile promoteRevision

  highRev = ""
  duplicate = 0

  /* check for duplicate promotes */
  DO i = 1 TO pvcs_files.0
     IF promoteFile     == pvcs_files.i &,
        promoteRevision \= pvcs_revisions.i THEN
     DO
        duplicate = 1
        SAY "found duplicate"
        /* then duplicate promotion of different versions, so record a message */
        j = dupMsgs.0 + 1
        dupMsgs.j = "'"promoteFile"' for revisions" pvcs_revisions.i "and" promoteRevision"."
        dupMsgs.0 = j

        /* now also make sure to promote the one with the highest
           revision number */
        highRev = determineHighRevision( pvcs_revisions.i, promoteRevision )
        /* replace revision in table with result */
        pvcs_revisions.i = highRev
        SAY pvcs_files.i pvcs_revisions.i
        /* make sure we record the version that was actually promoted */
        j = dupMsgs.0 + 1
        dupMsgs.j = "   revision promoted: "highRev
        dupMsgs.0 = j

     END /* THEN file name match */
  END /* DO all previous files */

  /* only add if this is not a duplicate file */
  IF \duplicate THEN
  DO
     j                = pvcs_files.0 + 1
     pvcs_files.0     = j
     pvcs_revisions.0 = j
     pvcs_files.j     = promoteFile
     pvcs_revisions.j = promoteRevision
     SAY pvcs_files.j pvcs_revisions.j
  END

RETURN 0
/*===========================================================================*/

BuildFiles: PROCEDURE EXPOSE root getListFile labelListFile labelChkFile archive,
                          LABEL pvcs_files. pvcs_revisions. dupMsgs. outFile,
                          touchFiles.;
  /* build the files */
  CALL outputMsg "Files in the Build"
  DO i = 1 TO pvcs_files.0
     CALL outputMsg "["i"] "pvcs_files.i pvcs_revisions.i
     pvcsFile = archive'\'pvcs_files.i

     /* make sure we can handle filenames that start with a . */
     PARSE VAR pvcsfile part1 '\' part2 '\' part3 '\' part4 '\' part5 '\' part6

     IF part6 \= "" THEN DO
        fn = part6
        fname = part1'\'part2'\'part3'\'part4'\'part5'\'
     END
     ELSE IF part5 \= "" THEN DO
        fn = part5
        fname = part1'\'part2'\'part3'\'part4'\'
     END
     ELSE IF part4 \= "" THEN DO
        fn = part4
        fname = part1'\'part2'\'part3'\'
     END
     ELSE If part3 \= "" THEN DO
        fn = part3
        fname = part1'\'part2'\'
     END
     ELSE If part2 \= "" THEN DO
        fn = part2
        fname = part1'\'
     END
     ELSE DO
        fn = part1
     END

     PARSE VAR fn filename "." extension
     pvcsFile = fname''filename'.'extension'V'

     CALL lineout getListFile,   '-R'pvcs_revisions.i PVCSFile'('root'\'pvcs_files.i')'
     CALL lineout labelListFile, '-V'LABEL '-R'pvcs_revisions.i PVCSFile
     CALL lineout labelChkFile,  '-BV'LABEL PVCSFile

     PARSE VAR pvcs_files.i .'.'ext
     IF ext == "IN" | ext == "SQL" | ext == "SQC" THEN DO
        /* then a file type that must be touched */
        touch_index            = touchFiles.0 + 1
        touchFiles.touch_index = root"\"pvcs_files.i
        touchFiles.0           = touch_index
     END /* THEN touchable file */
  END
RETURN 0

/*===========================================================================*/


GET_FILES: PROCEDURE EXPOSE outFile labelListFile labelChkFile pvcsBin drive;
  ARG tmpFile getListFile
  /* do a PVCS get on the files listed in the getListFile response file */

  CALL outputMsg "Doing PVCS get..."
  '@'pvcsBin'\get_org.exe -Y -XO+E'tmpFile '@'getListFile
  get_rc = rc
  CALL copy_to_outFile tmpFile
/*  CALL close_and_delete getListFile */

  IF get_rc \= 0 | isVcsErr(outFile) THEN DO
     /* then PVCS get failed */
     CALL outputMsg "PVCS get failed getting files."
     CALL close_and_delete labelListFile labelChkFile
     CALL error_exit "See" outFile "for errors."
  END /* THEN get failed */
  CALL outputMsg "PVCS get complete."
  CALL outputMsg "*"
RETURN
/*===========================================================================*/


ATTACH_LABELS: PROCEDURE EXPOSE outFile labelChkFile pvcsBin drive;
  ARG tmpFile labelListFile LABEL

  CALL outputMsg "Attaching" LABEL "label to files..."
  '@'pvcsBin'\vcs -Q -XO+E'tmpFile '@'labelListFile
  vcs_rc = rc

  CALL copy_to_outFile tmpFile
  CALL close_and_delete labelListFile

  IF vcs_rc \= 0 | isVcsErr(outFile) THEN DO
     /* then PVCS vcs failed */
     CALL outputMsg "PVCS vcs failed attaching labels."
     CALL close_and_delete tmpFile labelChkFile
     CALL error_exit "See" outFile "for errors."
  END /* THEN vcs failed */

  CALL outputMsg LABEL "labels attached."
  CALL outputMsg "*"
RETURN
/*===========================================================================*/


VERIFY_LABELS: PROCEDURE EXPOSE outFile archiveLength pvcsBin drive,
                                pvcs_files. pvcs_revisions.;
   ARG tmpFile labelChkFile LABEL


   notPromotedCount = 0  /* count of right labels on wrong files      */
   wrongFileCount   = 0  /* count of number of files with wrong label */

   CALL outputMsg "Verifying" LABEL "label on files..."
   '@'pvcsBin'\vlog -Q -BV'LABEL '-XO'tmpFile '@'labelChkFile
   vcs_rc = rc
   CALL close_and_delete labelChkFile

   IF vcs_rc \= 0 | isVcsErr(outFile) THEN DO
      /* then PVCS vcs failed */
      CALL outputMsg "PVCS vcs failed checking labels."
      CALL close_and_delete tmpFile
      CALL error_exit "See" outFile "for errors."
   END /* THEN vcs failed */

   CALL stream tmpFile, 'C', 'OPEN READ'
   DO WHILE lines(tmpFile)
      line = translate(linein(tmpFile))
      label_file     = strip(word(line, 1))
      label_file     = substr(label_file, archiveLength+2)
      label_file     = substr(label_file, 1, length(label_file)-1)
      label_revision = strip(word(line, 5))
      SAY "line: "line

      isFound = 0
      SAY "cnt: " pvcs_files.0
      DO i = 1 to pvcs_files.0
         pvcs_file = pvcs_files.i

         /* make sure we can handle filenames that start with a . */
         PARSE VAR pvcs_file part1 '\' part2 '\' part3 '\' part4 '\' part5 '\' part6

         IF part6 \= "" THEN DO
            fn = part6
            fname = part1'\'part2'\'part3'\'part4'\'part5'\'
         END
         ELSE IF part5 \= "" THEN DO
            fn = part5
            fname = part1'\'part2'\'part3'\'part4'\'
         END
         ELSE IF part4 \= "" THEN DO
            fn = part4
            fname = part1'\'part2'\'part3'\'
         END
         ELSE If part3 \= "" THEN DO
            fn = part3
            fname = part1'\'part2'\'
         END
         ELSE If part2 \= "" THEN DO
            fn = part2
            fname = part1'\'
         END
         ELSE DO
            fn = part1
         END

         PARSE VAR fn first "." ext
         ext = ext"__V"
         pvcs_file = fname''first'.'left(ext, 2)

         SAY pvcs_file "   " label_file
         IF pvcs_file == label_file THEN DO
            /* then we've found our matching file */
            isFound = 1
            IF pvcs_revisions.i \= label_revision THEN DO
               /* then LABEL was not set, so complain */
               wrongFileCount = wrongFileCount + 1
               CALL outputMsg "Promoted" pvcs_file"V" pvcs_revisions.i",",
                              "but" LABEL "label now on revision" label_revision"."
            END /* THEN mis-natch revisions */
         END /* THEN matching file */
      END /* DO all pvcs_files */

      IF \isFound THEN DO
         /* then we verified a label on a file we didn't promote! */
         notPromotedCount = failedCount + 1
         CALL outputMsg "Verified" LABEL "label on" label_file"V, but it wasn't promoted."
      END /* THEN not found */
   END /* DO WHILE tmpFile */
   CALL close_and_delete tmpFile

   IF wrongFileCount \= 0 THEN
      CALL error_exit wrongFileCount "promoted files with labels on wrong version."

   IF notPromotedCount \= 0 THEN
      CALL error_exit failedCount "correct label(s) found on file(s) not promoted."

   CALL outputMsg LABEL "labels checked."
   CALL outputMsg "*"
RETURN noFailures
/*===========================================================================*/


OUTPUTMSG: PROCEDURE EXPOSE outFile;
  PARSE ARG msg
  SAY msg
  IF outFile \= "" THEN
     /* then we have a file to output to */
     CALL lineout outFile, msg
RETURN 0
/*===========================================================================*/


UPDATERELEASENUM: PROCEDURE EXPOSE version archive tmpFile pvcsBin outFile drive;

ARG root
  filename  = root'\release.num'

  /* delete old RELEASE.NUM file */
  '@attrib -r -s -h' filename '1> NUL'
  CALL SysFileDelete filename
  IF RESULT \= 0 & RESULT \= 2 THEN
     /* then file exists, but it couldn't be deleted for some reason */
     CALL error_exit "Unable to delete old version of `"filename"'."

  CALL outputMsg "Create and update the release.num file..."

  /* write the new RELEASE.NUM file */
  IF stream(filename, 'C', 'OPEN WRITE') \= "READY:" THEN DO
     /* then we failed to open the date file, so complain */
     CALL outputMsg "P2BLD failed to create the new "filename" file:" rc
     CALL error_exit filename "not updated."
  END /* THEN open failed */

  PARSE VALUE date() WITH day month year
  version_line =version day month year time('C')
  CALL lineout filename, version_line
  CALL stream filename, 'C', 'CLOSE'
  '@attrib +r' filename

  /* update PVCS with RELEASE.NUM (ignore any errors) */
  '@'pvcsBin'\vcs -L -Y -Q -XONUL' archive'\release.numv'
  '@'pvcsBin'\put_org.exe -Y -Q -XONUL -M"Generated by P2BLD"' archive'('filename')'
  '@'pvcsBin'\get_org.exe -Y -Q -XONUL ' archive'\release.numv('filename')'

  CALL outputMsg "release.num updated as" version_line

RETURN 0
/*=========================================================================*/


ISTOUCHABLE: PROCEDURE;
  ARG filename
  /* If filename has a file extension that needs to be touched to be */
  /* refreshed correctly, return 1.  Otherwise, return 0.            */

  PARSE VAR filename .'.'ext
RETURN ext == "IN" | ext == "SQL" | ext == "SQC"
/*=========================================================================*/


COPY_TO_OUTFILE: PROCEDURE EXPOSE outFile;
  ARG srcFile
  IF outfile \= "NUL" & outFle \= "OUTFILE" & outFile \= "" THEN DO
     /* then we have a file to output to */
     CALL stream srcFile, 'C', 'OPEN READ'
     DO WHILE lines(srcFile)
        line = linein(srcFile)
        CALL lineout outFile, line
     END /* DO WHILE srcFile */
     CALL stream srcFile, 'C', 'CLOSE'
  END /* THEN outFile */
RETURN
/*==========================================================================*/


ERROR_EXIT: PROCEDURE EXPOSE outFile drive;
   PARSE ARG msg
   CALL check_drive drive
   CALL outputMsg msg
   SAY  "ADD2BLD/PVCS2BLD aborted."
   CALL err_beep
   CALL stream outFile, 'C', 'CLOSE'
   EXIT 1
RETURN
/*==========================================================================*/


CLOSE_AND_DELETE: PROCEDURE;
   ARG files
   DO WHILE files \= ""
      PARSE VAR files file files
      IF file \= "" THEN DO
         /* then the file still exists, do close and delete it */
         CALL stream file, 'C', 'CLOSE'  /* no harm to close a closed file */
         CALL SysFileDelete file
      END /* THEN still exists */
   END /* DO WHILE files */
RETURN
/*==========================================================================*/


CHECK_DRIVE: PROCEDURE;
   ARG DRIVE
   IF DRIVE \= "" THEN
      /* then we have a temporary drive letter to delete */
      '@net use' drive '/D 1> NUL'
RETURN
/*===========================================================================*/

determineHighRevision: PROCEDURE
   ARG listRev, newRev

   highRev = listRev

   PARSE VAR listRev llev.1 "." llev.2 "." llev.3 "." llev.4
   PARSE VAR newRev  nlev.1 "." nlev.2 "." nlev.3 "." nlev.4

   DO i = 1 TO 4
      IF nlev.i > llev.i THEN
      DO
         highRev = newRev
         leave
      END
      ELSE IF llev.i > nlev.i THEN
      DO
         leave
      END
   END

RETURN highRev
/*===========================================================================*/
