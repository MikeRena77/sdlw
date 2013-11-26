/* begin extraction */
/*****************************************************************************
*
*  NAME        :  $Workfile:   applbld.cmd  $
*                 $Revision:   1.9  $
*                 $Date:   06 Dec 2002 15:55:10  $
*
*  DESCRIPTION :  Script to combine all scripts that make up a build
*
*  MODIFICATION/REV HISTORY :
*
* $Log:   P:/vcs/cm/applbld.cmdv  $
*  
*     Rev 1.9   06 Dec 2002 15:55:10   gracel
*  remove the dependancy on network shares, using S:\build\buildId to access
*  
*     Rev 1.8   05 Aug 2002 09:10:54   CraigL
*  Changes for new server.
*  
*     Rev 1.7   Nov 28 2001 11:20:22   GraceP
*  Added nshell and ncanada
*  
*     Rev 1.6   Oct 01 2001 11:10:32   GraceP
*  Added NTEquiva project.
*  
*     Rev 1.5   Apr 04 2000 18:18:18   gracel
*  added ntbp as the appllink for bp project.
*  
*     Rev 1.4   Aug 26 1999 10:53:32   brettl
*  added all to setODBCNucDBFile before the make
*  before this script was available the build had to open up the ODBC UI
*  and check/change that the filename was pointing to the correct appl dir
*  
*     Rev 1.3   Oct 08 1998 18:26:48   brettl
*  added call to getproot, scripts were changed to look locally
*  for andirs.txt and proot.cmd
*  
*     Rev 1.2   May 11 1998 18:06:56   DavidC
*  use setmakl.bat to invoke setupbld and maklocal to allow setvdisk
*  (setupbld calls setvdisk) to be build-specific rather than on P:/pnutil.
*  
*     Rev 1.1   May 11 1998 17:17:00   DavidC
*  changes by unknown person were in P:/pnutil but not checked in.
*  Adds ApplProjectName, BuildLabel, & LogFileName parms to prmtlst.pl call.
*  
*     Rev 1.0   Aug 19 1997 15:32:56   BrettL
*  Initial revision.
* 
*     Rev 1.0   26 Jun 1997 15:53:02   BrettL
*  Initial revision.
   
      Rev 1.11   01 Apr 1996 20:17:28   hartmute
   Do parameter check before disconnecting/connecting S: drive.  Output messages
   will be send to screen only until S: drive is connected correctly.
   Added time stamps at start and end of script.
   
      Rev 1.10   26 Mar 1996 14:12:14   hartmute
   Moved connection of s: drive to beginning of script.
   
      Rev 1.9   05 Mar 1996 17:37:34   hartmute
   Readded initialisation of ApplLink variable, that got lost in previous
   change. Change output logfile name to be applbld.log.
   
      Rev 1.8   05 Mar 1996 11:39:48   hartmute
   No longer disconnect/connect the s: drive.
   
      Rev 1.7   29 Feb 1996 11:32:30   hartmute
   Changed applname parameter for movlabel call.
   
      Rev 1.6   29 Feb 1996 10:32:00   BMASTER
   Removed debug statements.
   
      Rev 1.5   29 Feb 1996 10:27:26   BMASTER
   Corrected parameter to extractl.
   Modified SAY statements to logmessages.
   
      Rev 1.4   29 Feb 1996 10:00:22   hartmute
   Corrected call to movlabel
   
      Rev 1.3   28 Feb 1996 16:35:30   hartmute
   corrected log message
   
      Rev 1.2   28 Feb 1996 16:08:30   hartmute
   Create output logfile.
   Added output file for extractl and movlabel.
   Added call to nottip script.
   
      Rev 1.1   28 Feb 1996 10:15:16   BMASTER
   Added delbuild script. Changed location of scrfiles.lst. Added check
   for return parameter to extractl.
   
      Rev 1.0   26 Feb 1996 16:50:26   hartmute
   Initial revision.
*
*****************************************************************************/

/* end extraction */

ARG BuildType BaseDir ApplDir BuildLabel ReleaseName AllocType Rest

CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'

