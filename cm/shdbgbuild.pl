#!perl
#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   shdbgbuild.pl  $
#*               $Revision:   1.2  $
#*               $Date:   05 Aug 2002 09:44:46  $
#*
#* DESCRIPTION: This script does the daily BASE and STARTER build.
#*              
#*
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/shdbgbuild.plv  $
#*  
#*     Rev 1.2   05 Aug 2002 09:44:46   CraigL
#*  Changes for new server.
#*  
#*     Rev 1.1   05 Aug 2002 09:33:48   CraigL
#*  Changes for new server.
#*  
#*     Rev 1.0   Feb 11 2000 20:59:56   brettl
#*  Initial revision.
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

require 'p:\\cm\\GetServerName.pl';

###  ARG PROCESSING  #####################################################
$ARGV[0] =~ tr/a-z/A-Z/; #convert arg to uppercase
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

THIS DOES A SMARTHEAP DEBUG BUILD USING THE MOST RECENT OFFICIAL BUILD
THIS DOES NOT INCLUDE THE SCRS IN THE SUBMIT DIRECTORY

HelpSection

exit;
}


###  SETUP  #####################################################
open (DAILYBUILDLOG, ">>d:\\dailybld.log");
print DAILYBUILDLOG "--------------------------------------------------------------------------------\n";

$baseRelease = "BASE110";
$starterRelease = "STARTER110";
$mobilRelease = "MOBIL23";
$chevronRelease = "CHEVRON11";
$basePE = "hgbedemah,craigl";
$mobilPE = "hgbedemah";
$chevronPE = "jacic_nt";

$mailFile = "d:\\mail.txt";

&logMessage("REBUILD flag = $rebuild");
&logMessage("BASE release = $baseRelease");
&logMessage("STARTER release = $starterRelease");
&logMessage("MOBIL release = $mobilRelease");
&logMessage("CHEVRON release = $chevronRelease");

$ENV{PROMS_WARNINGS_DO_NOT_FAIL} = 1;

###  DELETE  VDISK #############################################
if ($rebuild)
{
   &executeCmd("rd /s/q d:\\vdisk");
   if (-e 'd:\\vdisk'){&sendMsg($basePE, "vdisk del failed");die;}
}


###  BASE  #####################################################
&logMessage("starting BASE build");
&resetShares("NTSTART");

#delete d:\nbase if rebuild is requested
if ($rebuild)
{
   &executeCmd("kill rxapi.exe");
   &executeCmd("perl p:\\pnutil\\delbld.pl d:\\nbase");
   if (-e 'd:\\nbase'){&sendMsg($basePE, "delbld nbase failed");die;}
}

&createSCRFilesList("Q:", $baseRelease, "d:\\n_scrs.lst");

#create promote list
&executeCmd("perl p:\\cm\\prmtlst.pl NBASE $baseRelease d:\\n_prmt.lst d:\\n_scrs.lst d:\\n_prmt.log");
if ($?){&sendMsg($basePE, "prmtlst nbase failed");die;}

if ($rebuild)
{
  #get latest andirs.txt and proot.cmd
  &executeCmd("perl p:\\cm\\getproot.pl NBASE $baseRelease d:\\n_prmt.lst d:\\n_gtprt.log");
  if ($?){&sendMsg($basePE, "getproot nbase failed");die;}

  #extract latest build's files
  &executeCmd("rexx p:\\cm\\extractl.cmd D:\\NBASE, $baseRelease, Q:\\VCS, D:\\n_xtrtl.log");
  if ($?){&sendMsg($basePE, "extractl nbase failed");die;}
}

#promote new files, delete removed files
#&promoteFiles("d:\\nbase", "q:\\vcs", "d:\\n_prmt.SM_DEBUGlst");

#make hieararchy read-write
&executeCmd("attrib /s -r d:\\nbase\\*.*");
if ($?){&sendMsg($basePE, "attrib nbase failed");die;}

#delete the VB oca files from the PC (they can cause problems)
&executeCmd("deloca");

#do the build
&executeCmd("p:\\cm\\setmakl.bat REFRESH D:\\nbase SM_DEBUG ");
if ($?){&sendMsg($basePE, "setmakl nbase failed");die;}

#check make.out, send group e-mail if build broke
&executeCmd("grep -i \"directory aborted\" d:\\nbase\\make.out > d:\\n_err.out");
if (!$?) #if success, then aborts found, then build broke, send e-mail
{
   &executeCmd("echo ---------------------------------------------------------------- > $mailFile");
   &executeCmd("echo BASE MAKE.OUT SUMMARY ------------------------------------------ >> $mailFile");
   &executeCmd("type d:\\n_err.out >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo BASE SCR LIST -------------------------------------------------- >> $mailFile");
   &executeCmd("type d:\\n_scrs.lst >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo BASE MAKE.OUT (\\\\base80_nt\\d\$\\nbase\\make.out)---------------- >> $mailFile");
   &executeCmd("echo last 100 lines are included------------------------------------- >> $mailFile");
   &executeCmd("tail -100 d:\\nbase\\make.out >> $mailFile");
   &sendMsg($basePE, "\"\!\!\! SHDBG NIGHTLY BASE BUILD FAILED\!\!\!\"");
   die;
}
&logMessage("completed BASE build");


