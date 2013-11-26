#/*****************************************************************************
#* NAME:         $Workfile:   sbmitscr.pl  $
#*               $Revision:   1.5  $
#*               $Date:   09 Apr 2008 10:15:14  $
#
#* DESCRIPTION:  See usage help below
#
#  submit scr perl script
#  this script will take a filename or list of filenames and
#  submit them for the next specified build
#
#  sbmitscr <project> <bldlabel> <scrfilename>
#  ex. sbmitscr nbase base22 nancyn.001
#  ex. sbmitscr nstarter starter01 @sbmitlst.txt
#
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/sbmitscr.plv  $
#* 
#*    Rev 1.5   09 Apr 2008 10:15:14   JaciC
#* Remove the sending to PEs -- not working, not needed
#* 
#*    Rev 1.4   Mar 13 2000 17:16:58   brettl
#* replaced "net send" with bldutils' sendMsg (which supports
#* multiple PEs on a project)
#* 
#*    Rev 1.3   Sep 30 1999 09:27:48   brettl
#* renamed sbmitscr.cmd to sbmitscr.pl
#* added code to filter out SCR helper comment lines
#* 
#*    Rev 1.2   Jan 22 1999 09:36:40   brettl
#* added newline in front of "SUBMITTED" line.
#* Frequently there is not a trailing new line in the SCR and the "SUBMITTED"
#* line is tacked onto the the end of the last line of the test description.
#* 
#*    Rev 1.1   Jul 31 1998 11:49:36   brettl
#* removed use of vcsid, NT has username environment, PVCS uses this now
#* 
#*    Rev 1.0   12 Jun 1997 18:51:16   BrettL
#* Initial revision.
#*****************************************************************************/

if ( (!(length(@ARGV[0]))) || (@ARGV[0] =~ /\?/i) || (@ARGV[0] =~ /^help/i) || (@ARGV[0] =~ /^-h/i) ) {
   print "\n";
   print "Submit scr perl script:\n";
   print "this script will take a filename or list of filenames and\n";
   print "submit them for the next specified build\n";
   print "\n";
   print "Usage:  sbmitscr <project> <bldlabel> <scrfilename>\n";
   print "ex. sbmitscr nbase base22 nancyn.001\n";
   print "ex. sbmitscr nstarter starter01 \@sbmitlst.txt\n";
   print "\n";
   exit;
}

unshift(@INC,'.');
#require 'p:\perl\cm\chckparm.pl';
require 'p:\\cm\\chckparm.pl';
require 'p:\\cm\\bldutils.pl';

$userid = $ENV{'USERNAME'};

$scrpath = "$drive\\scr\\in";
$submitpath = "$drive\\scr\\submit\\$label";
#print "$scrpath\n";
#print "$submitpath\n";

if (!(-e $submitpath)) { 
   die "submit directory $submitpath does not exist\n"; 
}

$outfile = "$submitpath\\submit.log";
open(LOGFILE,">$outfile") || die "cannot open $outfile = $!";
$errors = 0;

$filelist = "";
foreach (@ARGV) {
   #print "$_\n";
   if (/^\@/) {  # it's a file list
      open(F,$_) || die "cannot open $_ = $!";
      while(<>) {
         &submitscr($_);   # submit this scr from a file with a list of scrs
      }
      close(F);
   }
   else {  # it's a file name
      &submitscr($_);   # submit this scr
   }
}

close(LOGFILE);

if (!(length($filelist))) {
   print "no files submitted.\n";
   $errors = 1;
}
#  send a broadcast to PEs
#else {
#   print "sending submit message for $filelist to $pe\n";
#   &sendMsg($pe, "\U$userid\E submitted $filelist for next \U$label\E build");
#}

if ($errors) {
   print "Errors occurred - check output\n";
   print ":::Output of $outfile error log\n";
   print STDOUT `type $outfile`;
   print ":::end of output\n";
}
else {
   print "Submittal of $filelist was SUCCESSFUL\n";
}

