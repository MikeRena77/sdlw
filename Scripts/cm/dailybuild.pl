#!perl
#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   dailybuild.pl  $
#*               $Revision:   1.20  $
#*               $Date:   03 Sep 2002 11:01:10  $
#*
#* DESCRIPTION: This script does the daily BASE and STARTER build.
#*              
#*
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/dailybuild.plv  $
#*  
#*     Rev 1.20   03 Sep 2002 11:01:10   gracel
#*  Added NBPAMOCO for BP RESPONS release.
#*  
#*     Rev 1.19   05 Aug 2002 09:44:30   CraigL
#*  Changes for new server.
#*  
#*     Rev 1.18   05 Aug 2002 09:33:32   CraigL
#*  Changes for new server.
#*  
#*     Rev 1.17   Apr 24 2002 08:50:46   GraceP
#*  Fixed bug is previous check in.
#*  
#*     Rev 1.16   Apr 24 2002 08:45:16   GraceP
#*  Modified to work for base 10
#*  
#*     Rev 1.15   Nov 28 2001 11:22:38   GraceP
#*  added nshell and ncanada
#*  
#*     Rev 1.14   Oct 01 2001 11:13:40   GraceP
#*  Add NTEquiva project
#*  
#*     Rev 1.13   Sep 11 2001 09:18:14   JACIC
#*  Added CITGO, ADS.
#*  
#*     Rev 1.12   Jun 05 2001 11:13:06   HGbedemah
#*  Changed MOBIL21 to MOBIL23 to reflect the change in the current mobil
#*  build.
#*  
#*     Rev 1.11   Aug 14 2000 09:39:36   GraceP
#*  changed SN10 to SUN10
#*  
#*     Rev 1.10   Jun 27 2000 11:17:00   WTong
#*  changed database login password
#*  
#*     Rev 1.9   Jun 22 2000 11:34:08   BMASTER
#*  Added Sun to projrct list
#*  
#*     Rev 1.8   Mar 21 2000 16:40:16   brettl
#*  code review rework - fixed minor typo - add clarification comment
#*  
#*     Rev 1.7   Mar 13 2000 17:11:18   brettl
#*  moved some general purpose subroutines into bldutils.pl
#*  added handling of sql server databases (drop/restore)
#*  added BP
#*  generalized build-project code so it could be called for each project
#*     (rather than being copied/pasted 5 times)
#*  
#*     Rev 1.6   Feb 11 2000 19:05:32   brettl
#*  changed sendMail to support comma seperated PE list
#*  
#*     Rev 1.5   Feb 11 2000 16:38:18   brettl
#*  added jaci to chevronPE list
#*  
#*     Rev 1.4   Jan 28 2000 06:28:50   HGbedemah
#*  Changed mobil PE from stephenm to hgbedemah
#*  
#*     Rev 1.3   Dec 06 1999 17:25:44   brettl
#*  added code to unregister the ocxes after each appl bld and added code
#*  to reregister the ocxes before each refresh
#*  
#*     Rev 1.2   Nov 11 1999 13:24:38   brettl
#*  added support for sendmail
#*  changed "net send"s to go to appropriate PE(s)
#*  
#*     Rev 1.1   Aug 27 1999 15:30:30   brettl
#*  enhanced to also do mobil and chevron nightly
#*  enhanced to automatically set the ODBC Nucleus filename to the 
#*  appropriate application's nucleus.db file
#*  fixed some sendMsg errors (sending to brettl@wayne, not just brettl)
#*  
#*     Rev 1.0   Jul 09 1999 11:59:56   brettl
#*  Initial revision.
#*  
#*
#*****************************************************************************
# end extraction 

require 'p:\\cm\\bldutils.pl';
require 'p:\\cm\\GetServerName.pl';

###  ARG PROCESSING  #####################################################
$ARGV[0] =~ tr/a-z/A-Z/; #convert arg to uppercase

local ($rebuild);
if ($ARGV[0] eq 'REBUILD')
{
   $rebuild = 1;
}
elsif ($ARGV[0] eq 'REFRESH')
{
  $rebuild = 0;
}
else
{
print <<HelpSection and exit 

Tool: Daily Build Script

Usage: dailyBuild [-h] [REFRESH|REBUILD] 
Example: dailyBuild REBUILD

This script does not modify PVCS labels like basebld and applbld.
This script is run daily (nightly) and pulls in all modules in SCRs that
were submitted (and not yet accepted).

REBUILD - deletes the vdisk, nbase, nstarter, nmobil and nchevron and extracts
all the current code from pvcs (and does a REFRESH).

REFRESH - uses what's in nbase, nstarter, nmobil and nchevron and gets the
submitted files into nbase and nstarter and does top level maklocal refreshes.  

REFRESH Warning: New directories are not created via PROMS.CMD.


HelpSection

exit;
}