###  STARTER ##############################################
&logMessage("starting STARTER build");
&resetShares("NTSTART");

#delete d:\nstarter if rebuild is requested
if ($rebuild)
{
   &executeCmd("kill rxapi.exe");
   &executeCmd("perl p:\\pnutil\\delbld.pl d:\\nstarter");
   if (-e 'd:\\nstarter'){&sendMsg($basePE, "delbld nstarter failed");die;}
}
else 
{
   #register the application's ocxes since they were unregistered earlier
   &executeCmd("perl p:\\pnutil\\regocxes.pl D:\\nstarter");
   if ($?){&sendMsg($basePE, "regocxes nstarter failed");die;}
}

&createSCRFilesList("S:", $starterRelease, "d:\\st_scrs.lst");

#create promote list
&executeCmd("perl p:\\cm\\prmtlst.pl NSTARTER $starterRelease d:\\st_prmt.lst d:\\st_scrs.lst d:\\st_prmt.log");
if ($?){&sendMsg($basePE, "prmtlst nstarter failed");die;}

if($rebuild)
{
  #get latest andirs.txt and proot.cmd
  &executeCmd("perl p:\\cm\\getproot.pl NSTARTER $starterRelease d:\\st_prmt.lst d:\\st_gtprt.log");
  if ($?){&sendMsg($basePE, "getproot nstarter failed");die;}

  #extract latest build's files
  &executeCmd("rexx p:\\cm\\extractl.cmd D:\\NSTARTER, $starterRelease, S:\\VCS, D:\\st_xtrtl.log");
  if ($?){&sendMsg($basePE, "extractl nstarter failed");die;}
}

#promote new files, delete removed files
#&promoteFiles("d:\\nstarter", "s:\\vcs", "d:\\st_prmt.lst");

#make hieararchy read-write
&executeCmd("attrib /s -r d:\\nstarter\\*.*");
if ($?){&sendMsg($basePE, "attrib nstarter failed");die;}

#delete the VB oca files from the PC (they can cause problems)
&executeCmd("deloca");

#set ODBC filename to starter's
&executeCmd("p:\\cm\\setODBCNucDBFile.bat D:\\NSTARTER");
if ($?){&sendMsg($basePE, "setODBCNucDBFile nstarter failed");die;}

#do the build
&executeCmd("p:\\cm\\setmakl.bat REFRESH D:\\nbase D:\\nstarter SM_DEBUG ");
if ($?){&sendMsg($basePE, "setmakl nstarter failed");die;}

#unregister the application's ocxes so they don't interfere with later builds
&executeCmd("perl p:\\pnutil\\unregocxes.pl D:\\nstarter");
if ($?){&sendMsg($basePE, "unregocxes nstarter failed");die;}

#check make.out, send group e-mail if build broke
&executeCmd("grep -i \"directory aborted\" d:\\nstarter\\make.out > d:\\st_err.out");
if (!$?) #if success, then aborts found, then build broke, send e-mail
{
   &executeCmd("echo ---------------------------------------------------------------- > $mailFile");
   &executeCmd("echo STARTER MAKE.OUT SUMMARY ------------------------------------------ >> $mailFile");
   &executeCmd("type d:\\st_err.out >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo BASE SCR LIST -------------------------------------------------- >> $mailFile");
   &executeCmd("type d:\\n_scrs.lst >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo STARTER SCR LIST -------------------------------------------------- >> $mailFile");
   &executeCmd("type d:\\st_scrs.lst >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo STARTER MAKE.OUT (\\\\base80_nt\\d\$\\nstarter\\make.out)---------- >> $mailFile");
   &executeCmd("echo last 100 lines are included------------------------------------- >> $mailFile");
   &executeCmd("tail -100 d:\\nstarter\\make.out >> $mailFile");
   &sendMsg($basePE, "\"\!\!\!NIGHTLY STARTER BUILD FAILED\!\!\!\"");
   die;
}
&logMessage("completed STARTER build");


### MOBIL ##############################################
&logMessage("starting MOBIL build");
&resetShares("NMOBIL");

