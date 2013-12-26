/* REXX SCRIPT */
/*****************************************************************************
* NAME:         $Workfile:   promote.cmd  $
*               $Revision:   1.5  $
*               $Date:   05 Aug 2002 09:24:26  $
* DESCRIPTION: see usage help
*   
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/promote.cmdv  $
#* 
#*    Rev 1.5   05 Aug 2002 09:24:26   CraigL
#* Changes for new server.
#* 
#*    Rev 1.4   Aug 07 2000 15:52:32   StephenM
#* Removed trailing '\' when creating vcs.cfg file.
#* 
#*    Rev 1.3   Sep 29 1999 14:18:02   brettl
#* pkzip is no longer the official zip tool
#* replaced pkzip with zip
#* 
#*    Rev 1.2   26 Jun 1997 18:28:46   BrettL
#* 
#* removed the temp map zipfile.  It's not needed.
* 
*     Rev 1.1   26 Jun 1997 17:22:10   BrettL
*  changed "ren" of zip file to "move" to correct a syntax error
* 
*     Rev 1.0   26 Jun 1997 17:21:10   BrettL
*  Initial revision.
   
      Rev 1.22   15 Jul 1996 23:00:42   BMASTER
   fixed error output of failed dir to srcDir
   
      Rev 1.21   17 Nov 1995 10:49:46   MerrillC
   Before zipping up the .MAP files, delete any old ZIP that exists.
   
      Rev 1.20   06 Nov 1995 11:07:28   MerrillC
   Restored promote of contents of <srcRoot> itself.
   
      Rev 1.19   06 Nov 1995 10:39:12   MerrillC
   Corrected argument error checking so that you can ask for usage help
   without using a comma.
   
      Rev 1.18   03 Nov 1995 17:26:10   MerrillC
   Removed optional 'withObj' argument.  Promotions are now always with object.
   (This allowed a simplication of the processing logic.)
   
   Upgraded to current CM script standards.
   
   Require commas between arguments.
   
   Now finds MAPFILES directory from the version  in the RELEASE.NUM files
   without depending upon the settings of Q: or S:.
   
   Added extra error checking.
   
      Rev 1.17   10 Sep 1995 22:21:58   CharlieS
   Added description of return code 1 to procedure that converts PKUNZIP2
   return codes into messages.
   
      Rev 1.16   29 Aug 1995 10:36:52   MerrillC
   Corrected syntax error in reading the number of files found in a
   directory.
   
      Rev 1.15   28 Aug 1995 16:27:02   MerrillC
   Do not attempt to promote directories which have no files in them.
   
      Rev 1.14   18 Aug 1995 14:34:42   CharlieS
   Remove the '.' from the version number in RELEASE.NUM before
   using it as a file name (e.g., Q:\MAPFILES\<version>.ZIP)
   
      Rev 1.13   19 Jul 1995 13:47:10   MerrillC
   The MAPFILES\ directory of the source root being promoted is copied to
   Q:\MAPFILES\<version>.ZIP or S:\MAPFILES\<version>.ZIP where <version> is
   taken from the first word in the RELEASE.NUM file.
* 11/17/94 Mac - Make sure you CD out of the root being pormoted before you start
* 09/04/94 Mac - Changed default to copy object
* 08/21/94 Mac - Leave EVERYTHING write protected.
* 07/28/94 Mac - Do not generate output file log.
* 07/18/94 Mac - Corrected unbalanced quote.
*                Removed test for destination directions existence.
* 07/15/94 Mac - Detects if destination directory does not exist.
* 07/13/94 Mac - No longer has to be run from P:\CM directory.
* 07/11/94 Mac - Changed temporary files to current working directory.
* 07/05/94 Mac - Abort if deltree fails.
*                Added libtmp??.* to files to be cleaned up.
* 06/16/94 Mac - Modified for standalone execution.
* 06/15/94 Mac - Set read-only on TARGET\DATABASE\*.DBD files
* 04/21/94 Mac - initial version
*****************************************************************************/

