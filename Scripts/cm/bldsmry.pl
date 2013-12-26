#!p:\perl
#
#/*****************************************************************************
#* NAME:         $Workfile:   bldsmry.pl  $
#*               $Revision:   1.2  $
#*               $Date:   Oct 31 1997 14:40:26  $
#*
#* DESCRIPTION:  Check parameters
#
#  modify build summary perl script
#  this script will modify the build summary file located 
#     in p:\latest
#
#  bldsmry <project> <bldlabel> <bldname> [<status>]
#  ex. bldsmry nbase base22 n0220an
#  ex. bldsmry nstarter starter01 st0100ab
#*               
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/bldsmry.plv  $
#*  
#*     Rev 1.2   Oct 31 1997 14:40:26   BrettL
#*  adding explicit path to require statement so it can be run from anywhere
#*  
#*     Rev 1.1   Sep 15 1997 16:15:48   BrettL
#*  changed command used to append release file to end of summary file.
#*  the copy a + b c was sticking in control characters
#*  the type a >> c doesn't
#* 
#*****************************************************************************
#/* end extraction */

unshift(@INC,'.');
require 'p:\cm\chckparm.pl';

# is the bldname valid??
$bldname = shift(@ARGV);
if (!(length($bldname))) {
   die "build name must be specified\n";
}

$releasefile = "$drive\\build\\$bldname\\release.num";
#print "$releasefile\n";

$bldsmryfile = "P:\\LATEST\\$label.num";
if ($label =~ /starter/i) {
   # substitute start for starter
   $start = $label;
   $start =~ s/starter/start/i;
   $bldsmryfile = "P:\\LATEST\\$start.num";
}
if ($label =~ /chevron/i) {
   # substitute chev for chevron
   $start = $label;
   $start =~ s/chevron/chev/i;
   $bldsmryfile = "P:\\LATEST\\$start.num";
}
#print "$bldsmryfile\n";

# does the status exist??
$status = "";
$status = shift(@ARGV);
#print "$status\n";
if (!(length($status))) { #default is add new release.num
   if (!(-e $releasefile)) { 
      die "$releasefile does not exist\n"; 
   }
   if (-e $bldsmryfile) { #if bldsmryfile exists, append to it
      $okay = 1;
      open(BSFILE,$bldsmryfile);
      while(<BSFILE>) {
         if (/^$bldname/i) {
            $okay = 0;
         }
      }
      close(BSFILE);
      #if okay, append
      if ($okay) {
         `attrib -r $bldsmryfile`;
         `type $releasefile >> $bldsmryfile`;
         `attrib +r $bldsmryfile`;
         print "updated build summary file for \U$label\E with \U$bldname\E release info\n";
      }
      else {
         print "build \U$bldname\E already exists in $bldsmryfile\n";
      }
   }
   else { #if bldmsryfile does not exist, create it new
      `copy $releasefile $bldsmryfile`;
      `attrib +r $bldsmryfile`;
      print "created build summary file for \U$label\E with \U$bldname\E release info\n";
   }
}
else {
   # find the release.num in bldsmryfile and append the status to the line
   if (-e $bldsmryfile) { #if bldsmryfile exists
      `attrib -r $bldsmryfile`;
      open(BSFILE,$bldsmryfile);
      $tmp = "P:\\LATEST\\$label.tmp";
      open(TMPBSFILE,">$tmp");
      #print "$bldsmryfile opened\n";
      while(<BSFILE>) {
         $fileline = $_;
         #print $fileline;
         if (/^$bldname/i) {
            if (!(/$status/i)) {
               chop $_; #delete newline
               $fileline = "$_ $status\n";
               #print $fileline;
               print TMPBSFILE $fileline;
               print "updated build summary file for \U$label\E with \U$bldname\E status $status\n";
            }
            else {
               print "build summary file entry for \U$label\E with \U$bldname\E status $status already exists\n";
               print TMPBSFILE $fileline;
            }
         }
         else {
            print TMPBSFILE $fileline;
         }
      }
      close(TMPBSFILE);
      close(BSFILE);
      `copy $tmp $bldsmryfile`;
      `del $tmp`;
      `attrib +r $bldsmryfile`;
   }
}


