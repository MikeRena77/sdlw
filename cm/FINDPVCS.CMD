/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   FINDPVCS.CMD  $
*               $Revision:   1.0  $
*               $Date:   19 Dec 1996 14:58:54  $
* DESCRIPTION:  See Help below.
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
* $Log:   Q:/vcs/cm/FINDPVCS.CMv  $
   
      Rev 1.0   19 Dec 1996 14:58:54   rosimild
   Initial revision.
   
      Rev 1.6   27 Sep 1995 16:25:06   MerrillC
   Added an optional output file argument.
   
      Rev 1.5   25 Sep 1995 16:57:36   MerrillC
   Corrected reporting of whether the drive letter needs to be deleted
   by the called or not.
   
      Rev 1.4   25 Sep 1995 13:24:36   MerrillC
   Modified usage help.
   
      Rev 1.3   05 Jun 1995 11:15:38   MerrillC
   Strip leading and trailing blanks from around <pvcsID> argument as a
   precaution.
   
      Rev 1.2   05 Jun 1995 11:10:28   MerrillC
   Correct NOT EQUAL comparison from != (the C syntax) to \= (the REXX syntax).
   
      Rev 1.1   05 Jun 1995 10:46:10   MerrillC
   Validate that the directory to be returned actually exists.
   
      Rev 1.0   05 Jun 1995 10:33:46   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */

PARSE ARG pvcsID','outFile
pvcsID      = strip(pvcsID)
outFile     = translate(strip(outFile))
IF outFile == "NUL" THEN outFile = ""

IF pvcsID \= "" & isUsage(pvcsID) THEN DO
   /* then usage request */
   '@cls'
   SAY " "
   SAY " "
   SAY "Usage:  FINDPVCS <pvcsID>[, <outFile>]"
   SAY " "
   SAY "Returns the pathname of the PVCS archive root identified by <pvcsID>"
   SAY "and a second string which, if non-empty, is a temporary drive letter"
   SAY "that needs to be deleted by the caller."
   SAY " "
   SAY "    * If <pvcsID> is a drive letter, return '<pvcsID>\VCS'."
   SAY " "
   SAY "    * If <pvcsID> contains a drive letter and a following pathname,"
   SAY "      then return <pvcsID> as-is."
   SAY " "
   SAY "    * If <pvcsID> does NOT contain a drive letter, is longer than one"
   SAY "      characters, and begins with 'N', then it is assumed to be an applName"
   SAY "      such as 'NBase' or 'NShell'.  A link is found or make to that applName's"
   SAY "      share name and the \VCS directory of that share name returned."
   SAY " "
   SAY "Otherwise, display a message and return and empty string.  If <outFile> is"
   SAY "specified, then also output the message to that file.  If <outFile> is 'NUL'"
   SAY "do not output to a file."
   EXIT 0
END /* THEN usage request */

IF length(pvcsID) == 2 & right(pvcsID, 1) == ":" THEN
   /* then drive letter, so return \VCS */
   CALL validate_and_exit pvcsID"\VCS" ""

IF length(pvcsID) > 2 & substr(pvcsID, 2, 1) == ":" THEN
   /* then drive letter with pathname, so return as is */
   CALL validate_and_exit pvcsID ""

IF pvcsID == "" |,
   (length(pvcsID) > 2                &,
    translate(left(pvcsID, 1)) == "N" &,
    substr(pvcsID, 2, 1) \= ":")      THEN DO
   /* then pvcsID should be an applName */
   drive     = ""    /* drive letter for accessing applName  */
   isNewLink = 0     /* true if drive is only a temporary link */
   SAY "calling findlink "pvcsID"..."

   PARSE VALUE findLink(pvcsID, outFile) WITH isNewLink drive
   IF drive == "" THEN  EXIT "" /* findLink() printed error message */

   IF isNewLink THEN
      /* then drive is a temporary link that must be deleted */
      CALL validate_and_exit drive"\VCS" drive
   ELSE
      /* else drive is an existing link */
      CALL validate_and_exit drive"\VCS" ""
END /* THEN applName */

/* ASSERT:  If we reached this point, <pvcsID> is illegal. */
msg = "'"pvcsID"' is an illegal value for a PVCS ID."
SAY msg
IF outFile \= "" THEN
   /* then we have a real output file to write to */
   CALL lineout outFile, msg

EXIT ""
/*==========================================================================*/


VALIDATE_AND_EXIT: PROCEDURE;
  ARG root drive_letter
 
  IF root \= "" & isDir(root) THEN
     /* then the PVCS archive root exists, so use it */
     EXIT root drive_letter
  ELSE
     /* else the root does not exist, so complain */
     DO
        SAY "'"root"' does not exist."
        EXIT ""
     END /* ELSE does not exist */
/*==========================================================================*/


ISDIR: PROCEDURE;
  ARG dir
  /* Return 1 if dir is a directory and 0 otherwise. */

  '@dir' dir '1> NUL 2> NUL'
RETURN rc == 0
/*==========================================================================*/