ARG arglist
IF \isUsage(arglist) & pos(',', arglist) == 0 THEN
   CALL error_exit "Argument must be separated by commas."

ARG srcRoot','destRoot dummy
srcRoot  = strip(srcRoot)
destRoot = strip(destRoot)

/* get software development server name */
PARSE VALUE GetServer() with ServerName

IF isUsage(srcRoot) | destRoot == "" | dummy \= "" THEN DO
   /* then this is a request for usage help or an improper call */
   SAY ""
   SAY "PROMOTE <srcRoot>, <destRoot>"
   SAY ""
   SAY "This script deletes <destRoot> if it exists and then creates a new, empty"
   SAY "<destRoot> hierarchy.  <srcRoot> and <destRoot> are entered without trailing"
   SAY "'\'.  It then copies all files from <srcRoot> to <destRoot>."
   SAY ""
   SAY "The script then extracts the version number from the RELEASE.NUM file.  That"
   SAY "version number is used to determine the application (e.g., NBASE, NSHELL,"
   SAY "NCHEVRON, etc.).  Then <srcRoot>\MAPFILES\*.* is zipped and stored under the"
   SAY "version name (e.g., N0205A.ZIP or SH0205B.ZIP) in the appropriate application"
   SAY "hierarchy (e.g., \\"ServerName"\NBASE\MAPFILES\, \\"ServerName"\NSHELL\MAPFILES\, etc.)"
   EXIT 0
END /* THEN usage */

/* Normalize arguments */
IF srcRoot  == "." THEN srcRoot  = directory()
IF destRoot == "." THEN destRoot = directory()
srcRoot  = make_absolute_path(srcRoot)
destRoot = make_absolute_path(destRoot)


CALL RxFuncAdd 'SysFileDelete', 'RexxUtil', 'SysFileDelete'
CALL RxFuncAdd 'SysFileTree',   'RexxUtil', 'SysFileTree'

CALL log "Begin promotion of" srcRoot "to" destRoot"..."
CALL log " "
CALL log "Deleting old" destRoot"..."
deltreecmd = "P:\\CM\\DELTREE"
/* deltreecmd = stream("P:\CM\DELTREE.CMD", 'C', 'QUERY EXISTS')  */
deltreecmd destRoot
/* IF RESULT \= 0 THEN */
/*   CALL error_exit "Failed to completely delete" destRoot"." */
/* CALL log " " */

CALL log "Constructing new" destRoot"..."
srcproot = srcRoot'\BIN\proot'
rexx srcproot destRoot
CALL log " "

/* temporarily save make.out in root to keep it from being deleted */
srcRootMakeOut = srcRoot'\make.out'
'@ren' srcRootMakeOut make.log '1> NUL 2> NUL'

CALL log "Promoting" srcRoot "to new" destRoot"..."
CALL SysFileTree srcRoot'\*.*', srcDirs, 'DOS'
IF RESULT \= 0 THEN
   CALL error_exit "Can't get list of directories in" srcRoot"."

/* copy object directory structure to destination (no files are copied here) */
/* this is required because VC++ automatically created the object heirarchy  */
SAY create object (and related) heirarchy files to destination
cmdLine = '@xcopy' srcRoot'\*.res' destRoot'\*.res /t/e'
cmdLine
cmdLine = '@xcopy' srcRoot'\*.idb' destRoot'\*.idb /t/e'
cmdLine
cmdLine = '@xcopy' srcRoot'\*.trg' destRoot'\*.trg /t/e'
cmdLine
cmdLine = '@xcopy' srcRoot'\*.tlb' destRoot'\*.tlb /t/e'
cmdLine
cmdLine = '@xcopy' srcRoot'\*.obj' destRoot'\*.obj /t/e'
cmdLine

/* append srcRoot directory itself (since SysFileTree skips it) */
i = srcDirs.0 + 1
srcDirs.i = srcRoot
srcDirs.0 = i

