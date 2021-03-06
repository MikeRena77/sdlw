/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   applname.cmd  $
*               $Revision:   1.11  $
*               $Date:   27 Jan 2006 14:28:54  $
* DESCRIPTION:  See Usage below.
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
*$Log:   P:/vcs/cm/applname.cmdv  $
#* 
#*    Rev 1.11   27 Jan 2006 14:28:54   SMcBrayer
#* Added new project:  BP EPS.
#* 
#*    Rev 1.10   01 Feb 2005 15:27:44   SMcBrayer
#* Add support for Marathon (MAP) project.
#* 
#*    Rev 1.9   13 Apr 2004 12:51:14   GraceL
#* Added "NBuypass" as the project name
#* 
#*    Rev 1.8   03 Sep 2002 10:53:18   gracel
#* Added project NBPAMOCO for BP RESPONS network
#* 
#*    Rev 1.7   05 Aug 2002 09:26:32   CraigL
#* Changes for new server.
#* 
#*    Rev 1.6   Nov 28 2001 11:22:08   GraceP
#* added nshell and ncanada
#* 
#*    Rev 1.5   Oct 01 2001 11:11:20   GraceP
#* Add NTEquiva project
#* 
#*    Rev 1.4   Sep 11 2001 08:41:34   JACIC
#* Add Generic ADS as AD, NADS.
#* 
#*    Rev 1.3   Aug 14 2000 13:04:48   GraceP
#* Changed project name from NSun to NSUN
#* 
#*    Rev 1.2   Mar 18 1998 15:38:48   JimL
#* Added Texaco Application
#* 
#*    Rev 1.1   26 Jun 1997 14:25:16   BrettL
#* Changed NTBASE to NBASE and NTSTART to NSTARTER.
#* Also changed all appl names to use standard Nxxxx prefix.
#* 
#*    Rev 1.0   26 Jun 1997 14:11:50   BrettL
#* Initial revision.

      Rev 1.5   20 Mar 1997 15:41:54   brettl
   Added support for mobil.

      Rev 1.4   22 Mar 1996 14:21:36   BMASTER
   Added NSTARTER application.

      Rev 1.3   02 Oct 1995 10:06:48   MerrillC
   Corrected starting substring index when finding build name suffix for
   applications.
   Prevented acceptance of a base build name with more than a two character
   suffix.

      Rev 1.2   29 Sep 1995 16:31:00   MerrillC
   Exposed applPrefixes in procedure.

      Rev 1.1   29 Sep 1995 10:47:54   MerrillC
   Centralized the mapping of application prefixes between application names
   to one array rather than two separate functions.

      Rev 1.0   28 Sep 1995 17:11:24   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */

PARSE ARG str
str = translate(strip(str))

/* get software development server name */
PARSE VALUE GetServer() with ServerName

IF isUsage(str) THEN DO
   /* then this is a usage request */
   '@cls'
   SAY " "
   SAY " "
   SAY "Usage:  APPLNAME(<applName>)"
   SAY "        APPLNAME(<shareName>)"
   SAY "        APPLNAME(<driveLetter>:)"
   SAY "        APPLNAME(<buildName>)"
   SAY " "
   SAY "If the argument is a known application name (e.g., NBase or NShell), then"
   SAY "return it as is."
   SAY " "
   SAY "If the argument is a share name and that share name is associated with a known"
   SAY "application name (e.g., \\"ServerName"\NBASE), then return the application name."
   SAY " "
   SAY "If the argument is a drive letter (e.g., Q: or S:) linked to a share name"
   SAY "associated with an application name, return the application name."
   SAY " "
   SAY "If the argument is a build name (e.g., N0202H or SH0203), then return the"
   SAY "application name associated with that build name."
   SAY " "
   SAY "Otherwise, return ''."
   EXIT ""
END /* THEN usage request */

CALL RxFuncAdd 'SysTempFileName', 'RexxUtil', 'SysTempFileName'
CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'

/* local variables */
NETUSE_locals.0  = 0   /* Local Names entries from NET USE listing      */
NETUSE_remotes.0 = 0   /* Remote Names entries from NET USE listing     */

/* MAINTENANCE NOTE: If new applications are added, update the applPrefixes.I */
/* and applNames.i arrays before with the appropriate prefix and name.        */

