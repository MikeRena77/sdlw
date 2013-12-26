/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   extractl.cmd  $
*               $Revision:   1.5  $
*               $Date:   Oct 09 1998 12:01:20  $
* DESCRIPTION:  See usage help below.
*
* TARGET:       OS/2 2.1
*
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/extractl.cmdv  $
   
      Rev 1.5   Oct 09 1998 12:01:20   brettl
   changed andirs_txt variable to andirsFile, for consistency
   added explicity open/read and close for andirs.txt file.
   when andirs.txt moved to d:\, movlabel was unable to open it when
   run via build scripts (but worked fine if run in isolation)
   
      Rev 1.4   Oct 08 1998 18:28:24   brettl
   Changed default location of proot.cmd or andirs.txt to be on D:\
   These files are build dependent and having in p:\ was causing a problem
   
      Rev 1.3   Aug 19 1997 15:30:34   BrettL
   updated script to support renamed archives ("v" suffix)
   
      Rev 1.2   01 Jul 1997 15:45:34   BrettL
    Integrated new feature of proot.  Passing a "-V<pvcs_drive>" will
    instruct proot to create vcs.cfg files in each hierarchy directory.
   
      Rev 1.1   30 Dec 1996 10:05:24   rosimild
   NSN - fixed path for andirs.txt
   
      Rev 1.0   19 Dec 1996 14:59:00   rosimild
   Initial revision.
   
      Rev 1.18   18 Mar 1996 13:00:38   hartmute
   Changed way how the output file is closed:  Make sure we have one, and send
   finish message to screen only.
   
      Rev 1.17   18 Mar 1996 12:55:12   hartmute
   Close output file at the end.
   
      Rev 1.16   19 Oct 1995 08:58:02   MerrillC
   Converted to assume commas between arguments.
   Process a response file of files in each directory rather than process
   the directory as a wildcard.
   Upgrade to various new conventions.
   
      Rev 1.15   06 Oct 1995 18:06:42   MerrillC
   Added missing END to a IF THEN DO.
   
      Rev 1.14   04 Oct 1995 09:06:44   MerrillC
   Changed calls to PVCS get to calls to get_org.
   If <label> argument is not specified, then display usage.
   Delete EXTRACTL.$$$ temp file at end.
   
      Rev 1.13   06 Sep 1995 09:24:24   charlies
   Add ISDIR procedure. SWN
   
      Rev 1.12   06 Sep 1995 08:51:30   charlies
   Added check for target subdirectory hierarcy. SWN
   
      Rev 1.11   26 Aug 1995 19:39:30   unknown
   Corrected syntax error.
   
      Rev 1.10   26 Aug 1995 18:50:48   MerrillC
   Avoid a lot of noise error messages by skipping PVCS archive directories
   that don't have any files in them to extract.
   
      Rev 1.9   25 Jul 1995 14:01:32   charlies
   Added call to findpvcs routine to determine PVCS archive drive.
   
      Rev 1.8   04 Jun 1995 12:30:18   charlies
   Changed archive dir from P:\VCS to Q:\VCS
   
      Rev 1.7   13 Jan 1995 14:21:32   MerrillC
   The date inserted into the release number now has spaces between the
   day, month, and year and the year is four digits (e.g., '1995'
   rather than '95')
* 11/04/94 Mac - Now updates RELEASE.NUM just like PVCS2BLD does.
* 07/25/94 Mac - Changed Q: to J: for PVCS binaries.
* 07/11/94 Mac - converted to use PVCS for OS/2
* 04/15/94 Mac - correct usage comment
*                switched from dirs.txt to andirs.txt
* 03/24/94 Mac - initial version
*****************************************************************************/
/* end extraction */

ARG ROOT',' label',' pvcsID',' outFile
outFileDefault = "extractl.out"

CALL RxFuncAdd 'SysFileTree',     'RexxUtil', 'SysFileTree'
CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'
CALL RxFuncAdd 'SysCls',          'RexxUtil', 'SysCls'
CALL RxFuncAdd 'SysTempFileName', 'RexxUtil', 'SysTempFileName'

/* Handle usage request */
IF isUsage(ROOT) THEN DO
   /* then called with no arguments, so treat it as a HELP request */
   CALL SysCls
   SAY ""
   SAY ""
   SAY "Usage:  EXTRACTL <root>, <label>[, [<pvcsID>][, <output_File>]]"
   SAY ""
   SAY "This script extracts all PROMS files in the PVCS archive <pvcsID>"
   SAY "which currently have the <label> PVCS label and puts them into"
   SAY "the <root> hierarchy."
   SAY ""
   SAY "<pvcsID> identifies which PVCS archive root to process.  Values can"
   SAY "be an applname (e.g., NBase or NShell), a drive letter (e.g., P: =>"
   SAY "P:\VCS), a pathname (e.g., Q:\VCS), or blank which defaults to the"
   SAY "value in the UDE_APPLNAME environment variable which itself defaults"
   SAY "to NBASE."
   SAY ""
   SAY "When this script runs, it write its error log to <output_file> which"
   SAY "defaults to '"outFileDefault"'.  If <output_file> is 'NUL', then no file"
   SAY "is written."
   EXIT 0
