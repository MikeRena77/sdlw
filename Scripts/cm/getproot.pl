#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   getproot.pl  $
#*               $Revision:   1.0  $
#*               $Date:   Oct 08 1998 18:26:30  $
#*
#* DESCRIPTION:  Get the correct version of PROOT.CMD and ANDIRS.TXT
#*               and place them in d:\
#*               The build scripts use them, and expect them them to be there.
#*               
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/getproot.plv  $
#*  
#*     Rev 1.0   Oct 08 1998 18:26:30   brettl
#*  Initial revision.
#* 
#*****************************************************************************
#/* end extraction */

require 'p:\cm\bldutils.pl';

if ($#ARGV != 3 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H')
{
  print <<HelpSection;
tool: getproot
description: This tool gets the versions of PROOT.CMD and ANDIRS.TXT that
             is associated with the specified build and put them in D:\\
             The build scripts expect these files to be in D:\\

usage:getproot <project> <build label> <promote list> <log output>
example:getprot NBASE BASE70 q:\\scr\\build\\n0700a\\promote.lst q:\\scr\\build\\n0700a\\getproot.log 
HelpSection
exit 1;
}

$project = "\U$ARGV[0]";
$buildLabel = "\U$ARGV[1]";
$promoteListFile = "\U$ARGV[2]";
$logFile = "\U$ARGV[3]";

&getProjectDrive(*drive, $project);
$vcsRoot = "$drive\\VCS";

open (LOG_FILE, ">$logFile");

print "getting proot.cmd and andirs.txt for build scripts...\n\n";
print "  project: $project\n  build label: $buildLabel\n".
      "  promote list file: $promoteListFile\n";
print "  logfile: $logFile\n  drive: $drive\n  vcsRoot: $vcsRoot\n\n";
print LOG_FILE "getting proot.cmd and andirs.txt for build scripts...\n\n";
print LOG_FILE "  project: $project\n  build label: $buildLabel\n".
               "  promote list file: $promoteListFile\n";
print LOG_FILE "  logfile: $logFile\n  drive: $drive\n  vcsRoot: $vcsRoot\n\n";


###########################
# loop over promote list, if proot.cmd or andirs.txt are included in the
# list, save the revision from the list (it will be used later instead of 
# the release label)

open (PROMOTE_LIST_FILE, "<$promoteListFile");
while (<PROMOTE_LIST_FILE>)
{
    s/\//\\/g;
    s/\n//g;

    #skip blank lines, tilde lines (remove-from-build lines) and comment lines
    if (!(/^~/ | /^$/ | /^#/))
    {
      ($file, $rev) = split(/\s+/);

      if (/proot.cmd/i)
      {
        $proot_rev = $rev;
         print LOG_FILE "found proot.cmd, using rev: $proot_rev\n";
         print "$_\n";
         print LOG_FILE "$_\n";
      }
      if (/andirs.txt/i)
      {
         $andirs_rev = $rev;
         print "found andirs.txt, using rev: $andirs_rev\n";
         print LOG_FILE "found andirs.txt, using rev: $andirs_rev\n";
         print "$_\n";
         print LOG_FILE "$_\n";
      }

   }

}
close (PROMOTE_LIST_FILE);


if ($proot_rev) #use the rev promoted for this build
{
   $vcsCmd = "get -Y -Q -R$proot_rev $vcsRoot\\BIN(D:\\PROOT.CMD)";
}
else # use the rev associated with this build
{
   $vcsCmd = "get -Y -Q -V$buildLabel $vcsRoot\\BIN(D:\\PROOT.CMD)";
}

print "$vcsCmd\n";
print LOG_FILE "$vcsCmd\n";
print LOG_FILE `$vcsCmd`;

if ($? != 0)
{
   print "getproot failed to get proot.cmd, vcs rc: $?, aborting\n";
   print LOG_FILE "getproot failed to get proot.cmd, vcs rc: $?, aborting\n";
   print LOG_FILE "adbldlbl failed to attach label, vcs rc: $?, aborting\n";
   close (LOG_FILE);
   die;
};

if ($andirs_rev) #use the rev promoted for this build
{
   $vcsCmd = "get -Y -Q -R$andirs_rev $vcsRoot\\BIN(D:\\ANDIRS.TXT)";
}
else # use the rev associated with this build
{
   $vcsCmd = "get -Y -Q -V$buildLabel $vcsRoot\\BIN(D:\\ANDIRS.TXT)";
}

print "$vcsCmd\n";
print LOG_FILE "$vcsCmd\n";
print LOG_FILE `$vcsCmd`;

if ($? != 0)
{
   print "getproot failed to get andirs.txt, vcs rc: $?, aborting\n";
   print LOG_FILE "getproot failed to get andirs.txt, vcs rc: $?, aborting\n";
   print LOG_FILE "adbldlbl failed to attach label, vcs rc: $?, aborting\n";
   close (LOG_FILE);
   die;
};

print "getproot completed successfully\n\n";
print LOG_FILE "getproot completed sucessfully\n";

close (LOG_FILE);