/* define application prefix to application name mapping */
i=0
i=i+1;  applPrefixes.i="N";   applNames.i="NBASE"
/* i=i+1;  applPrefixes.i="BP";  applNames.i="NBP" */
i=i+1;  applPrefixes.i="CH";  applNames.i="NCHEVRON"
i=i+1;  applPrefixes.i="CT";  applNames.i="NCITGO"
i=i+1;  applPrefixes.i="SH";  applNames.i="NSHELL"
i=i+1;  applPrefixes.i="SN";  applNames.i="NSUN"
i=i+1;  applPrefixes.i="ST";  applNames.i="NSTARTER"
i=i+1;  applPrefixes.i="MO";  applNames.i="NMOBIL"
i=i+1;  applPrefixes.i="TX";  applNames.i="NTEXACO"
i=i+1;  applPrefixes.i="EQ";  applNames.i="NEQUIVA"
i=i+1;  applPrefixes.i="AD";  applNames.i="NADS"
i=i+1;  applPrefixes.i="CA";  applNames.i="NCANADA"
i=i+1;  applPrefixes.i="BA";  applNames.i="NBPAMOCO"
i=i+1;  applPrefixes.i="GB";  applNames.i="NBUYPASS"
i=i+1;  applPrefixes.i="MP";  applNames.i="NMAP"
i=i+1;  applPrefixes.i="BP";  applNames.i="NBPEPS"
i=i+1;  applPrefixes.i="FD";  applNames.i="NFD"
applPrefixes.0 = i
applNames.0    = i
serverNameLength=length(serverName)
SELECT;
  WHEN isApplName(str) \= "" THEN
       /* case of simple application name, so return it as-is */
       EXIT str


  WHEN "\\"ServerName"\N" == left(str,4+serverNameLength) & length(str) <= 11 + serverNameLength THEN DO
       /* case of probably share name */
       '@net use' str '1> NUL 2> NUL'
       netuse_rc = rc
       '@net use' str '/D 1> NUL 2> NUL'
       IF netuse_rc \= 0 THEN
          /* then share name apparently doesn't exist */
          EXIT ""
       EXIT isApplName(substr(str, 4+serverNameLength))
  END /* case of share name */


  WHEN length(str) == 2 & right(str, 1) == ":" THEN DO
       /* case of drive letter */
       CALL readNetUseListing
       DO i = 1 TO NETUSE_locals.0
          IF NETUSE_locals.i == str THEN
             /* then we find the linked drive letter, is it an applName */
             EXIT isApplName(substr(NETUSE_remotes.i, 7))
       END /* DO all linked drive letters */

       /* If we reach here, the drive letter wasn't found */
       EXIT ""
  END /* case of drive letter */


  WHEN datatype(str, 'A') & length(str) >= 5 & length(str) <= 10 THEN
       EXIT buildName_to_applName(str)

  OTHERWISE EXIT ""
END /* SELECT on str */
/*===========================================================================*/


ISAPPLNAME: PROCEDURE EXPOSE applPrefixes. applNames.;
  ARG str

  /* If str is a known application name, then return it.  */
  /* Otherwise, return "" */
  DO i = 1 TO applNames.0
     IF str == applNames.i THEN
        /* then we've found a match, so return it */
        RETURN str
  END /* DO all applNames */
RETURN ""  /* If we reached here, it wasn't found */
/*===========================================================================*/


BUILDNAME_TO_APPLNAME: PROCEDURE EXPOSE applPrefixes. applNames.;
  ARG str

  /* If str appears to be a build name, then return the associated application */
  /* name.  Otherwise, return "".                                              */

  SELECT;
    WHEN length(str) <= 7 &,
         left(str, 1) == "N" & datatype(substr(str, 2, 4), 'W') &,
         (length(str) == 5 | datatype(substr(str, 6), 'U') )    THEN DO
         /* case of a base build name with picture 'N'9999[A[A]] */
         RETURN "NBASE"
    END /* WHEN base build name */

    WHEN length(str) <= 10 &,
         datatype(left(str, 4), 'U') & left(str, 2) == "NT" &,
         datatype(substr(str, 5, 4), 'W') &,
         (length(str) == 8 | datatype(substr(str, 9), 'U') )    THEN DO
         /* case of an application name with picture NTAA9999[A[A]] */
         prefix = left(str, 4)
         DO i = 1 TO applPrefixes.0
            IF prefix == applPrefixes.i THEN
               /* then we've found it, so return the associated applName */
               RETURN applNames.i
         END /* DO all prefixes */
         RETURN "" /* if we reached here, it wasn't found */
    END /* WHEN application build name */

    WHEN length(str) <= 8 &,
         left(str, 2) == "NT" & datatype(substr(str, 3, 4), 'W') &,
         (length(str) == 6 | datatype(substr(str, 7), 'U') )    THEN DO
         /* case of a base build name with picture 'NT'9999[A[A]] */
         RETURN "NBASE"
    END /* WHEN base build name */

    WHEN length(str) <= 8 &,
         datatype(left(str, 2), 'U') & datatype(substr(str, 3, 4), 'W') &,
         (length(str) == 6 | datatype(substr(str, 7), 'U') )    THEN DO
         /* case of an application name with picture AA9999[A[A]] */
         prefix = left(str, 2)
         DO i = 1 TO applPrefixes.0
            IF prefix == applPrefixes.i THEN
               /* then we've found it, so return the associated applName */
               RETURN applNames.i
         END /* DO all prefixes */
         RETURN "" /* if we reached here, it wasn't found */
    END /* WHEN application build name */

    OTHERWISE RETURN ""
  END; /* SELECT on str format */
/*=========================================================================*/


READNETUSELISTING: PROCEDURE EXPOSE NETUSE_locals. NETUSE_remotes.;
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
     IF rest          \= ""      THEN ITERATE /* other      */

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