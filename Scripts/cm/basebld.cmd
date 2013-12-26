/* begin extraction */
/*****************************************************************************
*
*  NAME        :  $Workfile:   basebld.cmd  $
*                 $Revision:   1.9  $
*                 $Date:   16 Dec 2004 13:00:40  $
*
*  DESCRIPTION :  Script to combine all scripts that make up a build
*
*  MODIFICATION/REV HISTORY :
*
* $Log:   P:/vcs/cm/basebld.cmdv  $
   
      Rev 1.9   16 Dec 2004 13:00:40   SMcBrayer
   Add capability to build .net solutions from build.
   
      Rev 1.8   06 Dec 2002 15:57:58   gracel
   Removed the dependancy on network shares, use Q:\build\buildId instead
   
      Rev 1.7   05 Aug 2002 09:11:34   CraigL
   Changes for new server.
   
      Rev 1.6   Oct 08 1998 18:27:12   brettl
   added call to getproot, scripts were changed to look locally
   for andirs.txt and proot.cmd
   
      Rev 1.5   May 11 1998 18:06:58   DavidC
   use setmakl.bat to invoke setupbld and maklocal to allow setvdisk
   (setupbld calls setvdisk) to be build-specific rather than on P:/pnutil.
   
      Rev 1.4   May 06 1998 13:45:58   DavidC
   change made by unknown person in Nov 97 but not checked in - adds prmtlst.log arg to prmtlst.pl call
   
      Rev 1.3   Nov 07 1997 14:51:42   BrettL
   fixed problem with how return code was being used in the maklocal call
   
      Rev 1.2   Nov 03 1997 10:47:20   BrettL
   The return code for the maklocal wasn't saved to the "rc" variable.
   This might be the cause for basebld not recognizing when the maklocal
   croaks.
   
      Rev 1.1   Aug 19 1997 15:56:20   BrettL
   misc changes, from sujit and myself
* 
*    Rev 1.0   26 Jun 1997 15:51:50   BrettL
* Initial revision.
   
      Rev 1.10   11 Apr 1996 11:05:20   BMASTER
   Corrected link to q: drive.
   
      Rev 1.9   01 Apr 1996 20:53:02   hartmute
   Mocved disconnect/connect of Q: drive after parameter check.
   Added timstamp at start and end.
   
      Rev 1.8   26 Mar 1996 14:07:02   hartmute
   Moved connection of q:\drive to the beginning of the script.
   
      Rev 1.7   05 Mar 1996 17:37:04   hartmute
   Removed disconnect/connect of q: drive.
   
      Rev 1.6   29 Feb 1996 11:33:02   hartmute
   Changed applname parameter for movlabel call.
   
      Rev 1.5   29 Feb 1996 09:32:34   hartmute
   Corrected call to movlabel.
   
      Rev 1.4   28 Feb 1996 16:29:12   hartmute
   Added log mesaages.
   Added nottip script.
   Added output file to movlabel and extractl.
   
      Rev 1.3   28 Feb 1996 11:48:06   BMASTER
   Added CALL to outputMsg.
   
      Rev 1.2   28 Feb 1996 11:20:16   BMASTER
   Sending error messages to screen and logfile.
   
      Rev 1.1   28 Feb 1996 10:14:08   BMASTER
   Added delbuild script. Changed location of scrfiles.lst.  Added check
   for return parameter to extractl.
   
      Rev 1.0   26 Feb 1996 16:49:46   hartmute
   Initial revision.
*
*****************************************************************************/

/* end extraction */
/***************************************************************************/
/*PARAMETERS*/
/***************************************************************************/

ARG BuildType BaseDir BuildLabel ReleaseName AllocType Rest

CALL RxFuncAdd 'SysFileDelete',   'RexxUtil', 'SysFileDelete'

ScrDir = "Q:\SCR\"
/* ScrDir = "Q:\SCR\" :changed here*/
PvcsDir = "Q:\VCS"
/* PvcsDir = "Q:\VCS" :changed here*/

BuildDir = "BUILD\"
BaseBuildDir = "Q:\BUILD\"
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
BaseLink = ""
/* basebld log output file              */
outFile = ScrDir""BuildDir""ReleaseName"\basebld.log"
ReleaseDir = BaseBuildDir""ReleaseName

CALL outputMsg "ReleaseDir is "ReleaseDir

/* get software development server name */
PARSE VALUE GetServer() with ServerName

ErrorMessage = ""
/**************************************************************************/
/* check parameters */
/**************************************************************************/

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

/* don't do anything if BuildType is REFRESH,
   but the BaseDir does not exist.            */