###  SETUP  #####################################################
open (LOG_MESSAGE_FILE, ">>d:\\dailybld.log");
print LOG_MESSAGE_FILE "--------------------------------------------------------------------------------\n";

$projectReleases{"NBASE"} = "BASE110";
$projectReleases{"NSTARTER"} = "STARTER110";
#$projectReleases{"NMOBIL"} = "MOBIL30";
#$projectReleases{"NCHEVRON"} = "CHEVRON15";
#$projectReleases{"NBP"} = "BP30";
#$projectReleases{"NSUN"} = "SUN10";
#$projectReleases{"NCITGO"} = "CITGO10";
#$projectReleases{"NCANADA"} = "CANADA10";
#$projectReleases{"NADS"} = "ADS10";
#$projectReleases{"NSHELL"} = "SHELL80";
#$projectReleases{"NBPAMOCO"} = "BPAMOCO10";

local ($softwareTeam, $basePE, $mailFile);

$softwareTeam = "CAB";
$basePE = $projectPEs{"NBASE"};
$mailFile = "d:\\mail.txt";

&logMessage("REBUILD flag = $rebuild");
&logMessage("BASE release = ".$projectReleases{"NBASE"});
&logMessage("STARTER release = ".$projectReleases{"NSTARTER"});
#&logMessage("MOBIL release = ".$projectReleases{"NMOBIL"});
#&logMessage("CHEVRON release = ".$projectReleases{"NCHEVRON"});
#&logMessage("BP release = ".$projectReleases{"NBP"});
#&logMessage("SUN release = ".$projectReleases{"NSUN"});
#&logMessage("CITGO release = ".$projectReleases{"NCITGO"});
#&logMessage("CANADA release = ".$projectReleases{"NCANADA"});
#&logMessage("ADS release = ".$projectReleases{"NADS"});
#&logMessage("SHELL release = ".$projectReleases{"NSHELL"});
#&logMessage("BPAMOCO release = ".$projectReleases{"NBPAMOCO"});

###  DELETE  VDISK #############################################
if ($rebuild)
{
   &executeCmd("rd /s/q d:\\vdisk");
   if (-e 'd:\\vdisk'){&sendMsg($basePE, "vdisk del failed");die;}
}

### DO THE PROJECT BUILDS ######################################
&buildProject("NBASE");
&buildProject("NSTARTER");
#&buildProject("NMOBIL");
#&buildProject("NCHEVRON");
#&buildProject("NBP");
#&buildProject("NSUN");
#&buildProject("NCITGO");
#&buildProject("NCANADA");
#&buildProject("NADS");
#&buildProject("NSHELL");
#&buildProject("NBPAMOCO");

close (LOG_MESSAGE_FILE);

################################################################################

