#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   bldutils.pl  $
#*               $Revision:   1.21  $
#*               $Date:   13 Apr 2004 13:11:34  $
#*
#* DESCRIPTION:  Misc Utilities common to the build and utility scripts
#*               
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/bldutils.plv  $
#*  
#*     Rev 1.21   13 Apr 2004 13:11:34   GraceL
#*  Added "NBuypass" into the project list
#*  
#*     Rev 1.20   02 Mar 2004 11:46:36   WTong
#*  update to make the getscr and rvwscr work for the file with "-" in the name
#*  
#*     Rev 1.19   06 Dec 2002 16:01:58   gracel
#*  remove the use of T: and V:, the network shares will not be used any more
#*  
#*     Rev 1.18   03 Sep 2002 11:06:08   gracel
#*  Added NBPAMOCO for BP RESPONS release1
#*  
#*     Rev 1.17   Nov 28 2001 11:23:10   GraceP
#*  added nshell and ncanada
#*  
#*     Rev 1.16   Oct 01 2001 11:11:58   GraceP
#*  Add NTEquiva project
#*  
#*     Rev 1.15   Sep 11 2001 08:47:28   JACIC
#*  Added NCITGO and NADS.
#*  
#*     Rev 1.14   Apr 03 2001 08:58:56   JaciC
#*  Update the PE names to be the machine names vs. the email names.  net send
#*  sends to machines, not email.  Change Texaco from Cheri to Thomas.
#*  
#*     Rev 1.13   Aug 14 2000 09:38:56   GraceP
#*  Add Grace P to SUN project
#*  
#*     Rev 1.12   Jun 27 2000 11:24:16   WTong
#*  changed database login password
#*  
#*     Rev 1.11   Jun 22 2000 11:28:54   BMASTER
#*  Added SUN into the project list
#*  
#*     Rev 1.10   Mar 13 2000 17:13:24   brettl
#*  added shares, drives, PEs to lookup tables (dailybuild.pl needs them)
#*  moved several general purpose subroutines from dailybuild.pl into
#*  this collection of utilities
#*  
#*     Rev 1.9   Jan 12 2000 12:14:48   NancyN
#*  added database restore/backup/delete functionality
#*  
#*     Rev 1.8   Jan 04 1999 16:24:48   brettl
#*  added sub extractBuildId
#*  
#*     Rev 1.7   Nov 30 1998 16:33:54   brettl
#*  changed extractModuleLines to not use scr file name in regexp
#*  (it was broken anyway, grep reveals that this method not used anywhere
#*  until now)
#*  
#*     Rev 1.6   Jul 31 1998 13:59:02   GraceP
#*  Added Chevron Project.
#*  
#*     Rev 1.5   Mar 10 1998 14:51:58   JimL
#*  Added Texaco project
#*  
#*     Rev 1.4   Jan 05 1998 12:00:52   BrettL
#*  processOCXList didn't handle the case in which an ocx line was not newline
#*  terminated.  (next line printed after call to processOCXList was printed on
#*  same line as last regsvr32 line.
#*  Added appropriate newline handling.
#*  
#*     Rev 1.3   Dec 31 1997 16:35:10   BrettL
#*  Added support for the new OCX.LST/OCXAPPL.LST split.
#*  Corrected problem where the OCXes were always unregistered and reregistered.
#*  Reg/Unreg should only be done on the standard project roots (e.g. NBASE,
#*  NMOBIL)
#*  
#*     Rev 1.2   Dec 30 1997 16:15:10   BrettL
#*  Added getOCSFile subroutine.  The ocx.lst file was base/appl split.
#*  filename is now fn of base vs. appl
#*  
#*     Rev 1.0   Dec 30 1997 16:13:52   BrettL
#*  Initial revision.
#*  
#*     Rev 1.1   Nov 17 1997 17:13:12   BrettL
#*  Added misc. utilities to support enhancements to prmtlst.pl.
#*  (mainly more revision comparison subs)
#* 
#*****************************************************************************
#/* end extraction */

$projectPrefixes{"NBASE"} = "N";
$projectExists{"NBASE"} = 1;
$projectNames{"N"} = "NBASE";
$projectShares{"NBASE"} = "NTBASE";
$projectDrives{"NBASE"} = "Q:";
$projectPEs{"NBASE"} = "JaciC_nt,Henryg_nt";

$projectPrefixes{"NSTARTER"} = "ST";
$projectExists{"NSTARTER"} = 1;
$projectNames{"ST"} = "NSTARTER";
$projectShares{"NSTARTER"} = "NTSTART";
$projectDrives{"NSTARTER"} = "S:";
$projectPEs{"NSTARTER"} = "JaciC_nt,Henryg_nt";

