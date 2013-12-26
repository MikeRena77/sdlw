/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   delbuild.cmd  $
*               $Revision:   1.1  $
*               $Date:   Aug 19 1997 15:36:44  $
* DESCRIPTION:  See usage below.
*
* TARGET:       OS/2 2.x
*
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/delbuild.cmdv  $
* 
*    Rev 1.1   Aug 19 1997 15:36:44   BrettL
* updated to support archive renaming ("v" suffix)
* 
*    Rev 1.0   21 Jul 1997 11:47:36   BrettL
* Initial revision.
   
      Rev 1.3   28 Feb 1996 11:42:24   BMASTER
   Moved functionality of extract directly into main code.
   Overwrite archive only if pvcsId is set.
   
      Rev 1.2   28 Feb 1996 11:18:46   BMASTER
   Calling pvcs seperately for each file.  Record error response from pvcs
   and continue.
   
      Rev 1.1   15 Sep 1995 16:41:30   MerrillC
   Updated DO FOREVER loop to be DO WHILE.
   Replaced code to substitute spaces for tabs with a translate statement.
   Changed "response file" argument name to "promote list."
   Output everything to both console and output file.
   
      Rev 1.0   20 Jul 1995 16:40:00   charlies
   Initial revision.
*****************************************************************************/
/* end extraction */

CALL RxFuncAdd 'SysFileDelete', 'RexxUtil', 'SysFileDelete'

ARG RESPONSE LABEL pvcsID
PARSE VAR RESPONSE RFile"."ext    /* response file less its extension      */
baseName      = "P:\CM\delbuild"
tmpFile       = baseName'.$$$'    /* output of individual PVCS steps.      */
outFile       = RFile'.del'       /* delbuild log output file              */
fileList.0    = 0                 /* list of files for deleting labels     */
pvcsBin       = 'J:\PVCS53\NT\NT'  /* PVCS executables directory            */
archive       = 'Q:\VCS'          /* default to base PVCS archive root     */

/* Check for usage query */
IF RESPONSE=="" | RESPONSE=="HELP" | RESPONSE=="?" | RESPONSE=="-H" | LABEL=="" THEN
   /* then display usage */
  DO
     SAY "Usage:  DELBUILD <promote_list> <label> [<pvcs ID>]"
     SAY " "
     SAY "Reads <promote_list> and looks for a '~'.  It then checks the rest"
     SAY "of the path to make sure it's properly formed.  If so, it deletes"
     SAY "the <label> from the file's PVCS archive."
     SAY " "
     SAY "<pvcsID> identifies which PVCS archive root to process.  Values can"
     SAY "be an applname (e.g., NBase or NShell), a drive letter (e.g., P: =>"
     SAY "P:\VCS), a pathname (e.g., Q:\VCS), or blank which defaults to the"
     SAY "value in the UDE_APPLNAME environment variable which itself defaults"
     SAY "to NBase."
     SAY " "
     SAY "This script writes its errors to" outFile"."
     EXIT 0
  END /* THEN usage */

/* determine which PVCS root to use from <pvcsID> argument */
pvcsRoot     = ""
drive_letter = ""
IF pvcsID \= "" THEN
   PARSE VALUE (findpvcs(pvcsID)) WITH archive drive_letter

/* Delete old files and open new ones */
IF deleteOld(outFile)         THEN EXIT 1
IF deleteOld(tmpFile)         THEN EXIT 1
IF openNew(RESPONSE READ)     THEN EXIT 1

CALL stream outFile,       'C', 'OPEN WRITE'
CALL outputMsg 'DELBUILD' RESPONSE LABEL pvcsID

i=0  /* count of number of files found  */