SAY "Verify directories"
IF BuildType = "REFRESH" THEN
DO
   IF \isDir(BaseDir) THEN
   DO
      ErrorMessage = "ERROR: BaseDir does not exist"
      CALL err_beep
      showUsage()
   END
END

/* don't do anything if BuildType is REBUILD,
   but the BaseDir does exist.                */
IF BuildType = "REBUILD" THEN
DO
   IF isDir(BaseDir) THEN
   DO
      ErrorMessage = "ERROR: "BaseDir" does already exist"
      CALL err_beep
      showUsage()
   END
END
SAY "checks ok"

/***********************************************************************/
/* check network connections */
/* q: drive */
/* need to check for correct link to q: before doing anything else */
/***********************************************************************/
'net use q: /d'
'net use q: \\'ServerName'\ntbase'
IF rc \= 0 THEN
DO
   ErrorMessage = "ERROR1: Unable to create network link to \\"ServerName"\NTBASE"
   CALL err_beep
   showUsage()
END
CALL outputMsg "Starting base build at "time()
CALL outputMsg "connected q: drive to \\"ServerName"\NTBASE"

/* p: drive */
CALL outputMsg "disconnect p: drive"
'@net use p: /d'
CALL outputMsg "connect p: drive to \\"ServerName"\NTNUC"
'@net use p: \\'ServerName'\ntnuc 1>nul 2>nul'
IF rc \= 0 THEN
DO
   ErrorMessage = "ERROR2: Unable to create network link to \\"ServerName"\ntnuc"
   CALL err_beep
   showUsage()
END

/* t: drive */

/*CALL outputMsg "disconnect t: drive" */
/* '@net use t: /d' */
/* CALL outputMsg "connect t: drive to \\"ServerName"\"ReleaseName */
/* '@net use t: \\'ServerName'\'ReleaseName '1>nul 2>nul' */
/* IF rc \= 0 THEN */
/* DO */
/*   ErrorMessage = "ERROR3: Unable to create network link to \\"ServerName"\"ReleaseName */
/*   CALL err_beep */
/*   showUsage() */
/* END */

/**************************************************************************/
/* start the build */
/**************************************************************************/
CALL outputMsg "start the build"

/**************************************************************************/
/* make the promote list                                                  */
/**************************************************************************/

/* build the promote list for this build */
CALL outputMsg "build the promote list for this build"
OutputFileName = ScrDir""BuildDir""ReleaseName"\"PromoteFileName
LogFileName = ScrDir""BuildDir""ReleaseName"\"PromoteLogFileName
InputFileName = ScrDir""BuildDir""ReleaseName"\"ScrFile
'perl p:\cm\prmtlst.pl NBASE' BuildLabel OutputFileName InputFileName LogFileName

/**************************************************************************/
/* extract the appropriate proot.cmd and andirs.txt for this build        */
/* the build scripts rely on them being in the path or in the current dir */
/**************************************************************************/
InputFileName = ScrDir""BuildDir""ReleaseName"\"PromoteFileName
LogFileName = ScrDir""BuildDir""ReleaseName"\"GetProotLogFileName
'perl p:\cm\getproot.pl NBASE' BuildLabel InputFileName LogFileName

/**************************************************************************/
/* remove obsolete files from the build */
/**************************************************************************/
CALL outputMsg "remove obsolete files from the build"
InputFileName = ScrDir""BuildDir""ReleaseName"\"PromoteFileName
rc = delbuild( InputFileName BuildLabel )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: delbuild failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/**************************************************************************/
/* skip the extractl for a refresh */
/**************************************************************************/

IF BuildType = "REBUILD" THEN
DO
   /* extract the files for the build */
   CALL outputMsg "extract the files for the build"
   OutputFileName = ScrDir""BuildDir""ReleaseName"\"ExtractlFileName
   rc = extractl( BaseDir"," BuildLabel"," PvcsDir"," OutputFileName )
   IF rc \= 0 THEN
   DO
      CALL outputMsg "ERROR: extractl failed with rc = " rc
      CALL err_beep
      EXIT 1
   END
   /* BaseDir should now be created, if not, stop the build */
   IF \isDir(BaseDir) THEN
   DO
      ErrorMessage = "ERROR: BaseDir does not exist after running extractl"
      CALL err_beep
      showUsage()
   END
END

/**************************************************************************/
/* extract the newly promoted files */
/**************************************************************************/

