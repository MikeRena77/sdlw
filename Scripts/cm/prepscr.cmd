@rem = '
@echo off
perl -Ip:\cm p:\cm\prepscr.cmd %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
@rem ';
#
#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   prepscr.cmd  $
#*               $Revision:   1.1  $
#*               $Date:   Mar 13 2000 17:18:58  $
#
#* DESCRIPTION:  See usage help below
#
#
#  prepare scr perl script
#  this script will take a set of files from the accept directory
#  and prepare an scrfiles.lst file for the next build specified
#
#  prepscr <project> <bldlabel> <bldname>
#  ex. prepscr nbase base22 n0220an
#  ex. prepscr nstarter starter01 st0100ab
#
#* TARGET:       NT
#*
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/prepscr.cmdv  $
#* 
#*    Rev 1.1   Mar 13 2000 17:18:58   brettl
#* updated script to support multiple PEs working on a single project
#* 
#*    Rev 1.0   Jul 31 1998 11:44:00   brettl
#* Initial revision.
#*
#*****************************************************************************/
#/* end extraction */

if ( (!(length(@ARGV[0]))) || (@ARGV[0] =~ /\?/i) || (@ARGV[0] =~ /^help/i) || (@ARGV[0] =~ /^-h/i) ) {
   print "\n";
   print "Prepare scr perl script:\n";
   print "this script will take a set of files from the accept directory\n";
   print "and prepare an scrfiles.lst file for the next build specified\n";
   print "\n";
   print "Usage:  prepscr <project> <bldlabel> <bldname>\n";
   print "ex. prepscr nbase base22 n0220an\n";
   print "ex. prepscr nstarter starter01 st0100ab\n";
   print "\n";
   exit;
}

unshift(@INC,'.');
#require 'p:\perl\cm\chckparm.pl';
require 'chckparm.pl';

$bldname = shift(@ARGV);

# is the bldname valid??
if (!(length($bldname))) {
   die "build name must be specified\n";
}

$userid = $ENV{'USERNAME'};
$scrpath = "$drive\\scr\\in";
$acceptpath = "$drive\\scr\\accept\\$label";
$preppath = "$drive\\scr\\build\\$bldname";

#print "$scrpath\n";
#print "$acceptpath\n";
#print "$preppath\n";

if (!(-e $scrpath)) { 
   die "scr directory $scrpath does not exist\n"; 
}
if (!(-e $acceptpath)) { 
   die "accept directory $acceptpath does not exist\n"; 
}
if (!(-e $preppath)) { 
   die "prep directory $preppath does not exist\n"; 
}

# copy filenames in scrfiles.lst
$scrfile = "$preppath\\scrfiles.lst";
`attrib -r $scrfile`;
open(SCRFILELST,">>$scrfile") || open(SCRFILELST,">$scrfile") || die "cannot open $scrfile = $!";

$outfile = "$preppath\\prep.log";
open(LOGFILE,">$outfile") || die "cannot open $outfile = $!";

$acceptfiles = "$acceptpath\\acceptf.log";
open(ACCEPTFILES,">$acceptfiles") || die "cannot open $acceptfiles = $!";

# do it
$count = 0;
$errors = 0;
opendir(DIR,"$acceptpath") || die "no $acceptpath?";
while($fname = readdir(DIR)) {
   &prepscr($fname);   # prepare scr for build
}
close(SCRFILELST);
closedir(DIR);
close(LOGFILE);
close(ACCEPTFILES);
`attrib +r $scrfile`;

# cleanup
open(ACCEPTFILES,"$acceptfiles") || die "cannot open $acceptfiles = $!";
while(<ACCEPTFILES>) {
   if (!(-e $_)) { 
      # delete the prepared scr from the accept directory
      `del $_`;
   }
}
close(ACCEPTFILES);

if (!($count)) {
   print "No files prepared for $project $label $bldname build.\n";
   $errors = 1;
}
else {
   print "$count files prepared for $project $label $bldname build.\n";
}

if ($errors) {
   print "Errors occurred - check output\n";
   print ":::Output of $outfile error log\n";
   print STDOUT `type $outfile`;
   print ":::end of output\n";
}
else {
   print "Preparation was SUCCESSFUL\n";
}

############################
#  prepare scr for build
############################
sub prepscr {
   # if $fname (scr file) is not a directory or the accept log file
   # and it exists
   if ((!($fname =~ /^\./)) && (!($fname=~ /\.log/))) {
      $tmp = "$scrpath\\$fname";
      if (!(-e $tmp)) { 
         print LOGFILE "$tmp does not exist - not promoted.\n"; 
         $errors = 1;
      }
      else {
         open(ORIGINSCRF,$tmp);
         $alreadydone = 0;
         while(<ORIGINSCRF>) {
            if (/promoted::(.*)$bldname/i) {
               print LOGFILE "$tmp has already been promoted for \U$bldname\E build.\n";
               $alreadydone = 1;
               $errors = 1;
            }
         }
         close(ORIGINSCRF);
         if (!$alreadydone) { 
            # mark as promoted with current timestamp
            $date = &getTime();
	    `attrib -r $tmp`;
            $doloop = 1;
            while($doloop) {
               if (open(ORIGINSCRF,">>$tmp")) {
	          print ORIGINSCRF "PROMOTED::  for \U$bldname\E on $date";
                  if (!($userid =~ /$pe/i)) {
                     print ORIGINSCRF " for \U$pe\E by \U$userid\E\n";
                  }
                  else {
                     print ORIGINSCRF " by \U$pe\E\n";
                  }
                  close(ORIGINSCRF);
                  `attrib +r $tmp`;

	          # write the scr filename into scrfiles.lst
                  print SCRFILELST "$tmp\n";

                  $acctmp = "$acceptpath\\$fname";
                  print ACCEPTFILES "$acctmp\n";

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
                     print LOGFILE "$tmp NOT promoted.\n";
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

__END__
:endofperl