DO i = 1 to srcDirs.0
   srcDir  = srcDirs.i

   /* don't process "." or ".." */
   PARSE VALUE srcDirs.i WITH tdir '\.' 
   IF tdir == srcDirs.i  THEN DO

      destDir = destRoot||substr(srcDir, length(srcRoot)+1)
      
      CALL SysFileTree srcDir'\*.*', files, 'F'
      IF files.0 > 0 THEN DO
         /* then there are files in this directory to promote */
         CALL promoteDir srcDir, destDir
         IF RESULT \= 0 THEN
            /* then we failed to promote a directory, so complain and quit */
            CALL error_exit "Failed to promote" srcDir"."
      END /* THEN files to promote */
    
      ELSE
          /* else no files to promote in this directory */
          CALL log "No files to promote in" srcDir"."
   END /* if not "\." */
END /* DO all srcDirs */

/* restore make.out in root */
'@ren' destRoot'\make.log make.out 1> NUL 2> NUL'
'@ren' srcRoot'\make.log  make.out 1> NUL 2> NUL'

/* find a ZIP to use */
ZIPEXE = stream("P:\PNUTIL\ZIP.EXE", 'C', 'QUERY EXISTS')

IF ZIPEXE == "" THEN
   /* then it's not in the usual place, maybe it's on the path */
   ZIPEXE = stream("ZIP.EXE", 'C', 'QUERY EXISTS')

IF ZIPEXE == "" THEN
   /* then we can't find the PKZIP executable, so complain and exit */
   CALL error_exit "Cannot find ZIP.EXE.  MAPFILES\*.*  and PDBFILES\*.* not zipped."

/* find version number */
CALL log " "
CALL log "Finding build name..."
CALL stream srcRoot'\release.num', 'C', 'OPEN READ'
line = linein(srcRoot'\release.num')
CALL stream srcRoot'\release.num', 'C', 'CLOSE'

version = translate(word(line, 1)) /* may still have '.' in it */
PARSE VAR version first'.'last .
version =first||last
CALL log "Build name is '"version"'."
CALL log " "

/* find link to MAPFILES directory */
CALL log "Finding link to '"version"'."
applName = applName(version)
IF applName == "" THEN DO
   CALL log "Could not deduce the application name for version '"version"'."
   CALL error_exit "Promotion completed normally, but map files and pdb files not zipped."
END /* THEN no applName */

PARSE VALUE findlink(applName(version)) WITH isNewLink driveLetter
IF driveLetter == "" THEN DO
   /* then we counldn't establish a link, so complain and exit */
   CALL log "Could not find or create a link for '"applName"'."
   CALL error_exit "Promotion completed normally, but map files and pdb files not zipped."
END /* THEN no drive letter */

IF isNewLink
   THEN CALL log "Using temporary link" driveLetter"."
   ELSE CALL log "Using existing link" driveLetter"."

/* delete any MAP files ZIP and reZIP a new one */
zipFile = driveLetter'\MAPFILES\'version'.ZIP'
tmpZipFile = driveLetter'\MAPFILES\MAPFILES.ZIP'
'@attrib -r -s -h' zipFile '1> NUL'
CALL SysFileDelete zipFile
IF stream(zipFile, 'C', 'QUERY EXISTS') \= "" THEN
   CALL error_exit "Could not delete old version of" zipFile"."
'@attrib -r -s -h' tmpZipFile '1> NUL'
CALL SysFileDelete tmpZipFile
IF stream(tmpZipFile, 'C', 'QUERY EXISTS') \= "" THEN
   CALL error_exit "Could not delete old version of" tmpZipFile"."
ZIPEXE zipFile '-j' srcRoot'\MAPFILES\*.*'
zip_rc = rc

'@attrib +R' zipFile '1> NUL'

