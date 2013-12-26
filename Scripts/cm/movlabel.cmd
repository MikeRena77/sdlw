/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   movlabel.cmd  $
*               $Revision:   1.2  $
*               $Date:   Oct 09 1998 11:59:40  $
* DESCRIPTION:  MOVELABEL.CMD <pvcsDir> <oldLabel> <newLabel>
*               See Usage below.
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
*$Log:   P:/vcs/cm/movlabel.cmdv  $
*  
*     Rev 1.2   Oct 09 1998 11:59:40   brettl
*  changed "andirs.txt" to "ANDIRS.TXT" for consistency
*  
*     Rev 1.1   Oct 08 1998 18:27:38   brettl
*  Changed default location of proot.cmd or andirs.txt to be on D:\
*  These files are build dependent and having in p:\ was causing a problem
*  
*     Rev 1.0   Aug 19 1997 15:36:06   BrettL
*  Initial revision.
   
      Rev 1.19   27 Oct 1995 14:44:52   MerrillC
   Do not require a comma on the command line if asking for usage help.
   
      Rev 1.18   27 Oct 1995 14:24:46   MerrillC
   Require that arguments be separated by commas by terminating with an
   error message is there are no commas on the command line.
   
      Rev 1.17   24 Oct 1995 15:03:48   MerrillC
   Remove the blank separated syntax line alternative from the usage help.
   
      Rev 1.16   10 Oct 1995 17:35:54   MerrillC
   Corrected parsing of the spece-delimited argument list.
   
      Rev 1.15   09 Oct 1995 10:25:16   MerrillC
   Added output file argument which defaults to
   \SCR\BUILD\<newlabel>\MOVLABEL.OUT.  If the output file argument is NUL, 
   no output file is written.
   
      Rev 1.14   30 Aug 1995 16:17:50   MerrillC
   Log progress message as well as error message to MOVLABEL.OUT.
   
      Rev 1.13   30 Aug 1995 13:55:28   MerrillC
   Removed extraneous EXIT left over from previous debugging.
   
      Rev 1.12   24 Aug 1995 18:42:48   CharlieS
   Changed processing to skip PVCS archive directories that have no files
   in them.
   
      Rev 1.11   20 Jul 1995 18:16:52   MerrillC
   Correct syntax error in CALL STREAM.
   
      Rev 1.10   20 Jul 1995 10:59:16   MerrillC
   In addition to examining the files in PVCS in the build hierarchy to see
   of they have a label to move, this script now also processes
   P:\VCS\UPDATE\MAKDISKS.CMV.
   
      Rev 1.9   08 Jun 1995 09:51:10   MerrillC
   Opened the ANDIRS.TXT file as READ-ONLY in an effort to allow two
   copies of this script to run in parallel.
   
      Rev 1.8   05 Jun 1995 13:46:52   MerrillC
   Replaced optional 'A' argument with a call to FINDPVCS() helper function
   to determine which PVCS archive to use.
   
      Rev 1.7   04 Jun 1995 12:29:08   charlies
   Changed archive dir from P:\vcs to Q:\vcs
   
      Rev 1.6   27 Apr 1995 13:51:56   charlies
   Added $Log$.  Also added applications argument 'A', if set uses S:\VCS.
* 07/29/94 Mac - Added missing quotes to @TYPE command.
* 07/26/94 Mac - Changed Q: to J: for PVCS binaries.
* 07/20/94 Mac - Converted to execute directly under PVCS for OS/2 rather 
*                than write a DOS batch file.
* 05/10/94 Mac - re-wrote to be standalone and to use andirs.txt file
* 03/31/94 Mac - initial version
*****************************************************************************/
/* end extraction */

outFile      = ""
drive_letter = ""

/* do a quick parse to check for missing commas */
ARG argList
IF \isUsage(arglist) & pos(',', argList) == 0 THEN
   CALL error_exit "Arguments must be separated by commas."

/* do the real command line parse */
ARG oldLabel_arg','newLabel_arg','applName_arg','outFile_arg

/* normalize and default arguments */
oldLabel     = strip(oldLabel_arg)
newLabel     = strip(newLabel_arg)
applName_arg = strip(applName_arg)
outFile      = translate(strip(outFile_arg))
IF outFile  == "" THEN outFile = 'movlabel.out'
IF outFile  == "NUL" THEN outFile = ""

