#!p:\perl
#
# $Workfile:   makspace.pl  $
# $Revision:   1.3  $ $Date:   Mar 23 1999 18:53:40  $
# $Logfile:   P:/vcs/cm/makspace.plv  $
#
#  display available build directories that still contain a release.num file
#
#  makspace.pl <project> <bldlabel>
#  ex. makspace nbase base22
#  ex. makspace nstarter starter01

unshift(@INC,'.');
require 'p:\cm\chckparm.pl';

#$releasefile = "$drive\\build\\$bldname\\release.num";
# don't print target\release.num or target\ipt\release.num
$blddir = "$drive\\build";
#print "$blddir\n";
#`dir /s $blddir\\release.num`;
opendir(DIR,"$blddir") || die "no $blddir?";
while($fname = readdir(DIR)) {
   # if this is a dir
   $subdirfile = "$blddir\\$fname";
   if (opendir(SUBDIR,"$subdirfile")) {
      while($subfname = readdir(SUBDIR)) {
         if ($subfname =~ /release.num/i) {
            print "$subdirfile\n";
         }
      }
      closedir(SUBDIR);
   }
}
closedir(DIR);

print "Do you want to delete a hierarchy?\n";
if (<STDIN> =~ /^y/i) { 
   print "Enter hierarchy to delete by build name (N0700Z):?\n";
   $bldname = <STDIN>;
   chop $bldname;
   if (!(length($bldname))) {
      print "no build name specified\n";
   }
   else {
      $delhier = "$blddir\\$bldname";
      #print "$delhier\n";
      if (!(-e $delhier)) { 
         die "\U$delhier\E does not exist\n"; 
      }
      else {
         print "WARNING:::THIS WILL CALL DELTREE ON \U$delhier\E\n";
         print "Are you sure you want to delete \U$delhier\E?\n";
         if (<STDIN> =~ /^y/i) { 
            print "Deleting \U$delhier\E\n";
            `perl.exe p:\\cm\\deltree.pl $delhier`;
           # `perl.exe -Ip:\\cm p:\\cm\\bldsmry.pl $project $label $bldname deleted`;
         }
         else {
            print "\U$delhier\E NOT deleted\n";
         }
      }
   }
}