ScrDir = "S:\SCR\"
PvcsDir = "S:\VCS"
ApplBuildDir = "S:\BUILD\"
BuildDir = "BUILD\"
PromoteFileName = "PROMOTE.LST"
PromoteLogFileName = "PRMTLST.LOG"
GetProotLogFileName = "GETPROOT.LOG"
NottipFileName = "Nottip.out"
ExtractlFileName = "extractl.out"
MovlabelFileName = "movlabel.out"
OutputFileName = ""
ScrFile = "SCRFILES.LST"
ScrSubDir = "IN\"
InputFileName = ""
ApplLink = ""
BaseLink = ""
/* applbld log output file */
outFile = ScrDir""BuildDir""ReleaseName"\applbld.log"    
ReleaseDir = ApplBuildDir""ReleaseName

/* get software development server name */
PARSE VALUE GetServer() with ServerName

ErrorMessage = ""

/* check parameters */

/* check if first parameter is request for help */
IF isUsage(BuildType) THEN DO
   /* then this is a usage request */
   ErrorMessage = ""
   showUsage()
END /* THEN usage request */

/* check the build type */
SAY "Verify build type"
IF BuildType \= 'REBUILD' & BuildType \= 'REFRESH' THEN
DO
   /* invalid build type */
   ErrorMessage = "ERROR: incorrect BuildType parameter"
   CALL err_beep
   showUsage()
END

/* check AllocType for setmakl */
SAY "Verify allocator type"
IF AllocType \= 'SM_PRODUCTION' & AllocType \= 'SM_DEBUG' & AllocType \= 'SYMBOLS' THEN
DO
   /* invalid build type */
   ErrorMessage = "ERROR: incorrect AllocType parameter"
   CALL err_beep
   showUsage()
END

/* check for correct number of parameters */
SAY "Verify parameter count"
IF ReleaseName = "" | Rest \= "" THEN
DO
   /* not enough or to many parameters */
   ErrorMessage = "ERROR: not enough or to many parameters"
   CALL err_beep
   showUsage()
END

/* check directories */

/* Don't do anything, if the BaseDir directory does not exist */
SAY "Verify directories"
IF \isDir(BaseDir) THEN
DO
   ErrorMessage = "ERROR: BaseDir does not exist"
   CALL err_beep
   showUsage()
END

/* Don't do anything if BuildType is REFRESH,
   but the ApplDir does not exist.            */
IF BuildType = "REFRESH" THEN
DO
   IF \isDir(ApplDir) THEN
   DO
      ErrorMessage = "ERROR: ApplDir does not exist"
      CALL err_beep
      showUsage()
   END
END

/* Don't do anything if BuildType is REBUILD,
   but the ApplDir does exist.                */
IF BuildType = "REBUILD" THEN
DO
   IF isDir(ApplDir) THEN
   DO
      ErrorMessage = "ERROR: ApplDir already exist"
      CALL err_beep
      showUsage()
   END
END
SAY "prebuild checks ok"

ApplLink = substr( ApplDir, 4, 10 )

ApplProjectName = ApplLink

IF applLink = "NSTARTER" THEN
DO
   applLink = "NTSTART"
END

IF applLink = "NBP" THEN
DO
   applLink = "NTBP"
END

IF applLink = "NEQUIVA" THEN
DO
   applLink = "NTEQUIVA"
END
IF applLink = "NSHELL" THEN
DO
   applLink = "NTSHELL"
END


/* check network connections */
/* s: drive */
/* need to check for correct link to s: here */
'net use s: /del'
'net use s: \\'ServerName'\'ApplLink
IF rc \= 0 THEN
DO
   ErrorMessage = "ERROR1: Unable to create network link to \\"ServerName"\"ApplLink
   CALL err_beep
   showUsage()
END

/* only now can we use the output file */
CALL outputMsg "Starting application build for "ApplLink" at "time()
CALL outputMsg "connected s: drive to \\"ServerName"\"ApplLink

/* p: drive */
CALL outputMsg "disconnect p: drive"
'@net use p: /d'
CALL outputMsg "connect p: drive to \\"ServerName"\NTNUC"
'@net use p: \\'ServerName'\ntnuc 1>nul 2>nul'
IF rc \= 0 THEN
DO
   ErrorMessage = "ERROR: Unable to create network link to \\"ServerName"\ntbase"
   CALL err_beep
   showUsage()
