#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   wherelbl.pl  $
#*               $Revision:   1.3  $
#*                   $Date:   Aug 26 1998 15:14:52  $
#*
#* DESCRIPTION:  perl script that displays important archive labels
#*               see script help for more info
#*               
#* $Log:   P:/vcs/cm/wherelbl.plv  $
#*  
#*     Rev 1.3   Aug 26 1998 15:14:52   brettl
#*  added filtering of labels like MO0101
#*  prettied up label prints
#*  
#*     Rev 1.2   Aug 26 1998 15:01:38   brettl
#*  Reduced number of input params required.
#*  Simplified internal logic
#*  
#*     Rev 1.1   Jul 31 1998 14:03:56   GraceP
#*  Added Chevron Project
#*  
#*     Rev 1.0   Mar 11 1998 10:36:20   JimL
#*  Initial revision.
#*
#*****************************************************************************
#/* end extraction */

print <<HelpSection and exit if ($#ARGV < 0 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H');

Tool: wherelbl - display important archive label information

Usage: wherelbl [-h] <file|archive> [<file|archive>]*

Example: wherelbl ecrsc.cpp
   This form of the command can be used when run from the file's
   directory in the build hierarchy.  In this case the file archive's
   directory is retrieved by PVCS from the VCS.CFG file in the current
   directory.

Example: wherelbl q:\\vcs\\sc\\ecr\\ecrsc.cpp
   This form of the command can be used from any directory since the
   full path location of the archive is specified

Note: All arguments on the command line are passed directly into vlog.  So,
      if "vlog x y z" works, then "wherelbl x y z" should work.

HelpSection

$files = join ' ', @ARGV;

@vcsOutput = `vlog -B -Q $files`;

if ($? != 0)
{
  print "vlog failed on $files\n";
  exit;
}

foreach (@vcsOutput)
{
   # print the trunk rev
   # save the trunk rev for later display with the NEXT floating label
   if (/^\s*Last trunk rev:.*$/)
   {
     print;

     #strip off everything but the rev #
     $lastTrunkRev = $_;
     $lastTrunkRev =~ s/^\s*Last trunk rev:(.*)$/\1/;
     $lastTrunkRev =~ s/[\n\s]//g;
   }

   # print the NEXT line with the real revision #
   # since NEXT is a floater its revision number contains a wilcard
   elsif (/^\s*\"NEXT\" =.*$/)
   {
      s/\n//g; #strip of trailing newline
      s/^\s*//g; #remove leading white space
      print "$_ (aka $lastTrunkRev)\n";
   }

   # print release labels
   # this regex matches the standard release label format
   # it matches labels like: BASE70 and MOBIL10
   # if does not match build labels like: N0700X and MO0101
   elsif (/^\s*\"[A-Za-z]{2,}\d+\" =.*$/)
   {
      s/^\s*//g; #remove leading white space
      print;
   }

   # print other important lines from vcs output
   elsif (/^\s*Archive:.*$/ |
          /^\s*Locks:.*$/)
   {
      print;
   }

} # end loop over vcs output