$projectPrefixes{"NCHEVRON"} = "CH";
$projectExists{"NCHEVRON"} = 1;
$projectNames{"CH"} = "NCHEVRON";
$projectShares{"NCHEVRON"} = "NCHEVRON";
$projectDrives{"NCHEVRON"} = "S:";
$projectPEs{"NCHEVRON"} = "JaciC_nt";

$projectPrefixes{"NTEXACO"} = "TX";
$projectExists{"NTEXACO"} = 1;
$projectNames{"TX"} = "NTEXACO";
$projectShares{"NTEXACO"} = "NTEXACO";
$projectDrives{"NTEXACO"} = "S:";
$projectPEs{"NTEXACO"} = "ThomasN_ntdvlb8";

$projectPrefixes{"NMOBIL"} = "MO";
$projectExists{"NMOBIL"} = 1;
$projectNames{"MO"} = "NMOBIL";
$projectShares{"NMOBIL"} = "NMOBIL";
$projectDrives{"NMOBIL"} = "S:";
$projectPEs{"NMOBIL"} = "HGbedemah";

$projectPrefixes{"NBP"} = "BP";
$projectExists{"NBP"} = 1;
$projectNames{"BP"} = "NBP";
$projectShares{"NBP"} = "NTBP";
$projectDrives{"NBP"} = "S:";
$projectPEs{"NBP"} = "GraceL";

$projectPrefixes{"NSUN"} = "SN";
$projectExists{"NSUN"} = 1;
$projectNames{"SN"} = "NSUN";
$projectShares{"NSUN"} = "NSUN";
$projectDrives{"NSUN"} = "S:";
$projectPEs{"NSUN"} = "GraceL";

$projectPrefixes{"NCITGO"} = "CT";
$projectExists{"NCITGO"} = 1;
$projectNames{"CT"} = "NCITGO";
$projectShares{"NCITGO"} = "NCITGO";
$projectDrives{"NCITGO"} = "S:";
$projectPEs{"NCITGO"} = "JACIC_NT";

$projectPrefixes{"NCANADA"} = "CT";
$projectExists{"NCANADA"} = 1;
$projectNames{"CA"} = "NCANADA";
$projectShares{"NCANADA"} = "NCANADA";
$projectDrives{"NCANADA"} = "S:";
$projectPEs{"NCANADA"} = "RobertG";

$projectPrefixes{"NADS"} = "AD";
$projectExists{"NADS"} = 1;
$projectNames{"AD"} = "NADS";
$projectShares{"NADS"} = "NADS";
$projectDrives{"NADS"} = "S:";
$projectPEs{"NADS"} = "JACIC_NT";

$projectPrefixes{"NEQUIVA"} = "EQ";
$projectExists{"NEQUIVA"} = 1;
$projectNames{"EQ"} = "NEQUIVA";
$projectShares{"NEQUIVA"} = "NTEQUIVA";
$projectDrives{"NEQUIVA"} = "S:";
$projectPEs{"NEQUIVA"} = "ThomasN, GraceP";

$projectPrefixes{"NSHELL"} = "SH";
$projectExists{"NSHELL"} = 1;
$projectNames{"SH"} = "NSHELL";
$projectShares{"NSHELL"} = "NTSHELL";
$projectDrives{"NSHELL"} = "S:";
$projectPEs{"NSHELL"} = "ThomasN, GraceP";

$projectPrefixes{"NBPAMOCO"} = "BA";
$projectExists{"NBPAMOCO"} = 1;
$projectNames{"BA"} = "NBPAMOCO";
$projectShares{"NBPAMOCO"} = "NBPAMOCO";
$projectDrives{"NBPAMOCO"} = "S:";
$projectPEs{"NBPAMOCO"} = "GraceL";

$projectPrefixes{"NBUYPASS"} = "GB";
$projectExists{"NBUYPASS"} = 1;
$projectNames{"GB"} = "NBUYPASS";
$projectShares{"NBUYPASS"} = "NBUYPASS";
$projectDrives{"NBUYPASS"} = "S:";
$projectPEs{"NBUYPASS"} = "GraceL";

################################
sub getProjectFromReleaseNum
{
   local (*projectName_, $releaseNumFile_) = @_;

   $_ = (`type $releaseNumFile_`)[0]; #get 1st line of release.num file
   s/^([A-Z]*)\d.*/\1/; #remove everything but project prefix
   s/\n//; #remove newline
   $projectName_ = $projectNames{$_}; #lookup project name using prefix
}


################################
sub getOCXListFile
{
   local (*OCXListFilename_, $projectName_) = @_;

   $_ = $projectName_;
   if ( /Q:/ || /NBASE/ ) 
      {$OCXListFilename_ = "OCX.LST";}
   else
      {$OCXListFilename_ = "OCXAPPL.LST";} 
}