END /* THEN usage */

/* default and normalize arguments */
ROOT       =  strip(ROOT)
label      =  strip(label)
IF label \= "" THEN label = "-R"label
pvcsID     =  strip(pvcsID)
outFile    =  strip(outFile)
IF outFile == ""    THEN outFile = outFileDefault
IF outFile == "NUL" THEN outFile = ""
tmpFile    =  ""
respFile   =  ""
pvcsBin    =  "J:\PVCS53\NT\NT"
andirsFile =  "D:\ANDIRS.TXT"

/* create unique temporary files */
tmpFile = SysTempFileName('EXLT????.$$$')
IF tmpFile == "" THEN
   CALL error_exit "Unable to generate unique tmpFile name in current directory."

/* touch the tmpFile to reserve its name */
CALL stream tmpFile, 'C', 'OPEN'
CALL stream tmpFile, 'C', 'CLOSE'

respFile = SysTempFileName('EXLR????.$$$')
IF respFile == "" THEN
   CALL error_exit "Unable to generate unique respFile name in current directory."

/* touch the respFile to reserve its name */
CALL stream respFile, 'C', 'OPEN'
CALL stream respFile, 'C', 'CLOSE'


/* make certain we have an output file */
outFilename = outFile
IF outFile \= "" THEN DO
   /* then we have an output file to write to */
   CALL stream outFile, 'C', 'CLOSE'
   CALL SysFileDelete outfile
   IF RESULT \= 0 & RESULT \= 2 THEN DO
      outFile = "" /* don't try to output to this file */
      CALL error_exit "Unable to delete old version of output file '"outFilename"'."
   END /* THEN can't delete */

   CALL stream outFile, 'C', 'OPEN WRITE'
   IF RESULT \= "READY:" THEN DO
      outFile = "" /* don't try to output to this file */
      CALL error_exit "Unable to open new output file '"outFilename"'."
   END /* THEN ready */
END /* THEN outFile exists */

/* make certain andirs.txt is readable */
IF stream(andirsFile, 'C', 'OPEN READ') \= 'READY:' THEN DO
   /* then can't open annotated directory file, so complain and exit */
   CALL error_exit "Can't open annotated directory list," andirsFile". Get appropriate version into d:\"
END /* THEN no ANDIRS.TXT */

/* determine which PVCS root to use from <pvcsID> argument            */
pvcs_Root    = "" /* pathname to PVCS archive root directory          */
drive_letter = "" /* if non-empty, then it's a temporary drive letter */
CALL outputMsg "Looking for PVCS archive..."
PARSE VALUE (findpvcs(pvcsID, outFile)) WITH pvcs_Root drive_letter

/* determine if returned value is a valid PVCS root */
IF pvcs_Root == "" THEN
   CALL error_exit "'"pvcsID"' is not a valid PVCS root."

IF \isdir(ROOT"\common") | \isdir(ROOT"\cc") | \isdir(ROOT"\sc") |,
   \isdir(ROOT"\ipt") | \isdir(ROOT"\target") THEN DO
   /* then there doesn't seem to be a hierarchy, so make one */
   CALL outputMsg "Creating root" ROOT" hierarchy."
   pvcs_drive = SUBSTR(pvcs_root, 1, 2)

   CALL proot "-V"pvcs_drive ROOT

   IF \isdir(ROOT"\common") | \isdir(ROOT"\cc") | \isdir(ROOT"\sc") |,
      \isdir(ROOT"\ipt") | \isdir(ROOT"\target") THEN
      /* then we didn't seem to be able to create one either */
      CALL error_exit "Cannot root" ROOT"."
   ELSE /* else we created it OK */
      SAY "Root" ROOT "hierarcy created successfully."
END /* THEN no hierarchy */

CALL outputMsg  "Extracting files labeled" label "from" PVCS_ROOT "into" ROOT "..."

DO WHILE lines(andirsFile)
   line = linein(andirsFile) /* list of hierarcy directories */

   PARSE VAR line type dir comment
   IF interestingType(type) == 0 THEN ITERATE /* not interested, so skip it */
   fullDir  = ROOT||dir                               /* has terminating \ */
   fullDir  = substr(fullDir, 1, length(fullDir)-1)   /* no terminating  \ */
   PVCS_Dir = PVCS_ROOT||dir                          /* has terminating \ */
   PVCS_Dir = substr(PVCS_Dir, 1, length(PVCS_DIR)-1) /* no terminating  \ */

   CALL outputMsg " "
   CALL outputMsg fullDir

   /* get the files for this directory */
   cmd = pvcsBin'\get -Y 'label '-XO+E'tmpfile PVCS_Dir'\*.*v('fullDir')'
   CALL outputMsg cmd
   '@'cmd

   CALL copy_to_outFile tmpFile
   CALL SysFileDelete tmpfile

   IF isVcsErr(tmpFile) THEN DO
      /* then PVCS get failed */
      CALL outputMsg "PVCS get failed getting files."
      SAY "See" outFile "for errors."
      CALL error_exit ""
   END /* THEN get failed */

