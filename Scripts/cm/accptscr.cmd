@rem = '
@echo off
perl -Ip:\cm p:\cm\accptscr.cmd %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
@rem ';
#
#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   accptscr.cmd  $
#*               $Revision:   1.4  $
#*               $Date:   Mar 13 2000 17:19:50  $
#
#* DESCRIPTION:  See usage help below
#
#
#  accept scr perl script
#  this script will take a set of files from the submit directory
#  and process them for acceptance for the next build specified
#
#  accptscr <project> <bldlabel>
#  ex. accptscr nbase base22
#  ex. accptscr nstarter starter01
#
#* TARGET:       NT
#*
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/accptscr.cmdv  $
#* 
#*    Rev 1.4   Mar 13 2000 17:19:50   brettl
#* updated script to support multiple PEs working on a single project
#* 
#*    Rev 1.3   Jul 31 1998 11:47:38   brettl
#* removed use of vcsid, NT has username environment, PVCS uses this now
#* 
#*    Rev 1.2   Jul 14 1998 12:16:42   brettl
#* updated to use codewright, not brief (brief is not the standard editor on NT
#* 
#*    Rev 1.1   Oct 31 1997 14:38:02   BrettL
#* adding explicit path to require statement so it can be run from anywhere
#* 
#*    Rev 1.0   02 Jul 1997 18:16:12   BrettL
#* Initial revision.
#*****************************************************************************/
#/* end extraction */

if ( (!(length(@ARGV[0]))) || (@ARGV[0] =~ /\?/i) || (@ARGV[0] =~ /^help/i) || (@ARGV[0] =~ /^-h/i) ) {
   print "\n";
   print "Accept scr perl script:\n";
   print "this script will take a set of files from the submit directory\n";
   print "and process them for acceptance for the next build specified\n";
   print "\n";
   print "Usage:  accptscr <project> <bldlabel>\n";
   print "ex. accptscr nbase base22\n";
   print "ex. accptscr nstarter starter01\n";
   print "\n";
   exit;
}

unshift(@INC,'.');
require 'p:\cm\chckparm.pl';

$userid = $ENV{'USERNAME'};

$origscrpath = "$drive\\scr\\in";
$submitpath = "$drive\\scr\\submit\\$label";
$acceptpath = "$drive\\scr\\accept\\$label";

#print "$origscrpath\n";
#print "$submitpath\n";
#print "$acceptpath\n";

if (!(-e $submitpath)) { 
   die "submit directory $submitpath does not exist\n"; 
}
if (!(-e $acceptpath)) { 
   die "accept directory $acceptpath does not exist\n"; 
}

$outfile = "$acceptpath\\accept.log";
open(LOGFILE,">$outfile") || die "cannot open $outfile = $!";

$count = 0;
$errors = 0;
opendir(DIR,"$submitpath") || die "no $submitpath?";
while($fname = readdir(DIR)) {
   &acceptscr($fname);   # accept this scr
}
closedir(DIR);
close(LOGFILE);

if (!($count)) {
   print "No files accepted for $label build.\n";
   $errors = 1;
}
else {
   print "$count files accepted for $label build.\n";
}

if ($errors) {
   print "Errors occurred - check output\n";
   print ":::Output of $outfile error log\n";
   print STDOUT `type $outfile`;
   print ":::end of output\n";
}
else {
   print "Acceptance was SUCCESSFUL\n";
}


############################
#  try to accept the scr
############################
sub acceptscr {
   if ((!($fname =~ /^\./)) && (!($fname=~ /^submit\.log/))) {
      # present the file and ask for approval
      $tmp = "$origscrpath\\$fname";
      $subtmp = "$submitpath\\$fname";
      #print "$tmp $subtmp\n";
      if (!(-e $tmp)) { 
         print LOGFILE "$tmp does not exist - not approved.\n"; 
         $errors = 1;
      }
      else {                 
         open(SCRF,$tmp);
         $alreadydone = 0;
         while(<SCRF>) {
            if (/accepted::(.*)$label/i) {
               print LOGFILE "$tmp has already been accepted for \U$label\E build.\n";
               $alreadydone = 1;
               $errors = 1;
            }
         }
         close(SCRF);
         if (!$alreadydone) { 
            `attrib -r $tmp`;
            # edit the original scr
            `cw32 -mm $tmp`;  
            `attrib +r $tmp`;
            print "Do you want to approve $fname?";
            if (<STDIN> =~ /^y/i) { 
               # mark as accepted with current timestamp
               $date = &getTime();
	       `attrib -r $tmp`;
               $doloop = 1;
               while($doloop) {
                  if (open(SCRF,">>$tmp")) {
                     print SCRF "ACCEPTED::  for \U$label\E on $date";
                     if (!($userid =~ /$pe/i)) {
                        print SCRF " for \U$pe\E by \U$userid\E\n";
                     }
                     else {
                        print SCRF " by \U$pe\E\n";
                     }
                     close(SCRF);
                     `attrib +r $tmp`;

                     # copy the original scr to accept directory
                     `copy $tmp $acceptpath`;
                     `del $subtmp`;  # delete the file from the submit directory
                     $count = $count + 1;
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
                        print LOGFILE "$tmp NOT accepted.\n";
                        $errors = 1;
                        $doloop = 0;
                     }
                  }
               }
            }
            else {
               print LOGFILE "$tmp not approved.\n";
               $errors = 1;
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

__END__
:endofperl