END

/* q: drive */
CALL outputMsg "disconnect q: drive"
BaseLink = "NTBASE"
/*'@net use q: /d'*/
/*CALL outputMsg "connect q: drive to \\"ServerName"\"BaseLink*/
/*'@net use q: \\'ServerName'\'BaseLink '1>nul 2>nul'*/
/*IF rc \= 0 THEN*/
/*DO*/
/*   ErrorMessage = "ERROR2: Unable to create network link to \\"ServerName"\"BaseLink*/
/*   CALL err_beep*/
/*   showUsage()*/
/*END*/

/* s: drive */
/* need to check for correct link to s: here ??? */

/* v: drive */
/*CALL outputMsg "disconnect v: drive"*/
/*'@net use v: /d'*/
/*CALL outputMsg "connect v: drive to \\"ServerName"\"ReleaseName */
/*'@net use v: \\'ServerName'\'ReleaseName '1>nul 2>nul' */
/*IF rc \= 0 THEN */
/*DO */
/*   ErrorMessage = "ERROR3: Unable to create network link to \\"ServerName"\"ReleaseName */
/*   CALL err_beep */
/*   showUsage() */
/*END */

/*CALL outputMsg "network links ok" */


/* start the build */
CALL outputMsg "start the build"


/**************************************************************************/
/* make the promote list                                                  */
/**************************************************************************/
/* build the promote list for this build */
CALL outputMsg "build promote list"
OutputFileName = ScrDir""BuildDir""ReleaseName"\"PromoteFileName
LogFileName = ScrDir""BuildDir""ReleaseName"\"PromoteLogFileName
InputFileName = ScrDir""BuildDir""ReleaseName"\"ScrFile
'perl p:\cm\prmtlst.pl' ApplProjectName BuildLabel OutputFileName InputFileName LogFileName

/**************************************************************************/
/* extract the appropriate proot.cmd and andirs.txt for this build        */
/* the build scripts rely on them being in the path or in the current dir */
/**************************************************************************/
InputFileName = ScrDir""BuildDir""ReleaseName"\"PromoteFileName
LogFileName = ScrDir""BuildDir""ReleaseName"\"GetProotLogFileName
'perl p:\cm\getproot.pl 'ApplProjectName BuildLabel InputFileName LogFileName

/* remove obsolete files from the build */
CALL outputMsg "remove obsolete files from the build"
InputFileName = ScrDir""BuildDir""ReleaseName"\"PromoteFileName
rc = delbuild( InputFileName BuildLabel PvcsDir )
IF rc \= 0 THEN
DO
   SAY "ERROR: delbuild failed with rc = " rc
   CALL err_beep
   EXIT 1
END


/* skip the extractl for a refresh */
IF BuildType = "REBUILD" THEN
DO
   CALL outputMsg "extract the files for the build"
   /* extract the files for the build */
   OutputFileName = ScrDir""BuildDir""ReleaseName"\"ExtractlFileName
   rc = extractl( ApplDir"," BuildLabel"," PvcsDir"," OutputFileName )
   IF rc \= 0 THEN
   DO
      CALL outputMsg "ERROR: extractl failed with rc = " rc
      CALL err_beep
      EXIT 1
   END
   /* ApplDir should now be created, if not, stop the build */
   IF \isDir(ApplDir) THEN
   DO
      ErrorMessage = "ERROR: ApplDir does not exist after running extractl"
      CALL err_beep
      showUsage()
   END
END

/* extract the newly promoted files */
CALL outputMsg "extract the newly promoted files"
InputFileName = ScrDir""BuildDir""ReleaseName"\"PromoteFileName
rc = pvcs2bld( ReleaseName"," ApplDir"," InputFileName"," BuildLabel )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: pvcs2bld failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/* change the ODBC DNS filename in the registry to point to this application */
cmd = 'setODBCNucDBFile 'ApplDir
CALL outputMsg cmd
'@'cmd

/* change directory to root */
newdir = directory(ApplDir)

/* Execute setmakl.bat to execute setupbld and maklocal.  Using this .bat file
   allows the already extracted build-specific version of setvdisk.bat to be
   used rather than putting a copy in P:/pnutil.  Setmakl.cmd puts its return
   code in setmakl.rc. */
