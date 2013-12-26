CALL RxFuncAdd 'SysFileTree',     'RexxUtil', 'SysFileTree'
CALL RxFuncAdd 'SysTempFileName', 'RexxUtil', 'SysTempFileName'
CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'
tmpFile = ""
outFile = ""
tdir = "\."

ARG arglist
IF \isUsage(arglist) & pos(',', arglist) == 0 THEN
   CALL error_exit "NOTTIP arguments must be separated by commas."

ARG DIR',' LABEL',' OUTFILE

DIR     = strip(DIR)
LABEL1   = strip(LABEL)
OUTFILE = strip(OUTFILE)
IF OUTFILE == ""    THEN OUTFILE = "NOTTIP.OUT"
IF OUTFILE == "NUL" THEN OUTFILE = ""

IF isUsage(DIR) THEN DO
   SAY ""
   SAY "Want to get the revision numbers of one label"
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
      '@vlog -XO'tmpFile '-bv'LABEL dirlist.i'\*.*V'

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