END /* DO WHILE andirs.txt */

CALL SysFileDelete respFile

/* Update release.num */
CALL updateReleaseNum root
CALL outputMsg "*"

/* wrap up the batch file */
CALL SysFileDelete tmpFile

/* close the andirs file */
CALL stream andirsFile, 'C', 'CLOSE'

/* close the output file */
IF outFile \= "" THEN DO
   /* then we have a real output file to close */
   CALL stream outFile, 'C', 'close'
   SAY  'EXTRACTL completed normally.  See' outFile 'for log.'
END /* THEN outFile */

EXIT 0
/*=========================================================================*/


INTERESTINGTYPE: PROCEDURE;
  ARG typeField
  /* return 1 if typeField represents an interesting type and 0 otherwise */

  type = substr(typeField, 3, 1)
  dev  = substr(typefield, 2, 1)
RETURN (type=="R" | type=="C" | type=="S" | type=="B") & dev == "D"
/*=========================================================================*/


UPDATERELEASENUM: PROCEDURE EXPOSE PVCS_ROOT tmpFile respFile pvcsBin outFile;
  ARG root
  releaseNum = root'\release.num'

  CALL outputMsg "Update release.num file..."
  '@'pvcsBin'\get -Y -XO+E'tmpFile PVCS_ROOT'\release.numv('releaseNum')'
  CALL copy_to_outFile tmpFile
  CALL SysFileDelete tmpFile

  /* open the release.num file */
  CALL stream releaseNum, 'C', 'OPEN READ'
  IF RESULT \= "READY:" THEN DO
     /* then we failed to open the date file, so complain */
     CALL outputMsg "EXTRACTL cannot open "releaseNum" for reading."
     CALL outputMsg releaseNum "not updated."
     RETURN 1
  END /* THEN open failed */
                          
  /* read the version number */
  PARSE VALUE linein(releaseNum) WITH version rest

  /* write the new RELEASE.NUM file */
  CALL stream releaseNum, 'C', 'CLOSE'       /* close the old file  */
  '@attrib -r' releaseNum
  CALL SysFIleDelete releaseNum              /* delete the old file */
  CALL stream releaseNum, 'C', 'OPEN WRITE'  /* open the new file   */
  IF RESULT \= "READY:" THEN DO
     /* then we failed to open the date file, so complain */
     CALL outputMsg "EXTRACTL cannot delete "releaseNum" for writing."

     /* attempt to restore deleted release.num */
     '@'pvcsBin'\get -Y -XO+E'NUL PVCS_ROOT'\release.numv(releaseNum)'
     CALL outputMsg releaseNum "not updated."
     RETURN 1
  END /* THEN open failed */

  today = date()
  PARSE VALUE date() WITH day month year
  newReleaseNum = version day month year time('C')
  CALL lineout releaseNum, newReleaseNum
  CALL stream releaseNum, 'C', 'CLOSE'
  '@attrib +r' releaseNum

  CALL outputMsg releaseNum "updated as" newReleaseNum
RETURN 0
/*=========================================================================*/


OUTPUTMSG: PROCEDURE EXPOSE outFile tmpFile respFile;
  PARSE ARG msg
  SAY msg
/*  IF outFile \= "" THEN */
     /* then we have a file to output to */
/*     CALL lineout outFile, msg */
RETURN 0
/*===========================================================================*/


ERROR_EXIT: PROCEDURE EXPOSE outFile tmpFile respFile;
  PARSE ARG msg

  CALL outputMsg msg
  CALL outputMsg "EXTRACTL aborted."

  IF outFile \= "" THEN 
     CALL stream outFIle, 'C', 'CLOSE'

  IF tmpFile \= "" THEN DO 
     CALL stream tmpFile, 'C', 'CLOSE'
     CALL SysFileDelete tmpFile
  END /* THEN tmpFile */

  IF respFile \= "" THEN DO
     CALL stream respFile, 'C', 'CLOSE'
     CALL SysFileDelete respFile
  END /* THEN respFile */

  CALL err_beep
EXIT 1
/*==========================================================================*/


COPY_TO_OUTFILE: PROCEDURE EXPOSE outFile;
  ARG srcFile
  IF outFile \= "" THEN DO
     /* then we have a file to output to */
     CALL stream srcFile, 'C', 'OPEN READ'
     DO WHILE lines(srcFile)
        CALL lineout outFile, linein(srcFile)
     END /* DO WHILE srcFile */
     CALL stream srcFile, 'C', 'CLOSE'
  END /* THEN outFile */
RETURN
/*==========================================================================*/