CALL SysFileDelete 'setmakl.rc'
cmd = 'setmakl 'BuildType' 'BaseDir' 'ApplDir' 'AllocType
CALL outputMsg cmd
'@'cmd

/* Get the maklocal rc from setmakl.rc */
CALL stream 'setmakl.rc', 'C', 'OPEN READ'
IF ( lines( 'setmakl.rc' ) ) THEN DO
   rc = linein( 'setmakl.rc' )
   END
ELSE DO
   CALL outputMsg "ERROR: setmakl.rc seems to be empty"
   CALL err_beep
   EXIT 1
   END
CALL stream 'setmakl.rc', 'C', 'CLOSE'

IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: maklocal failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/* promote the new build to the network */
CALL outputMsg "promote the new build to the network"
rc = promote( ApplDir"," ReleaseDir )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: promote failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/* attach the correct label */
CALL outputMsg "attach the correct label"
ApplLink = substr( ApplDir, 4, 10 )
OutputFileName = ScrDir""BuildDir""ReleaseName"\"MovlabelFileName
rc = movlabel( BuildLabel"," ReleaseName"," ApplLink"," OutputFileName )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: movlabel failed with rc = " rc
   CALL err_beep
   EXIT 1
END

CALL outputMsg "application build for "ApplLink" successfully completed at "time()

EXIT  0
/*=========================================================================*/

showUsage: PROCEDURE EXPOSE ErrorMessage
   '@cls'
   SAY " "
   SAY " "
   CALL outputMsg ErrorMessage
   SAY " "
   SAY " "
   SAY "APPLBLD BuildType BaseDir ApplDir BuildLabel ReleaseName AllocType"
   SAY " "
   SAY " BuildType: REFRESH or REBUILD"
   SAY " "
   SAY " BaseDir: Directory location of the Base (e.g. D:\NBASE)"
   SAY " "
   SAY " ApplDir: Directory location of the Application (e.g. D:\NSHELL)"
   SAY " "
   SAY " BuildLabel: e.g. SHELL21 BASE30 CHEVRON10"
   SAY " "
   SAY " ReleaseName: e.g. N0210AE, SH0220D, CH0200X"
   SAY " "
   SAY " AllocType:"
   SAY "    SM_PRODUCTION - production SmartHeap"
   SAY "    SM_DEBUG      - memory debug SmartHeap"
   SAY "    SYMBOLS       - no SmartHeap, but with debug"
   SAY " "
EXIT 1
/*=========================================================================*/

IsDir: PROCEDURE
  ARG dirPathname
  /* If dirPathname is the pathname of a directory, return 1; otherwise 0. */
  '@dir' dirPathname '1> NUL 2> NUL'
RETURN rc == 0
/*=========================================================================*/

outputMsg: PROCEDURE EXPOSE outFile;
  PARSE ARG msg
  SAY msg
  CALL lineout outFile, msg
RETURN 0
/*=========================================================================*/


/* test functions */
/*
prmtlst: PROCEDURE
   ARG arglist

   SAY "running fake prmtbld function"
   SAY "Arguments: "arglist

RETURN 0

extractl: PROCEDURE
   ARG arglist

   SAY "running fake extractl function"
   SAY "Arguments: "arglist

RETURN 0

pvcs2bld: PROCEDURE
   ARG arglist

   SAY "running fake pvcs2bld function"
   SAY "Arguments: "arglist

RETURN 0

setupbld: PROCEDURE
   ARG arglist

   SAY "running fake setupbld function"
   SAY "Arguments: "arglist

RETURN 0

maklocal: PROCEDURE
   ARG arglist

   SAY "running fake maklocal function"
   SAY "Arguments: "arglist

RETURN 0

promote: PROCEDURE
   ARG arglist

   SAY "running fake promote function"
   SAY "Arguments: "arglist

RETURN 0

movlabel: PROCEDURE
   ARG arglist

   SAY "running fake movlabel function"
   SAY "Arguments: "arglist

RETURN 0

nottip: PROCEDURE
   ARG arglist

   SAY "running fake nottip function"
   SAY "Arguments: "arglist

RETURN 0
*/