################################
sub getProjectDrive
{
   local (*driveLetter, $projectName) = @_;

   #assign the drive letter
   $_ = $projectName;
   if ( /^[A-Z]\:$/ ) {$driveLetter = $_;}
   elsif ( /NBASE/ ) { $driveLetter = 'Q:'; }
   else { $driveLetter = 'S:'; }
}


################################
#sub getBuildDrive
#{
#   local (*driveLetter, $projectName) = @_;
#
#   #assign the drive letter
#   $_ = "\U$projectName";
#   if ( /^[A-Z]\:$/ ) {$driveLetter = $_;}
#   elsif ( /NBASE/ ) { $driveLetter = 'T:'; }
#   else { $driveLetter = 'V:'; }
#}

################################
#returns empty string if no match

sub getDriveMapping
{
   local (*driveMapping, $driveLetter) = @_;
   local ($nuStatus, $nuDrive);
   $driveMapping = "";

   @driveLines = grep /$driveLetter/, `net use`;

   #use 1st match (if any match)
   if ($#driveLines >= 0)
   {
     ($nuStatus, $nuDrive, $driveMapping) = split ' ', "\U@driveLines[0]";
   }
}

##################
#pass in a "/u" if you want to unregister the OCXes
sub processOCXList
{
   local ($unregisterSwitch, $OCXListFile, $OCXDir) = @_;
   local (@OCXList, $curOCX);
   
   @OCXList = grep /^[^#]/, `type $OCXListFile`;
   while ($_ = pop(@OCXList))
   {
      s/\n//; #strip newline
      $curOCX = "$OCXDir\\$_";
      $regCmd = "regsvr32 /s /c $unregisterSwitch $curOCX";
      print "$regCmd\n";
      `$regCmd`;
      if ($?)
      {
        print "warning: could not process $curOCX\n";
      }
   }  
}

################################
# This sub extracts the revision number out of a file based on
# the standard pvcs header $ revision line. 
sub extractRev
{
   local (*revNum, $filename) = @_;

   #get existing file's rev
   open (DEST_FILE, "<$destPath");
   $revNum = (grep(/\$Revision\:/, <DEST_FILE>))[0];
   close DEST_FILE;

   chop($revNum);

   $revNum =~ s/.*\$Revision\:\s+([\d\.]+).*/$1/;

}

################################
# This sub compares 2 revisions 
sub isRevNewer
{
   local (*isNewer, $rev1, $rev2) = @_;

   #the following subs convert revs like 2.10 to 000002.000010
   #without this, a string comparison would be incorrect for revs like
   #   2.10 gt 100.1

   $rev1 =~ s/(\d+)/0000000000\1/g;
   $rev1 =~ s/\d*(\d{6,6})/\1/g;
   $rev2 =~ s/(\d+)/0000000000\1/g;
   $rev2 =~ s/\d*(\d{6,6})/\1/g;

   $isNewer = ($rev1 gt $rev2);

}

################################
# is rev1 older than rev 2
sub isRevOlder
{
   local (*isOlder, $rev1, $rev2) = @_;

   #the following subs convert revs like 2.10 to 000002.000010
   #without this, a string comparison would be incorrect for revs like
   #   2.10 gt 100.1

   $rev1 =~ s/(\d+)/0000000000\1/g;
   $rev1 =~ s/\d*(\d{6,6})/\1/g;
   $rev2 =~ s/(\d+)/0000000000\1/g;
   $rev2 =~ s/\d*(\d{6,6})/\1/g;

   $isOlder = ($rev1 lt $rev2);

}

################################
sub getDriveLetter
{
   local (*driveLetter, $projectName) = @_;

   #assign the drive letter
   $_ = $projectName;
   if ( /^[A-Z]\:$/ ) {$driveLetter = $_;}
   elsif ( /NBASE/ ) { $driveLetter = 'Q:'; }
   else { $driveLetter = 'S:'; }
}


################################
sub extractModuleLines
{
   local (*modules, $scrPath) = @_;

   #get the module lines from the file
   open(SCRFILE, $scrPath)
      || die "unable to open: $scrPath\n";
   @modules = grep(/^\s*\S+\.\w+\s+([0-9\.]+|New)\s+[0-9\.]+\s+[\w\\\/\.]+\s+\S+\s*$/, <SCRFILE> );
   close(SCRFILE);

}

################################
sub splitModuleLine
{
   local (*file, *oldRev, *newRev, *path, *scrName, $moduleLine) = @_;

   $_ = "\U$moduleLine";
   
   s/\//\\/g;
   
   ($file, $oldRev, $newRev, $path, $scrName) = split(/\s+/);

}

################################
sub extractDeletedModules
{
   local (*modules, $scrFile, $scrPath) = @_;

   #get the module lines from the file
   open(SCRFILE, $scrPath)
      || die "unable to open: $scrPath\n";
   @modules = grep(/^\~/, <SCRFILE> );
   close(SCRFILE);

}

################################
# this subroutine returns the Build Id specified in the SCR on the
# "Build:" line
################################
sub extractBuildId
{
   local (*buildId, $scrPath) = @_;
   local (@buildLine);

   #get the "Build:" lines from the file
   open(SCRFILE, $scrPath)
      || die "unable to open: $scrPath\n";
   @buildLine = grep(/^Build\:\W+\w+\W*$/, <SCRFILE> );
   close(SCRFILE);
   
   $buildId = $buildLine[0];
   $buildId =~ s/^Build\:\W+(\w+)\W*$/$1/; #strip off everything but Id
   $buildId =~ s/\n//g; #remove newline
}

################################
sub getArchiveLabelRev
{
   local (*rev, $archiveFile, $label ) = @_;

   $rev = "";

   #get the pvcs output
   open(PVCSOUTPUT, "vlog -q -bv$buildLabel $archiveFile|" );
   $_ = <PVCSOUTPUT>;
   close(PVCSOUTPUT);

   #example output returned by pvcs:
   #Q:\VCS\COMMON\DATABASE\BASUPGRD.SQLv - BASE70 : 4.15

   s/\s//g; #srip out all the whitespace
   s/.*-$buildLabel:([\d\.]*)$/$1/; #strip off everything but the rev
   $rev = $_;
}

################################
# this subroutine restores a Nucleus SQL Server database from the path
# specified in the parameter
################################
sub restoreDatabase
{
   local ($toDir) = @_;

   if (-e "$toDir\\target\\database\\nucleus.dat")
   {
      print "restoring new database...\n";
      $restoreCmd = "isql -b -Usa -PCulzean -Q\"RESTORE DATABASE Nucleus ".
         "FROM DISK='$toDir\\target\\database\\nucleus.dat' WITH RECOVERY, ".
         "REPLACE, ".
         "MOVE 'Nucleus' TO '$toDir\\common\\database\\nucleus.mdf', ".
         "MOVE 'Nucleus_Log' TO '$toDir\\common\\database\\nucleus_log.ldf'\"";
      print "$restoreCmd\n";
      print `$restoreCmd`;
   }
}

################################
# this subroutine does a backup of a Nucleus SQL Server database to the path
# specified in the parameter
################################
sub backupDatabase
{
   local ($toDir) = @_;

   if (-e "$toDir\\common\\database\\nucleus.mdf")
   {
      print "backing up database...\n";
      $Cmd = "isql -b -Usa -PCulzean -Q\"BACKUP DATABASE Nucleus ".
         "TO DISK='$toDir\\common\\database\\nucleus.bak' WITH FORMAT\"";
      print "$Cmd\n";
      print `$Cmd`;
   }
}

################################
# this subroutine drops a Nucleus SQL Server database
################################
sub dropDatabase
{
   print "dropping old database...\n";
   $dbcmd = "isql -b -Usa -PCulzean -dmaster -Q\"DROP DATABASE Nucleus\"";
   print "$dbcmd\n";
   print `$dbcmd`;
}


##################
### $sendToNames accepts name list, separated by commas
sub sendMsg
{
   local ($sendToNames, $message) = @_;

   local @sendToList = split ',', $sendToNames;

   while ($sendTo = pop(@sendToList))
   {
     &executeCmd("net send $sendTo $message");
   }
}

##################
#Note: currently only the dailybuild uses this
#      if other scripts need this the location and not-found handling
#      of the .ini file should be enhanced 
#      (suggestion: look at the local d:\ 1st, then try a generic one in pnutil)
sub sendMail
{
   local ($sendToNames, $subject, $file) = @_;
   local $WSENDMAILINI = "d:\\wsendmail.ini";

   if (-e $WSENDMAILINI )
   {
     local @sendToList = split ',', $sendToNames;
     while ($sendTo = pop(@sendToList))
     {
        &executeCmd("p:\\pnutil\\wsendmail.exe -d -v -i$WSENDMAILINI -s$subject $sendTo\@wayne.com $file");
     }
   }
   else
   {
     &sendMsg($projectPEs{"NBASE"}, 
              "$WSENDMAILINI does not exits - could not send email to: ".
              "$sendTo file: $file");
   }
}

##################
sub executeCmd
{
   local ($theCmd) = @_;

   print "$theCmd\n";
   &logMessage($theCmd);
   print `$theCmd`;
   &logMessage("execute CMD status: $?");

}
##################
#Note: currently only the daily build script uses the log file
#      the hanlde to the file must be global
#      if the handle exists, then the message will be logged
sub logMessage
{
   local ($theMsg) = @_;

   if (LOG_MESSAGE_FILE)
   {
     print LOG_MESSAGE_FILE scalar localtime, ": $theMsg\n";
   }

}
return 1;
