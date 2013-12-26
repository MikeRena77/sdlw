/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   findlink.cmd  $
*               $Revision:   1.1  $
*               $Date:   18 Jul 1997 14:28:06  $
* DESCRIPTION:  See Help below.
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/findlink.cmv  $
   
      Rev 1.1   18 Jul 1997 14:28:06   CraigL
   Remove check of rest being empty in readNetUseListing.
   Windows NT returns Microsoft Windos Network after the sharename
   causing the routine to never find any links.
   
      Rev 1.0   12 Jun 1997 11:57:50   BrettL
   Initial revision.
   
      Rev 1.8   27 Sep 1995 15:43:44   MerrillC
   Force outFile argument to uppercase so that 'nul' and 'NUL' both mean
   no output.
   
      Rev 1.7   27 Sep 1995 14:04:22   MerrillC
   Added optional outFile argument.
   Allowed input argument to be an applName as well as a shareName.
   
      Rev 1.6   25 Sep 1995 17:07:46   MerrillC
   Changed to order of search for a free drive letter.
   
      Rev 1.5   02 Jun 1995 18:56:16   MerrillC
   Removed unneeded non-error progress messages.
   
      Rev 1.4   27 Apr 1995 11:29:36   MerrillC
   Added error message if share name not found.
   Change 'SysFileDel' to be 'SysFileDelete'
   
      Rev 1.3   13 Apr 1995 10:32:18   MerrillC
   Still not comparing against upper case share name for some reason.
   Corrected it again.
   
      Rev 1.2   12 Apr 1995 17:52:12   MerrillC
   Corrected comparison of share name to compare against all upper case.
   
      Rev 1.1   12 Apr 1995 14:36:02   MerrillC
   Display message is existing link found for shareName argument, if
   a new link was created, or if no link was found and none could be
   created.
   
      Rev 1.0   12 Apr 1995 09:47:30   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */

ARG name','outFile
name        = strip(name)
outFile     = translate(strip(outFile))
IF outFile == "NUL" THEN outFile = ""

IF isUsage(name) THEN DO
   /* then usage request */
   '@cls'
   SAY " "
   SAY " "
   SAY "Usage:  FINDLINK  <shareName>[, <outFile>]"
   SAY "        FINDLINK  <applName>[, <outFile>]"
   SAY " "
   SAY "This script distinguishes a <shareName> argument from an <applName> argument"
   SAY "by assuming that only the <shareName> will contain a '\' character.  If an"
   SAY "<applName> arguement is passed, fndShare() is called to convert it into a"
   SAY "share name and then processing continues as described below."
   SAY " "
   SAY "If share name <shareName> is currently linked to a local name, then return it."
   SAY "If <shareName> is not already linked, then find an available drive letter,"
   SAY "link it, and return it."
   SAY " "
   SAY "Returns a two word string.  First word is isNewLink boolean flag.  It is true"
   SAY "if the line to driveLetter was established by this script and false otherwise."
   SAY "If isNewLink is true, then it is the caller's responsibility to unlink the"
   SAY "driveLetter."
   SAY " "
   SAY "The second word is driveLetter that was found to already be linked to"
   SAY "<shareName> or was linked to <shareName> by this script.  If, for some reason,"
   SAY "no drive was found already linked an no drive COULD be linked, then the second"
   SAY "word is empty."
   EXIT 0
END /* THEN usage request */

IF pos("\", name) == 0 THEN DO
   /* then no '\', so we have an applName that needs converting */
   say "find share " name"..."
   shareName = fndShare(name, outfile)
   IF shareName == "" THEN
      /* then we couldn't covert applName in to a share name, so return */
      EXIT 0
END /* THEN applName */
ELSE
   /* else has '\', so we have a share name */
   shareName = name


say " found share " shareName
CALL RxFuncAdd 'SysTempFileName', 'RexxUtil', 'SysTempFileName'
CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'

/* determine if there is a share name already out there */
/*'@net use' shareName '1> NUL 2> NUL'*/
/*IF rc \= 0 THEN DO */
   /* then the share name probably doesn't exist. */
/*   msg = "FINKLINK() can't find share name" shareName"." */
/*  SAY msg */
/*   IF outFile \= "" THEN */
      /* then we have an output file to write to */
/*      CALL lineout outFile, msg*/
/*   EXIT "0" */ /* isNewLink = 0, driveLetter = "" */
/*END */ /* THEN no share name */
/*'@net use' shareName '/D 1> NUL 2> NUL' */

/* search for an existing link we can use */
NETUSE_locals.0  = 0   /* Local Names entries from NET USE listing      */
NETUSE_remotes.0 = 0   /* Remote Names entries from NET USE listing     */
CALL readNetUseListing /* initialize NETUSE_locals. and NETUSE_remotes. */

DO i = 1 to NETUSE_remotes.0
   IF NETUSE_remotes.i == shareName THEN DO
      /* then we've found a link to shareName, so return the drive */
      drive = NETUSE_locals.i
      say "netuse_locals i " drive
      EXIT "0" drive /* isNewLink = 0, driveLetter = NETUSE_locals.i */
   END /* THEN link found */
END /* DO all NET USE entries */

/* shareName not already links, so find unused drive letter and link it. */
/* Search drive letters most likely to be free first.                    */
driveLetters = "H: I: W: X: Y: N: T: V: Q: S:"
DO WHILE driveLetters \= ""
   PARSE VAR driveLetters drive driveLetters

   '@net use' drive shareName '1> NUL 2> NUL'
   IF rc == 0 THEN
      /* then we've found an unused drive, so return it */
      EXIT "1" drive  /* isNewLink = 1, driveLetter = drive */
END /* WHILE drive letters */

msg = "FINDLINK() couldn't find or create a network link to share name" shareName"."
SAY msg
IF outFile \= "" THEN
   /* then we have an output file to write to */
   CALL lineout outFile, msg

EXIT "0"  /* isNewLink = 0, driveLetter = "" */
/*==========================================================================*/


readNetUseListing: PROCEDURE EXPOSE NETUSE_locals. NETUSE_remotes.;
  /* Initialize NETUSE_locals. and NETUSE_remotes. with the information */
  /* returned by the NET USE command.  Return 0 is successful or 1      */
  /* otherwise.                                                         */

  tempFile = SysTempFileName("fndlnk??.$$$")
  '@net use 1>' tempFile '2> NUL'
  IF rc \= 0 THEN DO
     /* then can't get NET USE listing, so return */
     Call SysFileDelete tempFile
     RETURN 1
  END /* THEN net use failed */

  CALL stream tempFile, 'C', 'OPEN READ'
  i = 0

  DO WHILE lines(tempFile)
     line = linein(tempFile)
     line = strip(line)
     PARSE VAR line status local remote rest
     /* skip over uninteresting lines */
     IF line          == ""      THEN ITERATE /* blank line */
     IF left(line, 5) == "-----" THEN ITERATE /* rule line  */

     i = i+1
     NETUSE_locals.i  = translate(strip(local))
     NETUSE_remotes.i = translate(strip(remote))
  END /* WHILE listing lines remain */

  NETUSE_locals.0  = i
  NETUSE_remotes.0 = i

  /* close and delete the temporary file */
  CALL stream tempFile, 'C', 'CLOSE'
  CALL SysFileDelete tempFile
RETURN 0
/*==========================================================================*/
