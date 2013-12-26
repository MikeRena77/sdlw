/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   nottip.cmd  $
*               $Revision:   1.0  $
*               $Date:   Aug 19 1997 15:28:40  $
* DESCRIPTION:  See help below
*
* TARGET:       OS/2 2.1
*
* MODIFICATION/REV HISTORY:
* $Log:   Q:/VCS/CHANGES/nottip.cmdv  $
*  
*     Rev 1.0   Aug 19 1997 15:28:40   BrettL
*  Initial revision.
   
      Rev 1.9   27 Oct 1995 14:47:06   MerrillC
   Do not require a comma in the command line when requesting usage help.
   
      Rev 1.8   25 Oct 1995 17:31:40   MerrillC
   Standardized handling of screen display and log file so that everything
   goes to both.  So, if there is nothing to report, you at least get a log
   file assuring you there WAS nothing to report.
* 09/14/95 Mac - Added optional output file argument
*                Do not save initial "Recording directories" and final
*                "NOTTIP Complete" messages in output file.
*                Allow blank lines to be output as separators.
* 10/26/94 Mac - initial version
*****************************************************************************/
/* end extraction */
CALL RxFuncAdd 'SysFileTree',     'RexxUtil', 'SysFileTree'
CALL RxFuncAdd 'SysTempFileName', 'RexxUtil', 'SysTempFileName'
CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'

/* local variables */
tmpFile = ""
outFile = ""
tdir = "\."

ARG arglist
IF \isUsage(arglist) & pos(',', arglist) == 0 THEN
   CALL error_exit "NOTTIP arguments must be separated by commas."

ARG DIR',' LABEL',' OUTFILE

/* normalize and default arguments */
DIR     = strip(DIR)
LABEL   = strip(LABEL)
OUTFILE = strip(OUTFILE)
IF OUTFILE == ""    THEN OUTFILE = "NOTTIP.OUT"
IF OUTFILE == "NUL" THEN OUTFILE = ""

/* Handle usage request */
IF isUsage(DIR) THEN DO
   /* then called with no arguments, so treat it as a HELP request */
   SAY ""
   SAY "Usage:  NOTTIP <pvcs_dir>, <pvcs_label>[, <outFile>]"
   SAY " "
   SAY "<pvcs_dir> is a PVCS archive directory written without trailing '\'"
   SAY "(e.g., P:\VCS\IPT\UI)."
   SAY ""
   SAY "<pvcs_label> is a PVCS label (e.g., BUILD) or a PVCS revision number"
   SAY "(e.g., 1.23)."
   SAY " "
   SAY "The output in <outFile> is the list of all files in <pvcs_dir> or in any of its"
   SAY "subdirectories which have the <pvcs_label> PVCS label and that label is"
   SAY "NOT on the tip revision of the file.  If <outFile> is specified, the"
   SAY "output goes to the NOTTIP.OUT.  If <outfile> is NUL, then no output file"
   SAY "is written.  In all cases, a copy of the output is displayed on the screen."
   EXIT 0
END /* THEN usage */

IF outFile \= "" THEN DO
   /* then we have an output file to open */
   CALL stream outFile, 'C', 'OPEN WRITE'
   IF RESULT \= "READY:" THEN DO
      outFileName = outFile
      outFile = ""
      CALL error_exit "Can't open output file," outFileName"."
   END /* THEN open failed */
END /* THEN output file */

CALL outputMsg "Recording directories in" DIR"..."
rc = SysFileTree(DIR'\*.*', dirs., 'DSO')
IF rc \= 0 THEN DO
   /* then SysFileTree() failed, so complain */
      CALL outputMsg "SysFileTree("DIR"\*.*) failed."
      EXIT 1
   END /* THEN SysFileTree() failed */
CALL outputMsg "Processing" dirs.0 "directories outputting to" outfile"..."

/* prepend DIR to front of dirs.i array */
dirlist.1 = DIR
DO i = 1 TO dirs.0
    directory = translate(dirs.i)
   next_i = i+1
   dirlist.next_i = directory
end /* do */
dirlist.0 = dirs.0 + 1

tmpFile = SysTempFileName('NOTTIP.???')
CALL SysFileDelete tmpFile

DO i = 1 to dirlist.0
   /* don't process "." or ".." */
   PARSE VALUE dirlist.i WITH tdir '\.' 
   IF tdir \= dirlist.i  THEN
      CALL outputMsg "Skipping " dirlist.i
   ELSE DO
      CALL outputMsg "Processing " dirlist.i
      '@vlog -XENUL -XO'tmpFile '-bc'LABEL dirlist.i'\*.*V'

      headerPrinted = 0
      CALL stream tmpFile, 'C', 'OPEN READ'
      IF lines(tmpFile) & \headerPrinted THEN DO
         /* then print header before outputting vlog result */
         CALL outputMsg " "
         CALL outputMsg dirlist.i
         headerPrinted = 1
      END /* THEN output header */
   
      DO WHILE lines(tmpFile)
         CALL outputMsg linein(tmpFile)
      END /* WHILE tmpFile */
      CALL stream tmpFile, 'C', 'CLOSE'
      CALL SysFileDelete tmpFile
   END  /* if ! "." or ".." */
END /* DO all directories */

CALL outputMsg "NOTTIP complete."
IF outFile \= "" THEN
   CALL stream outFile, 'C', 'CLOSE'
EXIT 0
/*=========================================================================*/


OUTPUTMSG: PROCEDURE EXPOSE outFile;
   PARSE ARG msg

   IF outFile \= "" THEN
      CALL lineout outFile, msg
   SAY msg
RETURN
/*=========================================================================*/


ERROR_EXIT: PROCEDURE EXPOSE outFile tmpFile;
   PARSE ARG msg
   CALL outputMsg msg
   CALL outPutMsg "NOTTIP aborted."
   CALL err_beep

   IF tmpFile \= "" THEN DO
      CALL stream tmpFile, 'C', 'CLOSE'
      CALL SysFileDelete tmpFile
   END /* then tmpFile exists */

   IF outFile \= "" THEN
      CALL stream outFile, 'C', 'CLOSE'

EXIT 1