/* Handle usage request */
IF isUsage(oldLabel) | newLabel == "" THEN DO
   /* then called with no arguments, so treat it as a HELP request */
   '@cls'
   SAY " "
   SAY " "
   SAY "Usage:  MOVLABEL <oldLabel>, <newLabel>[, [<applName>][, <outFile>]]"
   SAY " "
   SAY "If a PVCS archive in the PVCS hierarchy identified by <applName> has the PVCS"
   SAY "label <oldLabel> attached to it, then the label <newLabel> is also attached to"
   SAY "that archive.  If that archive already has the <newLabel> label attached, then"
   SAY "<newLabel> is 'bumped' to the same revision as <oldLabel>."
   SAY " "
   SAY "<applName> identifies which PVCS archive root to process.  Values can be an"
   SAY "'applname' (e.g., NBase, NShell, NChevron, etc.) or a directory pathname (e.g.,"
   SAY "Q:\VCS), or blank which defaults to the value in the UDE_APPLNAME environment"
   SAY "variable which itself defaults to NBase."
   SAY " "
   SAY "When this script runs, it writes an error log to <outFile> which defaults to"
   SAY "\SCR\BUILD\<build_name>\MOVLABEL.OUT where <build_name> is implied by <newLabelin the  Search this file for the string 'ERROR'."
   SAY "If <outFile> is 'NUL', no file is written."
   EXIT 0
END /* THEN usage */

CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'
CALL RxFuncAdd 'SysFileTree',     'RexxUtil', 'SysFileTree'
CALL RxFuncAdd 'SysTempFileName', 'RexxUtil', 'SysTempFileName'

/* local variables */
makdisksFile = "P:\VCS\UPDATE\makdisks.cmv"
andirsFile   = "D:\ANDIRS.TXT"         /* annotated directory list file     */
pvcsBin      = "J:\PVCS53\NT\NT"       /* PVCS DOS executable directory    */
baseName     = "mvlbl???"              /* template for temporary file names */
pvcsRoot     = ""                      /* PVCS root directory for applName  */
drive_letter = ""                      /* temporary drive letter, if any    */


/* prepare to log messages */
IF outFile \= "" THEN DO
   /* then we have an output file we can output to */
   CALL SysFileDelete outFile
   IF stream(outFile, 'C', 'OPEN WRITE') \= 'READY:' THEN DO
      /* then can't open output file, so complain and exit */
      SAY "Can't open the output file," outFile"."
      SAY "MOVLABEL aborted."
      CALL err_beep
      EXIT 1
   END /* THEN no outFile */
END /* THEN not NUL */
CALL outputMsg "MOVLABEL" date() time()


/* validate applName argument */
applName = applName(applName_arg)
IF applName == "" THEN
   /* then applName_arg is invalid, so complain and exit */
   CALL error_exit "'"applName_arg"' cannot be converted into an application name."


/* determine which PVCS root to use from <applName> argument */
PARSE VALUE (findpvcs(applName, outFile)) WITH pvcsRoot drive_letter
IF pvcsRoot == "" THEN
   /* then can't find PVCS root, so complain and exit */
   CALL error_exit "'"applName_arg"' is not a legal PVCS root."


IF stream(andirsFile, 'C', 'OPEN READ') \= 'READY:' THEN DO
   /* then can't open annotated directory file, so complain and exit */
   CALL error_exit "Can't open annotated directory list," andirsFile". Get appropriate version into d:\"
END /* THEN no ANDIRS.TXT */


/* create unique temporary file names */
tmpFile   = SysTempFileName(baseName'.$$$')
IF tmpFile == "" | stream(tmpFile, 'C', 'OPEN') \= "READY:" THEN
   /* then can't open temporary file name, so complain and exit */
   CALL error_exit "Can't open temporary file" tmpFile", the tmpFile."
CALL stream tmpFile, 'C', 'CLOSE'  /* equivalent to touching tmpFile */

responseFile = SysTempFileName(baseName'.lst')
IF responseFile == "" | stream(responseFile, 'C', 'OPEN WRITE') \= 'READY:' THEN DO
   /* then can't open temporary file name, so complain and exit */
   CALL close_and_delete tmpFile
   CALL error_exit "Can't open the temporary file" responseFile", the responseFile."
END /* THEN no response name */
CALL stream responseFile, 'C', 'CLOSE' /* equivalent of touching responseFile */