############################
#  submit the scr and mark with submit info
############################
sub submitscr {
   $filename = "$_";
   if (!(length($filename))) {
      print "no filename entered here.\n";
   }
   else {
      $tmp = "$scrpath\\$_";
      if (!(-e $tmp)) { 
         print LOGFILE "$tmp does not exist - not submitted.\n"; 
         $errors = 1;
      }
      else {
         open(SCRF,$tmp);
         $alreadydone = 0;
         while(<SCRF>) {
            if (/submitted::(.*)$label/i) {
               print LOGFILE "$tmp has already been submitted for \U$label\E build.\n";
               $alreadydone = 1;
               $errors = 1;
            }
         }
         close(SCRF);
         if (!$alreadydone) { 
            &removeHelperComments($filename, $tmp);
            # mark as submitted with current timestamp
            $date = &getTime();
            `attrib -r $tmp`;
            $doloop = 1;
            while($doloop) {
               if (open(SCRF,">>$tmp")) {
                  print SCRF "\nSUBMITTED:: for \U$label\E on $date by \U$userid\E\n";
                  close(SCRF);
                  `attrib +r $tmp`;

                  # copy to submit dir
                  `copy $tmp $submitpath`;
                  $filelist = "$filelist  $tmp";
                  $doloop = 0;
               }
               else {
                  print "Can't open scr $tmp\n";
                  print "   someone may have it open for editting.\n";
                  print "   close file before retrying!\n";
                  print "Do you want to retry?";
                  if (<STDIN> =~ /^y/i) { 
                     print "retrying\n";
                  }
                  else {
                     print LOGFILE "$tmp NOT submitted.\n";
                     $errors = 1;
                     $doloop = 0;
                  }
               }
            }
         }
      }
   }
}

############################
#  get and format the date and time
############################
sub getTime {
   $timestamp = time;
   ($sec, $min, $hour, $mday, $mon, $year) = localtime($timestamp);
   $mon++;   # increase by 1 since it was 0 based
   if ($sec < 10) {
      $sec = "0$sec";
   }
   if ($min < 10) {
      $min = "0$min";
   }
   if ($hour < 10) {
      $hour = "0$hour";
   }
   $date = "$mon\-$mday\-$year  $hour:$min:$sec";
}

############################
#  remove the helper comments
#  helper comments follow the "// bla bla bla //" format
#  these lines should be removed to make the SCR more readable
#
#  copy the original SCR to the TEMP dir
#  delete the original
#  read from the copy in TEMP, filter out the helper comments, write
#  a new version to the original SCR location
#
#  function requires 2 arguments
#  arg # 1 = scr filename (e.g., brettl.032
#  arg # 2 = scr filename with full path (e.g., s:\scr\in\brettl.032
############################
sub removeHelperComments
{
   local ( $scrFile, $scrPath ) = @_;

   $tmpDir = $ENV{'TEMP'};

   if (!$tmpDir)
   {
     die "TEMP not set (required to remove SCR helper comments)\n";
   }

   $tmpScrPath = "$tmpDir\\$scrFile";

   `attrib -r $tmpScrPath`;
   `copy $scrPath $tmpScrPath`;

   if ($?)
   {
      die "could not copy $scrPath to $tmpScrPath (to remove SCR helper comments)\n";
   }

   `del /q/f $scrPath`;
   if (-e "$scrPath")
   {
     die "could not delete old $scrPath (to remove SCR helper comments)\n";
   }

   unless ( open (OLD_SCR_FILE, "<$tmpScrPath") )
   {
     close (OLD_SCR_FILE);
     die "could not open $tmpScrPath (to remove SCR helper comments)\n"
   }

   unless ( open (NEW_SCR_FILE, ">$scrPath") )
   {
     close (OLD_SCR_FILE);
     close (NEW_SCR_FILE);
     die "could not open $scrPath (to remove SCR helper comments)\n"
   }

   while ( <OLD_SCR_FILE> )
   {
     # if line is not helper comment line ("// bla bla bla //")
     # then write it back to original SCR location
     if (!/^\s*\/\/.*\/\/\s*$/)
     {
       print NEW_SCR_FILE;
     }
   }
   
   close(OLD_SCR_FILE);
   close(NEW_SCR_FILE);   
}
