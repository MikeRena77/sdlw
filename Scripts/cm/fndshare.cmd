/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   fndshare.cmd  $
*               $Revision:   1.4  $
*               $Date:   05 Aug 2002 09:23:56  $
* DESCRIPTION:  See help below
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/fndshare.cmdv  $
   
      Rev 1.4   05 Aug 2002 09:23:56   CraigL
   Changes for new server.
   
      Rev 1.3   Nov 28 2001 11:21:06   GraceP
   added nshell and ncanada
   
      Rev 1.2   Oct 01 2001 11:12:28   GraceP
   Add NTEquiva project
   
      Rev 1.1   Mar 27 2000 15:38:52   gracel
   Added ntbp share name for nbp project
   
      Rev 1.0   26 Jun 1997 18:30:14   BrettL
   Initial revision.
   
      Rev 1.8   27 Sep 1995 15:40:08   MerrillC
   Shortened usage help string to prevent it from wrapping.
   Force outFile argument to uppercase so the 'nul' or 'NUL' both mean not
   output.
   
      Rev 1.7   27 Sep 1995 11:52:22   MerrillC
   Corrected handling of optional outFile argument.
   
      Rev 1.6   26 Sep 1995 17:08:36   MerrillC
   Added optional output file arguement.
   
      Rev 1.5   05 Jun 1995 10:21:08   MerrillC
   Removed "defaulted to" progress message
   
      Rev 1.4   27 Apr 1995 10:59:10   MerrillC
   If applName is not specified and if UDE_APPLNAME is not defined,
   default applName to 'NBase'.
   
      Rev 1.3   26 Apr 1995 18:55:42   MerrillC
   Changed mention of UDE_SYSTEMNAME in error message to UDE_APPLNAME.
   
      Rev 1.2   18 Apr 1995 18:22:42   MerrillC
   Changed message wording telling that application name was defaulted.
   
      Rev 1.1   12 Apr 1995 15:54:00   MerrillC
   Changed name of <systemName> argument to <applName>.
   
      Rev 1.0   12 Apr 1995 14:48:10   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */


PARSE ARG applName','outFile
applName    = strip(applName)
outFile     = translate(strip(outFile))
IF outFile == "NUL" THEN outFile = ""

/* get software development server name */
PARSE VALUE GetServer() with ServerName
say "getServer returned "ServerName"..."
IF applName \= "" & isUsage(applName) THEN DO
   /* then this is a usage request */
   SAY " "
   SAY "Usage: FNDSHARE(<applName>[, <outFile>])"
   SAY " "
   SAY "This is a helper script for the Nucleus Uniform Development Environment"
   SAY "scripts."
   SAY " "
   SAY "If <applName> is '', then it is defaulted using the value of the environment"
   SAY "variable UDE_APPLNAME.  If UDE_APPLNAME isn't defined, then default to 'NBase'."
   SAY " "
   SAY "Prepend the default file server name to applName to make a share name.  If"
   SAY "share name does not exist, display an error message and return ''.  Otherwise,"
   SAY "return share name."
   SAY " "
   SAY "If <outFile> is specified, then write error messages to it as well as to the"
   SAY "screen."
   EXIT 0
END /* THEN usage request */

/* default applName, if necessary */
IF applName == "" THEN DO
   /* then applName needs defaulting */
   applName = value('UDE_APPLNAME',,'OS2ENVIRONMENT')
   IF applName == "" THEN
      /* then no applName in the environment either, so default to NBase */
      applName = "NBase"
END /* THEN no applName */

/* validate applName */

/* don't assume appl name == sharename */
/* this isn't true for those projects that started on os/2 */
IF applName == "NBASE" THEN
  applName = "NTBASE"
IF applName == "NSTARTER" THEN
  applName = "NTSTART"
IF applName == "NBP" THEN
  applName = "NTBP"
IF applName == "NEQUIVA" THEN
  applName = "NTEQUIVA"
IF applName == "NSHELL" THEN
  applName = "NTSHELL"

say "appl name" applName"..."
shareName = '\\'ServerName'\'applName
say " share name " shareName"..."
'@net use' shareName '1> NUL 2> NUL'
netuse_rc = rc
say " net use rc " rc
/*'@net use' shareName '/D 1> NUL 2> NUL'
say " net use rc2 " rc*/

IF netuse_rc \= 0 THEN DO
   /* then shareName apparently doesn't exist, so complain and exit */
   msg = "FNDSHARE() can't find shareName" shareName"."
   SAY msg
   IF outFile \= "" THEN
      /* then we have an output file to write to */
      CALL lineout outFile, msg
   shareName = ""
END /* THEN no share name */

RETURN shareName
/*==========================================================================*/