CALL outputMsg 'Attaching' newLabel 'to versions with' oldLabel'...'
DO WHILE lines(andirsFile)
   line = linein(andirsFile)               /* list of hierarcy directories */
   IF left(line, 1)=="*" THEN ITERATE      /* comment line                 */
   IF strip(line) == ""  THEN ITERATE      /* blank line                   */

   annotation = subword(line, 1, 1)
   dir        = subword(line, 2, 1)                                  
   type       = substr(annotation, 1, 1)   /* Archived/not archived marker */

   IF type \= "V" THEN ITERATE             /* not a PVCS source file       */
   
      srcFiles = pvcsRoot||dir'*.*v'
      CALL outputMsg srcFiles" - processed"
 
      /* move the labels */
      '@'pvcsBin'\vcs -Q -Y -XO+E'tmpFile '-R'oldLabel '-V'newLabel srcFiles
      vcs_rc = rc
      CALL SysFileDelete responseFile
      CALL check_rc vcs_rc

END /* WHILE andirsFile */
CALL stream andirsFile, 'C', 'CLOSE'

/*
/* process MAKDISKS.CMD */
CALL outputMsg
'@'pvcsBin'\vcs -Q -Y -XO+E'tmpFile '-R'oldLabel '-V'newLabel makdisksFile
vcs_rc = rc
CALL check_rc vcs_rc
*/

IF drive_letter \= "" THEN
   /* then we have a temporary drive letter to unlink */
   '@net use' drive_letter '/D'

CALL outputMsg 'MOVLABEL complete.'
IF outFile \= "" THEN DO
   /* then we have a real output file to close */
   CALL stream outFile, 'C', 'close'
   SAY  'See' outFile 'for error listings, if any.'
END /* THEN outFile */

EXIT 0
/*========================================================================*/


CHECK_RC: PROCEDURE EXPOSE tmpFile outFile;
  ARG vcs_rc
  IF vcs_rc \= 0 THEN DO
     /* then something failed */
     IF isVcsError(tmpFile) THEN DO
        /* then VCS got an error */
        CALL outputMsg " "
        CALL outputMsg "Failed to move a label."
     END /* THEN  PVCS error */
  END /* THEN rc \= 0 */

  /* unconditionally record output */
  IF stream(tmpFile, 'C', 'QUERY EXISTS') \= "" THEN DO
     /* then we have a tmpFile to concatennate */
     '@TYPE' tmpFile

     CALL outputMsg " "
     DO WHILE lines(tmpFile)
        CALL outputMsg linein(tmpFile)
     END /* WHILE tmpFile */
     CALL stream tmpFile, 'C', 'CLOSE'
  END /* THEN tmpFile exists */
CALL SysFileDelete tmpFile
RETURN
/*========================================================================*/


ISVCSERROR: PROCEDURE;
  ARG file
  
  isError = 0
  IF stream(file, 'C', 'QUERY EXISTS') \= "" THEN DO
     /* then there is an error file to process */
     CALL stream file, 'C', 'OPEN READ'
     DO WHILE lines(file)
        IF isError THEN LEAVE
        line = lineIn(file)

        PARSE VAR line "vcs:" severity"," rest
        severity = strip(severity)
        isError = severity == "error"
     END /* WHILE file */
     CALL stream file, 'C', 'CLOSE'
   END /* THEN error file exists */

return isError 
/*=========================================================================*/


OUTPUTMSG: PROCEDURE EXPOSE outFile;
  PARSE ARG msg
  SAY msg
  IF outFile \= "" THEN
     /* then we aren't suppressing output, so do it */
     CALL lineout outFile, msg
RETURN
/*=========================================================================*/



ERROR_EXIT: PROCEDURE EXPOSE outFile drive_letter;
   PARSE ARG msg
   IF drive_letter \= "" THEN
      /* then we have a temporary drive letter to unlink */
      '@net use' drive_letter '/D 1> NUL'

   CALL outputMsg msg
   CALL outputMsg "MOVLABEL aborted."
   CALL err_beep

   IF outFIle \= "" THEN
      /* then we have a real output file, so close it */
      CALL stream outFile, 'C', 'CLOSE'

   EXIT 1
RETURN
/*==========================================================================*/


CLOSE_AND_DELETE: PROCEDURE;
   ARG files
   DO WHILE files \= ""
      PARSE VAR files file files
      CALL stream file, 'C', 'CLOSE'  /* no harm to close a closed file */
      CALL SysFileDelete file
   END /* DO WHILE files */
RETURN
/*==========================================================================*/