DO WHILE lines(RESPONSE)
   /* read a line and check for End-of-File */
   line = linein(RESPONSE)
   line = translate(line, " ", "	") /* turn TABs into spaces */
   IF strip(line) == "" THEN
      /* then we've just read a blank line, so skip it     */
      ITERATE

   /* now we are ready with the "line" to parse it for args */	
   file = word(line, 1);
   revision = word(line, 2)

   /*  Check to see if it's to be deleted, ignore everything else. */
   firstChar = substr(file, 1, 1)
   IF firstChar=="~" THEN
        DO
           /* It is to be deleted.  Get rid of the tilde. */
           file = SUBSTR(file, 2)
           /* check for a comment line and bad pathname */
           firstChar = substr(file, 1, 1)
           IF firstChar=="\" | firstChar=="/" | firstChar==" " THEN
             /* then we have an ill-formed pathname, so complain */
             DO
                CALL outputMsg "Pathname `"file"' begins with an illegal character.  DELBUILD aborted."
                CALL stream outFile,       'C', 'CLOSE'
                CALL stream RESPONSE,      'C', 'CLOSE'
                EXIT 1
             END /* THEN bad pathname */
           i = i+1
           CALL outputMsg "["i"] `"file"'"
           pvcsFile = archive'\'file'v'
           PARSE VAR pvcsFile filename "." extension "v"

           fileList.0 = i
           fileList.i = pvcsFile

        END

END /* DO WHILE */
      
/* Close the files */
CALL outputMsg " "
CALL stream RESPONSE,      'C', 'CLOSE'

/* Verify that there is something to do */
CALL outputMsg "[["fileList.0"]]"
IF fileList.0 == 0 THEN
   /* then there are no file to change, so exit quietly */
   DO
      CALL outputMsg "There are no files to remove the build label from."
      CALL stream outFile, 'C', 'CLOSE'
      EXIT 0
   END
   ELSE DO
      CALL outputMsg "There are" fileList.0 "file(s) to remove the label "LABEL" from" ARCHIVE"."
   END

/* delete label from files */

IF LABEL \= "" THEN
   /* then we have a label to delete */
   DO
      CALL outputMsg "Deleting" LABEL "label from files..."

      DO j = 1 TO fileList.0
         '@'pvcsBin'\vcs -Q -V'LABEL':delete -XO+E'tmpfile fileList.j
         vcs_rc = rc

         CALL stream tmpFile, 'C', 'OPEN READ'
         DO WHILE lines(tmpFile)
            CALL lineout outFile, linein(tmpFile)
         END /* DO WHILE tmpFile */
         CALL stream tmpFile, 'C', 'CLOSE'
         CALL SysFileDelete tmpFile

         IF vcs_rc \= 0 THEN
            /* then PVCS vcs failed */
            DO
               CALL outputMsg "PVCS vcs failed with rc="vcs_rc"."
               CALL outputMsg "Deletion aborted for file: " fileList.j
            END /* THEN vcs failed */
      END 
      CALL stream outFile, 'C', 'CLOSE'

      CALL outputMsg LABEL "labels deleted."
      CALL outputMsg "*"
   END /* THEN removing label */

CALL outputMsg "Deletion complete.  See" outFile "for any errors."
CALL stream outFile, 'C', 'CLOSE'
CALL deleteOld tmpFile
EXIT 0
/*=========================================================================*/

deleteOld: PROCEDURE;
  PARSE ARG filename
  /* Delete filenameand verify that it was deleted.  
     Return 0 on success or 1 otherwise. */

  CALL SysFileDelete filename
  IF RESULT \= 0 & RESULT \= 2 THEN
     /* then file exists, but it couldn't be deleted for some reason */
     DO
        CALL outputMsg "Unable to delete old version of `"filename"'.  DELBUILD aborted."
        RETURN 1
     END /* THEN delete failed */
RETURN 0
/*=========================================================================*/

openNew: PROCEDURE;
  PARSE ARG filename direction
  /* Open filename, and verify that it was open.  
     Return 0 on success or 1 otherwise. */

   CALL STREAM filename,  'C', 'OPEN' direction
   IF RESULT \= "READY:" THEN
      /* then we couldn't open the file for some reason, so complain */
     DO
        CALL outputMsg "Open of get list file `"filename"' failed with status of `"RESULT"'."
        CALL outputMsg "DELBUILD aborted."
        RETURN 1
     END /* THEN open failed */
RETURN 0
/*=========================================================================*/

outputMsg: PROCEDURE EXPOSE outFile;
  PARSE ARG msg
  SAY msg
  CALL lineout outFile, msg
RETURN 0
/*=========================================================================*/