pdbSrcDir = srcRoot'\PDBFILES'
IF isDir(pdbSrcDir) THEN DO
   /* delete any pdb files ZIP and reZIP a new one */
   pdbzipFile = driveLetter'\PDBFILES\'version'.ZIP'
   tmppdbZipFile = driveLetter'\PDBFILES\PDBFILES.ZIP'
   '@attrib -r -s -h' pdbzipFile '1> NUL'
   CALL SysFileDelete pdbzipFile
   IF stream(pdbzipFile, 'C', 'QUERY EXISTS') \= "" THEN
      CALL error_exit "Could not delete old version of" pdbzipFile"."
   '@attrib -r -s -h' tmppdbZipFile '1> NUL'
   CALL SysFileDelete tmppdbZipFile
   IF stream(tmppdbZipFile, 'C', 'QUERY EXISTS') \= "" THEN
      CALL error_exit "Could not delete old version of" tmppdbZipFile"."
   ZIPEXE pdbzipFile '-j' srcRoot'\PDBFILES\*.*'
   pdbzip_rc = rc
   
   '@attrib +R' pdbzipFile '1> NUL'
END

/* free temporary link, if any, before we check for an error and possibly abort */
IF isNewLink THEN DO
   /* then driveLetter was temporary, so unlink it now */
   '@net use' driveLetter '/D'
   CALL log "Temporary drive letter" driveLetter "unlinked."
END /* THEN temporary link */

IF zip_rc \= 0 THEN
   /* then ZIP failed, so print an error message */
   CALL error_exit "ZIP of" srcRoot"\MAPFILES\*.* failed with rc="zip_rc

IF isDir(pdbSrcDir) THEN DO
   IF pdbzip_rc \= 0 THEN DO
      /* then ZIP failed, so print an error message */
      CALL error_exit "ZIP of" srcRoot"\PDBFILES\*.* failed with rc="pdbzip_rc
   ENd
END
CALL log  "PROMOTE completed normally."
EXIT 0
/*=========================================================================*/


log: PROCEDURE; /* display and log <string> argument */
PARSE ARG string
SAY string
RETURN
/*=========================================================================*/


promoteDir: PROCEDURE;
ARG srcDir, destDir

srcFiles        = srcDir'\*.*'
destFiles = destDir'\*.*'
isError   = 0

CALL log "'"srcFiles"' --> '"destFiles"'"

CALL SysFileTree destFiles, dfiles., 'FO', '*--*-'
sysfiletree_result = RESULT
IF sysfiletree_result \= 0 THEN DO
   /* then SysFileTree() failed, so complain and exit */
   CALL log "SysFileTree("destfiles", ...) failed to find destination files."
   CALL log ERRORTEXT(sysfiletree_result)
   RETURN 1
END /* THEN SysFileTree() failed */
destCount = dfiles.0
DROP dfiles.

IF destCount \= 0 THEN DO
   /* then we have some destination files to process */

   /* Turn off write protect, if necessary */
   cmdLine = '@attrib -R -S -H' destFiles '1> NUL'
   cmdLine
   attrib_rc = rc
   IF attrib_rc \= 0 THEN DO
      /* then we failed to turn off write protect, so complain */
      CALL log cmdLine "failed with rc="attrib_rc"."
      CALL log ERRORTEXT(attrib_rc)
      RETURN 1
   END /* THEN attrib failed */

   /* Delete the file */
   cmdLine = '@del' destFiles '/q 1> NUL 2> NUL'
   cmdLine
   del_rc = rc
   IF del_rc \= 0 THEN DO
      /* then delete failed, so complain */
      CALL log cmdLine "failed with rc="rc"."
      CALL log ERRORTEXT(del_rc)
      RETURN 1
   END /* THEN DEL failed */
END /* THEN destination files to process */


/* Verify that destination directory is now empty */
CALL SysFileTree destFiles, dfiles., 'FO', '*--*-'
sysfiletree_result = RESULT
IF sysfiletree_result \= 0 THEN DO
   /* then SysFileTree() failed, so complain and exit */
   CALL log "SysFileTree("destFiles", ...) failed to verify empty directory."
   CALL log ERRORTEXT(sysfiletree_result)
   RETURN 1
