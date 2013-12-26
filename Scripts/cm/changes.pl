#! p:\perl
#/*****************************************************************************
#* NAME:         $Workfile:   changes.pl  $
#*               $Revision:   1.2  $
#*               $Date:   Sep 29 1999 10:45:46  $
#*
#* DESCRIPTION: extracts changes sections of all scrs in an scrfiles.lst file
#*
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/changes.plv  $
#*  
#*     Rev 1.2   Sep 29 1999 10:45:46   brettl
#*  added code to ignore the new // bla bla bla // helper comments in the SCR
#*  
#*     Rev 1.1   Jul 12 1999 15:42:54   NancyN
#*  added header and help section
#*
#*****************************************************************************/

#  $file = scrfiles.lst
#  $changes = the output file

print <<HelpSection and exit if ($#ARGV != 1 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H' || $ARGV[0] eq '/?');

Tool: Get build change details (changes)

Description: This tool extracts changes sections of all scrs in an scrfiles.lst file

Usage: changes <input file> <output file>
Example: changes q:\\scr\\build\\n0220t\\scrfiles.lst q:\\scr\\build\\n0220t\\changes.lst

HelpSection

##########################

$file = shift(@ARGV);
#print "$file\n";
open(F,$file) || die "cannot open $file = $!";
$changes = shift(@ARGV);
#print "$changes\n";
open(CF,">$changes") || die "cannot open $changes = $!";
print CF "\nFeatures and Fixes for \U$file\E\n\n";
while(<F>) {
   chop;
   $scrfile = $_;
   #print $scrfile;
   if (-e $scrfile) {
        open(SCRF,$scrfile) || die "cannot open $scrfile = $!";
        $printnow = 0;
        #print "$printnow";
        while(<SCRF>) {
                $cfline = "$_";
                #print "$cfline";
                if ($cfline =~ /Reason for Change:/i) {
                        $cfline =~ s/Reason for Change:/:::/i;  #strip out RFC
                        $printnow = 1;           # and begin printing comments
                }
                elsif (/NOTE: please list all/i) { #part of comments to strip
                        $printnow = 0;
                }
                elsif (/Proposed Changes:/i) {  # stop printing comments
                        $printnow = 0;
                }
                # ignore the helper comments in the SCR //
                # the helper comments look like "// bla bla bla //"
                if ($printnow && !/^\s*\/\/.*\/\/\s*$/) {
                        print CF "$cfline";
                }
                if (/reference to its requirement for each/i) { #strip out too
                        $printnow = 1;
                }
        }
        close(SCRF);
   }
   else {
      print "$scrfile doesn't exist\n";
   }
}
close(CF);
close(F);