##################
sub buildProject
{
   local ($projectName) = @_;
   local ($projectPE, $projectShare, $projectDrive, 
          $projectRelease, $projectPrefix, $isApplProject);

   $projectPE = $projectPEs{$projectName};
   $projectShare = $projectShares{$projectName};
   $projectDrive = $projectDrives{$projectName};
   $projectRelease = $projectReleases{$projectName};
   $projectPrefix = $projectPrefixes{$projectName};

   $isApplProject = ($projectName ne "NBASE");

   &logMessage("starting $projectName build");
   &resetShares($projectName);

   #delete project dir if rebuild is requested
   if ($rebuild)
   {
      &executeCmd("kill rxapi.exe");
      &executeCmd("perl p:\\pnutil\\delbld.pl d:\\$projectName");
      if (-e 'd:\\$projectName'){
         &sendMsg($projectPE, "delbld $projectName failed");die;}
   }
   else 
   {
      if ($isApplProject)
      {
         #register the application's ocxes since they were unregistered earlier
         &executeCmd("perl p:\\pnutil\\regocxes.pl D:\\$projectName");
         if ($?){&sendMsg($projectPE, "regocxes $projectName failed");die;}

         #restore the application's database, since it was dropped earlier
         &executeCmd("isql -b -Usa -PCulzean -Q\"RESTORE DATABASE Nucleus FROM ".
                     "DISK='D:\\$projectName\\TARGET\\DATABASE\\nucleus.dat' ".
                     "WITH RECOVERY, REPLACE, MOVE 'Nucleus' TO ".
                     "'D:\\nbase\\COMMON\\DATABASE\\nucleus.mdf', ".
                     "MOVE 'Nucleus_Log' TO ".
                     "'D:\\nbase\\COMMON\\DATABASE\\nucleus_log.ldf'\"");
         if ($?){&sendMsg($projectPE, "restore $projectName database failed");die;}
      }
      else
      {
         &executeCmd("isql -b -Usa -PCulzean -Q\"RESTORE DATABASE Nucleus FROM ".
                     "DISK='D:\\$projectName\\COMMON\\DATABASE\\nucleus.dat' ".
                     "WITH RECOVERY, REPLACE, MOVE 'Nucleus' TO ".
                     "'D:\\nbase\\COMMON\\DATABASE\\nucleus.mdf', ".
                     "MOVE 'Nucleus_Log' TO ".
                     "'D:\\nbase\\COMMON\\DATABASE\\nucleus_log.ldf'\"");
         if ($?){&sendMsg($projectPE, "restore $projectName database failed");die;}

      }
   }

   &createSCRFilesList($projectDrive, $projectRelease, 
                       "d:\\${projectPrefix}_scrs.lst");

   #create promote list
   &executeCmd("perl p:\\cm\\prmtlst.pl $projectName $projectRelease ".
               "d:\\${projectPrefix}_prmt.lst d:\\${projectPrefix}_scrs.lst ".
               "d:\\${projectPrefix}_prmt.log");
   if ($?){&sendMsg($projectPE, "prmtlst $projectName failed");die;}

   if($rebuild)
   {
     #get latest andirs.txt and proot.cmd
     &executeCmd("perl p:\\cm\\getproot.pl $projectName $projectRelease ".
        "d:\\${projectPrefix}_prmt.lst d:\\${projectPrefix}_gtprt.log");
     if ($?){&sendMsg($projectPE, "getproot $projectName failed");die;}

     #extract latest build's files
     &executeCmd(
        "rexx p:\\cm\\extractl.cmd D:\\$projectName, $projectRelease, ".
        "$projectDrive\\VCS, D:\\${projectPrefix}_xtrtl.log");
     if ($?){&sendMsg($projectPE, "extractl $projectname failed");die;}
   }

   #promote new files, delete removed files
   &promoteFiles("d:\\$projectName", "$projectDrive\\vcs", 
                 "d:\\${projectPrefix}_prmt.lst");

   #make hieararchy read-write
   &executeCmd("attrib /s -r d:\\$projectName\\*.*");
   if ($?){&sendMsg($projectPE, "attrib $projectName failed");die;}

   #delete the VB oca files from the PC (they can cause problems)
   &executeCmd("deloca");

   local ($projectDirList);
   $projectDirList = "D:\\NBASE";
   if ($isApplProject)
   {
      $projectDirList = "$projectDirList D:\\$projectName";
   }

   #do the build
   &executeCmd("p:\\cm\\setmakl.bat REFRESH $projectDirList");
   if ($?){&sendMsg($projectPE, "setmakl $projectName failed");die;}

   if ($isApplProject)
   {
      #unregister the application's ocxes so they don't interfere with 
      #later builds
      &executeCmd("perl p:\\pnutil\\unregocxes.pl D:\\$projectName");
      if ($?){&sendMsg($projectPE, "unregocxes $projectName failed");die;}
   }
   #drop the  database so it doesn't interfere with 
   #later builds
   &executeCmd("isql -b -Usa -PCulzean -dmaster -Q\"drop database Nucleus\"");
   if ($?){&sendMsg($projectPE, "drop $projectName database failed");die;}

   #check make.out, send group e-mail if build broke
   &executeCmd("grep -i \"failed with rc\" d:\\$projectName\\make.out > ".
               "d:\\${projectPrefix}_err.out");
   if ($?) #grep failed, no aborts found, build succeeded, send PE a msg
   {
      &sendMsg($projectPE, "daily build for $projectName succeeded :o)");
   }
   else #grep succeeded, aborts were found, the build broke, send e-mail
   {
      &executeCmd("echo ---------------------------------------------------------------- > $mailFile");
      &executeCmd("echo $projectName MAKE.OUT SUMMARY ------------------------------------------ >> $mailFile");

      #if it's an application build, include the base's scrs list (since the
      #abort could be caused by a base change)
      if ($isApplProject)
      {
         &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
         &executeCmd("echo BASE SCR LIST -------------------------------------------------- >> $mailFile");
         &executeCmd("type d:\\n_scrs.lst >> $mailFile");
      }

      &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
      &executeCmd("echo $projectName SCR LIST -------------------------------------------------- >> $mailFile");
      &executeCmd("type d:\\${projectPrefix}_scrs.lst >> $mailFile");
      &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
      &executeCmd("echo $projectName MAKE.OUT (\\\\base80_nt\\d\$\\$projectName\\make.out)---------- >> $mailFile");
      &executeCmd("echo last 100 lines are included------------------------------------- >> $mailFile");
      &executeCmd("tail -100 d:\\$projectName\\make.out >> $mailFile");

      #send the e-mail to the software team if it is base or starter
      #if base or starter fails, die, don't bother building other projects
      if ($projectName =~ /"NBASE NSTARTER"/)
      {
         &sendMail($softwareTeam, "\"\!\!\!NIGHTLY $projectName BUILD FAILED\!\!\!\"", $mailFile);
         die;
      }
      #send the e-mail to the PE if chevron, mobil, etc.
      else
      {
         &sendMail($projectPE, "\"\!\!\!NIGHTLY $projectName BUILD FAILED\!\!\!\"", $mailFile);
      }
   }
   &logMessage("completed $projectName build");
}