CALL outputMsg "extract the newly promoted files"
InputFileName = ScrDir""BuildDir""ReleaseName"\"PromoteFileName
CALL outputMsg InputFileName
rc = pvcs2bld( ReleaseName"," BaseDir"," InputFileName"," BuildLabel )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: pvcs2bld failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/* removed setupbld and setvdisk - must do these manually before starting the build */

/*************************************************************************/
/* start the make process */
/*************************************************************************/

CALL outputMsg "start the make process"

CALL outputMsg "changing directories"
CALL directory nbase

CALL stream 'wayne.net\maklocaldotnet.cmd', 'C', 'OPEN READ'
IF ( lines( 'wayne.net\maklocaldotnet.cmd' ) ) THEN DO
   /* then there are .NET solutions to build */
   CALL outputMsg "start building .NET solutions"
   CALL stream 'wayne.net\maklocaldotnet.cmd', 'C', 'CLOSE'   /* close file just opened */

   /* Execute setmakldotnet.bat to execute vcvars32.bat and invoke maklocaldotnet. */
   /* Setmakldotnet.cmd puts its return  code in setmakldotnet.rc. */
   CALL SysFileDelete 'setmakldotnet.rc'
   cmd = 'setmakldotnet 'BuildType' 'BaseDir' 'AllocType
   CALL outputMsg cmd
   '@'cmd

   /* Get the maklocal rc from setmakldotnet.rc */
   CALL stream 'setmakldotnet.rc', 'C', 'OPEN READ'
   IF ( lines( 'setmakldotnet.rc' ) ) THEN DO
      rc = linein( 'setmakldotnet.rc' )
   END
   ELSE DO
      CALL outputMsg "ERROR: setmakldotnet.rc seems to be empty"
      CALL err_beep
      EXIT 1
      END
   CALL stream 'setmakldotnet.rc', 'C', 'CLOSE'

   IF rc \= 0 THEN 
   DO 
   CALL outputMsg "ERROR: maklocaldotnet failed with rc = " rc 
      CALL err_beep 
      EXIT 1 
   END 
END /* THEN - dotnet solutions exist in this build */
ELSE DO
   CALL outputMsg "no .NET solutions to build"
END

/* Execute setmakl.bat to execute setupbld and maklocal.  Using this .bat file
   allows the already extracted build-specific version of setvdisk.bat to be
   used rather than putting a copy in P:/pnutil.  Setmakl.cmd puts its return
   code in setmakl.rc. */
CALL SysFileDelete 'setmakl.rc'
cmd = 'setmakl 'BuildType' 'BaseDir' 'AllocType
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

/************************************************************************/
/* promote the new build to the network */
/************************************************************************/

CALL outputMsg "promote the new build to the network"
rc = promote( BaseDir"," ReleaseDir )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: promote failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/************************************************************************/
/* attach the correct label */
/************************************************************************/

CALL outputMsg "attach the correct label"
BaseLink = substr( BaseDir, 4, 9 )
OutputFileName = ScrDir""BuildDir""ReleaseName"\"MovlabelFileName
rc = movlabel( BuildLabel"," ReleaseName"," BaseLink"," OutputFileName )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: movlabel failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/************************************************************************/
/* run the nottip utility */
/************************************************************************/

CALL outputMsg "run the nottip utility"
OutputFileName = ScrDir""BuildDir""ReleaseName"\"NottipFileName
rc = nottip( PvcsDir"," BuildLabel"," OutputFileName )
IF rc \= 0 THEN
DO
   SAY "ERROR: nottip failed with rc = " rc
   CALL err_beep
   EXIT 1
END

CALL outputMsg "Base build successfully completed at "time()

EXIT
/***************************************************************************/
/*=========================================================================*/

showUsage: PROCEDURE EXPOSE ErrorMessage
   '@cls'
   SAY " "
   SAY " "
   CALL outputMsg ErrorMessage
   SAY " "
   SAY " "
   SAY "BASEBLD BuildType BaseDir BuildLabel ReleaseName AllocType"
   SAY " "
   SAY " BuildType: REFRESH or REBUILD"
   SAY " "
   SAY " BaseDir: Directory location of the Base (e.g. D:\NBASE)"
   SAY " "
   SAY " BuildLabel: e.g. BASE22 BASE30"
   SAY " "
   SAY " ReleaseName: e.g. N0210AE, N0220D, N0300X"
   SAY " "
   SAY " AllocType:"
   SAY "    SM_PRODUCTION - production SmartHeap"
   SAY "    SM_DEBUG      - memory debug SmartHeap"
   SAY "    SYMBOLS       - no SmartHeap, but with debug"
   SAY " "
EXIT
/*=========================================================================*/

isDir: PROCEDURE
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
*/
