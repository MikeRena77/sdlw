/*****************************************************************************
* NAME:        $Workfile:   err.cmd  $
*              $Revision:   1.1  $
*              $Date:   14 Jul 1994 13:40:06  $
*              $Logfile:   P:/vcs/poutil/err.cmv  $
*
* DESCRIPTION: See usage below.
*
*              Here is err.cmd's basic algorithm:
*
*              Parse the 2nd level dir name from the cwd into subSys
*              Parse the 1st level dir name from the cwd into component
*              If the cwd is not located under the common component,
*                 cd ..\..\common\subSys
*                 evaluateErrFiles
*                 cd ..\..\component\subSys
*              evaluateErrFiles
*              Type any .ler files in the cwd
*
*              evaluateErrFiles:
*                 For each .err file, grep for Error, Warning, or Fatal
*                    If found,
*                       If the corresponding .cpp file exists in the cwd,
*                          edit the file in brief (allows you to take advantage
*                          of brief's automatic error location capabilites)
*                       else
*                          edit the .err file in brief
*                    else
*                       delete the .err file
*
*              After all .err & .ler files have been evaluated, the user is
*              asked if they want to delete all .err & .ler files.  If yes,
*              all are deleted.
*
* MODIFICATION/REV HISTORY:
*
* 07/14/94 ddc Added capability of evaluating .err files in both cwd and
*              ..\..\common\subSys
* 03/10/94 ddc Original
*****************************************************************************/
'@echo off'

call RxFuncAdd 'SysFileTree',    'RexxUtil', 'SysFileTree'
call RxFuncAdd 'SysFileSearch',  'RexxUtil', 'SysFileSearch'

call getRootComponentAndSubSysFromCwd

/* If the cwd is not located under the common component, */
if compare( component, "COMMON" ) <> 0 then
   do
      /* cd ..\..\common\subSys */
      oldDir = directory()
      call directory  '..\..\common\'subSys

      call evaluateErrFiles

      /* cd ..\..\component\subSys */
      call directory oldDir
   end

call evaluateErrFiles

/* Let the user examine all of the .ler files */
call SysFileTree '*.ler', 'lerFile', 'FO'
do i=1 to lerFile.0
   say 'Hit Enter to see link errors for 'lerFile.i
   pull
   'type 'lerFile.i' |more'
end

/* If any .ler or .err files still exist, ask the user if they want to delete
   them */
delStr = ''
if lerFile.0 > 0 then
   delStr = '*.ler'
call SysFileTree '*.err', 'errFile', 'FO'
if errFile.0 > 0 then
   delStr = delStr' *.err'
if compare( component, "COMMON" ) <> 0 then
   do
      call SysFileTree '..\..\common\'subSys'\*.err', 'errFile', 'FO'
      if errFile.0 > 0 then
         delStr = delStr' ..\..\common\'subSys'\*.err'
   end
if length( delStr ) <> 0 then
   do
      say 'Delete all the .err & .ler files? [y]: '
      pull reply
      if substr( reply, 1, 1 ) <> 'N' then
         'del 'delStr
   end
exit

/******************************************************************************
* Parse the 2nd level dir name from the cwd into subSys, and
* Parse the 1st level dir name from the cwd into component
* Parse the root      dir name from the cwd into root
* Output both in uppercase
******************************************************************************/
getRootComponentAndSubSysFromCwd:
procedure expose root component subSys

   cwd = directory()
   ssLoc = lastPos( '\', cwd )
   if ssLoc = 0 then
      error( 'Your cwd(' cwd ') must be at least 2 levels deep' )
   cLoc = lastPos( '\', cwd, ssLoc - 1 )
   if cLoc = 0 then
      call error 'Your cwd(' cwd ') must be at least 2 levels deep'
   root = translate( substr( cwd, 1, cLoc - 1 ) )
   if \ dirExists( root'\common' ) then
      error( 'Your cwd('cwd') does not appear to be a 2nd level dir' )
   component = translate( substr( cwd, cLoc + 1, ssLoc - cLoc - 1 ) )
   subSys = translate( substr( cwd, ssLoc + 1 ) )
return

/******************************************************************************
* Description: Return a bool which indicates whether the specified dir exists
******************************************************************************/
dirExists:
procedure
   arg dir
   oldDir = directory()
   newDir = directory( dir )
   if newDir = dir then
      do
         call directory oldDir
         ret = 1
      end
   else
      ret = 0
return ret

/******************************************************************************
* Evaluate the .err files in the cwd
* See algorithm in module header description
******************************************************************************/
evaluateErrFiles:
procedure

   /* For all .err files, */
   call SysFileTree '*.err', 'errFile', 'FO'
   do i=1 to errFile.0

      /* If file contains Error, Warning, or Fatal, */
      call SysFileSearch 'Error', errFile.i, 'result.', 'C'
      if result.0 > 0 then
         call editIt errFile.i
      else
         do
            call SysFileSearch 'Warning', errFile.i, 'result.', 'C'
            if result.0 > 0 then
               call editIt errFile.i
            else
               do
                  call SysFileSearch 'Fatal', errFile.i, 'result.', 'C'
                  if result.0 > 0 then
                     call editIt errFile.i
                  else
                     'del 'errFile.i
               end
         end
   end
return

/******************************************************************************
* If the .cpp file is local, edit it; otherwise, edit the .err file
******************************************************************************/
editIt:
procedure
   arg f"."ext
   call SysFileTree f".cpp", 'result', 'FO'
   if result.0 > 0 then
      'b.exe 'f'.cpp'
   else
      'b.exe 'f'.'ext
return

error:
   parse arg all
   say 'Error: ' all
   say ''
   call usage

Usage:
   say 'Usage  : err'
   say ''
   say 'The Error command file, written in Rexx, is a nice way to evaluate,'
   say 'then cleanup, the error files which are generated by your makes.'
   say ''
   say 'A .err file is produced for each module compiled by makefiles which'
   say 'define SINGLE_FILES = 1 before !including rules.mak.'
   say ''
   say 'A .ler file is produced by some makefiles for each .exe linked'
   say 'and contains the error output from link.exe.'
   say ''
   say 'Err.cmd assumes that your current working directory (cwd) is a'
   say 'directory under a PROMS directory hierarchy.  Specifically, it'
   say 'assumes that the cwd is a 2nd level directory (chs/ecr/fdd/etc.)'
   say 'under one of the 1st level component directories (common/cc/ipt/sc).'
   say ''
   say 'For each .err file in your cwd, and for each .err file in ../../common/subSys,'
   say '   If the .err file contains Warning, Error, or Fatal messages,'
   say '      Edit the source file with brief'
   say "         (This allows you to take advantage of brief's"
   say '          automatic error location capabilites - ^P & ^N)'
exit