##################
sub promoteFiles
{
   local ($buildRoot, $pvcsRoot, $promoteLst) = @_;

   open(PROMOTELIST, "<$promoteLst");
   while (<PROMOTELIST>)
   {
      s/\n//;
      if (/^\~.*$/)
      {
         s/\~/$buildRoot\\/;
         &executeCmd("del \\f\\q $_");
         
      }
      elsif (/^.*\S.*$/) #non blank line
      {
         ($filePath, $rev) = split(/\s+/);

         #seperate the path from the file
         $filePath =~ s/(.*)\\([^\\]*)/$1 $2/; #sub space for last backslash
         ($path, $file) = split(/\s+/, $filePath); #split on white space

         &executeCmd("get -Y -U -R${rev} ${pvcsRoot}\\$path($buildRoot\\$path\\$file)");
      }
   }
   close(PROMOTELIST);
}


##################
sub resetShares
{
   local ($projectName) = @_;

   local ($projectPE, $projectShare, $projectDrive, $isApplProject);
   $projectPE = $projectPEs{$projectName};
   $projectShare = $projectShares{$projectName};
   $projectDrive = $projectDrives{$projectName};
   $isApplProject = ($projectName ne "NBASE");

   if ($isApplProject)
   {
      &resetShare("s:", "\\\\$ServerName\\$projectShare", $projectPE);
   }
   &resetShare("q:", "\\\\$ServerName\\ntbase", $projectPE);
   &resetShare("p:", "\\\\$ServerName\\ntnuc", $projectPE);
   &resetShare("j:", "\\\\$ServerName\\library", $projectPE);
}


##################
sub resetShare
{
   local ($driveLetter, $shareName, $projectPE) = @_;

   &executeCmd("net use /d $driveLetter");
   &executeCmd("net use $driveLetter $shareName");

   local $isConnected = 0;
   local $isSharedCorrectly = 0;

   #escape backslashes for proper regexp matching
   $shareName =~ s/\\/\\\\/g;

   open(NETUSE_OUT, "net use $driveLetter|");
   while (<NETUSE_OUT>)
   {
      if (/^Remote name\s*$shareName$/i)
      {
         $isSharedCorrectly = 1;
      }
      if (/^Status\s*OK$/i)
      {
        $isConnected = 1;
      }
   }
   close(NETUSE_OUT);

   if (!($isConnected && $isSharedCorrectly))
   {
      &sendMsg($projectPE, "$driveLetter $shareName NOT CONNECTED");
      die;
   }
}


##################
sub createSCRFilesList
{
   local ($drive, $release, $scrfile) = @_;
   open(DIROUTPUT, "dir /b $drive\\scr\\submit\\$release|");
   open(SCRFILES, ">$scrfile");
   while (<DIROUTPUT>)
   {
      if (!/submit.log/i)
      {
         print SCRFILES "$drive\\scr\\in\\$_";
      }
   }
   close(DIROUTPUT);
   close(SCRFILES);
}