#delete d:\nstarter if rebuild is requested
if ($rebuild)
{
   &executeCmd("kill rxapi.exe");
   &executeCmd("perl p:\\pnutil\\delbld.pl d:\\nmobil");
   if (-e 'd:\\nmobil'){&sendMsg($mobilPE, "delbld nmobil failed");die;}
}
else 
{
   #register the application's ocxes since they were unregistered earlier
   &executeCmd("perl p:\\pnutil\\regocxes.pl D:\\nmobil");
   if ($?){&sendMsg($mobilPE, "regocxes nmobil failed");die;}
}

&createSCRFilesList("S:", $mobilRelease, "d:\\mo_scrs.lst");

#create promote list
&executeCmd("perl p:\\cm\\prmtlst.pl NMOBIL $mobilRelease d:\\mo_prmt.lst d:\\mo_scrs.lst d:\\mo_prmt.log");
if ($?){&sendMsg($mobilPE, "prmtlst nmobil failed");die;}

if($rebuild)
{
  #get latest andirs.txt and proot.cmd
  &executeCmd("perl p:\\cm\\getproot.pl NMOBIL $mobilRelease d:\\mo_prmt.lst d:\\mo_gtprt.log");
  if ($?){&sendMsg($mobilPE, "getproot nmobil failed");die;}

  #extract latest build's files
  &executeCmd("rexx p:\\cm\\extractl.cmd D:\\NMOBIL, $mobilRelease, S:\\VCS, D:\\mo_xtrtl.log");
  if ($?){&sendMsg($mobilPE, "extractl nmobil failed");die;}
}

#promote new files, delete removed files
#&promoteFiles("d:\\nmobil", "s:\\vcs", "d:\\mo_prmt.lst");

#make hieararchy read-write
&executeCmd("attrib /s -r d:\\nmobil\\*.*");
if ($?){&sendMsg($mobilPE, "attrib nmobil failed");die;}

#delete the VB oca files from the PC (they can cause problems)
&executeCmd("deloca");

#set ODBC filename to mobil's
&executeCmd("p:\\cm\\setODBCNucDBFile.bat D:\\NMOBIL");
if ($?){&sendMsg($mobilPE, "setODBCNucDBFile nmobil failed");die;}

#do the build
&executeCmd("p:\\cm\\setmakl.bat REFRESH D:\\nbase D:\\nmobil SM_DEBUG ");
if ($?){&sendMsg($mobilPE, "setmakl nmobil failed");die;}

#unregister the application's ocxes so they don't interfere with later builds
&executeCmd("perl p:\\pnutil\\unregocxes.pl D:\\nmobil");
if ($?){&sendMsg($mobilPE, "unregocxes nmobil failed");die;}

#check make.out, send group e-mail if build broke
&executeCmd("grep -i \"directory aborted\" d:\\nmobil\\make.out > d:\\mo_err.out");
if (!$?) #if success, then aborts found, then build broke, send e-mail
{
   &executeCmd("echo ---------------------------------------------------------------- > $mailFile");
   &executeCmd("echo MOBIL MAKE.OUT SUMMARY ------------------------------------------ >> $mailFile");
   &executeCmd("type d:\\mo_err.out >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo BASE SCR LIST -------------------------------------------------- >> $mailFile");
   &executeCmd("type d:\\n_scrs.lst >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo MOBIL SCR LIST -------------------------------------------------- >> $mailFile");
   &executeCmd("type d:\\mo_scrs.lst >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo MOBIL MAKE.OUT (\\\\base80_nt\\d\$\\nmobil\\make.out)-------------- >> $mailFile");
   &executeCmd("echo last 100 lines are included------------------------------------- >> $mailFile");
   &executeCmd("tail -100 d:\\nmobil\\make.out >> $mailFile");
   &sendMail("$mobilPE\@wayne.com", "\"\!\!\!SHDBG NIGHTLY MOBIL BUILD FAILED\!\!\!\"", $mailFile);
}
&logMessage("completed MOBIL build");


### CHEVRON ##############################################
&logMessage("starting CHEVRON build");
&resetShares("NCHEVRON");

#delete d:\nchevron if rebuild is requested
if ($rebuild)
{
   &executeCmd("kill rxapi.exe");
   &executeCmd("perl p:\\pnutil\\delbld.pl d:\\nchevron");
   if (-e 'd:\\nchevron'){&sendMsg($chevronPE, "delbld nchevron failed");die;}
}
else 
{
   #register the application's ocxes since they were unregistered earlier
   &executeCmd("perl p:\\pnutil\\regocxes.pl D:\\nchevron");
   if ($?){&sendMsg($chevronPE, "regocxes nchevron failed");die;}
}

&createSCRFilesList("S:", $chevronRelease, "d:\\ch_scrs.lst");