END /* THEN SysFileTree() failed */
destCount = dfiles.0
DROP dfiles.

IF destCount \= 0 THEN DO
   /* then there are still files in the destination directory */
   CALL log "Cannot empty" destFiles"."
   CALL log destCount "files remain."
   RETURN 1
END /* THEN destination directory not empty */

/* See if we have any source files to promote */
IF srcDir == "" THEN
   /* then we've successfully promoted an "empty" source directory */ 
   RETURN 0

/* Copy source files to destination directory */
CALL SysFileTree srcFiles, sfiles., 'FO', '*--*-'
sysfiletree_result = RESULT
IF sysfiletree_result \= 0 THEN DO
   /* then SysFileTree() failed, so complain and exit */
   CALL log "SysFileTree("srcFiles", ...) failed to find source files."
   CALL log ERRORTEXT(sysfiletree_result)
   RETURN 1
END /* THEN SysFileTree() failed */
srcCount = sfiles.0
DROP sfiles.

/* See if we have any source files to promote */
IF srcCount == 0 THEN
   /* then we've successfully promoted an "empty" source directory */ 
   RETURN 0

/* Copy source files to destination directory */
SAY srcFiles destFiles
cmdLine = '@copy' srcFiles destFiles '/v'
cmdLine
copy_rc = rc

IF copy_rc \= 0 THEN DO
   /* then copy failed, so complain */
   CALL log cmdLine "failed with rc="copy_rc"."
   RETURN 1
END /* THEN copy failed */

/* Verify that all files copied */
CALL SysFileTree destFiles, dfiles., 'FO', '*--*-'
sysfiletree_result = RESULT
IF sysfiletree_result \= 0 THEN DO
   /* then SysFileTree() failed, so complain and exit */
   CALL log "SysFileTree("srcFiles", ...) failed to verify destination files."
   CALL log ERRORTEXT(sysfiletree_result)
   RETURN 1
END /* THEN SysFileTree() failed */
destCount = dfiles.0

IF srcCount \= destCount THEN DO
   /* then source and destination have different number of files */
   CALL log "After promote, source directory      =" srcCount "files, but"
   CALL log "               destination directory =" destCount "files."
   isError = 1
END /* THEN file count mismatch */

/* Delete any extraneous stuff from destination */
'@del' destDir'\*.FIN        2> NUL 1> NUL'
'@del' destDir'\*.$$$        2> NUL 1> NUL'
'@del' destDir'\*.@@@        2> NUL 1> NUL'
'@del' destDir'\make.out     2> NUL 1> NUL'
'@del' destDir'\pvcs????.tmp 2> NUL 1> NUL'
'@del' destDir'\libtmp??.*   2> NUL 1> NUL'

/* Turn on write protect */
cmdLine = '@attrib +R' destFiles '1> NUL'
cmdLine
attrib_rc = rc
IF attrib_rc \= 0 THEN DO
   /* then we failed to turn on write protect, so complain */
   CALL log cmdLine "failed with rc="attrib_rc"."
   CALL log ERRORTEXT(attrib_rc)
   RETURN 1
END /* THEN attrib failed */

RETURN 0
/*=========================================================================*/


MAKE_ABSOLUTE_PATH: PROCEDURE;
   ARG root
   /* root is a directory pathname.  Modify it, if necessary, so that it */
   /* begins with a drive letter and return it.                          */

   IF left(root, 1) == "\" THEN
      /* then this is a root directory on current drive, so prepend drive */
      root =filespec("DRIVE", directory())||root

   IF substr(root, 2, 1) \= ":" THEN
      /* then does not have a drive letter, so must be relative */
      root =directory()||root
RETURN root
/*==========================================================================*/


ERROR_EXIT: PROCEDURE EXPOSE queName;
  PARSE ARG msg

  CALL log MSG
  CALL log "PROMOTE aborted."
  IF queName \= "" THEN CALL RxQueue 'Delete', queName
  CALL err_beep
EXIT 1
/*==========================================================================*/
 