#create promote list
&executeCmd("perl p:\\cm\\prmtlst.pl NCHEVRON $chevronRelease d:\\ch_prmt.lst d:\\ch_scrs.lst d:\\ch_prmt.log");
if ($?){&sendMsg($chevronPE, "prmtlst nchevron failed");die;}

if($rebuild)
{
  #get latest andirs.txt and proot.cmd
  &executeCmd("perl p:\\cm\\getproot.pl NCHEVRON $chevronRelease d:\\ch_prmt.lst d:\\ch_gtprt.log");
  if ($?){&sendMsg($chevronPE, "getproot nchevron failed");die;}

  #extract latest build's files
  &executeCmd("rexx p:\\cm\\extractl.cmd D:\\NCHEVRON, $chevronRelease, S:\\VCS, D:\\ch_xtrtl.log");
  if ($?){&sendMsg($chevronPE, "extractl nchevron failed");die;}
}

#promote new files, delete removed files
#&promoteFiles("d:\\nchevron", "s:\\vcs", "d:\\ch_prmt.lst");

#make hieararchy read-write
&executeCmd("attrib /s -r d:\\nchevron\\*.*");
if ($?){&sendMsg($chevronPE, "attrib nchevron failed");die;}

#delete the VB oca files from the PC (they can cause problems)
&executeCmd("deloca");

#set ODBC filename to chevron's
&executeCmd("p:\\cm\\setODBCNucDBFile.bat D:\\NCHEVRON");
if ($?){&sendMsg($chevronPE, "setODBCNucDBFile nchevron failed");die;}

#do the build
&executeCmd("p:\\cm\\setmakl.bat REFRESH D:\\nbase D:\\nchevron SM_DEBUG ");
if ($?){&sendMsg($chevronPE, "setmakl nchevron failed");die;}

#unregister the application's ocxes so they don't interfere with later builds
&executeCmd("perl p:\\pnutil\\unregocxes.pl D:\\nchevron");
if ($?){&sendMsg($chevronPE, "unregocxes nchevron failed");die;}

#check make.out, send group e-mail if build broke
&executeCmd("grep -i \"directory aborted\" d:\\nchevron\\make.out > d:\\ch_err.out");
if (!$?) #if success, then aborts found, then build broke, send e-mail
{
   &executeCmd("echo ---------------------------------------------------------------- > $mailFile");
   &executeCmd("echo CHEVRON MAKE.OUT SUMMARY ------------------------------------------ >> $mailFile");
   &executeCmd("type d:\\ch_err.out >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo BASE SCR LIST -------------------------------------------------- >> $mailFile");
   &executeCmd("type d:\\n_scrs.lst >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo CHEVRON SCR LIST -------------------------------------------------- >> $mailFile");
   &executeCmd("type d:\\ch_scrs.lst >> $mailFile");
   &executeCmd("echo ---------------------------------------------------------------- >> $mailFile");
   &executeCmd("echo CHEVRON MAKE.OUT (\\\\base80_nt\\d\$\\nchevron\\make.out)---------- >> $mailFile");
   &executeCmd("echo last 100 lines are included------------------------------------- >> $mailFile");
   &executeCmd("tail -100 d:\\nchevron\\make.out >> $mailFile");
   &sendMail("$chevronPE\@wayne.com", "\"\!\!\!SHDBG NIGHTLY CHEVRON BUILD FAILED\!\!\!\"", $mailFile);
}
&logMessage("completed CHEVRON build");

close (DAILYBUILDLOG);

&sendMsg($basePE, "DailyBuild script finished");

################################################################################

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
   local ($applShareName) = @_;
   &resetShare("s:", "\\\\$ServerName\\$applShareName");
   &resetShare("q:", "\\\\$ServerName\\ntbase");
   &resetShare("p:", "\\\\$ServerName\\ntnuc");
   &resetShare("j:", "\\\\$ServerName\\library");
}


##################
sub resetShare
{
   local ($driveLetter, $shareName) = @_;

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
      &sendMsg($basePE, "$driveLetter $shareName NOT CONNECTED");
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
sub sendMail
{
   local ($sendTo, $subject, $file) = @_;
   local $WSENDMAILINI = "d:\\wsendmail.ini";

   if (-e $WSENDMAILINI )
   {
     &executeCmd("p:\\pnutil\\wsendmail.exe -d -v -i$WSENDMAILINI -s$subject $sendTo $file");
   }
   else
   {
     &sendMsg($basePE, "$WSENDMAILINI does not exits - could not send email to: $sendTo file: $file");
   }
}

##################
sub executeCmd
{
   local ($theCmd) = @_;

   print "$theCmd\n";
   &logMessage($theCmd);
   print `$theCmd`;
   print "execute CMD status: $?\n";

}
##################
sub logMessage
{
   local ($theMsg) = @_;

   print DAILYBUILDLOG scalar localtime, ": $theMsg\n";

}



